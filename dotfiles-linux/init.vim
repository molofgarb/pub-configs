" linux: ~/.config/nvim/init.vim
" windows: ~/AppData/Local/nvim/init.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

" Scrolloff (keep cursor centered)
set so=999

" Syntax highlighting
syntax on

" Less lag when scrolling?
set ttyfast

" Yank and paste to system clipboard
set clipboard=unnamedplus

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ===== Plugins (vim-plug) =====
call plug#begin()

Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'ellisonleao/gruvbox.nvim'

call plug#end()

" ===== Theme =====
set background=dark " or light if you want light mode
colorscheme gruvbox

" ===== Lua plugin config =====
lua << END

require('lualine').setup({
    options = {
        theme = 'vscode',
    },
})

END

