return {
  'ThePrimeagen/harpoon',
  opts = { -- Opzioni di configurazione specifiche del plugin
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
  },
  config = function()
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
  end,
}
