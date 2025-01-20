{ dotfilesDirectory }:

{
	enable = true;
	enableCompletion = true;
	history.ignoreAllDups = true;
	
	initExtra = ''
source {dotfilesDirectory}/shell/zsh/theme
	'';

	#enableBashCompletion = true;
	#enableFzfCompletion = true;
	#enableFzfGit = true;
	#enableFzfHistory = true;
	#enableSyntaxHighlighting = true;
	#enableFastSyntaxHighlighting = true;
	#enableGlobalCompInit = true;

	antidote.enable = true;
	antidote.plugins = [
		"zsh-users/zsh-syntax-highlighting"
		"zsh-users/zsh-autosuggestions"
	];
}
