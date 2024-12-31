# ------------------------------------------------------------------------------
# Codely theme config
# ------------------------------------------------------------------------------
export CODELY_THEME_MINIMAL=false
export CODELY_THEME_MODE="dark"
# export CODELY_THEME_PROMPT_IN_NEW_LINE=true
export CODELY_THEME_PWD_MODE="short" # full, short, home_relative
# export CODELY_THEME_STATUS_ICON_OK="󰘧"
# export CODELY_THEME_STATUS_ICON_KO="󰘧"

# ------------------------------------------------------------------------------
# Languages
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Apps
# ------------------------------------------------------------------------------
# if [ "$CODELY_THEME_MODE" = "dark" ]; then
# fzf_colors="pointer:#ebdbb2,bg+:#3c3836,fg:#ebdbb2,fg+:#fbf1c7,hl:#8ec07c,info:#928374,header:#fb4934"
# else
# fzf_colors="pointer:#db0f35,bg+:#d6d6d6,fg:#808080,fg+:#363636,hl:#8ec07c,info:#928374,header:#fffee3"
# fi

# export FZF_DEFAULT_OPTS="--color=$fzf_colors --reverse"
export FZF_DEFAULT_OPTS=" \
--preview 'bat --style=numbers --color=always {}'
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
--reverse"

# ------------------------------------------------------------------------------
# Path - The higher it is, the more priority it has
# ------------------------------------------------------------------------------
# path=(
# 	"$HOME/bin"
# 	"$HOME/local/bin"
# 	"$HOME/.local/bin"
# 	"$DOTLY_PATH/bin"
# 	"$DOTFILES_PATH/bin"
# 	"/usr/local/bin"
# 	"/usr/local/sbin"
# 	"/bin"
# 	"/usr/bin"
# 	"/usr/sbin"
# 	"/sbin"
# )

# custom PATH based on OS
# source "$DOTFILES_PATH/os/extend_path.sh"
# path=(
# 	"${path[@]}"
# 	"${overrides[@]}"
# )
#
# export path
