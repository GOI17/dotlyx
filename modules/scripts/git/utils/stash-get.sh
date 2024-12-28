function get_stash() {
	git stash list | awk -F'\n' '{print (NR - 1), $1}' | fzf | awk '{print $1}'
}
