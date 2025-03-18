{ lib, ... }:

with stdenv;

let
  inherit (lib) systems;
  isDarwin = systems.isDarwin builtins.currentSystem;
  darwinCfg = [
    mac-app-util.darwinModules.default
    # Set Git commit hash for darwin-version.
    {
      system.configurationRevision = self.rev or self.dirtyRev or null;
      home-manager.users."${user}" = import ./os/mac/silicon/home.nix;
      nixpkgs.hostPlatform = "aarch64-darwin";
    }
  ];
  linuxCfg = [
    {
      nixpkgs.hostPlatform = "x86_64-linux";
      home-manager.users."${user}" = import ./os/linux/home.nix;
    }
  ];
in if isDarwin then darwinCfg else linuxCfg
