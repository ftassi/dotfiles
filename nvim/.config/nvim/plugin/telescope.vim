lua << EOF
local file_picker = require'telescope.themes'.get_dropdown({previewer = false})

require('telescope').setup{
    defaults = {
        vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number',  '--column', '--smart-case', '--hidden', '-u' },
        layout_strategy = 'vertical',
        color_devicons = true,
        layout_config = {
            width = 0.9,
            vertical = {mirror = false},
       },
    },
    pickers = {
        buffers = file_picker,
        oldfiles = file_picker,
        find_files = { find_command = {'rg', '--files', '--hidden', '-g', '!.git' }},
        treesitter = { layout_strategy = 'horizontal' },
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    }
}

require('telescope').load_extension('fzy_native')
require('telescope').load_extension('frecency')
EOF

nnoremap <C-f> :lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>
nnoremap <leader><leader> :lua require('telescope').extensions.frecency.frecency()<cr>
nnoremap <leader>ff :lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>
nnoremap <leader>fa :lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git', '--no-ignore-vcs'}})<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fgg :lua require('telescope.builtin').grep_string({ search = vim.fn.expand("<cword>")})<CR>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <Tab> <cmd>Telescope buffers<cr>
nnoremap <S-Tab> <cmd>Telescope oldfiles<cr>
nnoremap <leader>hh <cmd>Telescope help_tags<cr>
nnoremap <leader>gb :lua require('telescope.builtin').git_branches()<cr>
nnoremap <leader>df :lua require('ftassi.telescope').search_dotfiles()<cr>

