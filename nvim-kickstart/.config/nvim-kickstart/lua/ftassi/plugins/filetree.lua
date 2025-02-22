return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('neo-tree').setup {}

    vim.keymap.set('n', '<C-t>', '<Cmd>:Neotree left toggle<CR>', { desc = 'Toggle file tree' })
    vim.keymap.set('n', '<C-f>', '<Cmd>:Neotree left reveal_file=%:p reveal_force_cwd<CR>', { desc = 'Reveal current buffer on file tree' })
  end,
}
