local function codeBreadCrumbs()
    local treesitter = require'nvim-treesitter'
    local ok, statusline = pcall(treesitter.statusline)
    if not ok or not statusline then
        return "no status line" 
    end

    return statusline
end

require'lualine'.setup {
    options = {
        theme = 'onedark',
    },
    tabline = {
        ualine_a = {codeBreadCrumbs},
    },
}
