" Test runner
nmap <silent> <leader>tt :w<CR> :TestNearest<CR>
nmap <silent> <leader>tf :w<CR> :TestFile<CR>
nmap <silent> <leader>tl :w<CR> :TestLast<CR>
nmap <silent> <leader>ta :w<CR> :TestSuite<CR>
nmap <silent> <leader>tg :w<CR> :TestVisit<CR>

let test#strategy = 'neovim'
let test#neovim#term_position = "vert botright"
let test#rust#cargotest#test_options = '-- --nocapture'

if has('nvim')
  tmap <C-o> <C-\><C-n>
endif
