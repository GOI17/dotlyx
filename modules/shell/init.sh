# This is a useful file to have the same aliases/functions in bash and zsh

if [[ -f "$DOTFILES_PATH/privates/init.sh" ]]; then
  echo "Loading privates configs..."
  source "$DOTFILES_PATH/privates/init.sh"
fi

source "$DOTLYX_HOME_PATH/modules/shell/aliases.sh"
source "$DOTLYX_HOME_PATH/modules/shell/exports.sh"
source "$DOTLYX_HOME_PATH/modules/shell/functions.sh"
