#!bin/bash

# Install The Ultimate Vim configuration
# See also https://github.com/amix/vimrc
while true; do
    read -p "Do you want to install The Ultimate Vim configuration? (y/n) " answer
    case $answer in
        [Yy]* ) echo "👍 Installing The Ultimate Vim configuration..."; git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
                sh ~/.vim_runtime/install_awesome_vimrc.sh
                echo "✨ The Ultimate Vim configuration installed"; break;;
        [Nn]* ) echo "✅ The Ultimate Vim configuration is not installed"; break;;
        * ) echo "🚨 Please answer yes or no.";;
    esac
done