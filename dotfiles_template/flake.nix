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
    modules = [
      import ./system/environment.nix
      {
        nix.settings.experimental-features = "nix-command flakes";
        fonts.fontconfig.enable = true;
        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 5;
        # The platform the configuration will be used on.
        # nixpkgs.hostPlatform = "aarch64-darwin";
        # Allows to install non-opensource applications
        nixpkgs.config.allowUnfree = true;
        # Allows to install non-compatible architecture applications
        nixpkgs.config.allowUnsupportedSystem = true;
      }
    ];
    packages = { pkgs, ... }: with pkgs; [
      # text editors
      neovim
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
      nerd-fonts.caskaydia-cove
      jetbrains-mono
    ];
  in
  {
    homeConfigurations = {
      "dotlyx@linux" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = modules ++ packages ++ [];
      };
      "dotlyx@mac-intel" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-darwin;
        modules = modules ++ packages ++ [];
      };
      "dotlyx@mac-sillicon" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        modules = modules ++ packages ++ [
          import ./os/mac/silicon/home.nix
          mac-app-util.darwinModules.default
        ];
      };
    };
  };
}
