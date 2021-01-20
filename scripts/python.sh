#!/bin/zsh

eval "$(pyenv init -)"
pyenv install 3.8.6
pyenv global 3.8.6
pyenv shell 3.8.6

python -m pip install -U pip
pip install -U pipx
pipx install youtube-dl
pipx install poetry
pipx install pipenv