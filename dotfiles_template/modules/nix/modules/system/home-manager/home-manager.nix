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

		programs.zsh = import ../../programs/zsh.nix;
		home.file = {
			".config/nvim-nvchad" = "$HOME/.dotfiles/editors/nvim-nvchad";
			".zshrc".source = "$HOME/.dotfiles/shell/zsh/.zshrc";
			".zshenv".source = "$HOME/.dotfiles/shell/zsh/.zshenv";
			".zlogin".source = "$HOME/.dotfiles/shell/zsh/.zlogin";
			".zimrc".source = "$HOME/.dotfiles/shell/zsh/.zimrc";
		};
	};

in
{
	useGlobalPkgs = true;
	useUserPackages = true;
	verbose = true;
	users."${user}" = homeconfig { pkgs = userPackages; };
}
