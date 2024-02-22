#!/usr/bin/env bash

# maximum scrollback to search per pane
max_history=1000

if [ "$1" = "-d" ]; then
	DEBUG="true"
fi

debug() {
	if [ -n "$DEBUG" ]; then
		echo "$1"
	fi
}

rg_cmd() {
	rg -o '(([~./])?([a-zA-Z-_./0-9])+\.([a-zA-Z0-9]+)(:\d*:\d*)?|\..*)'
}

PATHS=()
# All tmux panes listed in the correct format for -t [target pane]
while read -r pane; do
	## current working directory for pane
	pane_cwd=$(tmux display -pt "$pane" "#{pane_current_path}")

	# read pane contents and filter through rg for files
	# sort and eliminate duplicates (sort required for uniq)
	while read -ru3 maybe_path; do
		debug "checking $pane_cwd for $maybe_path from $pane"

		maybe_path="${maybe_path/#\~/$HOME}" # expand ~

		# has :row:col
		unset row_col
		if [[ $maybe_path = *:* ]]; then
			row_col=":${maybe_path#*:}"    # extract :row:col
			maybe_path="${maybe_path%%:*}" # cut :row:col
		fi
		debug "row col: $row_col"

		# prepend the pane's cwd to the filename and see if we can get a real file path
		maybe_real_path=$(realpath -qL "$pane_cwd/$maybe_path" 2>/dev/null)
		if [[ -n $maybe_real_path && -f $maybe_real_path ]]; then
			debug "adding $maybe_real_path"
			PATHS+=("$maybe_real_path$row_col")
			continue
		fi

		# try the path to see if it's absolute
		maybe_real_path=$(realpath -qL "$maybe_path" 2>/dev/null)
		if [[ -n $maybe_real_path && -f $maybe_real_path ]]; then
			debug "adding $maybe_real_path"
			PATHS+=("$maybe_real_path$row_col")
		fi
	done 3< <(tmux capture-pane -p -t "$pane" -S -"$max_history" -E - | rg_cmd | sort | uniq)
done < <(tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index}')

printf "%s\n" "${PATHS[@]}" | sort | uniq
