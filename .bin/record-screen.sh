#!/bin/bash
# Copyright 2018 Aleksander Gajewski <adiog@brainfuck.pl>
#   created:  Fri 03 Aug 2018 08:46:44 AM CEST
#   modified: Fri 03 Aug 2018 08:46:48 AM CEST

# BASH CLEANUP {{{
# PRIVATE:
BASH_TMPDIR=/dev/shm/
BASH_MKTEMP="mktemp --tmpdir=$BASH_TMPDIR"
BASH_CLEANUP_FILE=`$BASH_MKTEMP`
trap BASH_CLEANUP EXIT

function BASH_CLEANUP() {
  tac $BASH_CLEANUP_FILE | bash
  rm $BASH_CLEANUP_FILE
}

# PUBLIC:
function FINALLY() {
  echo "$*" >> $BASH_CLEANUP_FILE
}

function MKTEMP() {
  BASH_TMP=`$BASH_MKTEMP`
  FINALLY "rm $BASH_TMP"
  echo $BASH_TMP
}

function MKTEMP_DIR() {
  BASH_TMP=`$BASH_MKTEMP -d`
  FINALLY "rm -fr $BASH_TMP"
  echo $BASH_TMP
}
# }}}

vlc screen:// --one-instance -I dummy --dummy-quiet --screen-follow-mouse --no-video :screen-fps=5 :screen-caching=300 --sout "#transcode{vcodec=h264,vb=400,fps=5,scale=1,width=1024,height=768,acodec=none}:duplicate{dst=std{access=file,mux=avi,dst=test_capture.avi}}"

