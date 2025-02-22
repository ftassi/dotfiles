
local M = {}


function M.defaults()
    -- Remove search highlighting with <Esc>
    vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

    -- Diagnostic keymaps
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
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
    map('n', ']h', function()
        if vim.wo.diff then
        vim.cmd.normal { ']h', bang = true }
        else
        gitsigns.nav_hunk 'next'
        end
    end, { desc = 'Go to Next [H]unk' })

    map('n', '[h', function()
        if vim.wo.diff then
        vim.cmd.normal { '[h', bang = true }
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

return M

