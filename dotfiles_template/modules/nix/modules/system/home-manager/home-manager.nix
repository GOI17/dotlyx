{ lib, userPackages ? [], user, ... }:

with lib;

let
	homeconfig = { pkgs, ... }: {
		# this is internal compatibility configuration 
		# for home-manager, don't change this!
		home.stateVersion = "23.05";
		# Let home-manager install and manage itself.
		programs.home-manager.enable = true;

		home.packages = pkgs;

		home.sessionVariables = {
			EDITOR = "vim";
		};

		home.file = {
		    ".zshrc".source = "$USER_DOTFILES_PATH/shell/zsh/.zshrc";
		    ".zshenv".source = "$USER_DOTFILES_PATH/shell/zsh/.zshenv";
		    ".zlogin".source = "$USER_DOTFILES_PATH/shell/zsh/.zlogin";
		    ".zimrc".source = "$USER_DOTFILES_PATH/shell/zsh/.zimrc";
		};
	};

in
{
	home-manager.darwinModules.home-manager = {
		home-manager.useGlobalPkgs = true;
		home-manager.useUserPackages = true;
		home-manager.verbose = true;
		home-manager.users."${user}" = homeconfig { inherit userPackages; };
	};
}
