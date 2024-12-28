#!/usr/bin/env bash

export DOTLYX_HOME_PATH="$HOME/Documents/personal/workspace/dotlyx"
export ZIM_HOME="$HOME/.zim"

source "$DOTLYX_HOME_PATH/scripts/check_for_required_tools.sh"

if [ -e "$HOME/.zshrc" ]; then
  echo "DOTLYX: Backing up current .zshrc..."

  mv "$HOME/.zshrc" "$HOME/.pre_dotlyx_zshrc"
fi

if [ -e "$HOME/.bashrc" ]; then
  echo "DOTLYX: Backing up current .bashrc..."

  mv "$HOME/.bashrc" "$HOME/.pre_dotlyx_bashrc"
fi

# TODO: Create a default rc files with default tools
cp "$DOTLYX_HOME_PATH/modules/shell/.zshrc" ~/.zshrc
cp "$DOTLYX_HOME_PATH/modules/shell/.zimrc" ~/.zimrc


if ! [[ "$SHELL" == zsh ]]; then
	echo "DOTLYX: Setting zsh as the default shell"
	sudo chsh -s "$(command -v zsh)"
fi

echo "DOTLYX: Installing zim..."
curl -fsSL --create-dirs -o "$ZIM_HOME/zimfw.zsh" https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh 2>&1 && zsh "$ZIM_HOME/zimfw.zsh" install 2>&1

source "$DOTLYX_HOME_PATH/scripts/build_nix_config.sh"

echo "DOTLYX: Installing dotbot..."
cd $DOTLYX_HOME_PATH
git submodule update --init --recursive modules/dotbot

cd $HOME

echo "DOTLYX: Restart your terminal and Welcome to Dotlyx!"

