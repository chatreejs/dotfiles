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
mkdir -p "$HOME/.claude"
linking_dotfiles ".config/claude/statusline-command.sh" ".claude/statusline-command.sh"
