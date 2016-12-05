@echo off

cd %USERPROFILE%
git clone https://github.com/VundleVim/Vundle.vim.git %USERPROFILE%/vimfiles/bundle/Vundle.vim
copy %USERPROFILE%/vimfiles/bundle/vim-adiog/_vimrc %USERPROFILE%/_vimrc
"C:\Program Files\Vim\vim74\gvim.exe" +PluginInstall +qall
"C:\Program Files\Vim\vim74\gvim.exe" +PluginUpdate +qall
pause

