#!/bin/bash
# Copyright 2016 Aleksander Gajewski <adiog@brainfuck.pl>
#   created:  Wed 14 Dec 2016 04:57:28 PM CET
#   modified: wto, 31 paź 2017, 00:58:06


resolution=`xrandr | sed -n -e "s#.*current \(.*\),.*#\1#p"`
frequency=`xrandr | sed -n -e "s#.*\(..\)...\*.*#\1#p"`
dpi=`cat ~/.dpi`

echo "${resolution} @${frequency}Hz (${dpi}DPI)"

