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
