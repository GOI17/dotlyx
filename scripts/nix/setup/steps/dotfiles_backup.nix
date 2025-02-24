{
  script = with import ./utilities/colors.nix; ''
    get_local_time_in_seconds ()
    {
      date +%s;
    }

    generate_backup_dir () {
      local backup_path="pre_dotlyx_dotfiles.$(get_local_time_in_seconds).back"
      echo "DOTLYX: Creating backup in '$backup_path'";
      local user_dotfiles_absolute_path=$(realpath $USER_DOTFILES_PATH)
      local parent_user_dotfiles_path=$(dirname $user_dotfiles_absolute_path)
      mv $user_dotfiles_absolute_path "$parent_user_dotfiles_path/$backup_path";
      local home_user_dotfiles_path="pre_dotlyx_home_dotfiles.$(get_local_time_in_seconds).back"
      mkdir -pv "$parent_user_dotfiles_path/$backup_path/$home_user_dotfiles_path"
      local current_dotfiles="$(ls -a ~ | grep -v dotlyx | grep -e zsh -e bash -e dot)"
      local files_with_errors=()
      for filename in $current_dotfiles; do
        mv "$HOME/$filename" "$parent_user_dotfiles_path/$backup_path/$home_user_dotfiles_path"
        [ $? -ne 0 ] && files_with_errors+=($filename)
      done
      if [ ! -z $files_with_errors ]; then
        echo "There were some issues moving these files ''${files_with_errors[*]}
        Posible solutions:
        - Run the install process again.
        - Verify if those files are in the same path.
        "
        exit 1
      fi
    }

    if ! [[ $SHELL =~ "zsh" ]]; then
        echo "DOTLYX: Setting zsh as default shell"
        sudo chsh -s "$(command -v zsh)"
    fi

    echo "DOTLYX: Looking for existing dotfiles..."

    if [ -d "$USER_DOTFILES_PATH" ]; then
      while true; do
        read -p "The path '$USER_DOTFILES_PATH' already exists. Do you want to create a backup? (y/n): " is_backup_required
        case $is_backup_required in
          [Yy] ) 
            generate_backup_dir
            break
            ;;
          [Nn] )
            echo "DOTLYX: Skipping backup";
	    rm -rf $USER_DOTFILES_PATH
            break
            ;;
          *)
            echo "DOTLYX: Plase provide a valid option."
            ;;
        esac
      done
    fi

    echo "DOTLYX: dotfiles will be located in: $USER_DOTFILES_PATH"
    mkdir -pv "$USER_DOTFILES_PATH" 2>&1

    export USER_DOTFILES_PATH="$(realpath $USER_DOTFILES_PATH)"
    if [ -z $USER_DOTFILES_PATH ]; then
      echo "DOTLYX: There was an issue setting USER_DOTFILES_PATH variable, please try again";
      exit 1;
    fi

    cd $USER_DOTFILES_PATH

    echo "TODO: Move into his own step script 'Manage dotlyx settings'"
    export DOTLYX_HOME_PATH="$USER_DOTFILES_PATH/modules/dotlyx"
    if [ -z $DOTLYX_HOME_PATH ]; then
      echo "DOTLYX: There was an issue setting DOTLYX_HOME_PATH variable, please try again";
      exit 1;
    fi
   
    git init
    git submodule add -b main ~/dotlyx $DOTLYX_HOME_PATH
    git submodule update --init --recursive

    rm -rf ~/dotlyx
  '';
}
