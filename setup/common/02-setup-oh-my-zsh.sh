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
    plugins_to_install=($(check_plugins))
    if [ ${#plugins_to_install[@]} -gt 0 ]; then
        for plugin in "${plugins_to_install[@]}"; do
            log_info "Downloading plugin: $plugin"
            case $plugin in
                zsh-autosuggestions)
                log_indent git clone -q https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ;;
                fast-syntax-highlighting)
                log_indent git clone -q https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting ;;
                zsh-z)
                log_indent git clone -q https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z ;;
                zsh-better-npm-completion)
                log_indent git clone -q https://github.com/lukechilds/zsh-better-npm-completion ~/.oh-my-zsh/custom/plugins/zsh-better-npm-completion ;;
            esac
            log_done "Plugin $plugin installed"
        done
    else
        log_ok "All Oh My Zsh plugins are already installed"
    fi
}

log_step "🚀  Oh My Zsh"

# Install Oh My Zsh
if [ -d ~/.oh-my-zsh ]; then
    log_ok "Oh My Zsh is already installed"
else
    log_info "Installing Oh My Zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    log_done "Oh My Zsh installed"
fi

# Install Oh My Zsh plugins
install_plugins
