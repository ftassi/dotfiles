local M = {}

function M.which_key()
  return {
    { '<leader>b', group = '[B]uffer' },
    { '<leader>c', group = '[C]ode' },
    { '<leader>d', group = '[D]iagnostic' },
    { '<leader>f', group = '[F]ind' },
    { '<leader>g', group = '[G]it' },
    { '<leader>l', group = '[L]SP' },
    { '<leader>o', group = '[O]ptions' },
    { '<leader>q', group = '[Q]uickfix' },
    { '<leader>r', group = '[R]ename' },
    { '<leader>s', group = '[S]earch' },
    { '<leader>t', group = '[T]est' },
    { '<leader>w', group = '[W]orkspace' },
  }
end

function M.defaults()
  -- Remove search highlighting with <Esc>
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- alternate file
  vim.keymap.set('n', '<C-;>', '<cmd>edit #<CR>', { desc = 'Open alternate file' })

  -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
  -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
  -- is not what someone will guess without a bit more experience.
  --
  -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
  -- or just use <C-\><C-n> to exit terminal mode
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- Ctrl-hjkl navigation is handled by vim-tmux-navigator plugin
  -- (works both with and without tmux)

  -- Split with | and - (consistent with tmux)
  vim.keymap.set('n', '|', '<cmd>vsplit<cr>', { desc = 'Vertical split' })
  vim.keymap.set('n', '-', '<cmd>split<cr>', { desc = 'Horizontal split' })

  -- Chiude il buffer corrente
  vim.keymap.set('n', 'Q', ':q<CR>')

  -- Mappature per Bdelete (gestione dei buffer)
  vim.keymap.set('n', '<leader>bo', ':Bdelete other<CR>', { desc = '[B]uffer close all [O]ther' })
  vim.keymap.set('n', '<leader>ba', ':Bdelete all<CR>', { desc = '[B]uffer close [A]ll' })
  vim.keymap.set('n', '<leader>bh', ':Bdelete hidden<CR>', { desc = '[B]uffer close [H]idden' })
  vim.keymap.set('n', '<leader>bm', ':Bdelete menu<CR>', { desc = '[B]uffer [M]enu' })

  -- Ridimensionamento delle finestre
  vim.keymap.set('n', '<A-k>', ':res +5<CR>', { silent = true })
  vim.keymap.set('n', '<A-j>', ':res -5<CR>', { silent = true })
  vim.keymap.set('n', '<A-h>', ':vertical resize -5<CR>', { silent = true })
  vim.keymap.set('n', '<A-l>', ':vertical resize +5<CR>', { silent = true })
  --
  -- nnoremap <silent> <C-a> <C-^>

  -- System clipboard: <leader>y as operator, <leader>Y for whole line
  vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = '[Y]ank to system clipboard' })
  vim.keymap.set('n', '<leader>Y', '"+yy', { desc = '[Y]ank line to system clipboard' })
end

function M.options()
  vim.keymap.set('n', '<leader>ow', function()
    vim.opt.wrap = not vim.opt.wrap:get()
  end, { desc = 'Toggle [W]rap' })
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
  local lga_shortcuts = require 'telescope-live-grep-args.shortcuts'
  vim.keymap.set('n', '<leader>fw', lga_shortcuts.grep_word_under_cursor, { desc = '[F]ind current [W]ord' })
  vim.keymap.set('v', '<leader>fg', lga_shortcuts.grep_visual_selection, { desc = '[F]ind by [G]rep' })
  vim.keymap.set('n', '<leader>fg', require('telescope').extensions.live_grep_args.live_grep_args, { desc = '[F]ind by [G]rep' })
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
  -- Operazioni sugli hunks
  vim.keymap.set('n', '<leader>gh', '<Plug>(GitGutterPreviewHunk)', { silent = true, desc = '[G]it: Preview Hunk' })
  vim.keymap.set('n', '<leader>ga', '<Plug>(GitGutterStageHunk)', { silent = true, desc = '[G]it: Stage Hunk' })
  vim.keymap.set('n', '<leader>gu', '<Plug>(GitGutterUndoHunk)', { silent = true, desc = '[G]it: Undo Hunk' })
  vim.keymap.set('n', '<leader>gf', '<Plug>(GitGutterFold)', { silent = true, desc = '[G]it: Fold Unchanged' })
end

function M.navigation()
  -- Git hunks (most used) - }} / {{
  vim.keymap.set('n', '}}', '<Plug>(GitGutterNextHunk)', { silent = true, desc = 'Next git hunk' })
  vim.keymap.set('n', '{{', '<Plug>(GitGutterPrevHunk)', { silent = true, desc = 'Previous git hunk' })

  -- Diagnostics - )) / ((
  vim.keymap.set('n', '))', function()
    local diagnostics = vim.diagnostic.get(0)
    if #diagnostics == 0 then
      vim.notify('No diagnostics in current buffer', vim.log.levels.INFO, { title = 'Diagnostics' })
    else
      vim.diagnostic.goto_next()
    end
  end, { silent = true, desc = 'Next diagnostic' })

  vim.keymap.set('n', '((', function()
    local diagnostics = vim.diagnostic.get(0)
    if #diagnostics == 0 then
      vim.notify('No diagnostics in current buffer', vim.log.levels.INFO, { title = 'Diagnostics' })
    else
      vim.diagnostic.goto_prev()
    end
  end, { silent = true, desc = 'Previous diagnostic' })

  -- Quickfix ]] / [[ -> see M.quickfix_navigation()
  -- Defined separately because ftplugins override [[ ]] with buffer-local mappings.
  -- Called from init.lua via FileType autocmd with { buffer = true }.
end

function M.quickfix_navigation(opts)
  opts = vim.tbl_extend('force', { silent = true }, opts or {})

  vim.keymap.set('n', ']]', function()
    local qflist = vim.fn.getqflist()
    if #qflist == 0 then
      vim.notify('Quickfix list is empty', vim.log.levels.INFO, { title = 'Quickfix' })
    else
      local ok, _ = pcall(vim.cmd, 'cnext')
      if not ok then
        vim.notify('End of quickfix list', vim.log.levels.INFO, { title = 'Quickfix' })
      end
    end
  end, vim.tbl_extend('force', opts, { desc = 'Next quickfix item' }))

  vim.keymap.set('n', '[[', function()
    local qflist = vim.fn.getqflist()
    if #qflist == 0 then
      vim.notify('Quickfix list is empty', vim.log.levels.INFO, { title = 'Quickfix' })
    else
      local ok, _ = pcall(vim.cmd, 'cprev')
      if not ok then
        vim.notify('Start of quickfix list', vim.log.levels.INFO, { title = 'Quickfix' })
      end
    end
  end, vim.tbl_extend('force', opts, { desc = 'Previous quickfix item' }))
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
  map('<leader>cs', vim.lsp.buf.signature_help, '[C]ode [S]ignature help', { silent = true })
  map('<leader>rr', vim.lsp.buf.rename, '[R]e[n]ame')

  map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, 'Find [W]orkspace [S]ymbols')

  -- Nuovi mapping per navigare i riferimenti al codice (tutti in minuscolo)
  map('<leader>fd', telescope_file_only(builtin.lsp_definitions), '[F]ind [D]efinition')
  map('<leader>fc', telescope_file_only(builtin.lsp_declarations), '[F]ind De[C]laration')
  map('<leader>fi', telescope_file_only(builtin.lsp_implementations), '[F]ind [I]mplementation')
  map('<leader>fr', telescope_file_only(builtin.lsp_references), '[F]ind [R]eferences')
  map('<leader>ft', telescope_file_only(builtin.lsp_type_definitions), '[F]ind [T]ype definition')

  -- format code
  map('<leader>==', vim.lsp.buf.format, 'Format code')

  local lsp_saga_installed, _ = pcall(require, 'lspsaga')
  if lsp_saga_installed then
    map('K', cmd 'Lspsaga hover_doc', 'Hover Documentation')
  else
    map('K', vim.lsp.buf.hover, 'Hover Documentation')
  end
end

function M.diagnostic()
  local lsp_saga_installed, _ = pcall(require, 'lspsaga')
  if lsp_saga_installed then
    vim.keymap.set('n', '<leader>dd', '<cmd>Lspsaga show_line_diagnostics<CR>', { desc = '[D]iagnostic [D]etails' })
  else
    vim.keymap.set('n', '<leader>dd', vim.diagnostic.open_float, { desc = '[D]iagnostic [D]etails' })
  end
  vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = '[D]iagnostic [L]ist' })
end

function M.quickfix()
  local ss = require 'ftassi.saved_searches'

  vim.keymap.set('n', '<leader>qo', '<cmd>copen<CR>', { desc = '[Q]uickfix [O]pen' })
  vim.keymap.set('n', '<leader>qx', function()
    vim.fn.setqflist({}, 'r', { items = {} })
    vim.notify('Quickfix list cleared', vim.log.levels.INFO, { title = 'Quickfix' })
  end, { desc = '[Q]uickfix clear (e[X]punge)' })
  vim.keymap.set('n', '<leader>qa', function()
    vim.fn.setqflist({}, 'a', {
      items = {{
        bufnr = vim.fn.bufnr(),
        lnum  = vim.fn.line('.'),
        col   = vim.fn.col('.'),
        text  = vim.fn.getline('.'),
      }},
    })
    vim.notify('Added to quickfix', vim.log.levels.INFO, { title = 'Quickfix' })
  end, { desc = '[Q]uickfix [A]dd current position' })
  vim.keymap.set('n', '<leader>qs', ss.save, { desc = '[Q]uickfix [S]ave as named search' })
  vim.keymap.set('n', '<leader>qf', ss.find, { desc = '[Q]uickfix [F]ind saved searches' })
end

function M.test()
  vim.keymap.set('n', '<leader>tt', ':TestNearest<CR>', { silent = true, desc = '[T]est nearest' })
  vim.keymap.set('n', '<leader>tf', ':TestFile<CR>', { silent = true, desc = '[T]est [F]ile' })
  vim.keymap.set('n', '<leader>tl', ':TestLast<CR>', { silent = true, desc = '[T]est [L]ast' })
  vim.keymap.set('n', '<leader>ta', ':TestSuite<CR>', { silent = true, desc = '[T]est [A]ll' })
  vim.keymap.set('n', '<leader>tg', ':TestVisit<CR>', { silent = true, desc = '[T]est and [G]oto test' })
  vim.keymap.set('n', '<leader>ti', ':TestNearest -- --ignored<CR>', { silent = true, desc = '[T]est [I]gnored' })
end

return M
