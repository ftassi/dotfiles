" Test runner
nmap <silent> <leader>t :w<CR> :TestNearest<CR>
nmap <silent> <leader>tt :w<CR> :TestFile<CR>
nmap <silent> <leader>tl :w<CR> :TestLast<CR>
nmap <silent> <leader>ta :w<CR> :TestSuite<CR>
nmap <silent> <leader>tg :w<CR> :TestVisit<CR>

let test#strategy = 'neovim'
