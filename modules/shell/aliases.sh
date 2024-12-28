#!/usr/bin/env sh

# Enable aliases to be sudo’ed
alias sudo='sudo '

alias ..="cd .."
alias ...="cd ../.."
alias ll="eza -l"
alias la="eza -la"
alias ~="cd ~"
alias dotfiles="j dotfiles"

# Git
alias gaa="git add -A"
alias gcm='git commit -m'
alias grb='git rebase'
alias grbi='git rebase -i -r'
alias gca="git add --all && git commit --amend --no-edit"
alias gco="git checkout"
alias gd='$DOTLY_PATH/bin/dot git pretty-diff'
alias gs="git status -sb"
alias gf="git fetch --all -p"
alias gps="git push"
alias gpsf="git push --force"
alias gpl="git pull --rebase --autostash"
alias gb="git branch"
alias gpsup='git push -u origin "$(gb --show-current)"'
alias gl='$DOTLY_PATH/bin/dot git pretty-log'
alias gswitch='git switch'

# Editors
alias c.='(code $PWD &>/dev/null &)'
alias v='NVIM_APPNAME=nvim-scratch nvim'  # default Neovim config
alias vz='NVIM_APPNAME=nvim-lazyvim nvim' # LazyVim

# Utils
alias pin="jump pin"
alias unpin="jump unpin"
alias pins="jump pins"
alias k='kill -9'
alias o.='open .'
alias up='dot package update_all'
alias chmodr='chmod -Rv'
alias ppath='echo "$PATH" | tr ":" "\n" | nl'
alias dotbot="$DOTLYX_HOME_PATH/modules/dotbot/bin/dotbot"
