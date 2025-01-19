{ ... }:

{
	homebrew = {
		enable = true;
		casks = [
			# it runs brew install --cask obs
			# "obs"
			# "notion"
		];
		masApps = {
			# it installs apps from apple store. You must be logged in.  
			# Identifier = APP_ID
			# "Yoink" = 457622435;
		};

		onActivation = {
			cleanup = "zap";
			autoUpdate = true;
			upgrade = true;
		};
	};

}
