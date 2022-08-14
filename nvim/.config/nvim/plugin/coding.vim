let g:phpactorActivateOverlapingMappings = v:true

lua << EOF
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
EOF

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
    au FileType php nmap <buffer> <Leader>mf :PhpactorMoveFile<CR>
    au FileType php nmap <buffer> <Leader>cf :PhpactorCopyFile<CR>
    au FileType php vmap <buffer> <silent> <Leader>ev
        \ :<C-u>PhpactorExtractExpression<CR>
    au FileType php vmap <buffer> <silent> <Leader>ec
        \ :<C-u>PhpactorExtractConstant<CR>
    au FileType php vmap <buffer> <silent> <Leader>em
        \ :<C-u>PhpactorExtractMethod<CR>
    "
    " au FileType php nmap <buffer> <Leader>nn :PhpactorNavigate<CR>
    " au FileType php,cucumber nnoremap <Leader>gd :PhpactorGotoDefinition edit<CR>
    " au FileType php nmap <buffer> <Leader>K :PhpactorHover<CR>
    " au FileType php nmap <buffer> <Leader>fr :PhpactorFindReferences<CR>
augroup END

" Reformat code inside {} block
nnoremap <leader>== mqvi{=`q
inoremap <C-c> <CR><Esc>O

" LSP mapping
nnoremap <leader>K <Cmd>lua vim.lsp.buf.hover()<cr>
nnoremap <leader>a :lua require('telescope.builtin').lsp_code_actions()<cr>
nnoremap <silent> <leader>sh <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <leader>rr :lua vim.lsp.buf.rename()<CR>
"
" Find and discover code
nnoremap <leader>ft :lua require('telescope.builtin').treesitter()<cr>
nnoremap <leader>fs :lua require('telescope.builtin').lsp_document_symbols()<cr>
nnoremap <leader>fm :lua require('telescope.builtin').lsp_document_symbols({default_text=":method: " })<cr>
nnoremap <leader>fr :lua require('telescope.builtin').lsp_references({entry_maker = require('ftassi.telescope').file_only_entry_maker})<cr>
nnoremap <leader>fi :lua require('telescope.builtin').lsp_implementations({entry_maker = require('ftassi.telescope').file_only_entry_maker})<cr>
" nnoremap <silent> fr <cmd>lua vim.lsp.buf.references()<CR>

nnoremap <leader>gi :lua require('telescope.builtin').lsp_implementations({entry_maker = require('ftassi.telescope').file_only_entry_maker})<cr>
" nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>gd :lua require('telescope.builtin').lsp_definitions({entry_maker = require('ftassi.telescope').file_only_entry_maker})<cr>
" nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration({entry_maker = require('ftassi.telescope').file_only_entry_maker})<CR>

" Avoid showing message extra message when using completion
set shortmess+=c
autocmd FileType php set iskeyword+=$

let g:completion_matching_smart_case = 1
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']

runtime lua/ftassi/lsp.lua

lua << EOF
  require("trouble").setup {
      auto_preview = false,
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF

nnoremap <leader>zx <cmd>TroubleToggle<cr>
nnoremap <leader>zw <cmd>TroubleToggle workspace_diagnostics<cr>
nnoremap <leader>zd <cmd>TroubleToggle document_diagnostics<cr>
nnoremap <leader>zq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>zl <cmd>TroubleToggle loclist<cr>
nnoremap zr <cmd>TroubleToggle lsp_references<cr>
nnoremap zR <cmd>TroubleRefresh<cr>
