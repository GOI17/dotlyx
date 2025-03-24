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
    # self,
		nix-darwin,
		# nixpkgs,
		# home-manager,
    # mac-app-util,
    # nix-homebrew,
    # nix-homebrew-cask,
    # nix-homebrew-core,
    # nix-homebrew-bundle,
		...
	}:
  let
    pkgs = import <nixpkgs> {
      # Allows to install non-opensource applications
      config.allowUnfree = true;
      # Allows to install non-compatible architecture applications
      config.allowUnsupportedSystem = true;
    };
    osConfigs = let
      args = inputs // { inherit pkgs; };
    in import ./os/selector.nix args; #{
      # inherit mac-app-util;
      # inherit self;
      # inherit nix-homebrew;
      # inherit nix-homebrew-core;
      # inherit nix-homebrew-cask;
      # inherit nix-homebrew-bundle;
      # inherit home-manager;
      # inherit inputs;
      # inherit pkgs;
    # };
  in 
  {
    darwinConfigurations."dotlyx" = nix-darwin.lib.darwinSystem {
      modules = osConfigs ++ [
        {
          nix.settings.experimental-features = "nix-command flakes";
          system.stateVersion = 5;
          environment.extraInit = import ./shell/functions.nix;
          environment.shellAliases = import ./shell/aliases.nix;
          environment.variables = with import ./env.nix; import ./shell/exports.nix
          // {
            USER_DOTFILES_PATH = dotfilesDirectory;
            DOTLYX_HOME_PATH = dotlyxDirectory;
          };
          environment.pathsToLink = [ "/share/zsh" ];
          environment.systemPackages = with pkgs; [
            neovim
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
    };
  };
}
