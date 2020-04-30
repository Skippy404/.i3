#!/bin/bash
# Available keybinds for usage. - indicates that key is in use
keybinds=(q sx c sc i si Return sReturn -)
dir=$(pwd)
rm -f localconf
touch localconf

### Helper functions ###

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
	echo "if you wish to abort, type \"abort\""
	echo -n "Enter your keybind: "
	read k
	if [ $k = "-" ]; then
		echo "\nInvalid key-bind, please try again..."
		return 255
	elif [ $k = "abort" ]; then
		return 254
	fi
	for index in ${!keys[*]}
	do
		if [[ ${keys[$index]} = $k  ]]; then
			return $index
		fi
	done
	echo "\nInvalid key-bind, please try again..."
	return 255 #
}

append_conf () {
	local dir=$(pwd)
	echo $1 >> $dir/localconf
}

# append_exec keys app
append_exec() {
	key="$1"
	sexec="$2"
	if [[ $key = "sReturn" ]]; then
		key="Shift+Return"
	elif [[ ! $key = "Return" ]]; then
		shft=$(echo $key | cut -c 1)
		if [[ $shft = "s"  ]]; then
			key="Shift+$(echo $key | cut -c 2)"
		fi
	fi
	append_conf "bindsym \$mod+$key exec $sexec"
}

### ---- ### ---- ### ---- ###
#~# Begin The installation #~#
### ---- ### ---- ### ---- ###

#Setup start of config splice
cat $dir/preamble/config_1 > $dir/localconf

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

cat $dir/preamble/config_2 >> $dir/localconf

### Begin Custom Binds setup ###
append_conf "# Part 1 custom-binds #"

#~ Start With terminal ~#
echo -n "Setting up terminal, please enter your terminal emulator name (eg gnome-terminal), type \"skip\" to skip: "
read app
if [[ ! $app = "skip" ]]; then
	enter_key "${keybinds[@]}"
	key=${keybinds[$?]}
	append_exec $key $app
fi

#~ Setup Web Browser ~#
echo -n "Setting up Web Browser, please enter your Web Browser name (eg chrome), type \"skip\" to skip: "
read app
if [[ ! $app = "skip" ]]; then
	enter_key "${keybinds[@]}"
	key=${keybinds[$?]}
	append_exec $key $app
fi

#~ Setup screenshot ~#
echo -n "Would you like to setup screenshots? (Y/N): "
read app
if [[ $app = "Y" ]]; then
	enter_key "${keybinds[@]}"
	key=${keybinds[$?]}
	app="$(pwd)/scripts/screenshot.sh"
	append_exec $key $app
fi

#~ Setup rofi support ~#
echo -n "Would you like to setup rofi support? (Y/N): "
read app
if [[ $app = "Y" ]]; then
	enter_key "${keybinds[@]}"
	key=${keybinds[$?]}
	app="rofi -show drun"
	append_exec $key "$app"
fi

#~ Setup screenshot ~#
echo -n "Would you like to setup a lockscreen? (Y/N): "
read app
if [[ $app = "Y" ]]; then
	enter_key "${keybinds[@]}"
	key=${keybinds[$?]}
	app="$(pwd)/scripts/lock.sh"
	append_exec $key $app
fi

# Splice 3rd preamble
cat $dir/preamble/config_3 >> $dir/localconf
