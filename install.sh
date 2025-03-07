#!/bin/bash

if [[ "$(uname)" == "Darwin" ]]; then
  echo "macOS Detected"

  if xcode-select -p &>/dev/null; then
    echo "Xcode already installed"
  else
    echo "Installing commandline tools..."
    xcode-select --install
  fi
  export DISTRO="macos"
elif [[ "$(uname)" == "linux" ]]; then
  echo "linux detected"
  if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
    export DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
  # Otherwise, use release info file
  else
    export DISTRO=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
  fi
fi


if [[ "$DISTRO" == "macos" ]]; then
  echo "macos"
  if ! which brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew analytics off
  brew install \
    stow git zsh neovim fd eza bat tmux fzf ripgrep tlrc \
    zsh-syntax-highlighting zsh-autosuggestions
elif [[ "$DISTRO" == "ubuntu" ]]; then
  echo "ubuntu"
  sudo apt update && sudo apt install \
    stow git zsh neovim fd-find eza bat tmux fzf ripgrep tldr \
    zsh-syntax-highlighting zsh-autosuggestions
  ln -s $(which fdfind) ~/.local//bin/fd
  if which batcat; then
    ln -s /usr/bin/batcat ~/.local/bin/bat
  fi
elif [[ "DISTRO" == "arch" ]]; then
  echo "archlinux"
  pacman -Sy \
    stow git zsh neovim fd eza bat tmux fzf ripgrep tldr \
    zsh-syntax-highlighting zsh-autosuggestions
fi

chsh -s $(which zsh)

if ! which starship >/dev/null; then
  curl -sS https://starship.rs/install.sh | sh
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [ ! -d "$HOME/dotenvfiles" ]; then
  echo "Cloning dotfiles repository..."
  git clone https://github.com/xNinjaKittyx/dotenvfiles.git $HOME/dotenvfiles
fi

cd $HOME/dotenvfiles || exit

stow -t ~ dotfiles
