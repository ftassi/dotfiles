return {
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<leader>gs', '<Cmd>:G<CR>', { desc = '[G]it [S]atus' })
      vim.keymap.set('n', '<leader>Gp', '<Cmd>:Git push<CR>', { desc = '[G]it [P]ush' })
      vim.keymap.set('n', '<leader>Gc', '<Cmd>:Git commit<CR>', { desc = '[G]it [C]ommit' })
    end,
  },
  -- TODO: This could be removed mapping fugitive git log with the right format
  -- fugitive allows for interactive rebase from the log which gv.vim seems no be able to
  -- the alternative could be add a `ri` mapping for that view, getting the hashcommit from the logline
  {
    'junegunn/gv.vim',
    dependencies = {
      'tpope/vim-fugitive',
    },
    config = function()
      vim.keymap.set('n', '<leader>gl.', '<Cmd>:GV<CR>', { desc = '[G]it [L]og' })
      vim.keymap.set('n', '<leader>glf', '<Cmd>:GV!<CR>', { desc = '[G]it [L]og current [F]ile' })
      vim.keymap.set('n', '<leader>glb', '<Cmd>:GV --first-parent<CR>', { desc = '[G]it [L]og current [B]ranch' })
    end,
    -- nmap <leader>gl :GV<cr>
    -- nmap <leader>glf :GV!<cr>
    -- nmap <leader>glb :GV --first-parent<cr>
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      current_line_blame = false,
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end
        -- Navigation

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
      end,
    },
  },
}
