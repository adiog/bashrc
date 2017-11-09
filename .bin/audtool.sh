#!/bin/bash
# Copyright 2016 Aleksander Gajewski <adiog@brainfuck.pl>
#   created:  Thu 15 Dec 2016 01:02:10 AM CET
#   modified: wto, 31 paź 2017, 01:33:47


STATUS=`audtool playback-status`

if [[ $STATUS == paused ]];
then
    DISPLAY="▷"
elif [[ $STATUS == playing ]];
then
    DISPLAY="▶"
elif [[ $STATUS == stopped ]];
then
    DISPLAY="◾"
else
    DISPLAY="Audacious is not running..."
fi

DISPLAY="${DISPLAY} `audtool current-song | sed -e "s/\(.{80}\).*/\1/"`"

echo -n $DISPLAY

