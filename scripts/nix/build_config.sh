#!/usr/bin/env bash

echo "DOTLYX: Initializing Nix default configurations"

command_exists() {
    type "$1" >/dev/null 2>&1
}

cd "$HOME/.config/nix-darwin"

if ! command_exists darwin-rebuild; then
	echo "DOTLYX: Installing nix-darwin..."
	sudo mkdir -p /etc/nix
	sudo touch /etc/nix/registry.json
	sudo chmod 644 /etc/nix/registry.json
	export SSL_CERT_FILE=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt
	export NIX_SSL_CERT_FILE=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt
	nix --extra-experimental-features "nix-command flakes" \
		run nix-darwin -- switch \
		--flake .
	#/bin/zsh -c "source '$HOME/.zshrc'"
fi

echo "DOTLYX: Setting your nix configurations..."
darwin-rebuild switch --flake . --impure
