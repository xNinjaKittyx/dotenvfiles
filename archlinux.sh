#!/bin/bash

# Setup environment
sudo pacman -Syu
sudo pacman -Sy --noconfirm base-devel pyenv zsh vim
# Sync vi to vim
sudo ln -s /usr/bin/vim /usr/bin/vi
git clone https://aur.archlinux.org/ttf-meslo.git
cd ttf-meslo && makepkg -si --noconfirm && cd ..
chsh -s /bin/zsh
./zsh_setup.sh
