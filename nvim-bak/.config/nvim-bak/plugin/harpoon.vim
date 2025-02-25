lua << EOF
require("harpoon").setup({
    menu = {
        width = 120
    }
})
EOF
nnoremap <leader>j :lua require("harpoon.mark").add_file()<CR>

nnoremap <leader><Tab> :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <leader><leader>f :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <leader><leader>d :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <leader><leader>s :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <leader><leader>a :lua require("harpoon.ui").nav_file(4)<CR>
