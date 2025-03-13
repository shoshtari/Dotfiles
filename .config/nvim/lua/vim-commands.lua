vim.cmd([[

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

let g:indentLine_char = '|'
let g:airline_theme='hybridline'
let g:airline#extensions#clock#format = '%c'
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

" Skeletons
if has("autocmd")
  augroup templates
    autocmd BufNewFile *.cpp 0r ~/.vim/templates/skeleton.cpp
    autocmd BufNewFile *.c 0r ~/.vim/templates/skeleton.c
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
