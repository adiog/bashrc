export LANG=en_US.UTF-8
export LC_TIME=en_US.UTF-8
export EDITOR=vim
export PATH=/opt/bin:$PATH

shopt -s globstar
#set -o vi

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
#alias g++="g++ -std=c++14 -Wall -pedantic -fsanitize=address"
alias make="time make"
alias cmake="time cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"

alias mc=". /usr/share/mc/bin/mc-wrapper.sh"

function cd-git-root() {
    if [[ ! -d .git ]];
    then
        cd $(git rev-parse --show-cdup)
    fi
}
export -f cd-git-root

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

function lanip() {
  ip route get 8.8.8.8 | awk '{print $NF; exit}'
}

function vv() {
  $@ | vim -R -
}

function vman() {
  vim -c "Man $1 $2" -c 'silent only'
}

function cdp() {
  mkdir -p $1
  cd $1
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

function copy()
{
  cp $1 $(dirname $1)/$2
}

function rename()
{
  mv $1 $(dirname $1)/$2
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
     -or -name "*.cc"  \
     -or -name "*.c"   \
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

function video_trim()
{
  INPUT=$1
  OUTPUT=$2
  START=$3
  LENGTH=$4
  if [[ $# == 4 ]];
  then
    ffmpeg -i $INPUT -vcodec copy -acodec copy -ss $START -t $LENGTH $OUTPUT
  else
    echo "Usage: "
    echo "$ video_trim INPUT OUTPUT START(HH:MM:SS) LENGTH(HH:MM:SS)"
  fi
}

function video_join()
{
  if [[ $# == 0 || $# == 1 ]];
  then
    echo "Usage: "
    echo "$ video_join OUTPUT INPUTS..."
  else
    OUTPUT=$1
    shift
    INPUTS=$*
    mencoder -ovc copy -oac copy $INPUTS -o $OUTPUTS
  fi
}

function gif_join()
{
  if [[ $# == 0 || $# == 1 ]];
  then
    echo "Usage: "
    echo "$ gif_join OUTPUT_GIF INPUTS..."
  else
    OUTPUT=$1
    shift
    INPUTS=$*
    convert -delay 20 -loop 0 $INPUTS $OUTPUT || "echo SOMETHING HAS GONE WRONG - maybe try: sudo apt-get install imagemagick"
  fi
}

function jupi()
{
  mkdir -p $HOME/Jupyter
  sudo docker run -p 8888:8888 -it -v $HOME/Jupyter:/home/jovyan jupyter/tensorflow-notebook jupyter notebook
}

function jupic()
{
  mkdir -p $HOME/Jupyter
  sudo docker run -p 8888:8888 -it -v $HOME/Jupyter:/Jupyter adiog/cling-jupyter
}

function i3t()
{
  /home/adiog/workspace/i3-tracker/bin/i3-tracker-spawn.sh
}

function now()
{
  date +%y_%m_%d-%H_%M_%S
}

function log()
{
  args=$*
  args=${args// /_}
  logfile=${args}-$(now).log
  (echo $*; echo; time $*) | tee -a ${logfile}
}

MARKS=$HOME/.dotfiles/.marks
if [ -e "$MARKS" ]; then
  . $MARKS
fi

VENVS=$HOME/.dotfiles/.venvs
if [ -e "$VENVS" ]; then
  . $VENVS
fi

TO_PATH=$HOME/.dotfiles/.bin
if [ -d "$TO_PATH" ] ; then
  export PATH=$TO_PATH:$PATH
fi

TO_PYTHONPATH=$HOME/.dotfiles/.pypath
if [[ -d "${TO_PYTHONPATH}" ]];
then
  export PYTHONPATH=${TO_PYTHONPATH}:$PYTHONPATH
  export PATH=$PATH:${TO_PYTHONPATH}
fi


echo "Welcome @$HOSTNAME!"
echo "=> Kernel $(uname -r)"
echo " "

