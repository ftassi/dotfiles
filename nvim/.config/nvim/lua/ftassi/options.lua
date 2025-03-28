-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3
-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath 'data' .. '/undodir'

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true

-- Clear the search buffer only after you press <Esc>
vim.opt.incsearch = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'nosplit'

vim.opt.backup = false
vim.opt.swapfile = false

-- Highlight column 120
vim.opt.colorcolumn = '120'

-- Avoid conceiling characters. Very important for markdown files
vim.opt.conceallevel = 0

-- Set some tab and indentation settings
-- This may be default values by I prefer having them explicitly set
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true

-- Allow for local vimrc files
vim.opt.exrc = true

-- Enable hidden buffers
vim.opt.hidden = true

-- Disable line wrapping
vim.opt.wrap = false

-- Set default file encoding to UTF-8
vim.opt.encoding = 'utf-8'

vim.opt.termguicolors = true

-- Configure ripgrep to use a vim friendly from
-- Telescope will have its own ripgrep setting
if vim.fn.exepath 'rg' == 1 then
  vim.opt.grepprg = 'rg --vimgrep'
end
