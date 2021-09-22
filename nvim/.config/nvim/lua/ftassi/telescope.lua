local M = {}
M.search_dotfiles = function()
    require("telescope.builtin").git_files({
        prompt_title = "< Dotfiles >",
        cwd = "/home/ftassi/.dotfiles.stow",
        hidden = true,
    })
end

return M
