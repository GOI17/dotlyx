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
    commonModules = [
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
        home.packages = with nixpkgs; [
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
      }
    ];
  in
  {
    darwinConfigurations."dotlyx" = nix-darwin.lib.darwinSystem {
      modules = commonModules ++ import ./os {} ++ [
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }];
    };
  };
}
