let
	fn = import ./environment.nix;
	pkgs = import <nixpkgs> {};
in fn { lib = pkgs.lib; systemPackages = with pkgs; [ neovim ]; }
