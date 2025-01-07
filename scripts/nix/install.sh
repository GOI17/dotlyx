#!/usr/bin/env bash

read -p 'Where are going to be located your dotfiles?
- Default: ~/.dotfiles
- Custom: ~/Documents/dotfiles
Press enter to keep default location: ' USER_DOTFILES_PATH

DEFAULT_USER_DOTFILES_PATH="~/.dotfiles"
USER_DOTFILES_PATH="${USER_DOTFILES_PATH:-$DEFAULT_USER_DOTFILES_PATH}"
USER_DOTFILES_PATH="$(eval echo "$USER_DOTFILES_PATH")"

get_local_time_in_seconds ()
{
  date +%s;
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
				backup_path="pre_dotlyx_dotfiles.$(get_local_time_in_seconds).back"
				echo "DOTLYX: Creating backup in '$backup_path'";
				user_dotfiles_absolute_path=$(realpath $USER_DOTFILES_PATH)
				parent_user_dotfiles_path=$(dirname $user_dotfiles_absolute_path)
				mv $user_dotfiles_absolute_path "$parent_user_dotfiles_path/$backup_path";
				home_user_dotfiles_path="pre_dotlyx_home_dotfiles.$(get_local_time_in_seconds).back"
				mkdir -pv "$parent_user_dotfiles_path/$backup_path/$home_user_dotfiles_path"
				current_dotfiles="$(ls -a ~ | grep -v dotlyx | grep -e zsh -e bash -e dot)"
				files_with_errors=()
				for filename in $current_dotfiles; do
					mv "$HOME/$filename" "$parent_user_dotfiles_path/$backup_path/$home_user_dotfiles_path"
					if [ $? -ne 0 ]; then files_with_errors+=($filename); fi
				done
				if [ ! -z $files_with_errors ]; then
					echo "There were some issues moving these files ${files_with_errors[*]}
					Posible solutions:
					- Run the install process again.
					- Verify if those files are in the same path.
					"
					exit 1
				fi
				break
				;;
			[Nn] )
				echo "DOTLYX: Skipping backup";
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
export DOTLYX_HOME_PATH="$USER_DOTFILES_PATH/modules/dotlyx"
export ZIM_HOME="$USER_DOTFILES_PATH/modules/zim"

echo "DOTLYX: ENVIRONMENT VARIABLES:
USER_DOTFILES_PATH: $USER_DOTFILES_PATH
DOTLYX_HOME_PATH: $DOTLYX_HOME_PATH
ZIM_HOME: $ZIM_HOME
"

if [ -z $USER_DOTFILES_PATH ]; then echo "DOTLYX: There was an issue setting ENVIRONMENT variables"; exit 1; fi

cd $USER_DOTFILES_PATH
git init
echo "DOTLYX: Adding dotlyx as gitsubmodule"
git -c protocol.file.allow=always submodule add "$HOME/Documents/personal/workspace/dotlyx" modules/dotlyx
source "$DOTLYX_HOME_PATH/scripts/nix/check_for_required_tools.sh"
echo "DOTLYX: Installing dotlyx submodules..."
git submodule update --init --recursive
cp -r "$DOTLYX_HOME_PATH/dotfiles_template/"* .
for file in "./modules/nix/flake.nix"; do
	sed -i -e "s|XXX_USER_DOTFILES_PATH_XXX|$USER_DOTFILES_PATH|g" $file
done
for symlinks_file in "conf.yaml" "conf.macos.yaml"; do
	"$DOTLYX_HOME_PATH/modules/dotbot/bin/dotbot" -d "$DOTLYX_HOME_PATH" -c "./symlinks/$symlinks_file"
done
#echo "DOTLYX: Installing zim..."
#curl -fsSL --create-dirs -o "$ZIM_HOME/zimfw.zsh" \
#  https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh 2>&1 && \
#  zsh "$ZIM_HOME/zimfw.zsh" install
source "$DOTLYX_HOME_PATH/scripts/nix/build_config.sh"
cd $HOME
echo "DOTLYX: Restart your terminal and Welcome to Dotlyx!"
