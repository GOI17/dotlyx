{ casks, masApps, ... }:

{
	homebrew = {
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
