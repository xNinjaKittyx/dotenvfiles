#!/bin/bash

# install zsh
if ! which zsh; then
    if which pacman; then
        echo "arch"
        sudo pacman -Sy pyenv zsh fd eza bat
        chsh -s $(which zsh)
    elif which apt; then
        echo "deb"
        sudo apt install pyenv zsh fd eza bat
        chsh -s $(which zsh)
    elif which brew; then
        echo "brew"
        brew install zsh nvim fd eza bat
        chsh -s $(which zsh)
    fi
fi

# install starship.rs
curl -sS https://starship.rs/install.sh | sh



# # Setup environment
# sudo pacman -Syu
# sudo pacman -Sy --noconfirm base-devel pyenv zsh vim
# # Sync vi to vim
# sudo ln -s /usr/bin/vim /usr/bin/vi
# git clone https://aur.archlinux.org/ttf-meslo.git
# cd ttf-meslo && makepkg -si --noconfirm && cd ..
# chsh -s /bin/zsh
# ./zsh_setup.sh
