with import ./utilities/colors.nix; 
with import ./utilities/log_helpers.nix;

rec {
  get_local_time_in_seconds = ''
      date +%s;
  '';
  create_backup_dir = ''
      local backup_path="pre_dotlyx_dotfiles.${get_local_time_in_seconds}.back"
      ${_s "Creating backup in '$backup_path'"}
      local user_dotfiles_absolute_path=''$(realpath $USER_DOTFILES_PATH)
      local parent_user_dotfiles_path=''$(dirname $user_dotfiles_absolute_path)
      mv ''$user_dotfiles_absolute_path "''$parent_user_dotfiles_path/''$backup_path";
      local home_user_dotfiles_path="pre_dotlyx_home_dotfiles.${get_local_time_in_seconds}.back"
      mkdir -pv "''$parent_user_dotfiles_path/''$backup_path/''$home_user_dotfiles_path"
      local current_dotfiles="''$(ls -a ~ | grep -v dotlyx | grep -e zsh -e bash -e dot)"
      local files_with_errors=()
      for filename in ''$current_dotfiles; do
        mv "''$HOME/''$filename" "''$parent_user_dotfiles_path/''$backup_path/''$home_user_dotfiles_path"
        [ ''$? -ne 0 ] && files_with_errors+=(''$filename)
      done
      if [ ! -z ''$files_with_errors ]; then
        ${_e "There were some issues moving these files $files_with_errors[*]
        Posible solutions:
        - Run the install process again.
        - Verify if those files are in the same path.
        "}
        exit 1
      fi
  '';
  script = ''
    if ! [[ ''$SHELL =~ "zsh" ]]; then
        ${_s "Setting zsh as default shell"}
        sudo chsh -s "''$(command -v zsh)"
    fi

    ${_s "Looking for existing dotfiles..."}

    if [ -d "''$USER_DOTFILES_PATH" ]; then
      while true; do
        read -p "The path ''${USER_DOTFILES_PATH} already exists. Do you want to create a backup? (y/n): " is_backup_required
        case ''$is_backup_required in
          [Yy] ) 
            ${create_backup_dir}
            break
            ;;
          [Nn] )
            ${_w "Skipping backup"}
            rm -rf ''$USER_DOTFILES_PATH
            break
            ;;
          *)
            ${_e "Plase provide a valid option."}
            ;;
        esac
      done
    fi

    ${_s "dotfiles will be located in: $USER_DOTFILES_PATH"}
    mkdir -pv "''$USER_DOTFILES_PATH" 2>&1

    export USER_DOTFILES_PATH="''$(realpath $USER_DOTFILES_PATH)"
    if [ -z ''$USER_DOTFILES_PATH ]; then
      ${_e "There was an issue setting USER_DOTFILES_PATH variable, please try again"}
      exit 1
    fi

    cd ''$USER_DOTFILES_PATH

    # TODO: Move into his own step script 'Manage dotlyx settings'
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
    sed -i -e "s|XXX_USER_DOTFILES_PATH_XXX|''$USER_DOTFILES_PATH|g" "./modules/nix/flake.nix"
    sed -i -e "s|XXX_USERNAME_XXX|''$(whoami)|g" "./modules/nix/flake.nix"

    if ! $(type darwin-rebuild >/dev/null 2>&1); then
      ${_s "Installing nix-darwin..."}
      nix --extra-experimental-features "nix-command flakes" \
        run nix-darwin -- switch \
        --flake ''$USER_DOTFILES_PATH/modules/nix#dotlyx --impure
    else
      darwin-rebuild switch --flake ''$USER_DOTFILES_PATH/modules/nix#dotlyx --impure
    fi

    if [ ''$? -ne 0 ]; then
        ${_e "We stopped the installation. Try with a new installation process"}
        exit 1
    fi

    cd ''$HOME
    ${_s "Restart your terminal and Welcome to Dotlyx!"}
  '';
}
