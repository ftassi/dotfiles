-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    opts = {
      enable_check_bracket_line = true,
    },
  },
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = { 'InsertEnter', 'CmdlineEnter', 'BufReadPost' },
    config = function()
      require('copilot').setup {
        panel = {
          enabled = false,
          -- auto_refresh = true,
          -- keymap = {
          --   accept = '<C-j>',
          --   accept_word = '<C-k>',
          --   accept_line = '<C-l>',
          --   next = '<C-n>',
          --   prev = '<C-d>',
          --   dismiss = '<C-f>',
          -- },
          -- layout = {
          --   position = 'bottom', -- | top | left | right
          --   ratio = 0.4,
          -- },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = '<C-j>',
            accept_word = '<C-k>',
            accept_line = '<C-l>',
            next = '<C-n>',
            prev = '<C-d>',
            dismiss = '<C-f>',
          },
        },
        filetypes = {
          ['*'] = true,
        },
        copilot_node_command = 'node', -- Node.js version must be > 16.x
        server_opts_overrides = {},
      }
    end,
  },
  { 'AndrewRadev/tagalong.vim' },
  { 'numToStr/Comment.nvim', opts = {} },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
}
