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

  outputs = inputs@{nix-darwin, ...}:
  let
    pkgs = import <nixpkgs> {
      config.allowUnfree = true;
      config.allowUnsupportedSystem = true;
    };
    pkgsFor = system: import <nixpkgs> {
      inherit system;
      config.allowUnfree = true;
      config.allowUnsupportedSystem = true;
    };
    osConfigs = let
      args = inputs // { inherit pkgs; };
    in import ./os/selector.nix args;
  in
  {
    darwinConfigurations."dotlyx" = nix-darwin.lib.darwinSystem {
      modules = osConfigs ++ [
        {
          nix.settings.experimental-features = "nix-command flakes";
          system.stateVersion = 5;
          environment.extraInit =
            import ./shell/functions.nix //
            import ./modules/dotlyx/shell/functions.nix;
          environment.shellAliases =
            import ./shell/aliases.nix //
            import ./modules/dotlyx/shell/aliases.nix;
          environment.variables = with import ./env.nix;
            import ./shell/exports.nix //
            import ./modules/dotlyx/shell/exports.nix //
            {
              USER_DOTFILES_PATH = dotfilesDirectory;
              DOTLYX_HOME_PATH = dotlyxDirectory;
            };
          environment.pathsToLink = [ "/share/zsh" ];
          environment.systemPackages = with pkgs; [
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

    nixosConfigurations."dotlyx" = pkgs.lib.nixosSystem {
      modules = osConfigs ++ [
        {
          nix.settings.experimental-features = "nix-command flakes";
          system.stateVersion = 5;
          environment.extraInit =
            import ./shell/functions.nix //
            import ./modules/dotlyx/shell/functions.nix;
          environment.shellAliases =
            import ./shell/aliases.nix //
            import ./modules/dotlyx/shell/aliases.nix;
          environment.variables = with import ./env.nix;
            import ./shell/exports.nix //
            import ./modules/dotlyx/shell/exports.nix //
            {
              USER_DOTFILES_PATH = dotfilesDirectory;
              DOTLYX_HOME_PATH = dotlyxDirectory;
            };
          # `environment.pathsToLink` is not a NixOS option; it is omitted.
          environment.systemPackages = with pkgs; [
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

    # Provide a default package for Linux systems so that
    # `nix build .#packages.<system>.default` works.
    packages = {
      aarch64-linux = {
        default = (pkgsFor "aarch64-linux").neovim;
        dotlyx-setup = import ./core/setup/install.nix { pkgs = pkgsFor "aarch64-linux"; };
      };
      x86_64-linux = {
        default = (pkgsFor "x86_64-linux").neovim;
        dotlyx-setup = import ./core/setup/install.nix { pkgs = pkgsFor "x86_64-linux"; };
      };
      aarch64-darwin = {
        default = (pkgsFor "aarch64-darwin").neovim;
        dotlyx-setup = import ./core/setup/install.nix { pkgs = pkgsFor "aarch64-darwin"; };
      };
      x86_64-darwin = {
        default = (pkgsFor "x86_64-darwin").neovim;
        dotlyx-setup = import ./core/setup/install.nix { pkgs = pkgsFor "x86_64-darwin"; };
      };
    };

    # Provide a minimal app entry for Linux and Darwin so that
    # `nix run .#apps.<system>.default` works.
    apps = {
      aarch64-linux = {
        default = {
          type = "app";
          program = "${packages.aarch64-linux.default}/bin/nvim";
        };
        dotlyx-setup = {
          type = "app";
          program = "${packages.aarch64-linux.dotlyx-setup}/bin/dotlyx-setup";
        };
      };
      x86_64-linux = {
        default = {
          type = "app";
          program = "${packages.x86_64-linux.default}/bin/nvim";
        };
        dotlyx-setup = {
          type = "app";
          program = "${packages.x86_64-linux.dotlyx-setup}/bin/dotlyx-setup";
        };
      };
      aarch64-darwin = {
        default = {
          type = "app";
          program = "${packages.aarch64-darwin.default}/bin/nvim";
        };
        dotlyx-setup = {
          type = "app";
          program = "${packages.aarch64-darwin.dotlyx-setup}/bin/dotlyx-setup";
        };
      };
      x86_64-darwin = {
        default = {
          type = "app";
          program = "${packages.x86_64-darwin.default}/bin/nvim";
        };
        dotlyx-setup = {
          type = "app";
          program = "${packages.x86_64-darwin.dotlyx-setup}/bin/dotlyx-setup";
        };
      };
    };
  };
}