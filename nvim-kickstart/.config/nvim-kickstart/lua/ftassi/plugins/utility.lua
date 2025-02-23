return {
  { 'tpope/vim-abolish' },
  { 'vim-scripts/ReplaceWithRegister' },
  { 'adelarsq/vim-matchit' },
  { 'kburdett/vim-nuuid' },
  { 'ThePrimeagen/vim-be-good' },
  { 'mhinz/vim-startify' },
  { 'Asheq/close-buffers.vim' },
  {
      'ThePrimeagen/harpoon',
      opts = { -- Opzioni di configurazione specifiche del plugin
          menu = {
              width = vim.api.nvim_win_get_width(0) - 4,
          },
      },
      config = function()
          require('ftassi.keymaps').harpoon()
      end,
  },
}
