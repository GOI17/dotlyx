{ self ? {}, ... }:

{
	imports = [
		./nix-darwin.nix { inherit self; }
		#./home-manager.nix
	];
}
