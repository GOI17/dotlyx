{ lib, userPackages ? [], ... }:

with lib;
with import ../env.nix;

let
	homeconfig = { pkgs, ... }: {
    home.homeDirectory = home;
		# this is internal compatibility configuration 
		# for home-manager, don't change this!
		home.stateVersion = "23.05";
		# Let home-manager install and manage itself.
		programs.home-manager.enable = true;
		home.packages = pkgs;
		home.sessionVariables = {
			EDITOR = "vim";
		};
		programs.zsh = import "${dotfilesDirectory}/shell/zsh/zsh.nix";
		home.file = {
			".config/nvim-nvchad".source = "${dotfilesDirectory}/editors/nvim-nvchad";
			".config/nvim-nvchad".force = true;
      "~/.wezterm.lua".source = "${dotfilesDirectory}/terminals/wezterm.lua";
      "~/.wezterm.lua".force = true;
		};
	};
in
{
	useGlobalPkgs = true;
	useUserPackages = true;
	verbose = true;
	users."${user}" = homeconfig { pkgs = userPackages; };
  backupFileExtension = "hm.backup";
}
