{ lib, systemPackages, ... }: 

with lib;

{
	environment.extraInit = import ../shell/functions.nix;
	environment.shellAliases = import ../shell/aliases.nix;
	environment.variables = import ../shell/exports.nix // import ../env.nix;
	environment.pathsToLink = [ "/share/zsh" ];
	environment.systemPackages = systemPackages;
}

