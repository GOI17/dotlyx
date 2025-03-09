with import ../../env.nix;

{
	enable = true;
	enableCompletion = true;
	history.ignoreAllDups = true;
	
	initExtra = ''
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
autoload _Uz add-zsh-hook && add-zsh-hook precmd precmd_vcs_info
prompt_opts=(cr percent sp subst)

# Replace with your custom theme path
# ex. ${dotfilesDirectory}/shell/zsh/themes/theme
source ${dotfilesDirectory}/modules/dotlyx/shell/zsh/themes/theme
	'';

	antidote.enable = true;
	antidote.plugins = [
		"zsh-users/zsh-syntax-highlighting"
		"zsh-users/zsh-autosuggestions"
	];
}
