{ dotfilesDirectory, pkgs ? import <nixpkgs> {} }:

{
	enable = true;
	enableCompletion = true;
	history.ignoreAllDups = true;
	
	initExtra = ''
source ${pkgs.antidote.gitstatus}/gitstatus/gitstatus.plugin.zsh
source ${dotfilesDirectory}/shell/zsh/theme
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
		"romkatv/gitstatus"
	];
}
