#!/usr/bin/env bash

command_exists() {
  type "$1" >/dev/null 2>&1
}

if ! command_exists curl; then
  echo "DOTLYX: curl not installed, trying to install"

  if command_exists apt; then
    echo "DOTLYX: Installing using apt"
    echo "DOTLYX: Installing curl"
    sudo apt -y install curl 2>&1
  elif command_exists dnf; then
    echo "DOTLYX: Installing using dnf"
    echo "DOTLYX: Installing curl"
    sudo dnf -y install curl 2>&1
  elif command_exists yum; then
    echo "DOTLYX: Installing using yum"
    echo "DOTLYX: Installing curl"
    yes | sudo yum install curl 2>&1 
  elif command_exists brew; then
    echo "DOTLYX: Installing using brew"
    echo "DOTLYX: Installing curl"
    yes | brew install curl 2>&1 
  elif command_exists pacman; then
    echo "DOTLYX: Installing using pacman"
    echo "DOTLYX: Installing curl"
    sudo pacman -S --noconfirm curl 2>&1 
  else
    echo "DOTLYX: Could not install curl, no package provider found"
    exit 1
  fi
fi

if ! command_exists git; then
  echo "DOTLYX: git not installed, trying to install"

  if command_exists apt; then
    echo "DOTLYX: Installing using apt"
    echo "DOTLYX: Installing git"
    sudo apt -y install git 2>&1
  elif command_exists dnf; then
    echo "DOTLYX: Installing using dnf"
    echo "DOTLYX: Installing git"
    sudo dnf -y install git 2>&1
  elif command_exists yum; then
    echo "DOTLYX: Installing using yum"
    echo "DOTLYX: Installing git";
    yes | sudo yum install git 2>&1 
  elif command_exists brew; then
    echo "DOTLYX: Installing using brew"
    echo "DOTLYX: Installing git"
    yes | brew install git 2>&1 
  elif command_exists pacman; then
    echo "DOTLYX: Installing using pacman"
    echo "DOTLYX: Installing git"
    sudo pacman -S --noconfirm git 2>&1 
  else
    echo "DOTLYX: Could not install git, no package provider found"
    exit 1
  fi
fi

if ! command_exists python3; then
  echo "DOTLYX: python not installed, trying to install"

  if command_exists apt; then
    echo "DOTLYX: Installing using apt"
    echo "DOTLYX: Installing python"
    sudo apt -y install python3 2>&1
  elif command_exists dnf; then
    echo "DOTLYX: Installing using dnf"
    echo "DOTLYX: Installing python"
    sudo dnf -y install python3 2>&1
  elif command_exists yum; then
    echo "DOTLYX: Installing using yum"
    echo "DOTLYX: Installing python";
    yes | sudo yum install python3 2>&1 
  elif command_exists brew; then
    echo "DOTLYX: Installing using brew"
    echo "DOTLYX: Installing python"
    yes | brew install python3 2>&1 
  elif command_exists pacman; then
    echo "DOTLYX: Installing using pacman"
    echo "DOTLYX: Installing python"
    sudo pacman -S --noconfirm python3 2>&1 
  else
    echo "DOTLYX: Could not install python, no package provider found"
    exit 1
  fi
fi

if ! command_exists nix; then
  echo "DOTLYX: nix is not installed, trying to install"
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

nix build --file ./setup/install.nix
./result/bin/dotlyx-setup

# read -p 'Where are going to be located your dotfiles?
# - Default: ~/.dotfiles
# - Custom: ~/Documents/dotfiles
# Press enter to keep default location: ' USER_DOTFILES_PATH
#
# DEFAULT_USER_DOTFILES_PATH="~/.dotfiles"
# USER_DOTFILES_PATH="${USER_DOTFILES_PATH:-$DEFAULT_USER_DOTFILES_PATH}"
# USER_DOTFILES_PATH="$(eval echo "$USER_DOTFILES_PATH")"
#
# get_local_time_in_seconds ()
# {
#   date +%s;
# }
#
# if ! [[ $SHELL =~ "zsh" ]]; then
#     echo "DOTLYX: Setting zsh as default shell"
#     sudo chsh -s "$(command -v zsh)"
# fi
#
# echo "DOTLYX: Looking for existing dotfiles..."
#
# if [ -d "$USER_DOTFILES_PATH" ]; then
# 	while true; do
# 		read -p "The path '$USER_DOTFILES_PATH' already exists. Do you want to create a backup? (y/n): " is_backup_required
# 		case $is_backup_required in
# 			[Yy] ) 
# 				backup_path="pre_dotlyx_dotfiles.$(get_local_time_in_seconds).back"
# 				echo "DOTLYX: Creating backup in '$backup_path'";
# 				user_dotfiles_absolute_path=$(realpath $USER_DOTFILES_PATH)
# 				parent_user_dotfiles_path=$(dirname $user_dotfiles_absolute_path)
# 				mv $user_dotfiles_absolute_path "$parent_user_dotfiles_path/$backup_path";
# 				home_user_dotfiles_path="pre_dotlyx_home_dotfiles.$(get_local_time_in_seconds).back"
# 				mkdir -pv "$parent_user_dotfiles_path/$backup_path/$home_user_dotfiles_path"
# 				current_dotfiles="$(ls -a ~ | grep -v dotlyx | grep -e zsh -e bash -e dot)"
# 				files_with_errors=()
# 				for filename in $current_dotfiles; do
# 					mv "$HOME/$filename" "$parent_user_dotfiles_path/$backup_path/$home_user_dotfiles_path"
# 					[ $? -ne 0 ] && files_with_errors+=($filename)
# 				done
# 				if [ ! -z $files_with_errors ]; then
# 					echo "There were some issues moving these files ${files_with_errors[*]}
# 					Posible solutions:
# 					- Run the install process again.
# 					- Verify if those files are in the same path.
# 					"
# 					exit 1
# 				fi
# 				break
# 				;;
# 			[Nn] )
# 				echo "DOTLYX: Skipping backup";
# 				break
# 				;;
# 			*)
# 				echo "DOTLYX: Plase provide a valid option."
# 				;;
# 		esac
# 	done
# fi
#
# echo "DOTLYX: dotfiles will be located in: $USER_DOTFILES_PATH"
# mkdir -pv "$USER_DOTFILES_PATH" 2>&1
#
# export USER_DOTFILES_PATH="$(realpath $USER_DOTFILES_PATH)"
# export DOTLYX_HOME_PATH="$USER_DOTFILES_PATH/modules/dotlyx"
#
# if [ -z $USER_DOTFILES_PATH ]; then
# 	echo "DOTLYX: There was an issue setting ENVIRONMENT variables";
# 	exit 1;
# fi
#
# cd $USER_DOTFILES_PATH
# git init
# echo "DOTLYX: Adding dotlyx as gitsubmodule"
# git -c protocol.file.allow=always submodule add "$HOME/Documents/personal/workspace/dotlyx" modules/dotlyx
# echo "DOTLYX: Installing dotlyx submodules..."
# git submodule update --init --recursive
# cp -r "$DOTLYX_HOME_PATH/dotfiles_template/"* .
# sed -i -e "s|XXX_USER_DOTFILES_PATH_XXX|$USER_DOTFILES_PATH|g" "./modules/nix/flake.nix"
# sed -i -e "s|XXX_USERNAME_XXX|$(whoami)|g" "./modules/nix/flake.nix"
# for symlinks_file in "conf.yaml" "conf.macos.yaml"; do
# 	"$DOTLYX_HOME_PATH/modules/dotbot/bin/dotbot" -d "$DOTLYX_HOME_PATH" -c "./symlinks/$symlinks_file"
# done
# source "$DOTLYX_HOME_PATH/scripts/nix/build_config.sh"
#
# if [ $? -ne 0 ]; then
# 	echo "DOTLYX: We stopped the installation cause of some issues. Try wiht a new installation process"
# 	exit 1
# fi
#
# cd $HOME
# echo "DOTLYX: Restart your terminal and Welcome to Dotlyx!"
