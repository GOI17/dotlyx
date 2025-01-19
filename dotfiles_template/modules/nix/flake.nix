{
	description = "Dotlyx flake template";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
		nix-darwin.url = "github:LnL7/nix-darwin";
		nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
		mac-app-util.url = "github:hraban/mac-app-util";
		nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
		nix-homebrew-core = {
			url = "github:homebrew/homebrew-core";
			flake = false;
		};
		nix-homebrew-cask = {
			url = "github:homebrew/homebrew-cask";
			flake = false;
		};
		nix-homebrew-bundle = {
			url = "github:homebrew/homebrew-bundle";
			flake = false;
		};
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{
		self,
		nix-darwin,
		nixpkgs,
		mac-app-util,
		nix-homebrew,
		nix-homebrew-core,
		nix-homebrew-cask,
		nix-homebrew-bundle,
		home-manager,
		...
	}:
	let
		user = "$(whoami)";
		nix-darwin-config = { pkgs, ... }: import ./modules/system/nix-darwin/nix-darwin.nix {
			darwinHashVersion = self.rev or self.dirtyRev or null;
			inherit user;
			userFonts = with pkgs; [
				nerd-fonts.caskaydia-cove
				jetbrains-mono
			];
		};
		environment-config = { lib, pkgs, ... }: import ./modules/system/environment/environment.nix {
			inherit lib;
			systemPackages = with pkgs; [
				# text editors
				neovim
				# UI apps
				raycast
				# terminal tools
				mas
				tree
				wget
				jq
				gh
				ripgrep
				rename
				neofetch
				jump
				gcc
				openssl
				asdf-vm
				lazygit
				eza
				fd
				fzf
				zsh
				zimfw
			];
		};
		home-manager-config = import ./modules/system/home-manager/home-manager.nix;
		zsh-config = import ./modules/programs/zsh.nix;
		homebrew-config = import ./modules/system/homebrew.nix;
	in
	{
		darwinConfigurations."dotlyx" = nix-darwin.lib.darwinSystem {
			modules = [
				nix-darwin-config
				environment-config
				{
					programs.zsh = zsh-config;
					homebrew = homebrew-config.homebrew {
						# it runs brew install --cask obs
						# "obs"
						# "notion"
						casks = [];
						# it installs apps from apple store. You must be logged in.  
						# Identifier = APP_ID
						# "Yoink" = 457622435;
						masApps = {};
					};
				}
				home-manager.darwinModules.home-manager {
					home-manager = home-manager-config { inherit user; };
				} 
				nix-homebrew.darwinModules.nix-homebrew {
					nix-homebrew = homebrew-config.module {
						inherit user;
						taps = {
							"homebrew/homebrew-core" = nix-homebrew-core;
							"homebrew/homebrew-cask" = nix-homebrew-cask;
							"homebrew/homebrew-bundle" = nix-homebrew-bundle;
						};
					};
				}
				mac-app-util.darwinModules.default
			];
		};
	};
}
