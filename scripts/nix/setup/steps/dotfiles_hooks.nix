{ pkgs ? import <nixpkgs> {}, ... }:

{
  script = ''
    #!/usr/bin/env bash

    echo "darwin-rebuild switch --flake ${pkgs.dotlyx-setup}/.config/nix-darwin#dotlyx --impure" >> ''$USER_DOTFILES_PATH/.git/hooks/post-commit

    chmod +x ''$USER_DOTFILES_PATH/.git/hooks/post-commit
  '';
}
