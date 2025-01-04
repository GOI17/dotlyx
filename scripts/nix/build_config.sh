#!/usr/bin/env bash

echo "DOTLYX: Initializing Nix default configurations"

command_exists() {
    type "$1" >/dev/null 2>&1
}

if ! command_exists darwin-rebuild; then
  echo "DOTLYX: Installing nix-darwin..."
  nix --extra-experimental-features "nix-command flakes" \
	  run nix-darwin -- switch --flake "$HOME/.config/nix-darwin"
  /bin/zsh -c "source '$HOME/.zshrc'"
fi

echo "DOTLYX: Building nix configurations..."

darwin-rebuild switch --flake "$HOME/.config/nix-darwin"
