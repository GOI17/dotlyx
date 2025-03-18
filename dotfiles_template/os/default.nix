{ stdenv, ... }:

with stdenv;

let
    darwinCfg =
      (if stdenv.isDarwin then with ./env.nix; [
        mac-app-util.darwinModules.default
        # Set Git commit hash for darwin-version.
        {
          system.configurationRevision = self.rev or self.dirtyRev or null;
          home-manager.users."${user}" = import ./os/mac/silicon/home.nix;
          nixpkgs.hostPlatform = "aarch64-darwin";
        }
      ] else []);
    linuxCfg =
      (if stdenv.isLinux then with ./env.nix; [
        {
            nixpkgs.hostPlatform = "x86_64-linux";
            home-manager.users."${user}" = import ./os/linux/home.nix;
        }
      ] else []);
in isDarwin then darwinCfg else linuxCfg;
