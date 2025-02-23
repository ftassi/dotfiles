return { -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
  },
  config = function()
    -- See `:help cmp`
    local cmp = require 'cmp'
    local mappings = require 'keymaps'.cmp(cmp)

    cmp.setup {
      snippet = {},
      completion = { completeopt = 'menu,menuone,noinsert' },
      mapping = cmp.mapping.preset.insert(mappings),
      sources = {
        { name = 'nvim_lsp' },
        { name = 'path' },
      },
    }
  end,
}
