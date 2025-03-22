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
  enable_backup_prompt = ''
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
            sudo rm -rf ''$USER_DOTFILES_PATH
            break
            ;;
          *)
            ${_e "Plase provide a valid option."}
            ;;
        esac
      done
    fi
  '';
  script = { is_restoring ? false }: ''
    ${if !is_restoring then ''
      ${_s "Looking for existing dotfiles..."}
      ${enable_backup_prompt}
      mkdir -pv "''$USER_DOTFILES_PATH" 2>&1
    '' else ""}

    ${_s "dotfiles will be located in: $USER_DOTFILES_PATH"}

    export USER_DOTFILES_PATH="''$(realpath $USER_DOTFILES_PATH)"
    if [ -z ''$USER_DOTFILES_PATH ]; then
      ${_e "There was an issue setting USER_DOTFILES_PATH variable, please try again"}
      exit 1
    fi

    cd ''$USER_DOTFILES_PATH
  '';
}
