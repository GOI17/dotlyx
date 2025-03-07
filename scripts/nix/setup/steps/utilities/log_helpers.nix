with import ./colors.nix;

rec {
  _s = message: ''
    echo -e "\${GREEN}DOTLYX:\${RESET} ${WHITE}${message}${RESET}"
  '';
  _e = message: ''
    echo -e "\${RED}DOTLYX:\${RESET} ${WHITE}${message}${RESET}"
  '';
  _w = message: ''
    echo -e "\${YELLOW}DOTLYX:\${RESET} ${WHITE}${message}${RESET}"
  '';
}
