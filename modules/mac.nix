{
  home.sessionVariables = {
    EDITOR = "vim";
    SHELL = "/bin/zsh";
  };

  programs.zsh.enable = true;

  home.packages = with pkgs; [
    iterm2
    wget
  ];
}
