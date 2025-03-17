rec {
  script = with import ./colors.nix; ''
    # Display the styled welcome message
    echo -e "\${CYAN}********************************************\${RESET}"
    echo -e "\${BOLD}\${WHITE}Welcome to \${GREEN}Dotlyx\${RESET}\${BOLD}!\${RESET}"
    echo -e "\${CYAN}********************************************\${RESET}"
    echo -e "\${BOLD}\${WHITE}We're glad to have you here.\${RESET}"
    echo -e "\${BOLD}\${WHITE}Let's get started!\${RESET}"
    echo -e "\${CYAN}********************************************\${RESET}"
  '';
}
