
local M = {}

function M.which_key()
   return   {
    { "", group = "[C]ode" },
    { "", group = "[R]ename" },
    { "", group = "[D]ocument" },
    { "", group = "[W]orkspace" },
    { "", group = "[S]earch" },
    { "", desc = "", hidden = true, mode = { "n", "n", "n", "n", "n" } },
  }
end

function M.defaults()
    -- Remove search highlighting with <Esc>
    vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

    -- Diagnostic keymaps
    vim.keymap.set('n', '((', vim.diagnostic.goto_prev, { desc = 'Go to previous Diagnostic message' })
    vim.keymap.set('n', '))', vim.diagnostic.goto_next, { desc = 'Go to next Diagnostic message' })

    -- Navigazione delle modifiche nel buffer (change list)
    vim.keymap.set('n', '{{', function() vim.cmd('normal! g;') end, { desc = 'Go to Previous Change' })
    vim.keymap.set('n', '}}', function() vim.cmd('normal! g,') end, { desc = 'Go to Next Change' })
    -- Navigazione della jump list
    vim.keymap.set('n', '@@', '<C-o>', { desc = 'Jump Back (Jump list)' })
    vim.keymap.set('n', '\\\\', '<C-i>', { desc = 'Jump Forward (Jump list)' })

    -- Navigazione nella quickfix list
    vim.keymap.set('n', '[[', '<cmd>cprev<CR>', { desc = 'Go to Previous Quickfix Item' })
    vim.keymap.set('n', ']]', '<cmd>cnext<CR>', { desc = 'Go to Next Quickfix Item' })

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

function M.gitsigns(bufnr)

    local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    vim.keymap.set('n', '~~', function() require('gitsigns').prev_hunk() end, { desc = 'Previous Git Hunk' })
    vim.keymap.set('n', '^^', function() require('gitsigns').next_hunk() end, { desc = 'Next Git Hunk' })
    
    map('n', '~~', function()
        if vim.wo.diff then
        vim.cmd.normal { '~~', bang = true }
        else
        gitsigns.nav_hunk 'next'
        end
    end, { desc = 'Go to Next [H]unk' })

    map('n', '^^', function()
        if vim.wo.diff then
        vim.cmd.normal { '^^', bang = true }
        else
        gitsigns.nav_hunk 'prev'
        end
    end, { desc = 'Go to Prev [H]unk' })

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
            fn({entry_maker = require('ftassi.plugins.telescope').file_only_entry_maker})
        end
    end

    local function cmd(cmd)
        return function()
            vim.cmd(cmd)
        end
    end

    local builtin = require('telescope.builtin')

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
        map('((', cmd('Lspsaga diagnostic_jump_prev'), 'Go to previous Diagnostic message')
        map('))', cmd('Lspsaga diagnostic_jump_next'), 'Go to next Diagnostic message')
        map('<leader>ld', cmd('Lspsaga show_line_diagnostics'), 'Show line diagnostics')
        map('<leader>wd', cmd('Lspsaga show_workspace_diagnostics'), 'Show workspace diagnostics')

        map('K', cmd('Lspsaga hover_doc'), 'Hover Documentation')
    end
end

function M.symbol_outlines()
    vim.keymap.set('n', '<A-Tab>', '<cmd>SymbolsOutline<CR>', { desc = 'Open Symbols Outline' })
end



return M

