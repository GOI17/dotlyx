{
  description = "Dotlyx Manager";

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
  }:
  let
    macosDefaults = import ./macos_defaults.nix;

    system = "aarch64-darwin";

    configuration = { pkgs, ... }: {
      fonts.packages = [
        pkgs.nerd-fonts.caskaydia-cove
      ];

      homebrew = {
        enable = true;
        casks = [
          "obs"
          "shortcat"
          "notion"
          "notion-calendar"
        ];
        masApps = {
          # Identifier = APP_ID
          #"Yoink" = 457622435;
        };

        onActivation = {
          cleanup = "zap";
          autoUpdate = true;
          upgrade = true;
        };
      };

      environment.systemPackages = with pkgs; [
        # text editors
        lite-xl # Lua text editor
        neovim
        # UI apps
        raycast
        karabiner-elements
        brave
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

      environment = {
        shellAliases = { };
        variables = {
          DOTLYX_HOME_PATH="$HOME/Documents/personal/workspace/dotlyx";
          ZIM_HOME="$HOME/.zim";
        };

      };

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
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.allowUnsupportedSystem = true;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Joses-MacBook-Pro
    darwinConfigurations."Joses-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration 
        mac-app-util.darwinModules.default
        nix-homebrew.darwinModules.nix-homebrew {
          nix-homebrew = {
            autoMigrate = true;
            enable = true;
            enableRosetta = true;
            user = "josegilbertoolivasibarra";
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

    programs = { pkgs }: {
      defaults.settings = macosDefaults
      // {
        # INFO: Override example:
        # "com.apple.dock".titlesize = 64;
      };
    };
  };
}
