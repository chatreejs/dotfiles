#!bin/bash

# Symlink to .zshrc
ZSHRC=~/.zshrc

if [ -L ${ZSHRC} ] ; then
    echo "🔗 Updating symlink .zshrc"
    rm ${ZSHRC}
    ln -s ${PWD}/.zshrc ${ZSHRC}
    echo "✨ Symlink updated"
elif [ -e ${ZSHRC} ] ; then
    echo "💾 Backup existing .zshrc"
    mv ${ZSHRC} ${ZSHRC}.bak
    echo "🔗 Linking to .zshrc"
    ln -s ${PWD}/.zshrc ${ZSHRC}
    echo "✨ Symlink created"
else
    echo "🔗 Linking to .zshrc"
    ln -s ${PWD}/.zshrc ${ZSHRC}
    echo "✨ Symlink created"
fi

# Symlink to .zsh
ZSH=~/.zsh
if [ -L ${ZSH} ] ; then
    echo "🔗 Updating symlink .zsh"
    rm ${ZSH}
    ln -s ${PWD}/.zsh ${ZSH}
    echo "✨ Symlink updated"
elif [ -e ${ZSH} ] ; then
    echo "💾 Backup existing .zsh"
    mv ${ZSH} ${ZSH}.bak
    echo "🔗 Linking to .zsh"
    ln -s ${PWD}/.zsh ${ZSH}
    echo "✨ Symlink created"
else
    echo "🔗 Linking to .zsh"
    ln -s ${PWD}/.zsh ${ZSH}
    echo "✨ Symlink created"
fi

# Symlink to .gitconfig
GIT_CONFIG=~/.gitconfig

if [ -L ${GIT_CONFIG} ] ; then
    echo "🔗 Updating symlink .gitconfig"
    rm ${GIT_CONFIG}
    ln -s ${PWD}/.gitconfig ${GIT_CONFIG}
    echo "✨ Symlink updated"
elif [ -e ${GIT_CONFIG} ] ; then
    echo "💾 Backup existing .gitconfig"
    mv ${GIT_CONFIG} ${GIT_CONFIG}.bak
    echo "🔗 Linking to .gitconfig"
    ln -s ${PWD}/.gitconfig ${GIT_CONFIG}
    echo "✨ Symlink created"
else
    echo "🔗 Linking to .gitconfig"
    ln -s ${PWD}/.gitconfig ${GIT_CONFIG}
    echo "✨ Symlink created"
fi

# Symlink to .config
DOT_CONFIG=~/.config

if [ ! -d ${DOT_CONFIG} ] ; then
    echo "🗂️ Create .config directory"
    mkdir ${DOT_CONFIG}
fi

for config in $(ls -d ${PWD}/.config/*); do
    config_name=$(basename ${config})
    if [ -L ${DOT_CONFIG}/${config_name} ] ; then
        echo "🔗 Updating symlink .config/${config_name}"
        rm ${DOT_CONFIG}/${config_name}
        ln -s ${PWD}/.config/${config_name} ${DOT_CONFIG}/${config_name}
        echo "✨ Symlink updated"
    elif [ -e ${DOT_CONFIG}/${config_name} ] ; then
        echo "💾 Backup existing .config/${config_name}"
        mv ${DOT_CONFIG}/${config_name} ${DOT_CONFIG}/${config_name}.bak
        echo "🔗 Linking to .config/${config_name}"
        ln -s ${PWD}/.config/${config_name} ${DOT_CONFIG}/${config_name}
        echo "✨ Symlink created"
    else
        echo "🔗 Linking to .config/${config_name}"
        ln -s ${PWD}/.config/${config_name} ${DOT_CONFIG}/${config_name}
        echo "✨ Symlink created"
    fi
done