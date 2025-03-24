{ pkgs }:

with import ../../../env.nix;

{
  home.packages = with pkgs; [
    raycast
  ];
  home.username = user;
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
}
