PROMPT='%F{32}%~ $%f '
alias ls='ls -G'
alias ll='ls -l'

autoload -Uz compinit
compinit

export LSCOLORS=GxFxCxDxBxegedabagaced
export PATH="$PATH:/Users/indikaudagedara/.dotnet/tools"

[[ /usr/local/bin/kubectl ]] && source <(kubectl completion zsh) # add autocomplete permanently to your zsh shell

complete -C '/usr/local/bin/aws_completer' aws
