local M = {}
M.search_dotfiles = function()
    require("telescope.builtin").git_files({
        prompt_title = "< VimRC >",
        cwd = "/home/ftassi/.dotfiles.stow",
        hidden = true,
    })
end

return M
