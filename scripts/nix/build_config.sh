#!/usr/bin/env bash

echo "DOTLYX: Initializing Nix default configurations"

command_exists() {
    type "$1" >/dev/null 2>&1
}

cd "$HOME/.config/nix-darwin"

if ! command_exists darwin-rebuild; then
	echo "DOTLYX: Installing nix-darwin..."
	nix --extra-experimental-features "nix-command flakes" \
		run nix-darwin -- switch \
		--flake . --impure
	/bin/zsh -c "source '$HOME/.zshrc'"
fi

[[ $? -ne 0 ]] && exit 1; 

echo "DOTLYX: Setting your nix configurations..."
darwin-rebuild switch --flake . --impure
