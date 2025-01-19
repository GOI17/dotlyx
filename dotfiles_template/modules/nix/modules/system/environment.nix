{ pkgs, ... }: 

{
	environment.extraInit = import ../shell/functions.nix;

	environment.shellAliases = import ../shell/aliases.nix;

	environment.variables = import ../shell/exports.nix
	// rec {
		USER_DOTFILES_PATH= "XXX_USER_DOTFILES_PATH_XXX";
		DOTLYX_HOME_PATH = "${USER_DOTFILES_PATH}/modules/dotlyx";
	};

	environment.pathsToLink = [ "/share/zsh" ];

	environment.systemPackages = with pkgs; [
		# text editors
		neovim
		# UI apps
		raycast
		# terminal tools
		mas
		tree
		wget
		jq
		gh
		ripgrep
		rename
		neofetch
		jump
		gcc
		openssl
		asdf-vm
		lazygit
		eza
		fd
		fzf
		zsh
	];
}

