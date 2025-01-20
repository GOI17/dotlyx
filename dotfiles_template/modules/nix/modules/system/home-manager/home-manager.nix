{ lib, userPackages ? [], user, dotfilesDirectory, ... }:

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
			".config/nvim-nvchad".source = "${dotfilesDirectory}/" + editors/nvim-nvchad;
			".config/nvim-nvchad".force = true;
			".zshrc".source = "${dotfilesDirectory}" + shell/zsh/.zshrc;
			".zshrc".force = true;
			#".zshenv".source = "$HOME/.dotfiles/shell/zsh/.zshenv";
			#".zlogin".source = "$HOME/.dotfiles/shell/zsh/.zlogin";
			#".zimrc".source = "$HOME/.dotfiles/shell/zsh/.zimrc";
		};
	};

in
{
	useGlobalPkgs = true;
	useUserPackages = true;
	verbose = true;
	users."${user}" = homeconfig { pkgs = userPackages; };
}
