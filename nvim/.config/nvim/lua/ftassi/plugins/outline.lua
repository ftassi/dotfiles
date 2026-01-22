return {
  'stevearc/aerial.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    backends = { 'lsp', 'treesitter', 'markdown', 'man' },
    layout = {
      min_width = 30,
      default_direction = 'right',
    },
    attach_mode = 'global',
    filter_kind = false, -- show all symbols
    show_guides = true,
    guides = {
      mid_item = '├─',
      last_item = '└─',
      nested_top = '│ ',
      whitespace = '  ',
    },
    keymaps = {
      ['<CR>'] = 'actions.jump',
      ['<C-v>'] = 'actions.jump_vsplit',
      ['<C-s>'] = 'actions.jump_split',
      ['q'] = 'actions.close',
      ['o'] = 'actions.tree_toggle',
    },
  },
  keys = {
    { '<A-Tab>', '<cmd>AerialToggle<CR>', desc = 'Toggle Aerial outline' },
    { '<leader>ao', '<cmd>AerialToggle<CR>', desc = '[A]erial [O]utline toggle' },
    { '<leader>an', '<cmd>AerialNavToggle<CR>', desc = '[A]erial [N]av popup' },
  },
  config = function(_, opts)
    require('aerial').setup(opts)
    -- Telescope integration
    pcall(require('telescope').load_extension, 'aerial')
  end,
}
