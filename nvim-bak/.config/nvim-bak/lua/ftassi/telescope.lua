local entry_display = require "telescope.pickers.entry_display"

local function file_only_entry_maker(entry)
    local displayer = entry_display.create {
        items = {
            { remaining = true },
        },
    }

    return {
        valid = true,
        display = function(entry)
            local filename = entry.filename
            return displayer {
                filename..":"..entry.lnum,
            }
        end,
        value = entry,
        ordinal = entry.filename,
        filename = entry.filename,
        text = entry.text,
        lnum = entry.lnum,
        col = entry.col,
    }
end

local M = {}
M.search_dotfiles = function()
    require("telescope.builtin").git_files({
        prompt_title = "< Dotfiles >",
        cwd = "/home/ftassi/dotfiles",
        hidden = true,
    })
end

M.file_only_entry_maker = file_only_entry_maker

return M
