" Plugins
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" Utility
Plug 'kylechui/nvim-surround' 
Plug 'numToStr/Comment.nvim' 
Plug 'vim-scripts/ReplaceWithRegister' 
Plug 'vim-scripts/argtextobj.vim' 
Plug 'machakann/vim-highlightedyank' 
Plug 'mhinz/vim-startify' 
Plug 'Asheq/close-buffers.vim' 
Plug 'BurntSushi/ripgrep' 
Plug 'pmalek/toogle-maximize.vim' 
Plug 'adelarsq/vim-matchit' 
" Plug 'Yggdroot/indentLine'
Plug 'Pocco81/auto-save.nvim' 
Plug 'tpope/vim-abolish' 


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
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'nvimdev/lspsaga.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'sheerun/vim-polyglot'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'hrsh7th/nvim-cmp' 
Plug 'ray-x/lsp_signature.nvim' 
Plug 'hrsh7th/cmp-nvim-lsp'
" Plug 'folke/trouble.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
Plug 'onsails/lspkind-nvim'
" Plug 'AndrewRadev/tagalong.vim'
Plug 'alx741/vim-rustfmt'
Plug 'simrat39/symbols-outline.nvim'
Plug 'j-hui/fidget.nvim'

"Coding aka where the magic happens
Plug 'janko-m/vim-test'
Plug 'phpactor/phpactor', {'for': 'php', 'tag': '2022.11.12', 'do': 'composer install --no-dev -o'}
Plug 'RRethy/vim-illuminate'
Plug 'zbirenbaum/copilot.lua'
Plug 'zbirenbaum/copilot-cmp'
Plug 'windwp/nvim-autopairs'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'kburdett/vim-nuuid'

" Fuzzy Finder
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'tami5/sqlite.lua'

Plug 'ThePrimeagen/harpoon'

" AI stuff
" Plug 'CoderCookE/vim-chatgpt'
Plug 'madox2/vim-ai'

" Training and getting better
Plug 'ThePrimeagen/vim-be-good'

call plug#end()
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
set conceallevel=0

" Tabs & Indent
set autoindent
set tabstop=4 softtabstop=4
set expandtab
set shiftwidth=4
set shiftround
set smartindent


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
    autocmd ColorScheme * call onedark#extend_highlight("LineNr", {"fg": s:colors.white})
    autocmd ColorScheme * call onedark#extend_highlight("Comment", { "fg": s:yellow })
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

let g:rustfmt_on_save = 1

" CoderCookE/vim-chatgpt settings
"
" let g:chat_gpt_max_tokens=4000
" let g:chat_gpt_model='gpt-4-turbo-preview'
" let g:chat_gpt_session_mode=1
" let g:chat_gpt_temperature = 0.5
" let g:chat_gpt_lang = 'Italian'
" let g:chat_gpt_split_direction = 'vertical'
" let g:chat_gpt_custom_prompts = {'ask': ''}

" madox2/vim-ai settings

let g:vim_ai_chat = {
\  "options": {
\       "model": "o3-mini",
\       "temperature": 0.0,
\   },
\  "ui": {
\    "code_syntax_enabled": 1,
\    "populate_options": 0,
\    "max_tokens": 0,
\    "open_chat_command": "preset_below",
\    "scratch_buffer_keep_open": 1,
\    "paste_mode": 1,
\  },
\ }

let g:vim_ai_roles_config_file = stdpath('config') . '/ai-prompts.ini'

lua << LUA

vim.api.nvim_set_keymap("n", "<leader>f", "", {
    noremap = true,
    callback = function()
        vim.lsp.buf.format()
    end,
    desc = "Format code",

})
require("auto-save").setup({
    trigger_events = {"BufLeave", "FocusLost"}
})
require("mason").setup()
require("mason-lspconfig").setup()
require("lspsaga").setup()
require("nvim-autopairs").setup()
require("nvim-surround").setup()
require("Comment").setup()
require("symbols-outline").setup()
require("fidget").setup {
  -- options
}

LUA

if has('clipboard')
  let g:clipboard = {
        \ 'name': 'xsel',
        \ 'copy': {
        \   '+': 'xsel --clipboard --input',
        \   '*': 'xsel --primary --input',
        \ },
        \ 'paste': {
        \   '+': 'xsel --clipboard --output',
        \   '*': 'xsel --primary --output',
        \ },
        \ 'cache_enabled': 1,
        \ }
endif
