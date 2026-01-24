return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      open_mapping = [[<C-\>]],
      direction = 'float',
      float_opts = {
        width = function()
          return math.floor(vim.o.columns * 0.8)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.8)
        end,
        border = 'curved',
      },
      persist_mode = true,
      persist_size = true,
    }

    require('ftassi.keymaps').toggleterm()
  end,
}
