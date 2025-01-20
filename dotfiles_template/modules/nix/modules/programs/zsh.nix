{ dotfilesDirectory }:

{
	enable = true;
	enableCompletion = true;
	history.ignoreAllDups = true;
	
	initExtra = ''
CODELY_THEME_MINIMAL=true
CODELY_THEME_MODE="dark"
CODELY_THEME_PROMPT_IN_NEW_LINE=false
CODELY_THEME_PWD_MODE="short" # full, short, home_relative
CODELY_THEME_STATUS_ICON_OK="▸"
CODELY_THEME_STATUS_ICON_KO="▪"

[[ $(echotc Co) -gt 100 ]] && support_color_tones=true || support_color_tones=false

git_no_changes_status="✓"
git_dirty_status="✗"

if [ "$CODELY_THEME_MODE" = "dark" ]; then
  git_branch_color="green"
  git_dirty_status_color="yellow"
  git_no_changes_status_color="white"
  git_on_branch_color="white"
  pwd_color="yellow"
  diamond_color="white"
  status_icon_color_ok="green"
  status_icon_color_ko="red"
  [[ $support_color_tones = true ]] && ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8' || ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=magenta'
else
  git_branch_color="black"
  git_dirty_status_color="magenta"
  git_no_changes_status_color="green"
  git_on_branch_color="green"
  pwd_color="black"
  diamond_color="black"
  status_icon_color_ok="black"
  status_icon_color_ko="red"
  [[ $support_color_tones = true ]] && ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8' || ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=magenta'
fi

function short_pwd() {
	if [[ $(pwd) == "$HOME" ]]; then
	  echo "~"
	else
	  current_dir=$(pwd)
	  penultimate_dir=$(/usr/bin/basename "$(dirname "$current_dir")" | cut -c1-2)
	  path=$(dirname "$(dirname "$current_dir")" | sed "s|$HOME|~|g" | sed -E 's|/([^/])[^/]*|/\1|g')

	  echo "$path/$penultimate_dir/$(/usr/bin/basename "$current_dir")"
	fi
}

prompt_codely_pwd() {
  case "$CODELY_THEME_PWD_MODE" in
    short) local -r prompt_dir=$(short_pwd) ;;
    full) local -r prompt_dir="$PWD" ;;
    home_relative) local -r prompt_dir=$(print -rD "$PWD") ;;
  esac

  print -n "%F{$pwd_color}${prompt_dir}"
}

prompt_codely_status="%(?:%F{diamond_color}<%F{$status_icon_color_ok}$CODELY_THEME_STATUS_ICON_OK%F{diamond_color}>:%F{diamond_color}<%F{$status_icon_color_ko}$CODELY_THEME_STATUS_ICON_KO%F{diamond_color}>)"

zstyle ':antidote:git-info:branch' format "%F{$git_branch_color}%b"
zstyle ':antidote:git-info:commit' format "%c"
zstyle ':antidote:git-info:clean' format "%F{$git_no_changes_status_color}$git_no_changes_status"
zstyle ':antidote:git-info:dirty' format "%F{$git_dirty_status_color}$git_dirty_status"
zstyle ':antidote:git-info:keys' format "prompt" " %F{cyan}%b%c %C%D"

PS1="${prompt_codely_status} \$(prompt_codely_pwd) "
RPS1="";
	'';

	#enableBashCompletion = true;
	#enableFzfCompletion = true;
	#enableFzfGit = true;
	#enableFzfHistory = true;
	#enableSyntaxHighlighting = true;
	#enableFastSyntaxHighlighting = true;
	#enableGlobalCompInit = true;

	antidote.enable = true;
	antidote.plugins = [
		"zsh-users/zsh-syntax-highlighting"
		"zsh-users/zsh-autosuggestions"
	];
}
