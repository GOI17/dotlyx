#!/bin/bash

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

echo "DOTLYX: Setting up Nix..."

if ! command_exists nix; then
	echo "DOTLYX: nix not installed, trying to install"

  echo "DOTLYX: Installing Nix..."

  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  curl -sSf -L https://install.lix.systems/lix | sh -s -- install
else
	echo "DOTLYX: nix installed, upgrading nix via flakes..."

  sudo --preserve-env=PATH nix run \
    --extra-experimental-features 'nix-command flakes' \
    --extra-substituters https://cache.lix.systems --extra-trusted-public-keys "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o=" \
    'git+https://git.lix.systems/lix-project/lix?ref=refs/tags/2.91.1' -- \
    upgrade-nix \
    --extra-substituters https://cache.lix.systems --extra-trusted-public-keys "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
fi

if [ -e "$HOME/.zshrc" ]; then
  echo "DOTLYX: Backing up current .zshrc..."

  mv "$HOME/.zshrc" "$HOME/.pre_dotlyx_zshrc"
fi

if [ -e "$HOME/.bashrc" ]; then
  echo "DOTLYX: Backing up current .bashrc..."

  mv "$HOME/.bashrc" "$HOME/.pre_dotlyx_bashrc"
fi

touch "$HOME/.bashrc" "$HOME/.zshrc"

NIX_CONFIG_HOME="$HOME/.config/nix-darwin"

if [ ! -d $NIX_CONFIG_HOME ]; then
  mkdir -p $NIX_CONFIG_HOME
fi

cd $NIX_CONFIG_HOME

echo "DOTLYX: Initializing Nix default configurations"

DOTLYX_DEFAULT_FLAKE_FILE="$HOME/Documents/personal/workspace/dotlyx/flake.nix"

# INFO: Initialize default template
# nix --extra-experimental-features flakes \
#   --extra-experimental-features nix-command flake init -t nix-darwin
# sed -i '' "s/simple/$(scutil --get LocalHostName)/" flake.nix

cp $DOTLYX_DEFAULT_FLAKE_FILE $NIX_CONFIG_HOME

echo "DOTLYX: Installing nix-darwin..."

nix --extra-experimental-features flakes run --extra-experimental-features nix-command nix-darwin -- switch --flake $NIX_CONFIG_HOME
source "$HOME/.zshrc"

echo "DOTLYX: Using nix-darwin..."

darwin-rebuild switch --flake $NIX_CONFIG_HOME
cd $HOME

echo "DOTLYX: Restart your terminal and Welcome to Dotlyx!"

