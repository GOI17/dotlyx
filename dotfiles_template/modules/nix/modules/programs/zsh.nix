{ dotfilesDirectory }:

{
	enable = true;
	enableCompletion = true;
	history.ignoreAllDups = true;
	
	initExtra = ''
fpath=("${dotfilesDirectory}/shell/zsh/theme" "${dotfilesDirectory}/shell/zsh/completions" $fpath)
prompt codely
	'';

	#enableBashCompletion = true;
	#enableFzfCompletion = true;
	#enableFzfGit = true;
	#enableFzfHistory = true;
	#enableSyntaxHighlighting = true;
	#enableFastSyntaxHighlighting = true;
	#enableGlobalCompInit = true;
	#shellAliases = import ../shell/aliases.nix;

	antidote.enable = true;
	antidote.plugins = [
		"zsh-users/zsh-syntax-highlighting"
		"zsh-users/zsh-autosuggestions"
	];
}
