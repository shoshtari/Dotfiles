set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line

" add | to show indentaion
Plugin 'Yggdroot/indentLine'
" gruvbox colorscheme
Plugin 'morhetz/gruvbox'
"Auto compelete for Brackets and cotation
"Plugin 'jiangmiao/auto-pairs'
"Alternative for powerline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
"comment and uncomment visualize lines by pressing g+c
Plugin 'tpope/vim-commentary'
Plugin 'preservim/nerdtree'
" Show clock in vim airline
Plugin 'enricobacis/vim-airline-clock'
" Vim-GO 
Plugin 'fatih/vim-go'
call vundle#end()            " required
"filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
set guifont=Consolas:h16

if strftime("%H") < 17 && strftime("%H") > 7
  set background=light
else
  set background=dark
endif

set mouse=a
syntax on
set number
set showcmd
set laststatus=2
set autoindent
set smartindent
map <F9> :NERDTreeToggle<CR>
let g:indentLine_char = '|'
let g:airline_theme='hybridline'
let g:airline#extensions#clock#format = '%c'
