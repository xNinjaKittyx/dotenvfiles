#!/bin/zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
cp dotfiles/.zshrc ~/
cp dotfiles/.p10k.zsh ~/
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
eval "$(pyenv init -)"
pyenv install 3.8.2
pyenv global 3.8.2
pyenv shell 3.8.2

# Install Python
python -m pip install -U pip
pip install -U pipx
pipx install youtube-dl
pipx install poetry
pipx install pipenv

# Installing Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

exec zsh -l
