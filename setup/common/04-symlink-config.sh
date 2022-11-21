#!bin/bash

# Symlink to .zshrc
ZSHRC=~/.zshrc

if [ -L ${ZSHRC} ] ; then
    echo "✅ Symlink already exists (.zshrc)"
elif [ -e ${ZSHRC} ] ; then
    echo "💾 Backup existing .zshrc"
    mv ${ZSHRC} ${ZSHRC}.bak
    echo "🔗 Creating symbolic link to .zshrc"
    ln -s ${PWD}/.zshrc ${ZSHRC}
    echo "✨ Symbolic link created"
else
    echo "🔗 Creating symbolic link to .zshrc"
    ln -s ${PWD}/.zshrc ${ZSHRC}
    echo "✨ Symbolic link created"
fi

# Symlink to .zsh
ZSH=~/.zsh
if [ -L ${ZSH} ] ; then
    echo "✅ Symlink already exists (.zsh)"
elif [ -e ${ZSH} ] ; then
    echo "💾 Backup existing .zsh"
    mv ${ZSH} ${ZSH}.bak
    echo "🔗 Creating symbolic link to .zsh"
    ln -s ${PWD}/.zsh ${ZSH}
    echo "✨ Symbolic link created"
else
    echo "🔗 Creating symbolic link to .zsh"
    ln -s ${PWD}/.zsh ${ZSH}
    echo "✨ Symbolic link created"
fi

# Symlink to .gitconfig
GIT_CONFIG=~/.gitconfig

if [ -L ${GIT_CONFIG} ] ; then
    echo "✅ Symlink already exists (.gitconfig)"
elif [ -e ${GIT_CONFIG} ] ; then
    echo "💾 Backup existing .gitconfig"
    mv ${GIT_CONFIG} ${GIT_CONFIG}.bak
    echo "🔗 Creating symbolic link to .gitconfig"
    ln -s ${PWD}/.gitconfig ${GIT_CONFIG}
    echo "✨ Symbolic link created"
else
    echo "🔗 Creating symbolic link to .gitconfig"
    ln -s ${PWD}/.gitconfig ${GIT_CONFIG}
    echo "✨ Symbolic link created"
fi

# Symlink to .config
DOT_CONFIG=~/.config

if [ -d ${DOT_CONFIG} ] ; then
    echo "✅ Config directory already exists"
else
    echo "🗂️ Create .config directory"
    mkdir ${DOT_CONFIG}
fi

for config in $(ls -d ${PWD}/.config/*); do
    config_name=$(basename ${config})
    if [ -L ${DOT_CONFIG}/${config_name} ] ; then
        echo "✅ Symlink already exists (.config/${config_name})"
    elif [ -e ${DOT_CONFIG}/${config_name} ] ; then
        echo "💾 Backup existing .config/${config_name}"
        mv ${DOT_CONFIG}/${config_name} ${DOT_CONFIG}/${config_name}.bak
        echo "🔗 Creating symbolic link to .config/${config_name}"
        ln -s ${PWD}/.config/${config_name} ${DOT_CONFIG}/${config_name}
        echo "✨ Symbolic link created"
    else
        echo "🔗 Creating symbolic link to .config/${config_name}"
        ln -s ${PWD}/.config/${config_name} ${DOT_CONFIG}/${config_name}
        echo "✨ Symbolic link created"
    fi
done