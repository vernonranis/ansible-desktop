" START Sets
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set timeoutlen=2000
set mouse=a
set nu
set nohlsearch
set hidden
set noerrorbells
set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set scrolloff=10
set termguicolors
set signcolumn=yes
set colorcolumn=80
set background=dark
set foldmethod=indent
set foldlevel=99
set t_Co=256
set fileformat=unix
" END Sets

" START Plugins use ViM Plug
" This automates the installation of ViM Plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" To install a plugin :PlugInstall
call plug#begin('~/.vim/plugged')
Plug 'lifepillar/vim-solarized8'
Plug 'dense-analysis/ale'

call plug#end()
" END Plugins use ViM Plug

" START Editor Settings
syntax enable
colorscheme solarized8_high
" END Editor Settings

" START Lets
let mapleader=" "
let g:ale_linters = {'python': ['flake8']}
" END Lets

" START Leader Maps
" normal mode no recursive execution map
nnoremap <leader>rr :set nu! rnu!<CR> " this toggles relative numbering
nnoremap <leader>r :set nu!<CR> " this toggles relative numbering
" visual mode no recursive execution map
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nmap <buffer> <leader>t <Esc>:w<CR>:!clear;python %<CR>
" END Leader Maps

" START Custom Functions
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
" END Custom Functions

" START AutoGroup
augroup MAIN
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace()
augroup END
" END AutoGroup
