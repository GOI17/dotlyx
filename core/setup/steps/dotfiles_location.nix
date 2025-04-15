rec {
  defaultUserDotfilesPath="~/.dotfiles";
  messages = with import ./utilities/colors.nix; {
	new = ''
	    \${BOLD}\${WHITE}Where do you want to be located your dotfiles?
	    \${MAGENTA}-\${RESET} \${BOLD}\${WHITE}Default: ${defaultUserDotfilesPath}
	    \${MAGENTA}-\${RESET} \${BOLD}\${WHITE}Custom: ~/Documents/dotfiles

	    Press enter to keep default location:\${RESET}
	  '';
	restore = ''
	    \${BOLD}\${WHITE}Where do you have your dotfiles?
	'';
  };
  script = with import ./utilities/log_helpers.nix; { type }: ''
    echo -e "${messages."${type}"}" && read -p "" USER_DOTFILES_PATH

    USER_DOTFILES_PATH=''${USER_DOTFILES_PATH:-${defaultUserDotfilesPath}}
    USER_DOTFILES_PATH="$(eval echo "$USER_DOTFILES_PATH")"

    if ! [[ ''$SHELL =~ "zsh" ]]; then
        ${_s "Setting zsh as default shell"}
        sudo chsh -s "''$(command -v zsh)"
    fi
  '';
}
