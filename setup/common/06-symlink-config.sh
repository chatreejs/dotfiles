#!/bin/bash

log_step "🔗  Config files"

# linking_dotfiles <source> [target]: symlink $PWD/<source> to $HOME/<target> (default: same path).
# A real file at the target is backed up to *.bak; an existing symlink is replaced.
linking_dotfiles() {
    local source="$1"
    local target="${2:-$1}"
    if [ -L "$HOME/$target" ]
    then
        rm "$HOME/$target"
    elif [ -e "$HOME/$target" ]
    then
        mv "$HOME/$target" "$HOME/$target.bak"
        log_info "Backed up existing ~/$target to ~/$target.bak"
    fi
    if ln -s "$PWD/$source" "$HOME/$target" 2>/dev/null; then
        log_done "Linked ~/$target"
    else
        log_error "Failed to link ~/$target"
    fi
}

linking_dotfiles ".zshenv"
linking_dotfiles ".gitconfig"
linking_dotfiles ".zsh"
linking_dotfiles ".config/starship.toml"
linking_dotfiles ".config/lvim/config.lua"
mkdir -p "$HOME/.config/tmux"
linking_dotfiles ".config/tmux/tmux.conf"
# Every file in .config/claude goes into ~/.claude, except settings.json (merged below)
mkdir -p "$HOME/.claude"
for file in "$PWD"/.config/claude/*; do
    name=$(basename "$file")
    [[ $name == "settings.json" ]] && continue
    linking_dotfiles ".config/claude/$name" ".claude/$name"
done

# Merge the tracked keys (status line) into each machine's own Claude Code settings,
# so other settings stay local. The repo's keys win on conflict.
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
if ! command -v jq &> /dev/null; then
    log_error "jq is not installed; skipped merging ~/.claude/settings.json"
else
    if [ -L "$CLAUDE_SETTINGS" ]; then
        # Older installs symlinked the whole file into the repo
        rm "$CLAUDE_SETTINGS"
    fi
    [ -s "$CLAUDE_SETTINGS" ] || echo '{}' > "$CLAUDE_SETTINGS"
    merged=$(jq -s '.[0] * .[1]' "$CLAUDE_SETTINGS" "$PWD/.config/claude/settings.json")
    if [[ -z $merged ]]; then
        log_error "Failed to merge ~/.claude/settings.json"
    elif [[ $merged == "$(jq . "$CLAUDE_SETTINGS")" ]]; then
        log_ok "~/.claude/settings.json already has the tracked settings"
    else
        echo "$merged" > "$CLAUDE_SETTINGS"
        log_done "Merged tracked settings into ~/.claude/settings.json"
    fi
fi
