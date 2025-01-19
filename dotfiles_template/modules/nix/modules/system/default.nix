{ ... }@attrs:

{
	imports = [
		./nix-darwin.nix { inherit attrs; }
		#./home-manager.nix
	];
}
