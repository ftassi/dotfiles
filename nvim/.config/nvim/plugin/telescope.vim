nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nnoremap <leader>a :lua require('telescope.builtin').lsp_code_actions()<cr>
nnoremap <leader>fu :lua require('telescope.builtin').lsp_references()<cr>
nnoremap <leader>fs :lua require('telescope.builtin').lsp_document_symbols()<cr>
nnoremap <leader>fgs :lua require('telescope.builtin').lsp_workspace_symbols()<cr>
nnoremap <leader>ts :lua require('telescope.builtin').treesitter()<cr>
