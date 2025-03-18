with import ./colors.nix; 

rec {
  new_user = ''
    echo -e "\${BOLD}\${WHITE}We're glad to have you here.\${RESET}"
    echo -e "\${BOLD}\${WHITE}Let's get started!\${RESET}"
    echo -e "\${CYAN}********************************************\${RESET}"
  '';
  rebuild_settings = ''
    echo -e "\${BOLD}\${WHITE}Rebuilding your new cool settings!\${RESET}"
    echo -e "\${CYAN}********************************************\${RESET}"
  '';
  script = { type ? "new" }: ''
    # Display the styled welcome message
    echo -e "\${CYAN}********************************************\${RESET}"
    echo -e "\${BOLD}\${WHITE}Welcome to \${GREEN}Dotlyx\${RESET}\${BOLD}!\${RESET}"
    echo -e "\${CYAN}********************************************\${RESET}"
    ${if type == "rebuild" then rebuild_settings else new_user}
  '';
}
