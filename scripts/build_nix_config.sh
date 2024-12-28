#!/usr/bin/env bash

NIX_CONFIG_HOME="$HOME/.config/nix-darwin"

if [ ! -d $NIX_CONFIG_HOME ]; then
  mkdir -p $NIX_CONFIG_HOME
fi

cd $NIX_CONFIG_HOME

echo "DOTLYX: Initializing Nix default configurations"

DOTLYX_DEFAULT_FLAKE_FILE="$DOTLYX_HOME_PATH/flake.nix"

# INFO: Initialize default template
# nix flakes \
#   --extra-experimental-features "nix-command flakes" init -t nix-darwin
# sed -i '' "s/simple/$(scutil --get LocalHostName)/" flake.nix

cp $DOTLYX_DEFAULT_FLAKE_FILE $NIX_CONFIG_HOME

echo "DOTLYX: Installing nix-darwin..."

NIX_CONFIG_HOME="$HOME/.config/nix-darwin"

nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake $NIX_CONFIG_HOME#Joses-MacBook-Pro

/bin/zsh -c "source '$HOME/.zshrc'"

echo "DOTLYX: Using nix-darwin..."

darwin-rebuild switch --flake $NIX_CONFIG_HOME
