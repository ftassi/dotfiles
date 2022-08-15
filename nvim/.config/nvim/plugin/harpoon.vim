lua << EOF
require("harpoon").setup({
    menu = {
        width = 120
    }
})
EOF
nnoremap <leader>j :lua require("harpoon.mark").add_file()<CR>

nnoremap <leader><Tab> :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <leader>9 :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <leader>8 :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <leader>7 :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <leader>6 :lua require("harpoon.ui").nav_file(4)<CR>

