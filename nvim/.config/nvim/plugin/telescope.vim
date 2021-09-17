lua << EOF
local file_picker = require'telescope.themes'.get_dropdown({previewer = false})

require('telescope').setup{
    defaults = {
        layout_strategy = 'vertical',
        color_devicons = true,
        layout_config = {
            vertical = {mirror = true},
       },
    },
    pickers = {
        buffers = file_picker,
        oldfiles = file_picker,
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
nnoremap <leader>ffa :lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git', '--no-ignore-vcs'}})<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fgg :lua require('telescope.builtin').grep_string({ search = vim.fn.expand("<cword>")})<CR>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <Tab> <cmd>Telescope buffers<cr>
nnoremap <S-Tab> <cmd>Telescope oldfiles<cr>
nnoremap <leader>hh <cmd>Telescope help_tags<cr>
nnoremap <leader>gb :lua require('telescope.builtin').git_branches()<cr>
nnoremap <leader>df :lua require('ftassi.telescope').search_dotfiles()<cr>

