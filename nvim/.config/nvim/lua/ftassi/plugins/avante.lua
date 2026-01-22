return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  lazy = false,
  version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
  opts = {
    debug = false,
    rag_service = {
      enabled = false,
    },
    provider = 'claude',
    disabled_tools = { 'python' },
    providers = {
      openai = {
        endpoint = 'https://api.openai.com/v1',
        model = 'gpt-4o',
        timeout = 30000,
        disable_tools = false,
        extra_request_body = {
          temperature = 0,
          max_tokens = 4096,
        },
      },
      claude = {
        endpoint = 'https://api.anthropic.com',
        model = 'claude-sonnet-4-20250514',
        disable_tools = true,
        extra_request_body = {
          temperature = 0,
          max_tokens = 4096,
        },
      },
    },
    dual_boost = {
      enabled = false,
      first_provider = 'claude',
      second_provider = 'openai',
      prompt = 'Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]',
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = 'make',
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    'echasnovski/mini.pick', -- for file_selector provider mini.pick
    'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
    'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
    'ibhagwan/fzf-lua', -- for file_selector provider fzf
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = { 'InsertEnter', 'CmdlineEnter', 'BufReadPost' },
      lazy = true,
      -- opts = {
      --   -- recommended settings
      --   default = {
      --     embed_image_as_base64 = false,
      --     prompt_for_file_name = false,
      --     drag_and_drop = {
      --       insert_mode = true,
      --     },
      --     -- required for Windows users
      --     use_absolute_path = true,
      --   },
      -- },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
}
