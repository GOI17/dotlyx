{
  description = "Dotlyx Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    system = "aarch64-darwin";  # (x86_64-linux, aarch64-darwin, etc.)
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [
        pkgs.vim
      ];

      environment.variables = {
        DOTLYX_HOME_PATH="~/Documents/personal/workspace/dotlyx";
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
  };
}
