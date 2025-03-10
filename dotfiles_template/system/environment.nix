{ lib, systemPackages, ... }: 

with lib;
with import ../env.nix;

{
	environment.extraInit = import ../shell/functions.nix;
	environment.shellAliases = import ../shell/aliases.nix;
	environment.variables = import ../shell/exports.nix
  // {
    USER_DOTFILES_PATH = dotfilesDirectory;
    DOTLYX_HOME_PATH = dotlyxDirectory;
  };
	environment.pathsToLink = [ "/share/zsh" ];
	environment.systemPackages = systemPackages;
}

