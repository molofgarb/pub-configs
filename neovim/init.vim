" linux: ~/.config/nvim/init.vim
" windows: ~/AppData/Local/nvim/init.vim
" :PlugInstall to install plugins

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Line numbers
set number
set relativenumber

" Indentation settings
filetype plugin indent on
set autoindent
set backspace=indent,eol,start " Intuitive backspace behavior.
set clipboard=unnamedplus      " Yank and paste to system clipboard
set expandtab                  " Turn tabs into spaces
set hidden                     " Possibility to have more than one unsaved buffers.
set hlsearch                   " Highlight search results
set shiftwidth=2
set so=999                     " Scrolloff (keep cursor centered)
set softtabstop=2
set tabstop=2
set ttyfast                    " Less lag when scrolling?
set wildmenu                   " Great command-line completion, use `<Tab>` to move
                               " around and `<CR>` to validate.
syntax on                      " Syntax highlighting

" Rulers
set cc=80
set cc=100

" Swap p and P to not override unnamed register when pasting with p
xnoremap p P

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ===== Plugins (vim-plug) =====
call plug#begin()

Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'ellisonleao/gruvbox.nvim'
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'

call plug#end()

" ===== Theme =====
set background=dark " or light if you want light mode
colorscheme gruvbox

" ===== Lua plugin config =====
lua << END

require('lualine').setup({
    options = {
        theme = 'gruvbox_dark',
    },
})

END
