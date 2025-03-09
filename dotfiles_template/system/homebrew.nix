with import ../env.nix;

{
	module = { taps, ... }: {
		autoMigrate = true;
		enable = true;
		enableRosetta = true;
		mutableTaps = false;
		inherit user;
		inherit taps;
	};

	homebrew = { casks, masApps, ... }: {
		enable = true;
		casks = casks;
		masApps = masApps;
		onActivation = {
			cleanup = "zap";
			autoUpdate = true;
			upgrade = true;
		};
	};
}
