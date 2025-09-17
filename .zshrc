# Antigen setup.
if command -v brew &> /dev/null
then
  [ -f $(brew --prefix)/share/antigen/antigen.zsh ] && source $(brew --prefix)/share/antigen/antigen.zsh
else
  [ -f ~/.local/bin/antigen.zsh ] && source ~/.local/bin/antigen.zsh
fi

antigen use oh-my-zsh
antigen bundle git
antigen bundle sudo
antigen bundle command-not-found
antigen bundle kubectl
antigen bundle zsh-users/zsh-autosuggestions
antigen apply

# Set up zoxide.
eval "$(zoxide init zsh)"

# Environment variables.
export EDITOR="nvim"
export GIT_EDITOR="nvim"
export HISTSIZE=1000000000
export SAVEHIST=1000000000
export HISTFILE="$HOME/.zsh_history"
export HIST_STAMPS="yyyy-mm-dd"
export GPG_TTY=$(tty)
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Aliases and overrides.
alias k="kubectl"
alias ls="eza"
alias la="eza -alh"
alias find="fd"
alias grep="rg"
alias cat="bat"
alias htop="btop"
alias diff="diff-so-fancy"
alias more="most"
alias pcupd="podman compose up -d"
alias pcdn="podman compose down"
alias pce="podman compose exec"
alias pc="podman compose"
alias p="podman"
alias pcps="podman compose ps"
alias pcl="podman compose logs"
alias pclf="podman compose logs -f"
alias pcr="podman compose run --rm -it"
alias lg="lazygit"

# Start starship.
eval "$(starship init zsh)"

# Key bindings.
bindkey -v
bindkey '^R' history-incremental-search-backward

# Homebrew autocompletion.
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# Start autocompletion.
autoload -Uz compinit
compinit

# kubectl autocompletion
if command -v kubectl &>/dev/null; then
  source <(kubectl completion zsh)
fi

# oc (OpenShift CLI) autocompletion
if command -v oc &>/dev/null; then
  source <(oc completion zsh)
fi

# Set up fzf.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
