{ mac-app-util, nix-homebrew, nix-homebrew-core, nix-homebrew-cask, nix-homebrew-bundle, home-manager, self, pkgs, ... }:

with import ../env.nix;

let
  isDarwin = if builtins.currentSystem == "aarch64-darwin" then true else false;
  darwinCfg = [
    mac-app-util.darwinModules.default
    nix-homebrew.darwinModules.nix-homebrew {
      nix-homebrew = {
        autoMigrate = true;
        enable = true;
        enableRosetta = true;
        mutableTaps = false;
        inherit user;
        taps = {
          "homebrew/homebrew-core" = nix-homebrew-core;
          "homebrew/homebrew-cask" = nix-homebrew-cask;
          "homebrew/homebrew-bundle" = nix-homebrew-bundle;
        };
      };
    }
    home-manager.darwinModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${user}" = import ./mac/silicon/home.nix { };
    }
    # Set Git commit hash for darwin-version.
    {
      system.configurationRevision = self.rev or self.dirtyRev or null;
      nixpkgs.hostPlatform = "aarch64-darwin";
      homebrew = {
        enable = true;
        casks = [
          "docker"
        ];
        masApps = {};
        onActivation = {
          cleanup = "zap";
          autoUpdate = true;
          upgrade = true;
        };
      };
      users.users."${user}" = {
          name = user;
          home = home;
      };
    }
  ];
  linuxCfg = [
    home-manager.darwinModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${user}" = import ./linux/home.nix { };
    }
    {
      nixpkgs.hostPlatform = "x86_64-linux";
    }
  ];
in if isDarwin then darwinCfg else linuxCfg
