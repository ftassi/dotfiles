nmap <leader>gs :G<cr>
" nmap <leader>gn <Plug>(GitGutterNextHunk)
" nmap <leader>gp <Plug>(GitGutterPrevHunk)
nmap <leader>gp :Git push<CR>
nmap <leader>gc :Git commitf<CR>
nmap <leader>gh <Plug>(GitGutterPreviewHunk)
nmap <leader>ga <Plug>(GitGutterStageHunk)
nmap <leader>gu <Plug>(GitGutterUndoHunk)
" Git log
nmap <leader>gl :GV<cr>
nmap <leader>glf :GV!<cr>
nmap <leader>glb :GV --first-parent<cr>

" Use fontawesome icons as signs
let g:gitgutter_sign_added = ''
let g:gitgutter_sign_modified = ''
let g:gitgutter_sign_removed = ''
let g:gitgutter_sign_removed_first_line = ''
let g:gitgutter_sign_modified_removed = ''

autocmd User FugitiveChanged call gitgutter#all(1)
