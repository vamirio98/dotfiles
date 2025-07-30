#!/bin/bash

print_cur_git_branch()
{
	# Make sure all output will be stored in `GitBr` even if error
	local GitBr="$(git branch 2>&1)"
	local CurBr=$(echo "$GitBr" | sed -n 's/^\* \(.*\)/\1/p')
	if [ -z "$CurBr" ]; then
		echo ""
	else
		echo "  $CurBr ☰ "
	fi
}

export PS1="\\033[48;5;72m\$(print_cur_git_branch)\\033[0m\n\\033[38;5;100m\u@\h\\033[0m: \\033[38;5;65m\w\\033[0m\n$ "
