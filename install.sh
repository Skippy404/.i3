#!/bin/bash
# Available keybinds for usage. - indicates that key is in use
keybinds=(q sx c sc i si Return sReturn -)
dir=$(pwd)
rm -f localconf
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

# Return 0 if !shift, 1 if shift, 2 if return, 3 if shift + return #
is_special () {
	if [[ $1 = "Return" ]]; then
		return 2
	elif [[ $1 = "sReturn" ]]; then
		return 3
	fi
	local testl=$(echo $1 | cut -c 1)
	if [[ $testl = s ]]; then
		return 1
	else
		return 0
	fi
}

# append_exec keys app
append_exec() {
	is_special $1
	if [[ $? = 1 ]]; then
		# has shift
		key="Shift+$(echo $key | cut -c 2)"
	elif [[ $? = 2 ]]; then
		key="Return"
	elif [[ $? = 3 ]]; then
		key="Shift+Return"
	fi
	append_conf "bindsym \$mod+$key exec $2"
}

### ---- ### ---- ### ---- ###
#~# Begin The installation #~#
### ---- ### ---- ### ---- ###

#Setup start of config splice
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

cat ./config_preamble/config_2 >> $dir/localconf

### Begin Custom Binds setup ###
append_conf "# Part 1 custom-binds #"

#~ Start With terminal ~#
echo -n "Setting up terminal, please enter your terminal emulator name (eg gnome-terminal), type \"skip\" to skip: "
read app
if [[ ! $app = "skip" ]]; then
	enter_key "${keybinds[@]}"
	key=${keybinds[$?]}
	keybinds[$?]="-"
	append_exec $key $app
fi

#~ Setup Web Browser ~#
echo -n "Setting up Web Browser, please enter your Web Browser name (eg chrome), type \"skip\" to skip: "
read app
if [[ ! $app = "skip" ]]; then
	enter_key "${keybinds[@]}"
	key=${keybinds[$?]}
	keybinds[$?]="-"
	append_exec $key $app
fi
