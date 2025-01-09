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
    ...
  }:
  let
    #systemDefaults = import ./macos_defaults.nix;
    system = "aarch64-darwin";
    userName="$(whoami)";
    hostName="XXX_USER_HOSTNAME_XXX";
    configuration = { pkgs, ... }: {
      # Add your custom fonts
      # ex.
      # fonts.packages = [
      #   pkgs.nerd-fonts.caskaydia-cove
      #   pkgs.jetbrains-mono
      # ];

      homebrew = {
        enable = true;
        casks = [
          # it runs brew install --cask obs
          # "obs"
          # "notion"
        ];
        masApps = {
          # it installs apps from apple store. You must be logged in.  
          # Identifier = APP_ID
          # "Yoink" = 457622435;
        };

        onActivation = {
          cleanup = "zap";
          autoUpdate = true;
          upgrade = true;
        };
      };

      environment.extraInit = import ./functions.nix;

      environment.shellAliases = import ./aliases.nix;

      environment.variables = import ./exports.nix
      // rec {
      	USER_DOTFILES_PATH= "XXX_USER_DOTFILES_PATH_XXX";
      	DOTLYX_HOME_PATH = "${USER_DOTFILES_PATH}/modules/dotlyx";
      };

      environment.systemPackages = with pkgs; [
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

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = system;

      # Allows to install non-opensource applications
      nixpkgs.config.allowUnfree = true;

      # Allows to install non-compatible architecture applications
      nixpkgs.config.allowUnsupportedSystem = true;

      programs.zsh.enable = true;
      programs.zsh.enableCompletion = true;
      programs.zsh.enableBashCompletion = true;
      programs.zsh.enableFzfCompletion = true;
      programs.zsh.enableFzfGit = true;
      programs.zsh.enableFzfHistory = true;
      # programs.zsh.enableSyntaxHighlighting = true;
      programs.zsh.enableFastSyntaxHighlighting = true;
      programs.zsh.enableGlobalCompInit = true;
      programs.zsh.interactiveShellInit = ''
	# ZSH Ops
	setopt HIST_IGNORE_ALL_DUPS
	setopt HIST_FCNTL_LOCK
	setopt +o nomatch
	# setopt autopushd

	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

	# Async mode for autocompletion
	ZSH_AUTOSUGGEST_USE_ASYNC=true
	ZSH_HIGHLIGHT_MAXLENGTH=300
	eval "$(jump shell)"
      '';
      programs.zsh.shellInit = ''
	export USER_DOTFILES_PATH="XXX_USER_DOTFILES_PATH_XXX"
	export DOTLYX_HOME_PATH="$USER_DOTFILES_PATH/modules/dotlyx"
	export NIX_CONFIG_HOME="$USER_DOTFILES_PATH/modules/nix"
      '';
      programs.zsh.zimfw.enable = true;
      programs.zsh.zimfw.theme = "gitster";
      programs.zsh.zimfw.inputMode = "nvim";
      programs.zsh.zimfw.modules = { modules }: with modules; [
	      gitster
      ];
    };
  in
  {
    darwinConfigurations."${hostName}" = nix-darwin.lib.darwinSystem {
      modules = [
      		./modules/zimfw
	      configuration 
	      mac-app-util.darwinModules.default
	      nix-homebrew.darwinModules.nix-homebrew {
			nix-homebrew = {
				autoMigrate = true;
				enable = true;
				enableRosetta = true;
				user = "${userName}";
				mutableTaps = false;
				taps = {
					"homebrew/homebrew-core" = nix-homebrew-core;
					"homebrew/homebrew-cask" = nix-homebrew-cask;
					"homebrew/homebrew-bundle" = nix-homebrew-bundle;
				};
			};
		}
      ];
    };
  };
}
