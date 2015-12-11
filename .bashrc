# Copyleft 2015 Aleksander Gajewski <adiog@brainfuck.pl>
#   created:  Sun 26 Oct 2014 11:01:45 AM CET
#   modified: Fri 11 Dec 2015 03:27:36 PM CET

export EDITOR=vim
set -o vi
set -o globstar

export LANG=en_US.UTF-8

alias x="chmod +x"

alias hg="hg -v"
alias bc="bc -l"
alias grep="grep --color"

alias vim="vim -p"
function vv() {
  $@ | vim -R -
}

function cdln() {
  READLINK=$(readlink $1)
  DIRNAME=$(dirname $READLINK)
  cd $DIRNAME
}

# allow user define <C-s> (used in vim)
stty -ixon

if [ -e ~/.marks ]; then
  . ~/.marks
fi

if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi

echo "Welcome @$HOSTNAME!"
echo "=> Kernel $(uname -r)"
echo "=> Using .bashrc modified $(stat -c %y $HOME/.bashrc | cut -d"." -f 1)"
echo "         .vimrc  modified $(stat -c %y $HOME/.vimrc | cut -d"." -f 1)"
echo " "

