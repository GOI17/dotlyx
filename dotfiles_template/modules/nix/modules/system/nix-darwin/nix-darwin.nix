{ self, user, pkgs, ... }:

{
	# Add your custom fonts
	# ex.
	# fonts.packages = [
	#   pkgs.nerd-fonts.caskaydia-cove
	#   pkgs.jetbrains-mono
	# ];

	# Necessary for using flakes on this system.
	nix.settings.experimental-features = "nix-command flakes";

	# Set Git commit hash for darwin-version.
	system.configurationRevision = self.rev or self.dirtyRev or null;

	# Used for backwards compatibility, please read the changelog before changing.
	# $ darwin-rebuild changelog
	system.stateVersion = 5;

	# The platform the configuration will be used on.
	nixpkgs.hostPlatform = "aarch64-darwin";

	# Allows to install non-opensource applications
	nixpkgs.config.allowUnfree = true;

	# Allows to install non-compatible architecture applications
	nixpkgs.config.allowUnsupportedSystem = true;

	# Declare the user that will be running `nix-darwin`.
	users.users."${user}" = rec {
	    name = "${user}";
	    home = "/Users/${name}";
	};

	#nix-homebrew.darwinModules.nix-homebrew = {
	#	nix-homebrew = {
	#		autoMigrate = true;
	#		enable = true;
	#		enableRosetta = true;
	#		user = "${userName}";
	#		mutableTaps = false;
	#		taps = {
	#			"homebrew/homebrew-core" = nix-homebrew-core;
	#			"homebrew/homebrew-cask" = nix-homebrew-cask;
	#			"homebrew/homebrew-bundle" = nix-homebrew-bundle;
	#		};
	#	};
	#};

}
