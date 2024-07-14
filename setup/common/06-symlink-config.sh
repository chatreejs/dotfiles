#!bin/bash

echo "🔗  $(tput setaf 6)Linking configuration files$(tput sgr0)"

linking_dotfiles() {
    if [ -n "$2" ]; then
        if [ -L "$HOME/$2" ]
        then
            rm "$HOME/$2"
            ln -s "$PWD/$1" "$HOME/$2"
        elif [ -e "$HOME/$2" ]
        then
            mv "$HOME/$2" "$HOME/$2.bak"
            ln -s "$PWD/$1" "$HOME/$2"
        else
            ln -s "$PWD/$1" "$HOME/$2"
        fi
    else
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
    fi
}

linking_dotfiles ".zshrc"
linking_dotfiles ".zshenv"
linking_dotfiles ".gitconfig"
linking_dotfiles ".zsh"
linking_dotfiles ".config/starship.toml"
linking_dotfiles ".config/lvim/config.lua"
