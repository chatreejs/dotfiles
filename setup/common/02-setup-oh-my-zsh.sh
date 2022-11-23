#!/bin/bash

custom_plugins=(
    zsh-autosuggestions
    fast-syntax-highlighting
    zsh-z
    zsh-better-npm-completion
)

check_plugins() {
    plugins_to_install=()
    for plugin in "${custom_plugins[@]}"; do
        if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/$plugin ]; then
            plugins_to_install+=($plugin)
        fi
    done

    echo "${plugins_to_install[@]}"
}

install_plugins() {
    echo "🔍  Checking Oh My Zsh plugins"
    plugins_to_install=($(check_plugins))
    if [ ${#plugins_to_install[@]} -gt 0 ]; then
        for plugin in "${plugins_to_install[@]}"; do
            echo "🌏  Downloading plugin: $plugin"
            case $plugin in
                zsh-autosuggestions)
                    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ;;
                fast-syntax-highlighting)
                    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting ;;
                zsh-z)
                    git clone https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z ;;
                zsh-better-npm-completion)
                    git clone https://github.com/lukechilds/zsh-better-npm-completion ~/.oh-my-zsh/custom/plugins/zsh-better-npm-completion ;;
            esac
            echo "✨  $plugin installed"
        done
    else
        echo "✅  All plugins already installed (Skipping)"
    fi
}

# Install Oh My Zsh
if [ -d ~/.oh-my-zsh ]; then
    echo "✅  Oh My Zsh is already installed (Skipping)"
else
    echo "🚀  Installing Oh My Zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "✨  Oh My Zsh installed"
fi

# Install Oh My Zsh plugins
install_plugins