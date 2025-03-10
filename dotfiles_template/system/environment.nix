{ lib, systemPackages, ... }: 

with lib;
with import ../env.nix;

{
	environment.extraInit = import ../shell/functions.nix;
	environment.shellAliases = import ../shell/aliases.nix;
	environment.variables = import ../shell/exports.nix
  // {
    testing = dotfilesDirectory
  };
	environment.pathsToLink = [ "/share/zsh" ];
	environment.systemPackages = systemPackages;
}

