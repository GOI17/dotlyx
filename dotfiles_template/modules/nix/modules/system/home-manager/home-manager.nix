{ lib, pkgs, user, ... }:

with lib;

let
	homeconfig = { pkgs, ... }: {
		# this is internal compatibility configuration 
		# for home-manager, don't change this!
		home.stateVersion = "23.05";
		# Let home-manager install and manage itself.
		programs.home-manager.enable = true;

		home.packages = mkDefault {
			description = "Dedicated user packages";
			type = with types; listOf package;
			default = [];
			value = pkgs;
		};

		home.sessionVariables = {
			EDITOR = "vim";
		};
	};

in
{
	home-manager.darwinModules.home-manager = {
		home-manager.useGlobalPkgs = true;
		home-manager.useUserPackages = true;
		home-manager.verbose = true;
		home-manager.users."${user}" = homeconfig { inherit pkgs; };
	};
}
