" Plugins
call plug#begin('~/.vim/plugged')
" Utility
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'vim-scripts/argtextobj.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'mhinz/vim-startify'
Plug 'Asheq/close-buffers.vim'
Plug 'BurntSushi/ripgrep'
Plug 'pmalek/toogle-maximize.vim'

" Aesthetic
Plug 'joshdick/onedark.vim'
Plug 'hoob3rt/lualine.nvim'

" NerdTree related
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'

" Git 
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim'

"LSP and coding related plugin
Plug 'ftassi/nvim-lspconfig'
Plug 'sheerun/vim-polyglot'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'hrsh7th/nvim-cmp' 
Plug 'ray-x/lsp_signature.nvim' 
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip' 
Plug 'rafamadriz/friendly-snippets' 

"Coding aka where the magic happens
Plug 'janko-m/vim-test'
Plug 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev -o'}
Plug 'jiangmiao/auto-pairs'

" Fuzzy Finder
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'

" Training and getting better
Plug 'ThePrimeagen/vim-be-good'

" General
set exrc
set nohlsearch
set hidden
set noerrorbells
set ignorecase
set smartcase
set incsearch
set nowrap

set clipboard+=unnamedplus
" History
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile

" Display
set display=lastline
set laststatus=2
set background
set relativenumber
set number
set ruler
set signcolumn=yes
set colorcolumn=120
set scrolloff=6

" Tabs & Indent
set autoindent
set tabstop=4 softtabstop=4
set expandtab
set shiftwidth=4
set shiftround
set smartindent

call plug#end()

set encoding=UTF-8
set updatetime=500
let g:onedark_termcolors=256

set cursorlineopt=both
set cursorline

if (has("autocmd"))
  augroup colorextend
    autocmd!
    let s:colors = onedark#GetColors()
    let s:visual_grey = s:colors.visual_grey
    let s:yellow = s:colors.yellow

    autocmd ColorScheme * call onedark#extend_highlight("CursorLine", {"bg": s:visual_grey})
    autocmd ColorScheme * call onedark#extend_highlight("CursorLineNr", {"fg": s:yellow})
  augroup END
endif

syntax on
colorscheme onedark

let mapleader=" "
"
" Edit vimr configuration file
nnoremap <Leader>ve :e $MYVIMRC<CR>
" " Reload vimr configuration file
nnoremap <Leader>vr :source $MYVIMRC<CR>
nnoremap <Leader>pu :PlugInstall<CR>

let g:highlightedyank_highlight_duration = 500

if executable('rg')
    set grepprg=rg\ --vimgrep
endif

set exrc

" Autosave
autocmd BufLeave,FocusLost * silent! wall

autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \  Startify | execute 'NERDTree' argv()[0] | wincmd w | execute 'cd '.argv()[0] | endif

let g:startify_change_to_dir = 0
let g:startify_lists = [
            \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
            \ { 'type': 'files',     'header': ['   MRU']            },
            \ { 'type': 'sessions',  'header': ['   Sessions']       },
            \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
            \ { 'type': 'commands',  'header': ['   Commands']       },
            \ ]


