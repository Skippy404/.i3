#!/bin/bash
rm -f ~/Pictures/.lock*.png
scrot ~/Pictures/.lock.png
convert -scale 10% -scale 1000% ~/Pictures/.lock.png ~/Pictures/.lock2.png
convert ~/Pictures/.lock2.png ~/Pictures/.lk.png -gravity center -composite ~/Pictures/.lock.png
i3lock -i ~/Pictures/.lock.png
