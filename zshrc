PROMPT='%F{32}%~ $%f '
alias ls='ls -G'
alias ll='ls -l'

export LSCOLORS=GxFxCxDxBxegedabagaced

autoload -Uz compinit
compinit




[[ /usr/local/bin/kubectl ]] && source <(kubectl completion zsh) # add autocomplete permanently to your zsh shell
