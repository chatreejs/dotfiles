#!bin/bash

echo "🔗  Linking configuration files"

linking_dotfiles() {
    if [ -L "$HOME/$1" ]
    then
        rm "$HOME/$1"
        ln -s "$PWD/$1" "$HOME/$1"
    elif [ -e "$HOME/$1" ]
    then
        mv "$HOME/$1" "$HOME/$1.bak"
        ln -s "$PWD/$1" "$HOME/$1"
    else
        ln -s "$PWD/$1" "$HOME/$1"
    fi
}

linking_dotfiles ".zshrc"
linking_dotfiles ".zshenv"
linking_dotfiles ".gitconfig"
linking_dotfiles ".zsh"
linking_dotfiles ".config/starship.toml"
linking_dotfiles ".config/lvim/config.lua"