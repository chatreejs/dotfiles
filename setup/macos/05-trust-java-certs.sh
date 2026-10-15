#!/bin/bash

# Import the corporate root CA into every installed JDK's cacerts.
# `brew upgrade` replaces the openjdk keg (and its cacerts), so re-run this after upgrading.
# JAVA_CERT_PATH, JAVA_CERT_ALIAS and JAVA_CERT_STOREPASS come from .env (see .env.example);
# machines without them skip this step.
if [[ -z "$JAVA_CERT_PATH" || -z "$JAVA_CERT_ALIAS" || -z "$JAVA_CERT_STOREPASS" ]]; then
    echo "☕  $(tput setaf 3)JAVA_CERT_PATH, JAVA_CERT_ALIAS or JAVA_CERT_STOREPASS is not set, skipping JDK certificate trust$(tput sgr0)"
elif [[ ! -f "$JAVA_CERT_PATH" ]]; then
    echo "☕  $(tput setaf 3)$JAVA_CERT_PATH not found, skipping JDK certificate trust$(tput sgr0)"
else
    echo "☕  $(tput setaf 6)Trusting $JAVA_CERT_ALIAS certificate in installed JDKs$(tput sgr0)"

    # System JDKs (Homebrew symlinks + vendor installs) and Homebrew kegs that are not symlinked
    jdk_homes=()
    for jdk in /Library/Java/JavaVirtualMachines/*.jdk "$(brew --prefix 2>/dev/null)"/opt/openjdk*/libexec/openjdk.jdk; do
        [[ -d "$jdk/Contents/Home" ]] && jdk_homes+=("$jdk/Contents/Home")
    done

    # Fingerprint as printed by keytool, e.g. "AB:CD:...", used to detect an up-to-date import
    cert_fingerprint=$("${jdk_homes[0]}/bin/keytool" -printcert -file "$JAVA_CERT_PATH" 2>/dev/null | awk '/SHA256:/ { print $2; exit }')

    seen_keystores=""
    for jdk_home in "${jdk_homes[@]}"; do
        keystore="$jdk_home/lib/security/cacerts"
        keytool_bin="$jdk_home/bin/keytool"
        [[ -f "$keystore" && -x "$keytool_bin" ]] || continue

        # Several paths can point at the same keg; handle each real keystore once
        real_keystore=$(cd "$(dirname "$keystore")" && pwd -P)/cacerts
        [[ "$seen_keystores" == *"|$real_keystore|"* ]] && continue
        seen_keystores+="|$real_keystore|"

        jdk_name=$(basename "$(dirname "$(dirname "$jdk_home")")")
        existing=$("$keytool_bin" -list -keystore "$real_keystore" -storepass "$JAVA_CERT_STOREPASS" -alias "$JAVA_CERT_ALIAS" 2>/dev/null) || existing=""
        if [[ -n "$existing" && -n "$cert_fingerprint" && "$existing" == *"$cert_fingerprint"* ]]; then
            echo "    ✅  $jdk_name already trusts $JAVA_CERT_ALIAS"
            continue
        fi

        # Homebrew kegs are user-owned; vendor JDKs (e.g. Temurin) are owned by root
        sudo_cmd=""
        [[ -w "$real_keystore" ]] || sudo_cmd="sudo"

        # Replace a stale entry with the same alias before importing
        if [[ -n "$existing" ]]; then
            $sudo_cmd "$keytool_bin" -delete -keystore "$real_keystore" -storepass "$JAVA_CERT_STOREPASS" -alias "$JAVA_CERT_ALIAS" >/dev/null 2>&1
        fi

        if $sudo_cmd "$keytool_bin" -importcert -trustcacerts -noprompt \
            -keystore "$real_keystore" -storepass "$JAVA_CERT_STOREPASS" \
            -alias "$JAVA_CERT_ALIAS" -file "$JAVA_CERT_PATH" >/dev/null 2>&1; then
            echo "    🔐  $(tput setaf 2)$jdk_name now trusts $JAVA_CERT_ALIAS$(tput sgr0)"
        else
            echo "    ❌  $(tput setaf 1)Failed to import $JAVA_CERT_ALIAS into $jdk_name$(tput sgr0)"
        fi
    done
fi
