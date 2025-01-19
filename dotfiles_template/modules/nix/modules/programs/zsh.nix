{ ... }: 

{
	programs.zsh.enable = true;
	programs.zsh.enableCompletion = true;
	programs.zsh.enableBashCompletion = true;
	programs.zsh.enableFzfCompletion = true;
	programs.zsh.enableFzfGit = true;
	programs.zsh.enableFzfHistory = true;
	# programs.zsh.enableSyntaxHighlighting = true;
	programs.zsh.enableFastSyntaxHighlighting = true;
	programs.zsh.enableGlobalCompInit = true;
	programs.zsh.shellAliases = import ../shell/aliases.nix;
	programs.zsh.history.ignoreAllDups = true;
	/*programs.zsh.interactiveShellInit = ''
		# ZSH Ops
		setopt HIST_FCNTL_LOCK
		setopt +o nomatch
		# setopt autopushd

		ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

		# Async mode for autocompletion
		ZSH_AUTOSUGGEST_USE_ASYNC=true
		ZSH_HIGHLIGHT_MAXLENGTH=300
		eval "$(jump shell)"
	'';*/
	#programs.zsh.zimfw.enable = true;
	#programs.zsh.zimfw.theme = "gitster";
	#programs.zsh.zimfw.inputMode = "nvim";
	#programs.zsh.zimfw.modules = [
	#	"gitster"
	#];
}
