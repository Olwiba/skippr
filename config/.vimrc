" Skippr vim configuration

" Exit insert mode with jj or kk (no Escape needed!)
inoremap jj <Esc>
inoremap kk <Esc>
inoremap jk <Esc>

" Quick save with Leader+w (Leader is \)
nnoremap <Leader>w :w<CR>

" Quick quit with Leader+q
nnoremap <Leader>q :q<CR>

" Quick save and quit
nnoremap <Leader>x :wq<CR>

" Line numbers
set number
set relativenumber

" Search settings
set ignorecase
set smartcase
set hlsearch
set incsearch

" Indentation
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent

" Better defaults
set mouse=a
set clipboard=unnamedplus
set nowrap
set scrolloff=8

" Colors
syntax on
set background=dark