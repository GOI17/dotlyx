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

		programs.zsh = import ../../../../../shell/zsh/zsh.nix { inherit dotfilesDirectory; };

		home.file = {
			".config/nvim-nvchad".source = "${dotfilesDirectory}/editors/nvim-nvchad";
			".config/nvim-nvchad".force = true;
      ".config/nix-darwin/flake.nix".source = "${dotfilesDirectory}/modules/nix/flake.nix";
			".config/nix-darwin/flake.nix".force = true;
		};
	};

in
{
	useGlobalPkgs = true;
	useUserPackages = true;
	verbose = true;
	users."${user}" = homeconfig { pkgs = userPackages; };
}
