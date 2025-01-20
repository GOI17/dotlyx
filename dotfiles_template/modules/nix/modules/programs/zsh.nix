{ dotfilesDirectory, pkgs ? import <nixpkgs> {} }:

{
	enable = true;
	enableCompletion = true;
	history.ignoreAllDups = true;
	
	initExtra = ''
autoload promptinit && promptinit
source ${dotfilesDirectory}/shell/zsh/theme
prompt pure
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
		"sindresorhus/pure"
	];
}
