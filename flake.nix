{
  description = "Dotlyx Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    macosDefaults = import ./macos_defaults.nix;
    system = "aarch64-darwin";  # (x86_64-linux, aarch64-darwin, etc.)
    configuration = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        mas
        neovim
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
        raycast
        karabiner-elements
        brave
        lazygit
        eza
        fd
      ];

      environment.variables = {
        DOTLYX_HOME_PATH="$HOME/Documents/personal/workspace/dotlyx";
        TESTING="DUMMY";
        EDITOR="NVIM_APPNAME=nvim-nvchad";
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
      # nixpkgs.config.allowUnsupportedSystem = true;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Joses-MacBook-Pro
    darwinConfigurations."Joses-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration 
      ];
    };
    programs = { pkgs }: {
      defaults.settings = macosDefaults
      // {
        # INFO: Override example:
        # "com.apple.dock".titlesize = 64;
      };

      zsh.initExtra = ". ${pkgs.asdf-vm}/share/asdf-vm/asdf.sh";
      zsh.plugins = [
        {
          name = "fzf-tab";
          src = pkgs.fetchFromGitHub {
            owner = "Aloxaf";
            repo = "fzf-tab";
            rev = "c2b4aa5ad2532cca91f23908ac7f00efb7ff09c9";
            sha256 = "1b4pksrc573aklk71dn2zikiymsvq19bgvamrdffpf7azpq6kxl2";
          };
        }
      ];
    };
  };
}
