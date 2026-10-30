# Check Distro
DISTRO=$(source ${PWD}/setup/common/00-check-distro.sh)

if [[ $DISTRO != "macos" ]]; then
    echo "This script is only for macOS"
    exit 1
fi

# Export iTerm2 preferences to the folder that setup/macos/06-setup-iterm2.sh points iTerm2 at.
# Machine-local state (window frames, NoSync* keys, Sparkle update state) is dropped to keep diffs clean.
PLIST=${PWD}/.config/iterm2/com.googlecode.iterm2.plist
mkdir -p "$(dirname "$PLIST")"
defaults export com.googlecode.iterm2 "$PLIST"
plutil -convert xml1 "$PLIST"

# Collect the top-level keys first: PlistBuddy rewrites the file on every delete
local_keys=$(LC_ALL=C sed -nE 's|^[[:space:]]<key>(.*)</key>$|\1|p' "$PLIST" \
    | grep -E '^(NoSync|NSWindow Frame|NSSplitView|NSToolbar|NSNavPanel|NSOSP|SU|com\.apple\.|findMode_|iTerm Version$)')
while IFS= read -r key; do
    [[ -n "$key" ]] && /usr/libexec/PlistBuddy -c "Delete \":$key\"" "$PLIST"
done <<< "$local_keys"

echo "Dumped iTerm2 preferences to $PLIST"
