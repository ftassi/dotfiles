return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim',
    {
      'MeanderingProgrammer/render-markdown.nvim',
      ft = { 'markdown', 'codecompanion' },
    },
  },
  opts = {
    strategies = {
      chat = {
        adapter = 'anthropic',
      },
      inline = {
        adapter = 'anthropic',
      },
      agent = {
        adapter = 'anthropic',
      },
    },
    adapters = {
      anthropic = function()
        return require('codecompanion.adapters').extend('anthropic', {
          schema = {
            model = {
              default = 'claude-opus-4-5-20250514',
              choices = {
                'claude-opus-4-5-20250514',
                'claude-sonnet-4-20250514',
              },
            },
            max_tokens = {
              default = 8192,
            },
          },
        })
      end,
    },
    display = {
      chat = {
        window = {
          layout = 'vertical',
          width = 0.4,
        },
        show_settings = false,
      },
      diff = {
        provider = 'mini_diff',
      },
    },
  },
  keys = {
    { '<leader>aa', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' }, desc = 'Code Companion Actions' },
    { '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>', mode = { 'n', 'v' }, desc = 'Code Companion Chat' },
    { '<leader>ai', '<cmd>CodeCompanion<cr>', mode = { 'n', 'v' }, desc = 'Code Companion Inline' },
    { '<leader>ad', '<cmd>CodeCompanionChat Add<cr>', mode = 'v', desc = 'Add selection to chat' },
  },
  config = function(_, opts)
    require('codecompanion').setup(opts)
    vim.cmd([[cab cc CodeCompanion]])
  end,
}
