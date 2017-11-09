#!/bin/bash
# Copyright 2017 Aleksander Gajewski <adiog@brainfuck.pl>
#   created:  nie, 29 sty 2017, 20:00:30
#   modified: wto, 31 paź 2017, 00:57:28


device=17
state=`xinput list-props "$device" | grep "Device Enabled" | grep -o "[01]$"`

if [ $state == '1' ];then
    xinput --disable $device
else
    xinput --enable $device
fi

