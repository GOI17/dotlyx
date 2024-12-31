#!/usr/bin/env bash

read -p 'Where are going to be located your dotfiles (Default: ~/.dotfiles)?. Enter to keep default: ' dotfiles_user_input

DEFAULT_DOTFILES_PATH="~/.dotfiles"
export DOTFILES_PATH="$dotfiles_user_input:-$DEFAULT_DOTFILES_PATH"
export DOTLYX_HOME_PATH="$DOTFILES_PATH/modules/dotlyx"
export ZIM_HOME="$DOTFILES_PATH/modules/zim"
export NIX_CONFIG_HOME="$DOTLYX_HOME_PATH/modules/nix"

get_local_time_in_secons ()
{
  date +%s;
}

create_backup_current_dotfiles ()
{
  mv "$DOTFILES_PATH" "$1";
  local -r home_dotfiles_path="$1/home_dotfiles"
  mkdir $home_dotfiles_path;
  for file in $(ls -a ~ | grep -e zsh -e bash); do
    mv ~/$file $home_dotfiles_path;
  done
}

echo "DOTLYX: Looking for existing dotfiles..."

if [ -d "$DOTFILES_PATH" ]; then
  local -r backup_path="pre_dotlyx_$1.$(get_local_time_in_secons).back"

  while true; do
    read -p "The path '$DOTFILES_PATH' already exists. Do you want to create a backup? (y/n): " is_backup_required
    case $is_backup_required in
      [Yy] ) 
        echo "DOTLYX: Creating backup in '$backup_path'";
        create_backup_current_dotfiles $backup_path;
        break
        ;;
      [Nn] )
        echo "DOTLYX: Skipping backup";
        exit
        ;;
      *)
        echo "DOTLYX: Plase provide a valid option."
        ;;
    esac
  done
fi

echo "DOTLYX: dotfiles will be located in: $DOTFILES_PATH"
mkdir -p "$DOTFILES_PATH"

if ! [[ "$SHELL" == zsh ]]; then
	echo "DOTLYX: Setting zsh as default shell"
	sudo chsh -s "$(command -v zsh)"
fi

cd $DOTFILES_PATH

echo "DOTLYX: Adding dotlyx as git submodule"
git submodule add -b "main" "https://github.com/GOI17/dotlyx.git" "modules/dotlyx" 2>&1

source "$DOTLYX_HOME_PATH/scripts/nix/check_for_required_tools.sh"

echo "DOTLYX: Installing zim..."
curl -fsSL --create-dirs -o "$ZIM_HOME/zimfw.zsh" \
  https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh 2>&1 && \
  zsh "$ZIM_HOME/zimfw.zsh" install 2>&1

echo "DOTLYX: Installing dotbot..."
git submodule update --init --recursive modules/dotbot

source "$DOTLYX_HOME_PATH/scripts/nix/build_config.sh"

cd $HOME

echo "DOTLYX: Restart your terminal and Welcome to Dotlyx!"

