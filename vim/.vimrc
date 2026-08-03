" ==============================
" GENERAL
" ==============================
set nocompatible
set encoding=utf-8
set hidden
set number
set relativenumber
set cursorline
set signcolumn=yes
set updatetime=300
set termguicolors

" Mouse
set mouse=a
set ttymouse=sgr
set mousemodel=popup

" Clipboard
set clipboard=unnamedplus

" ==============================
" INDENTATION
" ==============================
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent

" ==============================
" SEARCH
" ==============================
set ignorecase
set smartcase
set incsearch
set hlsearch

" ==============================
" SPLITS
" ==============================
set splitbelow
set splitright

" ==============================
" TABS (REAL TAB PAGES)
" ==============================
set showtabline=2
set tabpagemax=50

" Tab navigation
nnoremap <C-t> :tabnew<CR>
nnoremap <C-w> :tabclose<CR>
nnoremap <S-l> :tabnext<CR>
nnoremap <S-h> :tabprevious<CR>

" Move tabs
nnoremap <leader>tm :tabmove 

" ==============================
" STATUSLINE
" ==============================
set laststatus=2
set noshowmode

" ==============================
" PLUGINS
" ==============================
call plug#begin('~/.vim/plugged')

" Git
Plug 'tpope/vim-fugitive'

" Surround
Plug 'tpope/vim-surround'

" Commenting
Plug 'preservim/nerdcommenter'

" FZF
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Syntax highlight
Plug 'sheerun/vim-polyglot'

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

" ==============================
" AIRLINE CONFIG
" ==============================
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'dark'

" ==============================
" FZF CONFIG
" ==============================
let g:fzf_layout = { 'down': '40%' }
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'

nnoremap <C-p> :Files<CR>
nnoremap <C-f> :Rg<CR>
nnoremap <leader>b :Buffers<CR>

" ==============================
" BUFFER NAVIGATION
" ==============================
nnoremap <TAB> :bnext<CR>
nnoremap <S-TAB> :bprevious<CR>

" ==============================
" QUICK SAVE / QUIT
" ==============================
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" ==============================
" VISUAL SETTINGS
" ==============================
syntax on
colorscheme desert
