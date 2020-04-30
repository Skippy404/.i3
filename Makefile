DIR=$(shell pwd)

all: install backup symlinks

install:
	mkdir -p ~/.config/i3/
	bash install.sh

backup:
	-mv -f ~/.config/i3/config ~/.config/i3/config.backup

symlinks:
	ln -s $(DIR)/localconf ~/.config/i3/config

uninstall:
	-mv -f ~/.config/i3/config.backup ~/.config/i3/config
	
