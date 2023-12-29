local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
	{ 'tpope/vim-commentary' },
	{ 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
	{ 'fatih/vim-go' },
	{ 'wakatime/vim-wakatime' },
	{ 'github/copilot.vim' },
	{ 'nvim-treesitter/nvim-treesitter' },
	{ 'eandrju/cellular-automaton.nvim'  },
	{ 'f-person/git-blame.nvim' },
	{ 'rust-lang/rust.vim' },
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{ 'davidhalter/jedi-vim' },
	{ 'Shougo/ddc.vim' },
	{ 'vim-denops/denops.vim' }
}
local opt = {}
require("lazy").setup(plugins, opts)

require("ibl").setup()

-- TODO: airline, airline-theme, airline-clock, NERD tree(or alternative), 
vim.cmd([[
" if strftime("%H") < 17 && strftime("%H") > 7
"   set background=light
" else
"   set background=dark
" endif
set background=dark

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

let mapleader = ','
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>



let g:indentLine_char = '|'
let g:airline_theme='hybridline'
let g:airline#extensions#clock#format = '%c'
colorscheme catppuccin
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
map t :CellularAutomaton make_it_rain<CR>
map T :CellularAutomaton game_of_life<CR>
map b :GitBlameToggle<CR>

set foldmethod=indent   
set foldnestmax=10
set nofoldenable
set foldlevel=2

 let g:jedi#popup_on_dot = 0
]])

