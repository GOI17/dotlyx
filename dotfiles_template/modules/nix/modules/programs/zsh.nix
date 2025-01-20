{ dotfilesDirectory, pkgs ? import <nixpkgs> {} }:

{
	enable = true;
	enableCompletion = true;
	history.ignoreAllDups = true;
	
	initExtra = ''
autoload -Uz vcs_info
autoload -Uz add-zsh-hook && add-zsh-hook precmd vcs_info
prompt_opts=(cr percent sp subst)

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
		"sindresorhus/pure"
	];
}
