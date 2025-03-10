with import ./utilities/log_helpers.nix;

{
  script = ''
    ${_s "Setting dotlyx core configurations"}

    export DOTLYX_HOME_PATH="''$USER_DOTFILES_PATH/modules/dotlyx"
    if [ -z ''$DOTLYX_HOME_PATH ]; then
      ${_e "There was an issue setting DOTLYX_HOME_PATH variable, please try again"}
      exit 1
    fi

    git init
    git config --global protocol.file.allow always
    git submodule add -b main ''$HOME/dotlyx modules/dotlyx
    git submodule update --init --recursive
    git config --global protocol.file.allow never

    rm -rf ''$HOME/dotlyx

    # Edit .gitmodules to change the URL
    git config -f .gitmodules submodule.modules/dotlyx.url https://github.com/goi17/dotlyx.git

    # Sync and update the changes
    git submodule sync
    git submodule update --init --remote
    git add .gitmodules
    git commit -m "Update dotlyx submodule to use remote URL"

    # Setting up dotfiles template
    cp -r "''$DOTLYX_HOME_PATH/dotfiles_template/"* .
    sed -i -e "s|XXX_USER_DOTFILES_PATH_XXX|''$USER_DOTFILES_PATH|g" "./env.nix"
    sed -i -e "s|XXX_USERNAME_XXX|''$(whoami)|g" "./env.nix"
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
