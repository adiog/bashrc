#!/bin/bash
# Copyright 2017 Aleksander Gajewski <adiog@brainfuck.pl>
#   created:  Tue 05 Dec 2017 04:59:05 PM CET
#   modified: Tue 05 Dec 2017 04:59:12 PM CET

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

# OpenSSL requires the port number.
SERVER=$1
DELAY=1
ciphers=$(openssl ciphers 'ALL:eNULL' | sed -e 's/:/ /g')

echo Obtaining cipher list from $(openssl version).

for cipher in ${ciphers[@]}
do
echo -n Testing $cipher...
result=$(echo -n | openssl s_client -cipher "$cipher" -connect $SERVER 2>&1)
if [[ "$result" =~ ":error:" ]] ; then
  error=$(echo -n $result | cut -d':' -f6)
  echo NO \($error\)
else
  if [[ "$result" =~ "Cipher is ${cipher}" || "$result" =~ "Cipher    :" ]] ; then
    echo YES
  else
    echo UNKNOWN RESPONSE
    echo $result
  fi
fi
sleep $DELAY
done

