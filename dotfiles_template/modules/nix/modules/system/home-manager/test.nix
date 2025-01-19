let
	fn = import ./home-manager.nix;
	pkgs = import <nixpkgs> {};
in fn {
	user = "testuser";
	pkgs = with pkgs; [ neovim ];
	lib = pkgs.lib;
}
