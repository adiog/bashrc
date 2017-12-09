set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'majutsushi/tagbar'
"Plugin 'Valloric/YouCompleteMe'
" cd ~/.vim/bundle/YouCompleteMe && git submodule update --init --recursive && ./install.sh --clang-completer --system-libclang --system-boost
""Plugin 'rdnetto/YCM-Generator'

Plugin 'leafgarland/typescript-vim'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'itchyny/lightline.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-fugitive'
Plugin 'sjl/gundo.vim'
Plugin 'adiog/nerdtree'
Plugin 'vim-utils/vim-man'
Plugin 'jpalardy/vim-slime'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'google/vim-searchindex'
Plugin 'godlygeek/tabular'
Plugin 'tpope/vim-unimpaired'
Plugin 'airblade/vim-rooter'
Plugin 'airblade/vim-gitgutter'
Plugin 'vim-scripts/a.vim'
Plugin 'pboettch/vim-cmake-syntax'
Plugin 'fidian/hexmode'
Plugin 'adiog/vim-adiog'

Plugin 'trevordmiller/nova-vim'
Plugin 'junegunn/seoul256.vim'
Plugin 'tyrannicaltoucan/vim-quantum'

Plugin 'inkarkat/vim-SearchAsQuickJump'

if has("gui_running")
  Plugin 'ryanoasis/vim-devicons'
  set guifont=DroidSansMono\ Nerd\ Font\ 11
endif
"Plugin 'chrisbra/NrrwRgn'
"Plugin 'vim-scripts/Conque-GDB'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

cmap <S-CR> <Plug>(SearchAsQuickJump)

