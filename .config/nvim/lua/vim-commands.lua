vim.cmd([[
set mouse=a
syntax on

set number
set updatetime=100

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
:  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
:augroup END

set showcmd
set laststatus=2
set autoindent
set smartindent

let g:indentLine_char = '|'
:set tabstop=4
:set shiftwidth=4
" Map F5 to run program in diffrent language ( in some language compile and run)
:autocmd FileType python :noremap <F5> :w <bar> !clear && python % && echo press Enter to return to the VIM ; read <CR>
:autocmd FileType sh :noremap <F5> :w <bar> !clear && bash % && echo press Enter to return to the VIM ; read <CR>
:autocmd FileType go :noremap <F5> :w <bar> !clear && go run % && echo press Enter to return to the VIM ; read  <CR>
:autocmd FileType c :noremap <F5> :w <bar> !clear && gcc % -o a.out && echo "Compile finished " && ./a.out && echo "\npress Enter to return to the VIM" ; read  <CR>
:autocmd FileType cpp :noremap <F5> :w <bar> !clear && g++ % -o a.out && echo "Compile finished " && ./a.out && echo "\npress Enter to return to the VIM" ; read  <CR>

" Skeletons
if has("autocmd")
  augroup templates
    autocmd BufNewFile *.cpp 0r ~/.config/nvim/skeletons/main.cpp
    autocmd BufNewFile *.c 0r ~/.config/nvim/skeletons/main.c
  augroup END
endif

" Disable git blame at start
let g:gitblame_enabled = 0
" Cellular Automata
map b :GitBlameToggle<CR>

GitBlameDisable

set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2

]])
