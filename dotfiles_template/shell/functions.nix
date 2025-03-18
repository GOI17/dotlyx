with import ../modules/dotlyx/core/setup/steps/utilities/log_helpers.nix;

''
function vv () {
	# Assumes all configs exist in directories named ~/.config/nvim-*
	local config=$(fd --max-depth 1 --glob 'nvim-*' ~/.config | fzf --prompt="Neovim Configs > " --border --exit-0)

	# If I exit fzf without selecting a config, don't open Neovim
	[[ -z $config ]] && echo "No config selected" && return

	# Open Neovim with the selected config
	NVIM_APPNAME=$(basename $config) nvim
}

function get_ports () {
  local port=$1

  [[ -z $port ]] && echo "Provide a valid port..." && return

  echo "Looking for proocesses using $port..."

  local result=$(lsof -i tcp:$port | awk 'FNR==1{next} {printf "%s,", $2}')

  [[ -z $result ]] && echo "No processes running under $port port" && return

  echo $result | pbcopy

  echo "PID's are in you clipboard now"
}

function dotlyx_core_rebuild () {
  $USER_DOTFILES_PATH/result/bin/dotlyx-setup -- -u
  nix build --file $DOTLYX_HOME_PATH/core/setup/install.nix
  sudo rm -rf $USER_DOTFILES_PATH/result
  mv ./result $USER_DOTFILES_PATH
}
''
