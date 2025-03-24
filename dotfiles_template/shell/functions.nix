with import ../modules/dotlyx/core/setup/steps/utilities/log_helpers.nix;

''
function vv () {
	# Assumes all configs exist in directories named ~/.config/nvim-*
	local config=$(fd --max-depth 1 --glob 'nvim-*' ~/.config | fzf --prompt="Neovim Configs > " --border --exit-0)

	# If I exit fzf without selecting a config, don't open Neovim
	[[ -z $config ]] && ${_w "No config selected"} && return

	# Open Neovim with the selected config
	NVIM_APPNAME=$(basename $config) nvim ''$1
}

function get_ports () {
  local port=$1

  [[ -z $port ]] && ${_e "Provide a valid port..."} && return

  ${_w "Looking for proocesses using $port..."} 

  local result=$(lsof -i tcp:$port | awk 'FNR==1{next} {printf "%s,", $2}')

  [[ -z $result ]] && ${_w "No processes running under $port port"} && return

  echo $result | pbcopy

  ${_s "PID's are in you clipboard now"}
}
''
