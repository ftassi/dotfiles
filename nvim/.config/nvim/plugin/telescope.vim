lua << EOF
local defaultPicker = {
    theme = "ivy",
    previewer = false,
}

require('telescope').setup{
    defaults = {
        layout_strategy = 'vertical',
        layout_config = {
            vertical = { mirror = true }
        },
    },
    pickers = {
        find_files = defaultPicker,
        buffers = defaultPicker
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    }
}

require('telescope').load_extension('fzy_native')
EOF

nnoremap <leader>ff :lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>gb :lua require('telescope.builtin').git_branches()<cr>

