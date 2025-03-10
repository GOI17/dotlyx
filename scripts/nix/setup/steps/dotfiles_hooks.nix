{
  script = ''
    #!/usr/bin/env bash

    echo "darwin-rebuild switch --flake ''$HOME/.config/nix-darwin#dotlyx --impure" >> ''$USER_DOTFILES_PATH/.git/hooks/post-commit

    chmod +x ''$USER_DOTFILES_PATH/.git/hooks/post-commit
  '';
}
