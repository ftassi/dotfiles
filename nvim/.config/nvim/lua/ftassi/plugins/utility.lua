return {
  { 'tpope/vim-sleuth' }, -- Detect tabstop and shiftwidth automatically
  { 'tpope/vim-abolish' },
  { 'vim-scripts/ReplaceWithRegister' },
  { 'adelarsq/vim-matchit' },
  { 'kburdett/vim-nuuid' },
  { 'ThePrimeagen/vim-be-good' },
  { 
        'mhinz/vim-startify', 
        init = function() 
            vim.g.startify_change_to_dir = 0
            vim.g.startify_lists = {
                { type = 'dir',       header = { '   MRU ' .. vim.fn.getcwd() } },
                { type = 'files',     header = { '   MRU' } },
                { type = 'sessions',  header = { '   Sessions' } },
                { type = 'bookmarks', header = { '   Bookmarks' } },
                { type = 'commands',  header = { '   Commands' } },
            }
        end 
},
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
