with import ./utilities/log_helpers.nix;

{
  script = { is_restoring ? false }: ''
    ${_s "Setting dotlyx core configurations"}

    export DOTLYX_HOME_PATH="''$USER_DOTFILES_PATH/modules/dotlyx"
    if [ -z ''$DOTLYX_HOME_PATH ]; then
      ${_e "There was an issue setting DOTLYX_HOME_PATH variable, please try again"}
      exit 1
    fi

    mv "''$HOME/dotlyx/result" ''$USER_DOTFILES_PATH
    sudo rm -rf ''$HOME/dotlyx

    ${if !is_restoring then ''
      git init
      git config --global protocol.file.allow always
      git submodule add -b main ''$HOME/dotlyx modules/dotlyx
      git submodule update --init --recursive
      git config --global protocol.file.allow never

      # Edit .gitmodules to change the URL
      git config -f .gitmodules submodule.modules/dotlyx.url https://github.com/goi17/dotlyx.git

      # Sync and update the changes
      git submodule sync
      git submodule update --init --remote
      git add .gitmodules
      git commit -m "Update dotlyx submodule to use remote URL"
      cp -r "''$DOTLYX_HOME_PATH/dotfiles_template/"* .
    '' else ''
      git submodule update --init --remote
    ''}

    # Setting up dotfiles template
    sed -i -e "s|XXX_USER_DOTFILES_PATH_XXX|''$USER_DOTFILES_PATH|g" "''$USER_DOTFILES_PATH/env.nix"
    sed -i -e "s|XXX_DOTLYX_HOME_PATH_XXX|''$DOTLYX_HOME_PATH|g" "''$USER_DOTFILES_PATH/env.nix"
    sed -i -e "s|XXX_USER_NAME_XXX|''$(whoami)|g" "''$USER_DOTFILES_PATH/env.nix"
    sed -i -e "s|XXX_USER_HOME_XXX|''$HOME|g" "''$USER_DOTFILES_PATH/env.nix"
    ln -sf ''$USER_DOTFILES_PATH/flake.nix ''$HOME/.config/nix-darwin/flake.nix 
    cd ''$HOME/.config/nix-darwin

    if ! $(type darwin-rebuild >/dev/null 2>&1); then
      ${_s "Installing nix-darwin..."}
      nix --extra-experimental-features "nix-command flakes" \
        run nix-darwin -- switch \
        --flake .#dotlyx --impure
    else
      darwin-rebuild switch --flake .#dotlyx --impure
    fi
  '';
}
