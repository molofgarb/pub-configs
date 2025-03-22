" linux: ~/.config/nvim/init.vim
" windows: ~/AppData/Local/nvim/init.vim

" Line numbers
set number

" Indentation settings
set autoindent
filetype plugin indent on
set tabstop=2
set softtabstop=2
set shiftwidth=2
set hlsearch "highlight search results
set expandtab "turn tabs into spaces

" Rulers
set cc=80
set cc=100

" Syntax highlighting
syntax on

" Yank and paste to system clipboard
set clipboard=unnamedplus

" Less lag when scrolling?
set ttyfast

" Theme
colorscheme slate

" Plugins (vim-plug)
call plug#begin()

Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'

call plug#end()
