return {
  {
    'tpope/vim-fugitive',
    config = function()
        require('ftassi.keymaps').fugitive()
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
        require('ftassi.keymaps').gv()
    end,
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
        require('ftassi.keymaps').gitsigns(bufnr)
      end,
    },
  },
  {
      'airblade/vim-gitgutter',
      event = 'BufReadPre',
      init = function()
        vim.g.gitgutter_sign_added = ''
        vim.g.gitgutter_sign_modified = ''
        vim.g.gitgutter_sign_removed = ''
        vim.g.gitgutter_sign_removed_first_line = ''
        vim.g.gitgutter_sign_modified_removed = ''
      end,
      config = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "FugitiveChanged",
            callback = function()
                vim.cmd("call gitgutter#all(1)")
            end,
        })

        require 'ftassi.keymaps'.gitgutter()
      end
  }
}
