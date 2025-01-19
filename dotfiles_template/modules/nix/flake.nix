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
  {
    darwinConfigurations."dotlyx" = nix-darwin.lib.darwinSystem {
      modules = [
	      ./modules/system/nix-darwin/nix-darwin.nix { self = self; user = "testuser"; pkgs = nixpkgs; }
	      ./modules/system/environment/environment.nix {
	          lib = nixpkgs.lib;
		  systemPackages = with nixpkgs; [
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
		  ];
	       }	
	      ./modules/nix/modules/programs/zsh.nix {}	
	      ./modules/nix/modules/system/homebrew.nix {}	
	      #mac-app-util.darwinModules.default
      ];
    };
  };
}
