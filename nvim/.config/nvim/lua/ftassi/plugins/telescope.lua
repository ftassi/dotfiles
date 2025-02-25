local function file_only_entry_maker(entry)
  local entry_display = require 'telescope.pickers.entry_display'
  local displayer = entry_display.create {
    items = {
      { remaining = true },
    },
  }

  return {
    valid = true,
    display = function(entry)
      local filename = entry.filename
      return displayer {
        filename .. ':' .. entry.lnum,
      }
    end,
    value = entry,
    ordinal = entry.filename,
    filename = entry.filename,
    text = entry.text,
    lnum = entry.lnum,
    col = entry.col,
  }
end

return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    local action_layout = require 'telescope.actions.layout'
    local opts = {
      defaults = {
        mappings = {
          n = {
            ['<M-p>'] = action_layout.toggle_preview,
          },
          i = {
            ['<M-p>'] = action_layout.toggle_preview,
          },
        },
        vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--hidden', '-g!.git' },
        color_devicons = true,
        layout_config = {
          width = 0.9,
          vertical = { mirror = false },
        },
      },
      pickers = {
        find_files = { theme = 'ivy', find_command = { 'rg', '--files', '--hidden', '-g', '!.git' } },
        treesitter = { layout_strategy = 'horizontal' },
        buffers = { theme = 'ivy' },
        git_branches = { theme = 'ivy' },
        oldfiles = { theme = 'ivy' },
        lsp_references = { theme = 'ivy' },
        lsp_implementations = { theme = 'ivy' },
        lsp_dynamic_workspace_symbols = { theme = 'ivy' },
        lsp_definitions = { theme = 'ivy' },
        lsp_document_symbols = { theme = 'ivy' },
        lsp_workspace_symbols = { theme = 'ivy' },
      },
      extensions = {
        fzy_native = {
          override_generic_sorter = false,
          override_file_sorter = true,
        },
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }
    require('telescope').setup(opts)
    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    require('ftassi.keymaps').telescope()
  end,
  file_only_entry_maker = file_only_entry_maker,
}
