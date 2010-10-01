#!/bin/bash

# TODO :
#  * use cursor keys
#  * show also current (uncommited) version
#  * syntax highlighting
#     * process through nano (problem : nano's output is limited to one single screen, and puts some termcaps at the begining and end of output.)
#     * use vim : http://machine-cycle.blogspot.com/2007/10/syntax-highlighting-pager.html
#     * use highlight --ansi --force, or pygmentize -g : http://machine-cycle.blogspot.com/2008/02/syntax-highlighting-pager-reloaded.html
#     * use emacs
#     * choose from one of the above by guessing from $EDITOR and what's installed on the system.
# * doesn't seem to include pre-rename versions of a file that was renamed.
#     * git log --follow --name-only --oneline $file
#     * git whatchanged --follow $file | grep '^\(:\|commit \)'

file="$1"
if [ -z "$file" -o "$file" == "--help" -o "$file" == "-h" ]; then
	echo "Usage : $0 filename"
	echo "You must be in a directory versionned with git for this to work."
	exit 1
fi

statusbar() {
	echo -e "\e[47m\e[K[$(($i+1)) / $(($max+1))] : ${rev[i]}\e[1000G\e[46D\e[1mh\e[47m : help  \e[1mp\e[47m,\e[1m-\e[47m : previous  \e[1mn\e[47m,\e[1m+\e[47m : next  \e[1mq\e[47m : quit \e[m"
}

page=0
pager() {
	termlines="$(tput lines)"
	tail -n +$(($termlines*$page/2)) | head -n $(($termlines-2))
}

show() {
	clear
	statusbar
	git show "${rev[i]}:$fullpath" | nl | pager
}

help() {
	local garbage
	clear
	statusbar
	echo -e "status line : [version i / of total] : sha1"
	echo ""
	echo -e "\e[1mh\e[m   : help"
	echo -e "\e[1mp\e[m,\e[1m-\e[m : previous version"
	echo -e "\e[1mn\e[m,\e[1m+\e[m : next version"
	echo -e "\e[1mf\e[m   : first version"
	echo -e "\e[1ml\e[m   : last version"
	echo -e "\e[1md\e[m   : scroll down"
	echo -e "\e[1mu\e[m   : scroll up"
	echo -e "\e[1mt\e[m   : scroll to top"
	echo -e "\e[1mq\e[m   : quit"
	echo ""
	echo "Press any key to hide this help."
	read -n 1 garbage
}

fullpath="$(git ls-files --full-name "$file" | head -n 1)"
i=0
for ab in $(git log --oneline "$file" | cut -d ' ' -f 1 | tac); do
	rev[i]="$ab"
	i=$((i+1))
done
max="$((i-1))"

i="$max"
show
while read -n 1 ab; do
	case "$ab" in
		"") continue ;;
		"p"|"+") i=$((i-1)); [ "$i" -lt 0 ] && i=0 ;;
		"n"|"-") i=$((i+1)); [ "$i" -gt "$max" ] && i="$max" ;;
		"f") i=0 ;;
		"l") i="$max" ;;
		"d") page=$((page+1)) ;;
		"u") page=$((page-1)); [ "$i" -lt 0 ] && i=0 ;;
		"t") page=0 ;;
		"h") help ;;
		"q") break ;;
	esac
	show
done
