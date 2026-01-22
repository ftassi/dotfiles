return {
  'vim-test/vim-test',
  event = 'VeryLazy',
  config = function()
    vim.g['test#strategy'] = 'neovim'
    vim.g['test#neovim#term_position'] = 'vert botright'
    vim.g['test#rust#cargotest#test_options'] = '-- --nocapture'

    require('ftassi.keymaps').test()
  end,
}
