#!/bin/zsh
if which pacman; then
    echo "arch"
    sudo pacman -Sy conky
elif which apt; then
    echo "deb"
    sudo apt install -U conky
fi

cp -r dotfiles/.conky ~/.conky

