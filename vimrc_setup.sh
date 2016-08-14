#!/bin/bash

if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
  mkdir -p ~/.vim/bundle
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
if [ ! -f ~/.vimrc ]; then
  ln -s `pwd`/.vimrc ~/.vimrc
fi

vim +PluginInstall +qall
vim +PluginUpdate +qall

