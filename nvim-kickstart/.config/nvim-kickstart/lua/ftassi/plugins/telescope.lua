local function file_only_entry_maker(entry)
    local entry_display = require "telescope.pickers.entry_display"
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
                filename..":"..entry.lnum,
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
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use Telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of `help_tags` options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    require('telescope').setup {
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      -- defaults = {
      --   mappings = {
      --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
      --   },
      -- },
      -- pickers = {}
      extensions = {
        defaults = {
            mappings = {
                n = {
                    ['<M-p>'] = action_layout.toggle_preview
                }, 
                i = {
                    ['<M-p>'] = action_layout.toggle_preview
                }, 
            },
            vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number',  '--column', '--smart-case', '--hidden', '-g!.git' },
            color_devicons = true,
            layout_config = {
                width = 0.9,
                vertical = {mirror = false},
        },
        },
        pickers = {
            find_files = { theme = "ivy", find_command = {'rg', '--files', '--hidden', '-g', '!.git' }},
            treesitter = { layout_strategy = 'horizontal' },
            buffers = {theme = "ivy"},
            git_branches = {theme = "ivy"},
            oldfiles = {theme = "ivy"},
            lsp_references = {theme = "ivy"},
            lsp_implementations = {theme = "ivy"},
            lsp_dynamic_workspace_symbols = {theme = "ivy", entry_maker = require('ftassi.telescope').file_only_entry_maker },
            lsp_definitions = {theme = "ivy", entry_maker = require('ftassi.telescope').file_only_entry_maker },
            lsp_document_symbols = {theme = "ivy"},
            lsp_workspace_symbols = {theme = "ivy"},
            lsp_dynamic_workspace_symbols = {theme = "ivy"},
        },
        extensions = {
            fzy_native = {
                override_generic_sorter = false,
                override_file_sorter = true,
            },
            ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
            },
        }
    },
      defaults = vim.tbl_extend('force', require('telescope.themes').get_ivy(), {
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
        -- layout_config = {
        --   width = 0.9,
        --   vertical = { mirror = false },
        -- },
      }),
      pickers = {
        find_files = { find_command = { 'rg', '--files', '--hidden', '-g', '!.git' } },
        treesitter = { layout_strategy = 'horizontal' },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sF', function()
      builtin.find_files { find_command = { 'rg', '--files', '--hidden', '-g!.git', '--no-ignore-vcs' } }
    end, { desc = '[S]earch [F]iles even if ignored by vcs' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sG', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    -- vim.keymap.set('v', '<leader>sG "gy', builtin.grep_string, { search = vim.fn.getreg 'g', desc = '[S]earch current [W]ord' })
    vim.keymap.set('v', '<leader>sg', function()
      vim.cmd 'normal! "gy'
      require('telescope.builtin').grep_string { search = vim.fn.getreg 'g' }
    end, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<Tab>.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<Tab><Tab>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
  file_only_entry_maker = file_only_entry_maker,
}
