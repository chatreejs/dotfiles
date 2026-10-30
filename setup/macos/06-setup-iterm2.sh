#!/bin/bash

# Point iTerm2 at the tracked preferences in .config/iterm2 (exported by dump_iterm2.sh).
# iTerm2 reads them on its next launch, so quit and reopen it if it is already running.
log_step "🖥️   iTerm2"

ITERM2_PREFS_DIR="$PWD/.config/iterm2"

if [[ ! -d "/Applications/iTerm.app" ]]; then
    log_skip "iTerm2 is not installed"
elif [[ "$(defaults read com.googlecode.iterm2 PrefsCustomFolder 2>/dev/null)" == "$ITERM2_PREFS_DIR" \
    && "$(defaults read com.googlecode.iterm2 LoadPrefsFromCustomFolder 2>/dev/null)" == "1" ]]; then
    log_ok "iTerm2 already loads preferences from $ITERM2_PREFS_DIR"
else
    defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$ITERM2_PREFS_DIR"
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
    log_done "iTerm2 now loads preferences from $ITERM2_PREFS_DIR"
    pgrep -xq iTerm2 && log_info "Restart iTerm2 to apply the tracked preferences"
fi
