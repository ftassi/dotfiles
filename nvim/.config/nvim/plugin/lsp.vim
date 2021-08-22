" LSP mapping
nnoremap <leader>a :lua require('telescope.builtin').lsp_code_actions()<cr>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <leader>rr :lua vim.lsp.buf.rename()<CR>
nnoremap <leader>a :lua require('telescope.builtin').lsp_code_actions()<cr>
"
" Find and discover code
nnoremap <leader>fs :lua require('telescope.builtin').lsp_document_symbols()<cr>
nnoremap <leader>ft :lua require('telescope.builtin').treesitter()<cr>
nnoremap <leader>fS :lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>
nnoremap <leader>fr :lua require('telescope.builtin').lsp_references()<cr>
" nnoremap <silent> fr <cmd>lua vim.lsp.buf.references()<CR>

nnoremap <leader>gi :lua require('telescope.builtin').lsp_implementations()<cr>
" nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>gd :lua require('telescope.builtin').lsp_definitions()<cr>
" nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>

" autocomplete mapping 
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"map <tab> to manually trigger completion
imap <tab> <Plug>(completion_smart_tab)
imap <s-tab> <Plug>(completion_smart_s_tab)

" Avoid showing message extra message when using completion
set shortmess+=c
set completeopt=menuone,noinsert,noselect

let g:completion_matching_smart_case = 1
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']

lua << EOF
local lsp = require('lspconfig')
local completion = require('completion')

local mapper = function(mode, key, result)
  vim.api.nvim_buf_set_keymap(0, mode, key, "<cmd>lua "..result.."<cr>", {noremap = true, silent = true})
end

local custom_attach = function()
    completion.on_attach()
    -- Move cursor to the next and previous diagnostic
    mapper('n', '<leader>dn', 'vim.lsp.diagnostic.goto_next()')
    mapper('n', '<leader>dp', 'vim.lsp.diagnostic.goto_prev()')
end

lsp.intelephense.setup{
    on_attach = custom_attach
}
EOF


