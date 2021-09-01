lua << EOF

require('telescope').setup{
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
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    }
}

require('telescope').load_extension('fzy_native')
EOF

nnoremap <C-f> :lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>
nnoremap <leader>ff :lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <Tab> <cmd>Telescope buffers<cr>
nnoremap <leader>hh <cmd>Telescope help_tags<cr>
nnoremap <leader>gb :lua require('telescope.builtin').git_branches()<cr>
nnoremap <leader>df :lua require('ftassi.telescope').search_dotfiles()<cr>

