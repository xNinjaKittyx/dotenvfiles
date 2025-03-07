#!/bin/bash


if ! which zsh; then
    if which pacman; then
        echo "arch"
        sudo pacman -Sy pyenv zsh
        chsh -s $(which zsh)
    elif which apt; then
        echo "deb"
	sudo apt update
        sudo apt install pyenv zsh fd-find eza bat
	ln -s $(which fdfind) ~/.local/bin/fd
	if which batcat; then
	    ln -s /usr/bin/batcat ~/.local/bin/bat
	fi
        chsh -s $(which zsh)
    elif which brew; then
        echo "brew"
        brew install zsh nvim fd eza bat zsh-syntax-highlighting zsh-autosuggestions
        chsh -s $(which zsh)
    fi
fi

curl -sS https://starship.rs/install.sh | sh

stow -t ~ -d ./dotfiles

# # Setup environment
# sudo pacman -Syu
# sudo pacman -Sy --noconfirm base-devel pyenv zsh vim
# # Sync vi to vim
# sudo ln -s /usr/bin/vim /usr/bin/vi
# git clone https://aur.archlinux.org/ttf-meslo.git
# cd ttf-meslo && makepkg -si --noconfirm && cd ..
# chsh -s /bin/zsh
# ./zsh_setup.sh
