return {
  'nvimdev/lspsaga.nvim',
  config = function()
    require('lspsaga').setup {}
    vim.keymap.set('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', { desc = 'Go to previous [D]iagnostic message' })
    vim.keymap.set('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<CR>', { desc = 'Go to next [D]iagnostic message' })
    vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>', { desc = '[H]over doc' })
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  ft = { 'rust', 'php', 'lua', 'go' },
}
