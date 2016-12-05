export LANG=en_US.UTF-8
export EDITOR=vim
export PATH=/opt/bin:$PATH

shopt -s globstar
set -o vi

xset -b > /dev/null 2> /dev/null
xset b off

# allow user define <C-s> (used in vim)
stty -ixon


alias bc="bc -l"
alias ll="ls --color -la"
alias grep="grep --color"
alias hg="hg -v"
alias vim="vim -p"
alias x="chmod +x"
alias g++="g++ -std=c++14 -Wall -pedantic -fsanitize=address"
alias cmake="cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"


function git-root() {
    if [[ ! -d .git ]];
    then
        cd $(git rev-parse --show-cdup)
    fi
}

function cmake2clang() 
{
    if [[ $# == 0 ]]; 
    then
        CWD=`pwd`
        CMAKE_DIR=${CWD}
        TARGET_DIR=${CWD}
    elif [[ $# == 1 ]];
    then
        CMAKE_DIR=$1
        TARGTET_DIR=`pwd`
    elif [[ $# == 2 ]];
    then
        CMAKE_DIR=$1
        TARGET_DIR=$2
    fi
    TEMP=`mktemp -d`
    cd $TEMP
    cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ${CMAKE_DIR}
    mv compile_commands.json ${TARGET_DIR}
    cd -
    rm -fr $TEMP
}

function wanip() {
  dig +short myip.opendns.com @resolver1.opendns.com
}

function vv() {
  $@ | vim -R -
}

function vman() {
  vim -c "Man $1 $2" -c 'silent only'
}

function cdln() {
  READLINK=$(readlink $1)
  DIRNAME=$(dirname $READLINK)
  cd $DIRNAME
}

function mvln() {
  mv $1 $2
  ln -s $2 $1
}

function hi() {
  PATTERN=$1
  shift
  grep --color -E "${PATTERN}|\$" $*
}

function hilimit() {
  grep --color -E "^.{${COLUMNLIMIT:-120}}.+|^" $*
}

function limit() {
  grep -q -E "^.{${COLUMNLIMIT:-120}}.+" $*
}

function formatted() {
  file=$1
  tmp=`mktemp`
  clang-format $file > $tmp
  diff -q $file $tmp 
  code=$?
  rm $tmp
  return $code
}

function findcpp() {
  find . -name "*.cpp" \
     -or -name "*.cc" \
     -or -name "*.hpp" \
     -or -name "*.h"     
}

function xgrep() {
  cat - | xargs grep $*
}

function names() {
  cat - | cut -d: -f1 | sort | uniq
}

function doseol() {
  grep -q "^M" 
}

function replace() {
  PATTERN=$1
  REPLACE=$2
  shift 2
  if [[ -z "$*" ]];
  then
    FILES=`cat -`
  else
    FILES=$*
  fi
  for file in $FILES; do
    sed -e "s/$PATTERN/$REPLACE/g" -i $file
  done
}

function preview() {
  PATTERN=$1
  REPLACE=$2
  shift 2
  if [[ -z "$*" ]];
  then
    FILES=`cat -`
  else
    FILES=$*
  fi
  TMP=`mktemp`
  NUM=`mktemp`
  for file in $FILES; do
    cat -n $file > $NUM
    cat $NUM | sed -e "s/$PATTERN/$REPLACE/g" > $TMP
    diff $NUM $TMP | hi "$PATTERN|$REPLACE"
  done
  rm $TMP $NUM
}

function gof() {
  # get offline dump
  SITE=$1
  LEVEL=$2
  cd ~/Offline
  wget -r -k -l ${LEVEL:=2} $SITE
  cd -
}


MARKS=$HOME/.dotfiles/.marks
if [ -e "$MARKS" ]; then
  . $MARKS
fi

TO_PATH=$HOME/.dotfiles/.bin
if [ -d "$TO_PATH" ] ; then
  export PATH=$TO_PATH:$PATH
fi

TO_PYTHONPATH=$HOME/.dotfiles/.pypath
if [[ -d "${TO_PYTHONPATH}" ]];
then
  export PYTHONPATH=${TO_PYTHONPATH}:$PYTHONPATH
fi


echo "Welcome @$HOSTNAME!"
echo "=> Kernel $(uname -r)"
echo " "

