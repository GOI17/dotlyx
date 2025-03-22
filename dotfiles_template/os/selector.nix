{ mac-app-util, self, pkgs, ... }:

with import ../env.nix;

let
  isDarwin = if builtins.currentSystem == "aarch64-darwin" then true else false;
  darwinCfg = [
    mac-app-util.darwinModules.default
    # Set Git commit hash for darwin-version.
    {
      system.configurationRevision = self.rev or self.dirtyRev or null;
      home-manager.users."${user}" = import ./mac/silicon/home.nix { inherit pkgs; };
      nixpkgs.hostPlatform = "aarch64-darwin";
    }
  ];
  linuxCfg = [
    {
      nixpkgs.hostPlatform = "x86_64-linux";
      home-manager.users."${user}" = import ./linux/home.nix;
    }
  ];
in if isDarwin then darwinCfg else linuxCfg
