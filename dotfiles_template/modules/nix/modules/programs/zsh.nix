{
	enable = true;
	enableCompletion = true;
	enableBashCompletion = true;
	enableFzfCompletion = true;
	enableFzfGit = true;
	enableFzfHistory = true;
	# enableSyntaxHighlighting = true;
	enableFastSyntaxHighlighting = true;
	enableGlobalCompInit = true;
	#shellAliases = import ../shell/aliases.nix;
	#history.ignoreAllDups = true;
	/*interactiveShellInit = ''
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
	#zimfw.enable = true;
	#zimfw.theme = "gitster";
	#zimfw.inputMode = "nvim";
	#zimfw.modules = [
	#	"gitster"
	#];
}
