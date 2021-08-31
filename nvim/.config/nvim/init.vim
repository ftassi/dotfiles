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
" Plug 'jremmen/vim-ripgrep'
Plug 'pmalek/toogle-maximize.vim'

" Aesthetic
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" NerdTree related
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'

" Git 
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim'

"LSP and coding related plugin
Plug 'neovim/nvim-lspconfig'
Plug 'sheerun/vim-polyglot'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'hrsh7th/nvim-cmp' 
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

call plug#end()

set encoding=UTF-8
set updatetime=500
let g:onedark_termcolors=256
let g:airline_theme='onedark'
let g:lightline = {'colorscheme': 'onedark',}

syntax on
colorscheme onedark
set cursorlineopt=both
set cursorline

hi CursorLine guibg=#3e454f
hi CursorLineNR guifg=#c6c900

let mapleader=" "
"
" Edit vimr configuration file
nnoremap <Leader>ve :e $MYVIMRC<CR>
" " Reload vimr configuration file
nnoremap <Leader>vr :source $MYVIMRC<CR>
nnoremap <Leader>pu :PlugInstall<CR>

let g:highlightedyank_highlight_duration = 500
let g:airline_powerline_fonts = 1

let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

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
