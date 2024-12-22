{
  home.sessionVariables = {
    EDITOR = "vim";
    SHELL = "/bin/bash";
  };

  programs.bash.enable = true;
  programs.zsh.enable = true;

  home.packages = with pkgs; [
    htop
    wget
  ];
}
