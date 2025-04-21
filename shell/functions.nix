with import ../modules/dotlyx/core/setup/steps/utilities/log_helpers.nix;

''
function vv () {
	local config=$(fd --max-depth 1 --glob 'nvim-*' ~/.config | fzf --prompt="Neovim Configs > " --border --exit-0)

	if [ -z "$config" ];
  then
    ${_w "No config selected"}
    return
  fi

	NVIM_APPNAME=$(basename $config) nvim ''$1
}

function get_ports () {
  local port=$1

  if [ -z "$port" ];
  then
    ${_e "Provide a valid port..."}
    return
  fi

  ${_w "Looking for proocesses using $port..."} 

  local result=$(lsof -i tcp:$port | awk 'FNR==1{next} {printf "%s,", $2}')

  if [ -z "$result" ];
  then
    ${_w "No processes running under $port port"}
    return
  fi

  echo $result | pbcopy

  ${_s "PID's are in you clipboard now"}
}
''
