{
  home-manager,
  pkgs,
  ...
}:
[
  home-manager.darwinModules.home-manager {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users."${user}" = import ./home.nix { inherit pkgs; };
  }
  {
    nixpkgs.hostPlatform = "x86_64-linux";
  }
]
