# Antigen setup.
[ -f ~/.local/bin/antigen.zsh ] && source ~/.local/bin/antigen.zsh
[ -f /opt/homebrew/share/antigen/antigen.zsh ] && source /opt/homebrew/share/antigen/antigen.zsh
antigen use oh-my-zsh
antigen bundle git
antigen bundle sudo
antigen bundle command-not-found
antigen bundle docker
antigen bundle docker-compose
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
export GOROOT=/opt/homebrew/opt/go/libexec
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

# Start starship.
eval "$(starship init zsh)"

bindkey -v

# Start autocompletion.
autoload -Uz compinit
compinit

# Kubectl autocomplete.
source <(kubectl completion zsh)

# Set up fzf.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
