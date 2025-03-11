#!/bin/bash
set -e

if [[ "$(uname)" == "Darwin" ]]; then
  echo "macOS Detected"

  if xcode-select -p &>/dev/null; then
    echo "Xcode already installed"
  else
    echo "Installing commandline tools..."
    xcode-select --install
  fi
  export DISTRO="macos"
elif [[ "$(uname)" == "Linux" ]]; then
  if ! which sudo; then
    SUDO=
  else
    SUDO=sudo
  fi
  echo "linux detected"
  if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
    if ! which lsb_release; then
      $SUDO apt update && $SUDO apt install lsb-release -y
    fi
    export DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
    export DISTRO_VERSION=$(lsb_release -r | cut -d: -f2 | sed s/'^\t'//)
  # Otherwise, use release info file
  else
    # TODO: Needs work
    export DISTRO=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
    export DISTRO_VERSION=$(lsb_release -r | cut -d: -f2 | sed s/'^\t'//)
  fi
fi

if [[ ! -d "$HOME/.local/bin" ]]; then
  mkdir -p $HOME/.local/bin
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
elif [[ "$DISTRO" == "Ubuntu" ]]; then
  # TODO: Need to detect architecture as well for some of these
  echo "ubuntu"
  $SUDO apt update && $SUDO apt install \
    stow git zsh neovim fd-find bat tmux ripgrep tldr \
    zsh-syntax-highlighting zsh-autosuggestions software-properties-common -y
    
  curl -LO https://github.com/eza-community/eza/releases/download/v0.20.23/eza_x86_64-unknown-linux-gnu.tar.gz
  tar -zxvf eza_x86_64-unknown-linux-gnu.tar.gz
  mv eza ~/.local/bin/eza
  rm eza_x86_64-unknown-linux-gnu.tar.gz

  # fzf on ubuntu 24.04 and below are too old.
  curl -LO https://github.com/junegunn/fzf/releases/download/v0.60.3/fzf-0.60.3-linux_amd64.tar.gz
  tar -zxvf fzf-0.60.3-linux_amd64.tar.gz
  mv fzf ~/.local/bin/fzf
  rm fzf-0.60.3-linux_amd64.tar.gz

  # This is needed on 22.04 Ubuntu or older.
  if [[ "$DISTRO_VERSION" == "22.04" ]]; then
    $SUDO add-apt-repository ppa:neovim-ppa/unstable
    $SUDO apt-get update
    $SUDO apt-get install neovim
  fi
  
  ln -s $(which fdfind) ~/.local/bin/fd
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
