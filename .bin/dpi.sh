#!/bin/bash
# Copyright 2016 Aleksander Gajewski <adiog@brainfuck.pl>
#   created:  Tue 13 Dec 2016 04:08:15 PM CET
#   modified: wto, 31 paź 2017, 00:56:59


DPI_FILE=~/.dpi
PREVIOUS_DPI=`cat $DPI_FILE`
MOD_DPI=${1:-${PREVIOUS_DPI}}

if [[ $MOD_DPI =~ [+\-].* ]];
then
    CURRENT_DPI=$(($PREVIOUS_DPI $MOD_DPI))
else
    CURRENT_DPI=$MOD_DPI
fi

echo $CURRENT_DPI > $DPI_FILE
xrandr --dpi ${CURRENT_DPI}

