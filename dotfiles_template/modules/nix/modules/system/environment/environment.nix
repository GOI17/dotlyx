{ lib, systemPackages, ... }: 

with lib;

{
	environment.extraInit = import ../../shell/functions.nix;

	environment.shellAliases = import ../../shell/aliases.nix;

	environment.variables = import ../../shell/exports.nix
	// rec {
		USER_DOTFILES_PATH= "XXX_USER_DOTFILES_PATH_XXX";
		DOTLYX_HOME_PATH = "${USER_DOTFILES_PATH}/modules/dotlyx";
	};

	environment.pathsToLink = [ "/share/zsh" ];

	environment.systemPackages = mkDefault {
		description = "System packages";
		default = [];
		type = with types; listOf package;
		value = systemPackages;
	};
}

