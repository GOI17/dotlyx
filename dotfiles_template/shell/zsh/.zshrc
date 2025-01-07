#!/usr/bin/env zsh
# Uncomment for debuf with `zprof`
# zmodload zsh/zprof

# ZSH Ops
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FCNTL_LOCK
setopt +o nomatch
# setopt autopushd

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Start Zim
source "$ZIM_HOME/init.zsh"

# Async mode for autocompletion
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_HIGHLIGHT_MAXLENGTH=300

fpath=(
	"$USER_DOTFILES_PATH/shell/zsh/themes"
	"$USER_DOTFILES_PATH/shell/zsh/completions"
	$fpath
)

# autoload -Uz promptinit && promptinit
# autoload -Uz compinit && compinit

# source "$DOTLY_PATH/shell/zsh/bindings/dot.zsh"
# source "$DOTLY_PATH/shell/zsh/bindings/reverse_search.zsh"
# source "$DOTLYX_HOME_PATH/modules/shell/zsh/key-bindings.zsh"
# source "$HOME/fzf-tab/fzf-tab.plugin.zsh"

eval "$(jump shell)"
