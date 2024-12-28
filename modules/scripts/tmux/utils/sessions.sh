function get_tmux_sessions() {
	tmux ls | fzf | awk '{print $1}' | rev | cut -c2- | rev
}
