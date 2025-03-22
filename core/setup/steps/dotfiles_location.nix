rec {
  defaultUserDotfilesPath="~/.dotfiles";
  messsage = with import ./utilities/colors.nix; ''
    \${BOLD}\${WHITE}Where do you want to be located your dotfiles?
    \${MAGENTA}-\${RESET} \${BOLD}\${WHITE}Default: ${defaultUserDotfilesPath}
    \${MAGENTA}-\${RESET} \${BOLD}\${WHITE}Custom: ~/Documents/dotfiles

    Press enter to keep default location:\${RESET}
  '';
  script = with import ./utilities/log_helpers.nix; ''
    echo -e "${messsage}" && read -p "" USER_DOTFILES_PATH

    USER_DOTFILES_PATH=''${USER_DOTFILES_PATH:-${defaultUserDotfilesPath}}
    USER_DOTFILES_PATH="$(eval echo "$USER_DOTFILES_PATH")"

    if ! [[ ''$SHELL =~ "zsh" ]]; then
        ${_s "Setting zsh as default shell"}
        sudo chsh -s "''$(command -v zsh)"
    fi
  '';
}
