" no need to be compatible
set nocompatible

" skips startup message
set shortmess=atI

" use os clipboard (`+clipboard`)
set clipboard=unnamed

" allows cursor keys in insert mode
set esckeys

" allows backspace in insert mode
set backspace=indent,eol,start

" optimizes for fast terminal connections
set ttyfast

" enhances command-line completion
set wildmenu

" uses UTF-8 without BOM
set encoding=utf-8 nobomb

" centralizes backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
    set undodir=~/.vim/undo
endif

" enables line numbers
set number

" enables syntax highlighting
syntax on

" highlights current line
set cursorline

" soft tabs, 4 chars
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" highlights searches
set hlsearch

" ignores case of searches, unless search string contains uppercase chars
set ignorecase
set smartcase

" highlights dynamically as pattern is typed
set incsearch

" always shows status line
set laststatus=2

" shows the cursor position
set ruler

" shows the current mode
set showmode

" shows the filename in the window titlebar
set title

" shows the (partial) command as it’s being typed
set showcmd
