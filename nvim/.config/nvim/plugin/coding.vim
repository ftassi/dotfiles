let g:phpactorActivateOverlapingMappings = v:true

augroup PhpactorMappings
    au!
    au FileType php nmap <buffer> <Leader>u :PhpactorImportClass<CR>
    au FileType php nmap <buffer> <Leader>ua :PhpactorImportMissingClasses<CR>
    au FileType php nmap <buffer> <Leader>e :PhpactorClassExpand<CR>
    au FileType php nmap <buffer> <Leader>mm :PhpactorContextMenu<CR>
    au FileType php nmap <buffer> <Leader>tc :PhpactorTransform<CR>
    au FileType php nmap <buffer> <Leader>cc :PhpactorClassNew<CR>
    au FileType php nmap <buffer> <Leader>ei :PhpactorClassInflect<CR>
    au FileType php nmap <buffer> <Leader>mf :PhpactorMoveFile<CR>
    au FileType php vmap <buffer> <silent> <Leader>ev
        \ :<C-u>PhpactorExtractExpression<CR>
    au FileType php vmap <buffer> <silent> <Leader>ec
        \ :<C-u>PhpactorExtractConstant<CR>
    au FileType php vmap <buffer> <silent> <Leader>em
        \ :<C-u>PhpactorExtractMethod<CR>
    "
    " au FileType php nmap <buffer> <Leader>nn :PhpactorNavigate<CR>
    " au FileType php,cucumber nmap <buffer> <Leader>o
    "     \ :PhpactorGotoDefinition edit<CR>
    " au FileType php nmap <buffer> <Leader>K :PhpactorHover<CR>
    " au FileType php nmap <buffer> <Leader>fr :PhpactorFindReferences<CR>
    " au FileType php nmap <buffer> <Leader>cf :PhpactorCopyFile<CR>
augroup END

" Reformat code inside {} block
nnoremap <leader>== mqvi{=`q
inoremap <C-c> <CR><Esc>O

" LSP mapping
nnoremap <leader>a :lua require('telescope.builtin').lsp_code_actions()<cr>
nnoremap <silent> <leader>sh <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <leader>rr :lua vim.lsp.buf.rename()<CR>
nnoremap <leader>a :lua require('telescope.builtin').lsp_code_actions()<cr>
"
" Find and discover code
nnoremap <leader>fs :lua require('telescope.builtin').lsp_document_symbols()<cr>
nnoremap <leader>ft :lua require('telescope.builtin').treesitter()<cr>
nnoremap <leader>fS :lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>
nnoremap <leader>fm :lua require('telescope.builtin').lsp_document_symbols({default_text=":method: " })<cr>
nnoremap <leader>fr :lua require('telescope.builtin').lsp_references()<cr>
" nnoremap <silent> fr <cmd>lua vim.lsp.buf.references()<CR>

nnoremap <leader>gi :lua require('telescope.builtin').lsp_implementations()<cr>
" nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>gd :lua require('telescope.builtin').lsp_definitions()<cr>
" nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>

" Avoid showing message extra message when using completion
set shortmess+=c
autocmd FileType php set iskeyword+=$

let g:completion_matching_smart_case = 1
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']

lua << EOF
local lsp = require('lspconfig')
require "lsp_signature".setup({zindex=50})
local on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local opts = {noremap = true, silent = true}

  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)

end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- enable language server
lsp.intelephense.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}

lsp.psalm.setup{
  cmd = {'backend/bin/psalm.phar', '--language-server', '-r', 'backend'},
  on_attach = on_attach,
  capabilities = capabilities,
}


local luasnip = require'luasnip'
require("luasnip/loaders/from_vscode").lazy_load()

local cmp = require'cmp'
cmp.setup {
    snippet = {
        expand = function(args)
            require'luasnip'.lsp_expand(args.body)
        end,
    },
    completeopt = 'longest,menuone',
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
            },
        ['<Tab>'] = function(fallback)
            if vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
            elseif luasnip.expand_or_jumpable() then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n')
            elseif luasnip.jumpable(-1) then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
            else
                fallback()
            end
        end,
    },
    sources  = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }
}
EOF


