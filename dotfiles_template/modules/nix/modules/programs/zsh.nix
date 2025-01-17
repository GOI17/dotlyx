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
	programs.zsh.interactiveShellInit = ''
		# ZSH Ops
		setopt HIST_IGNORE_ALL_DUPS
		setopt HIST_FCNTL_LOCK
		setopt +o nomatch
		# setopt autopushd

		ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

		# Async mode for autocompletion
		ZSH_AUTOSUGGEST_USE_ASYNC=true
		ZSH_HIGHLIGHT_MAXLENGTH=300
		eval "$(jump shell)"
	'';
	programs.zsh.shellInit = ''
		export USER_DOTFILES_PATH="XXX_USER_DOTFILES_PATH_XXX"
		export DOTLYX_HOME_PATH="$USER_DOTFILES_PATH/modules/dotlyx"
		export NIX_CONFIG_HOME="$USER_DOTFILES_PATH/modules/nix"
	'';
	programs.zsh.zimfw.enable = true;
	programs.zsh.zimfw.theme = "gitster";
	programs.zsh.zimfw.inputMode = "nvim";
	programs.zsh.zimfw.modules = [
		"gitster"
	];
}
