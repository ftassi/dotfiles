local M = {}

function M.which_key()
  return {
    { '', group = '[C]ode' },
    { '', group = '[R]ename' },
    { '', group = '[D]ocument' },
    { '', group = '[W]orkspace' },
    { '', group = '[S]earch' },
    { '', desc = '', hidden = true, mode = { 'n', 'n', 'n', 'n', 'n' } },
  }
end

function M.defaults()
  -- Remove search highlighting with <Esc>
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- alternate file
  vim.keymap.set('n', '<C-;>', '<cmd>edit #<CR>', { desc = 'Open alternate file' })
  --  gs
  -- Diagnostic keymaps (leader + dp/dn = diagnostic previous/next)
  vim.keymap.set('n', '<leader>dp', function()
    local diagnostics = vim.diagnostic.get(0)
    if #diagnostics == 0 then
      vim.notify('Nessuna diagnostica nel buffer corrente', vim.log.levels.INFO, {
        title = 'Diagnostica',
        icon = 'ℹ️',
      })
    else
      vim.diagnostic.goto_prev()
    end
  end, { silent = true, desc = 'Previous diagnostic' })

  vim.keymap.set('n', '<leader>dn', function()
    local diagnostics = vim.diagnostic.get(0)
    if #diagnostics == 0 then
      vim.notify('Nessuna diagnostica nel buffer corrente', vim.log.levels.INFO, {
        title = 'Diagnostica',
        icon = 'ℹ️',
      })
    else
      vim.diagnostic.goto_next()
    end
  end, { silent = true, desc = 'Next diagnostic' })

  -- Navigazione nella quickfix list (leader + qp/qn = quickfix previous/next)
  vim.keymap.set('n', '<leader>qp', function()
    local qflist = vim.fn.getqflist()
    if #qflist == 0 then
      vim.notify('Quickfix list vuota', vim.log.levels.INFO, {
        title = 'Quickfix',
        icon = 'ℹ️',
      })
    else
      local ok, err = pcall(function()
        vim.cmd 'cprev'
      end)
      if not ok then
        vim.notify('Inizio della quickfix list raggiunto', vim.log.levels.INFO, {
          title = 'Quickfix',
          icon = '⚠️',
        })
      end
    end
  end, { silent = true, desc = 'Previous quickfix item' })

  vim.keymap.set('n', '<leader>qn', function()
    local qflist = vim.fn.getqflist()
    if #qflist == 0 then
      vim.notify('Quickfix list vuota', vim.log.levels.INFO, {
        title = 'Quickfix',
        icon = 'ℹ️',
      })
    else
      local ok, err = pcall(function()
        vim.cmd 'cnext'
      end)
      if not ok then
        vim.notify('Fine della quickfix list raggiunto', vim.log.levels.INFO, {
          title = 'Quickfix',
          icon = '⚠️',
        })
      end
    end
  end, { silent = true, desc = 'Next quickfix item' })

  -- Navigazione delle modifiche nel buffer (change list) (leader + cp/cn = change previous/next)
  vim.keymap.set('n', '<leader>cp', function()
    local ok, err = pcall(function()
      vim.cmd 'normal! g;'
    end)
    if not ok then
      vim.notify('Inizio della lista modifiche raggiunto', vim.log.levels.INFO, {
        title = 'Navigazione modifiche',
        icon = '⚠️',
      })
    end
  end, { silent = true, desc = 'Previous change' })

  vim.keymap.set('n', '<leader>cn', function()
    local ok, err = pcall(function()
      vim.cmd 'normal! g,'
    end)
    if not ok then
      vim.notify('Fine della lista modifiche raggiunto', vim.log.levels.INFO, {
        title = 'Navigazione modifiche',
        icon = '⚠️',
      })
    end
  end, { silent = true, desc = 'Next change' })

  -- Navigazione della jump list (leader + jp/jn = jump previous/next)
  vim.keymap.set('n', '<leader>jp', function()
    local jumplist = vim.fn.getjumplist()
    local current_pos = jumplist[2]
    if current_pos == 0 then
      vim.notify('Inizio della jump list raggiunto', vim.log.levels.INFO, {
        title = 'Navigazione jump list',
        icon = '⚠️',
      })
    else
      vim.cmd 'normal! <C-o>'
    end
  end, { silent = true, desc = 'Previous jump' })

  vim.keymap.set('n', '<leader>jn', function()
    local jumplist = vim.fn.getjumplist()
    local jumps = jumplist[1]
    local current_pos = jumplist[2]
    if current_pos >= #jumps then
      vim.notify('Fine della jump list raggiunto', vim.log.levels.INFO, {
        title = 'Navigazione jump list',
        icon = '⚠️',
      })
    else
      vim.cmd 'normal! <C-i>'
    end
  end, { silent = true, desc = 'Next jump' })

  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
  -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
  -- is not what someone will guess without a bit more experience.
  --
  -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
  -- or just use <C-\><C-n> to exit terminal mode
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- Keybinds to make split navigation easier.
  --  Use CTRL+<hjkl> to switch between windows
  --
  --  See `:help wincmd` for a list of all window commands
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- Chiude il buffer corrente
  vim.keymap.set('n', 'Q', ':q<CR>')

  -- Mappature per Bdelete (gestione dei buffer)
  vim.keymap.set('n', '<leader>wo', ':Bdelete other<CR>', { desc = 'Close all other buffers' })
  vim.keymap.set('n', '<leader>wa', ':Bdelete all<CR>', { desc = 'Close all buffers' })
  vim.keymap.set('n', '<leader>wh', ':Bdelete hidden<CR>', { desc = 'Close all hidden buffers' })
  vim.keymap.set('n', '<leader>w', ':Bdelete menu<CR>', { desc = 'Close buffer menu' })

  -- Ridimensionamento delle finestre
  vim.keymap.set('n', '<A-k>', ':res +5<CR>', { silent = true })
  vim.keymap.set('n', '<A-j>', ':res -5<CR>', { silent = true })
  vim.keymap.set('n', '<A-h>', ':vertical resize -5<CR>', { silent = true })
  vim.keymap.set('n', '<A-l>', ':vertical resize +5<CR>', { silent = true })
  --
  -- nnoremap <silent> <C-a> <C-^>
end

function M.telescope()
  -- See `:help telescope.builtin`
  local builtin = require 'telescope.builtin'
  vim.keymap.set('n', '<leader>ts', builtin.builtin, { desc = '[T]elescop [S]earch builtin' })
  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
  vim.keymap.set('n', '<leader>fh', function()
    builtin.find_files { find_command = { 'rg', '--files', '--hidden', '-g!.git', '--no-ignore-vcs' } }
  end, { desc = '[F]ind [H]idden files even vcs ignored' })
  vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
  vim.keymap.set('v', '<leader>fg', function()
    vim.cmd 'normal! "gy'
    require('telescope.builtin').grep_string { search = vim.fn.getreg 'g' }
  end, { desc = '[F]ind by [G]rep' })
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
  vim.keymap.set('n', '<leader>//', builtin.resume, { desc = '[F]ind [R]esume' })

  vim.keymap.set('n', '<Tab>', builtin.buffers, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<S-Tab>', builtin.oldfiles, { desc = '[S]earch Recent Files' })

  vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = '[/] Fuzzily search in current buffer' })
  vim.keymap.set('n', '<leader>s/', function()
    builtin.live_grep {
      grep_open_files = true,
      prompt_title = 'Live Grep in Open Files',
    }
  end, { desc = '[S]earch [/] in Open Files' })

  -- Shortcut for searching your Neovim configuration files
  vim.keymap.set('n', '<leader>df', function()
    builtin.git_files { prompt_tile = '< Dotfiles >', cwd = '/home/ftassi/dotfiles', hidden = true }
  end, { desc = '[S]earch [D]otfiles' })
end

function M.neo_tree()
  vim.keymap.set('n', '<C-t>', '<Cmd>:Neotree left toggle<CR>', { desc = 'Toggle file tree' })
  vim.keymap.set('n', '<C-f>', '<Cmd>:Neotree left reveal_file=%:p reveal_force_cwd<CR>', { desc = 'Reveal current buffer on file tree' })
end

function M.fugitive()
  vim.keymap.set('n', '<leader>gs', '<Cmd>:G<CR>', { desc = '[G]it [S]atus' })
  vim.keymap.set('n', '<leader>Gp', '<Cmd>:Git push<CR>', { desc = '[G]it [P]ush' })
  vim.keymap.set('n', '<leader>Gc', '<Cmd>:Git commit<CR>', { desc = '[G]it [C]ommit' })
end

function M.gv()
  vim.keymap.set('n', '<leader>gl.', '<Cmd>:GV<CR>', { desc = '[G]it [L]og' })
  vim.keymap.set('n', '<leader>glf', '<Cmd>:GV!<CR>', { desc = '[G]it [L]og current [F]ile' })
  vim.keymap.set('n', '<leader>glb', '<Cmd>:GV --first-parent<CR>', { desc = '[G]it [L]og current [B]ranch' })
end

function M.gitgutter()
  vim.keymap.set('n', '<leader>gh', '<Plug>(GitGutterPreviewHunk)', { silent = true, desc = '[G]itGutter: Preview Hunk' })
  vim.keymap.set('n', '<leader>ga', '<Plug>(GitGutterStageHunk)', { silent = true, desc = '[G]itGutter: Stage Hunk' })
  vim.keymap.set('n', '<leader>gu', '<Plug>(GitGutterUndoHunk)', { silent = true, desc = '[G]itGutter: Undo Hunk' })
end

function M.gitsigns(bufnr)
  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
  end

  -- Navigation
  map('n', '<leader>gn', function()
    if vim.wo.diff then
      vim.cmd.normal { '<leader>gn', bang = true }
    else
      require('gitsigns').nav_hunk 'next'
    end
  end, { desc = 'Go to Next Git Hunk' })

  map('n', '<leader>gp', function()
    if vim.wo.diff then
      vim.cmd.normal { '<leader>gp', bang = true }
    else
      require('gitsigns').nav_hunk 'prev'
    end
  end, { desc = 'Go to Prev Git Hunk' })

  map('n', '<leader>ga', gitsigns.stage_hunk, { desc = '[G]it [A]dd current hunk' })
  map('v', '<leader>ga', function()
    gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
  end, { desc = '[G]it [A]dd current hunk' })
  map('n', '<leader>gA', gitsigns.undo_stage_hunk, { desc = '[G]it Undo [A]dd current hunk' })
  map('n', '<leader>gco', gitsigns.reset_hunk, { desc = '[G]it Check[O]ut current hunk' })
  map('v', '<leader>gco', function()
    gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
  end, { desc = '[G]it Check[O]ut current hunk' })
  map('n', '<leader>gp', gitsigns.preview_hunk, { desc = '[G]it [P]review current hunk' })
  map('n', '<leader>gb', function()
    gitsigns.blame_line { full = true }
  end, { desc = '[G]it [B]lame current line' })
  map('n', '<leader>tb', gitsigns.toggle_deleted, { desc = '[T]oggle [B]lame current line' })
  -- This conflicts with Goto Definition which is much more used
  -- TODO: I need to find another mapping for this
  -- map('n', '<leader>gd', gitsigns.diffthis)
  --
  -- map('n', '<leader>gS', gitsigns.stage_buffer)
  -- map('n', '<leader>gR', gitsigns.reset_buffer)
  -- map('n', '<leader>gD', function()
  --   gitsigns.diffthis '~'
  -- end)
  -- map('n', '<leader>td', gitsigns.toggle_deleted)
end

function M.harpoon()
  vim.keymap.set('n', '<leader>j', function()
    require('harpoon.mark').add_file()
  end, { desc = 'Add file to Harpoon' })
  vim.keymap.set('n', '<leader><Tab>', function()
    require('harpoon.ui').toggle_quick_menu()
  end, { desc = 'Toggle Harpoon Quick Menu' })
  vim.keymap.set('n', '<leader><leader>f', function()
    require('harpoon.ui').nav_file(1)
  end, { desc = 'Navigate to Harpoon file 1' })
  vim.keymap.set('n', '<leader><leader>d', function()
    require('harpoon.ui').nav_file(2)
  end, { desc = 'Navigate to Harpoon file 2' })
  vim.keymap.set('n', '<leader><leader>s', function()
    require('harpoon.ui').nav_file(3)
  end, { desc = 'Navigate to Harpoon file 3' })
  vim.keymap.set('n', '<leader><leader>a', function()
    require('harpoon.ui').nav_file(4)
  end, { desc = 'Navigate to Harpoon file 4' }) -- Mapping dei comandi Harpoon con descrizioni
end

function M.cmp(cmp)
  -- For an understanding of why these mappings were
  -- chosen, you will need to read `:help ins-completion`
  --
  -- No, but seriously. Please read `:help ins-completion`, it is really good!
  return {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-j>'] = cmp.mapping.scroll_docs(-4),
    ['<C-k>'] = cmp.mapping.scroll_docs(4),

    ['<C-Space>'] = cmp.mapping.complete {},
    ['<C-y>'] = cmp.mapping.confirm { select = true },
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n')
      else
        fallback()
      end
    end,
  }
end

function M.lsp(bufnr)
  local map = function(keys, func, desc, opts)
    opts = opts or {}
    opts.buffer = bufnr
    opts.desc = 'LSP: ' .. desc
    vim.keymap.set('n', keys, func, opts)
  end

  local function telescope_file_only(fn)
    return function()
      fn { entry_maker = require('ftassi.plugins.telescope').file_only_entry_maker }
    end
  end

  local function cmd(cmd)
    return function()
      vim.cmd(cmd)
    end
  end

  local builtin = require 'telescope.builtin'

  map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  map('<leader>sh', vim.lsp.buf.signature_help, '[S]ignature [H]elp', { silent = true })
  map('<leader>rr', vim.lsp.buf.rename, '[R]e[n]ame')

  map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, 'Find [W]orkspace [S]ymbols')
  map('<leader>ds', builtin.lsp_document_symbols, 'Find [D]ocument [S]ymbols')

  -- Nuovi mapping per navigare i riferimenti al codice (tutti in minuscolo)
  map('<leader>fd', telescope_file_only(builtin.lsp_definitions), '[F]ind [D]efinition')
  map('<leader>fc', telescope_file_only(builtin.lsp_declarations), '[F]ind De[C]laration')
  map('<leader>fi', telescope_file_only(builtin.lsp_implementations), '[F]ind [I]mplementation')
  map('<leader>fr', telescope_file_only(builtin.lsp_references), '[F]ind [R]eferences')
  map('<leader>ft', telescope_file_only(builtin.lsp_type_definitions), '[F]ind [T]ype definition')

  -- format code
  map('<leader>==', vim.lsp.buf.format, 'Format code')

  local lsp_saga_installed, lspsaga = pcall(require, 'lspsaga')
  if lsp_saga_installed then
    map('<leader>dp', cmd 'Lspsaga diagnostic_jump_prev', 'Go to previous Diagnostic message')
    map('<leader>dn', cmd 'Lspsaga diagnostic_jump_next', 'Go to next Diagnostic message')
    map('<leader>ld', cmd 'Lspsaga show_line_diagnostics', 'Show line diagnostics')
    map('<leader>wd', cmd 'Lspsaga show_workspace_diagnostics', 'Show workspace diagnostics')

    map('K', cmd 'Lspsaga hover_doc', 'Hover Documentation')
  end
end

function M.symbol_outlines()
  vim.keymap.set('n', '<A-Tab>', '<cmd>SymbolsOutline<CR>', { desc = 'Open Symbols Outline' })
end

function M.test()
  vim.keymap.set('n', '<leader>tt', ':w<CR>:TestNearest<CR>', { silent = true, desc = '[T]est nearest test' })
  vim.keymap.set('n', '<leader>tf', ':w<CR>:TestFile<CR>', { silent = true, desc = '[T]est [F]ile' })
  vim.keymap.set('n', '<leader>tl', ':w<CR>:TestLast<CR>', { silent = true, desc = '[T]est [L]ast' })
  vim.keymap.set('n', '<leader>ta', ':w<CR>:TestSuite<CR>', { silent = true, desc = '[T]est [A]ll' })
  vim.keymap.set('n', '<leader>tg', ':w<CR>:TestVisit<CR>', { silent = true, desc = '[T]est and [G]oto test or SUT' })
end

return M
