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
		    ".zshrc".source = "$HOME/.dotfiles/shell/zsh/.zshrc";
		    ".zshenv".source = "$HOME/.dotfiles/shell/zsh/.zshenv";
		    ".zlogin".source = "$HOME/.dotfiles/shell/zsh/.zlogin";
		    ".zimrc".source = "$HOME/.dotfiles/shell/zsh/.zimrc";
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
