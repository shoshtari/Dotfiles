call plug#begin()
Plug 'Yggdroot/indentLine'
" gruvbox colorscheme
Plug 'morhetz/gruvbox'
"Auto compelete for Brackets and cotation
"Plug 'jiangmiao/auto-pairs'
"Alternative for powerline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"comment and uncomment visualize lines by pressing g+c
Plug 'tpope/vim-commentary'
Plug 'preservim/nerdtree'
" Show clock in vim airline
Plug 'enricobacis/vim-airline-clock'
" Vim-GO 
Plug 'fatih/vim-go'
" wakkatime
Plug 'wakatime/vim-wakatime'
" Copilot
Plug 'github/copilot.vim'
" Css Color
Plug 'ap/vim-css-color'

call plug#end()            " required

if strftime("%H") < 17 && strftime("%H") > 7
  set background=light
else
  set background=dark
endif

set mouse=a
syntax on

set number

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
:  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
:augroup END

set showcmd
set laststatus=2
set autoindent
set smartindent
map <F9> :NERDTreeToggle<CR>

" Autosave

let g:indentLine_char = '|'
let g:airline_theme='hybridline'
let g:airline#extensions#clock#format = '%c'
" colorscheme gruvbox
:set tabstop=4
:set shiftwidth=4
" Map F5 to run program in diffrent language ( in some language compile and run)
:autocmd FileType python :noremap <F5> :w <bar> !clear && python % && echo press Enter to return to the VIM ; read <CR> 
:autocmd FileType sh :noremap <F5> :w <bar> !clear && bash % && echo press Enter to return to the VIM ; read <CR> 
:autocmd FileType go :noremap <F5> :w <bar> !clear && go run % && echo press Enter to return to the VIM ; read  <CR> 
:autocmd FileType c :noremap <F5> :w <bar> !clear && gcc % -o a.out && echo "Compile finished " && ./a.out && echo "\npress Enter to return to the VIM" ; read  <CR> 
:autocmd FileType cpp :noremap <F5> :w <bar> !clear && g++ % -o a.out && echo "Compile finished " && ./a.out && echo "\npress Enter to return to the VIM" ; read  <CR> 
" Go
" Go syntax highlighting
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1

" Auto formatting and importing
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"

" Status line types/signatures
let g:go_auto_type_info = 1

" go Compeletion
let g:go_code_completion_enabled = 1
" au filetype go inoremap <buffer> . .<C-x><C-o>

" Run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

:set colorcolumn=72
