#!/bin/bash
# Available keybinds for usage. - indicates that key is in use
keybinds=(q sx c sc i si -)
dir=$(pwd)
touch localconf

### Helper functions ###

chr() {
	[ "$1" -lt 256 ] || return 1
	printf "\\$(printf '%03o' "$1")"
}

ord() {
	LC_CTYPE=C printf '%d' "'$1"
}

get_avail_keys () {
	a="$@"
	echo Current Available keybinds are:
	for key in ${a[*]}
	do
		if [[ ! $key = "-" ]]; then
		echo -n $key " "
		fi
	done
	echo ""
}

enter_key () {
	keys=("$@")
	get_avail_keys "$@"
	echo "These are the available keybinds, s<letter> means shift+<letter>"
	echo -n "Enter your keybind: "
	read k
	if [ $k = "-" ]; then
		return -1
	fi
	for index in ${!keys[*]}
	do
		if [[ ${keys[$index]} = $k  ]]; then
			return $index
		fi
	done
	return -1
}

append_conf () {
	local dir=$(pwd)
	echo $1 >> $dir/localconf
}

### ---- ### ---- ### ---- ###
#~# Begin The installation #~#
### ---- ### ---- ### ---- ###

#Setup start of config splice
rm -f localconf
cat ./config_preamble/config_1 > $dir/localconf

# Setup Compton & Wallpaper.
echo -n "Would you like to enable wallpaper support. (Y/N): "
read input
if [[ $input = "Y"  ]]; then
	append_conf "exec compton"
	echo -n "Please enter FULL path to wallpaper, \"s\" to skip: "
	read input
	if [[ ! $input = "s" && -f $input ]]; then
		append_conf "feh --bg-csale $input"
	fi
fi

# Enable tilda
echo -n "Would you like to enable tilda support on startup. (Y/N): "
read input
if [[ $input = "Y"  ]]; then
	append_conf "exec tilda"
fi

append_conf "# Part 1 custom #"

enter_key "${keybinds[@]}"
key=$?
if [[ ! $key = -1 ]]; then
	yk=${keybinds[$key]}
	keybinds[$key]="-"
	echo "You entered: $yk"
else
	echo Invalid
fi
