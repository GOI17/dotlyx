with import ./colors.nix;

rec {
  messages = {
    new = ''
      echo -e "${CYAN}******************************************${RESET}"
      echo -e "${BOLD}${WHITE}Hey welcome to ${GREEN}Dotlyx${RESET}${BOLD}!${RESET}"
      echo -e "${CYAN}******************************************${RESET}"
      echo -e "${BOLD}${WHITE}We're glad to have you here.${RESET}"
      echo -e "${BOLD}${WHITE}Let's get started!${RESET}"
      echo -e "${CYAN}******************************************${RESET}"
    '';
    rebuild = ''
      echo -e "${CYAN}******************************************${RESET}"
      echo -e "${BOLD}${WHITE}Rebuilding your new cool settings!${RESET}"
      echo -e "${CYAN}******************************************${RESET}"
    '';
    restore = ''
      echo -e "${BOLD}${WHITE}Hey welcome back to ${GREEN}Dotlyx${RESET}${BOLD}!${RESET}"
      echo -e "${BOLD}${WHITE}Let's get started!${RESET}"
      echo -e "${CYAN}******************************************${RESET}"
    '';
    update = ''
      echo -e "${CYAN}******************************************${RESET}"
      echo -e "${BOLD}${WHITE}Searching for updates in our core...${RESET}"
      echo -e "${CYAN}******************************************${RESET}"
    '';
    version = ''
      echo -e "${CYAN}******************************************${RESET}"
      echo -e "${BOLD}${WHITE}Your local information${RESET}"
      echo -e "${CYAN}******************************************${RESET}"
    '';
  };

  script = { type ? "new" }: ''
    ${messages."${type}"}
  '';
}
