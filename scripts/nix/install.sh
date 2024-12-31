#!/usr/bin/env bash

read -p 'Where are going to be located your dotfiles?
- Default: ~/.dotfiles
- Custom: ~/Documents/dotfiles
Press enter to keep default location: ' DOTFILES_PATH

DEFAULT_DOTFILES_PATH="~/.dotfiles"
DOTFILES_PATH="${DOTFILES_PATH:-$DEFAULT_DOTFILES_PATH}"
DOTFILES_PATH="$(eval echo "$DOTFILES_PATH")"
export DOTFILES_PATH="$DOTFILES_PATH"
export DOTLYX_HOME_PATH="$DOTFILES_PATH/modules/dotlyx"
export NIX_CONFIG_HOME="$DOTFILES_PATH/modules/nix"
export ZIM_HOME="$DOTFILES_PATH/modules/zim"

get_local_time_in_secons ()
{
  date +%s;
}

create_backup_current_dotfiles ()
{
  mv "$DOTFILES_PATH" "$1"
  local -r home_dotfiles_path="home_dotfiles"
  mkdir $home_dotfiles_path
  for file in $(ls -a ~ | grep -e zsh -e bash); do
    mv ~/$file $home_dotfiles_path
  done
}

echo "DOTLYX: Looking for existing dotfiles..."

if [ -d "$DOTFILES_PATH" ]; then
  backup_path="pre_dotlyx_$1.$(get_local_time_in_secons).back"

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
        break
        ;;
      *)
        echo "DOTLYX: Plase provide a valid option."
        ;;
    esac
  done
fi

echo "DOTLYX: dotfiles will be located in: $DOTFILES_PATH"
mkdir "$DOTFILES_PATH" && cd "$DOTFILES_PATH"

if ! [[ $SHELL =~ "zsh" ]]; then
    echo "DOTLYX: Setting zsh as default shell"
    sudo chsh -s "$(command -v zsh)"
fi

git init

echo "DOTLYX: Adding dotlyx as git submodule"
git -c protocol.file.allow=always \
	submodule add "$HOME/Documents/personal/workspace/dotlyx" modules/dotlyx

source "$DOTLYX_HOME_PATH/scripts/nix/check_for_required_tools.sh"

echo "DOTLYX: Installing zim..."
curl -fsSL --create-dirs -o "$ZIM_HOME/zimfw.zsh" \
  https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh 2>&1 && \
  zsh "$ZIM_HOME/zimfw.zsh" install

echo "DOTLYX: Installing dotlyx submodules..."
git submodule update --init --recursive

if [ ! -d "$DOTFILES_PATH/shell" ]; then
	cp -r "$DOTLYX_HOME_PATH/dotfiles_template/"* "$DOTFILES_PATH/"

	sed -i -e "s|XXX_DOTFILES_PATH_XXX|$DOTFILES_PATH|g" "$DOTFILES_PATH/bin/sdot"
	sed -i -e "s|XXX_DOTFILES_PATH_XXX|$DOTFILES_PATH|g" "$DOTFILES_PATH/shell/bash/.bashrc"
	sed -i -e "s|XXX_DOTFILES_PATH_XXX|$DOTFILES_PATH|g" "$DOTFILES_PATH/shell/zsh/.zshenv"
fi

"$DOTLYX_HOME_PATH/modules/dotbot/bin/dotbot" -d "$DOTLYX_HOME_PATH" -c "$DOTFILES_PATH/symlinks/conf.yaml"

source "$DOTLYX_HOME_PATH/scripts/nix/build_config.sh"

cd $HOME

echo "DOTLYX: Restart your terminal and Welcome to Dotlyx!"

