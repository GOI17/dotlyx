let
	fn = import ./nix-darwin.nix;
in fn { self = {}; user = "testuser"; pkgs = {}; darwinHashVersion = "324saljfds47"; }

