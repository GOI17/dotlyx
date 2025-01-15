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
    hostName="XXX_USER_HOSTNAME_XXX";
    userName="$(whoami)";
  in
  {
    darwinConfigurations."${hostName}" = nix-darwin.lib.darwinSystem {
      modules = [
	      ./nix-darwin.nix { inherit inputs; inherit userName; }
	      ./home-manager.nix { inherit userName; }
	      mac-app-util.darwinModules.default
      ];
    };
  };
}
