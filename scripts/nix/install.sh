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
