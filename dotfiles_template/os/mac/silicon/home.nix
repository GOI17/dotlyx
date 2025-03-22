{ pkgs, ... }:

with import ../../../env.nix;

{
  home.packages = with pkgs; [
    # UI apps
    raycast
  ];
  homebrew = { casks, masApps, ... }: {
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
  home.homeDirectory = home;
  # this is internal compatibility configuration 
  # for home-manager, don't change this!
  home.stateVersion = "23.05";
  # Let home-manager install and manage itself.
  programs.home-manager.enable = true;
  home.sessionVariables = {
    EDITOR = "vim";
  };
  programs.zsh = import "${dotfilesDirectory}/shell/zsh/zsh.nix";
  home.file = {
    #symlinks
    #ex.
    # ".config/nvim-nvchad".source = "${dotfilesDirectory}/editors/nvim-nvchad";
    # ".config/nvim-nvchad".force = true;
  };
  nix-homebrew.darwinModules.nix-homebrew {
    nix-homebrew = {
      module = { taps, ... }: {
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
    };
  };
}
