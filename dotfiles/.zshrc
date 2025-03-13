# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.cargo/bin:/usr/local/go/bin:$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH
if [[ "$(uname)" == "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

ZSH="$HOME/.oh-my-zsh"
plugins=(git)
source $ZSH/oh-my-zsh.sh

autoload -Uz +X compinit && compinit
autoload -Uz +X bashcompinit && bashcompinit

alias vim="nvim"
alias ls="eza --no-filesize --long --color=always --icons=always --no-user"
alias tarz="tar -zxvf"
alias editzsh="nvim ~/.zshrc"
alias reloadzsh="source ~/.zshrc"
alias editalacritty="nvim ~/.alacritty.toml"
alias edittmux="nvim ~/.tmux.conf"
alias gcm="git commit -m"
alias gdc="git diff --cached"
alias fman="compgen -c | fzf | xargs man"

function showdiff() {
    git diff $1~ $1
}

function showdockerlogs() {
    co=$(sudo docker inspect --format='{{.Name}}' $(sudo docker ps -aq --no-trunc) | sed 's/^.\(.*\)/\1/' | sort); for c_name in $co; do c_size=$(sudo docker inspect --format={{.ID}} $c_name | xargs -I @ sh -c 'sudo ls -hl /var/lib/docker/containers/@/@-json.log' | awk '{print $5 }'); YE='\033[1;33m'; NC='\033[0m'; PI='\033[1;35m'; RE='\033[1;31m'; case "$c_size" in *"K"*) c_size=${YE}$c_size${NC};; *"M"*) p=${c_size%.*}; q=${p%M*}; r=${#q}; if [[ $r -lt 3 ]]; then c_size=${PI}$c_size${NC}; else c_size=${RE}$c_size${NC}; fi ;;  esac;  echo -e "$c_name $c_size"; done
}
# if mac
if [[ "$(uname)" == "Darwin" ]]; then
    export DOCKER_CLIENT_TIMEOUT=360
    export COMPOSE_HTTP_TIMEOUT=360
    export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=true
    export GPG_TTY=$(tty)
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    defaults write .GlobalPreferences com.apple.mouse.scaling -1
else
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# FZF
# Set up fzf key bindings and fuzzy completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git "
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git "

export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"
# fzf default for tmux
export FZF_TMUX_OPTS=" -p90%,70% "

# setup fzf previews
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"


if [[ -f ~/.config/secrets.env ]]; then
  source ~/.config/secrets.env
fi

export PYENV_ROOT="$HOME/.pyenv"

# Pyenv
if [[ -d $PYENV_ROOT/bin ]]; then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Rust
if [[ -d $HOME/.cargo ]]; then
  . "$HOME/.cargo/env"
fi

eval "$(starship init zsh)"

