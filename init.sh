#!/bin/bash
# Copyright 2017 Aleksander Gajewski <adiog@brainfuck.pl>
#   created:  Thu Mar  9 14:14:06 2017
#   modified: Thu Mar  9 14:20:54 2017

# BASH_CLEANUP {{{
BASH_CLEANUP_FILE=`mktemp`
trap BASH_CLEANUP EXIT

function BASH_CLEANUP() {
  BASH_CLEANUP_FILE_REV=`mktemp`
  tac $BASH_CLEANUP_FILE > $BASH_CLEANUP_FILE_REV
  . $BASH_CLEANUP_FILE_REV
  rm $BASH_CLEANUP_FILE $BASH_CLEANUP_FILE_REV
}

function BASH_FINALLY() {
  echo "$*" >> $BASH_CLEANUP_FILE
}

function BASH_MKTEMP() {
  BASH_TMP=`mktemp`
  echo "rm $BASH_TMP" >> $BASH_CLEANUP_FILE
  echo $BASH_TMP
}

function BASH_MKTEMP_DIR() {
  BASH_TMP=`mktemp -d`
  echo "rm -fr $BASH_TMP" >> $BASH_CLEANUP_FILE
  echo $BASH_TMP
}
# }}}

function link_dot()
{
  DOT=$1
  if [[ -e ~/$DOT ]];
  then
    echo "$DOT already exists."
  else
    ln -s ~/.dotfiles/$DOT ~/$DOT
  fi
}

link_dot .clang-format
link_dot .gitconfig
link_dot .i3
link_dot .ideavimrc
link_dot .marks
link_dot .screenrc
link_dot .Xmodmap

if ! grep .dotfiles ~/.bashrc;
then
  echo ". ~/.dotfiles/.bashrc" >> ~/.bashrc
else
  echo ".bashrc already sourced."
fi

