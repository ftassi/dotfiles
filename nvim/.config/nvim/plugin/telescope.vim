lua << EOF

--[[    
    defaults = {
        previewer = true,
        layout_strategy = 'center',
        layout_config = {
            vertical = { mirror = true },
            horizontal = { mirror = false },
            center = { mirror = true, previewer = true },
        },
    },
]]--
require('telescope').setup{
    defaults = {
        color_devicons = true,
        path_display = { "shorten", }
    },
    pickers = {
        buffers = {
            sort_lastused = true,
            theme = "dropdown",
            dropdown = {
                mirror = true,
            }
        }
    },
    extensions = {
        fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = false, -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                            -- the default case_mode is "smart_case"
        }
    }
}

require('telescope').load_extension('fzf')
EOF

nnoremap <C-f> :lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>
nnoremap <leader>ff :lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git'}})<cr>
nnoremap <leader>ffa :lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git', '--no-ignore-vcs'}})<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fgg :lua require('telescope.builtin').grep_string({ search = vim.fn.expand("<cword>")})<CR>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <Tab> <cmd>Telescope buffers<cr>
nnoremap <leader>hh <cmd>Telescope help_tags<cr>
nnoremap <leader>gb :lua require('telescope.builtin').git_branches()<cr>
nnoremap <leader>df :lua require('ftassi.telescope').search_dotfiles()<cr>

