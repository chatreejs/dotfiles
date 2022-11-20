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