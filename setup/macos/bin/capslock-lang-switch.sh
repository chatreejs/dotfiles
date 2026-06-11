#!/bin/bash
#
# capslock-lang-switch.sh
# Make Caps Lock switch input language ONLY (no Caps Lock function, no delay).
#
# How it works:
#   1. Uses `hidutil` to remap the physical Caps Lock key to F18
#      (a key that doesn't exist on Mac keyboards, so it conflicts with nothing).
#      This completely removes the Caps Lock toggle behavior and macOS's
#      built-in press-duration detection (the source of your 1-second delay).
#   2. Sets the macOS keyboard shortcut "Select the previous input source"
#      (symbolic hotkey 60) to F18.
#   3. Installs a LaunchAgent so the remap survives reboots
#      (hidutil mappings reset on restart otherwise).
#
# Usage:
#   chmod +x capslock-lang-switch.sh
#   ./capslock-lang-switch.sh install     # apply everything
#   ./capslock-lang-switch.sh uninstall   # restore normal Caps Lock
#
set -euo pipefail

PLIST="$HOME/Library/LaunchAgents/com.user.capslock-to-f18.plist"
LABEL="com.user.capslock-to-f18"

# Caps Lock = 0x700000039, F18 = 0x70000006D (HID usage IDs)
REMAP_JSON='{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x70000006D}]}'

install() {
  echo "==> 1/4 Remapping Caps Lock -> F18 (takes effect immediately)"
  hidutil property --set "$REMAP_JSON" > /dev/null

  echo "==> 2/4 Installing LaunchAgent so the remap persists after reboot"
  mkdir -p "$HOME/Library/LaunchAgents"
  cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>${LABEL}</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/hidutil</string>
        <string>property</string>
        <string>--set</string>
        <string>${REMAP_JSON}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF
  launchctl unload "$PLIST" 2>/dev/null || true
  launchctl load "$PLIST"

  echo "==> 3/4 Binding F18 to 'Select the previous input source' (hotkey 60)"
  # parameters: (65535 = no ASCII char, 79 = virtual keycode for F18, 0 = no modifiers)
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "
    <dict>
      <key>enabled</key><true/>
      <key>value</key>
      <dict>
        <key>type</key><string>standard</string>
        <key>parameters</key>
        <array>
          <integer>65535</integer>
          <integer>79</integer>
          <integer>0</integer>
        </array>
      </dict>
    </dict>"

  echo "==> 4/4 Refreshing system hotkey cache"
  /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u 2>/dev/null \
    || echo "    (could not auto-refresh - log out and back in if the shortcut doesn't work yet)"

  cat <<'DONE'

Done!

IMPORTANT - two quick manual checks (macOS doesn't expose these reliably via CLI):

  1. System Settings > Keyboard > Input Sources > Edit...
     UNCHECK "Use Caps Lock to switch to and from <your input source>"
     (otherwise the old delayed behavior may fight with the new shortcut)

  2. System Settings > Keyboard > Keyboard Shortcuts > Input Sources
     Verify "Select the previous input source" shows F18 and is enabled.
     If it still shows the old value, log out and back in once.

After that: pressing Caps Lock = instant Thai/English switch, every time,
no delay, and it can never turn on Caps Lock by accident.

If you ever need actual CAPS LOCK for typing, use Shift, or run:
  ./capslock-lang-switch.sh uninstall
DONE
}

uninstall() {
  echo "==> Removing key remap"
  hidutil property --set '{"UserKeyMapping":[]}' > /dev/null

  echo "==> Removing LaunchAgent"
  launchctl unload "$PLIST" 2>/dev/null || true
  rm -f "$PLIST"

  echo "==> Disabling the F18 input-source shortcut (hotkey 60)"
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "
    <dict>
      <key>enabled</key><false/>
    </dict>"
  /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u 2>/dev/null || true

  echo "Caps Lock restored to normal. Re-enable any settings you want in System Settings."
}

case "${1:-}" in
  install)   install ;;
  uninstall) uninstall ;;
  *) echo "Usage: $0 {install|uninstall}"; exit 1 ;;
esac

