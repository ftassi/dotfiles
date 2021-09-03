nnoremap Q :q<CR>

nnoremap <leader>wo :Bdelete other<CR>
nnoremap <leader>wa :Bdelete all<CR>
nnoremap <leader>wh :Bdelete hidden<CR>
nnoremap <leader>w :Bdelete menu<CR>

nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-h> :wincmd h<CR>
nnoremap <silent> <C-l> :wincmd l<CR>

nnoremap <silent> <A-k> :res +5<CR>
nnoremap <silent> <A-j> :res -5<CR>
nnoremap <silent> <A-h> :vertical resize -5<CR>
nnoremap <silent> <A-l> :vertical resize +5<CR> 

nnoremap <silent> <C-a> <C-^><CR>
map <silent> <C-m> :call ToggleMaximizeCurrentWindow()<CR>
