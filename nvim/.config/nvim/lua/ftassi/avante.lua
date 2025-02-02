local avante = require("avante")

avante.setup({
    provider = "openai",
    openai = {
        model = "o3-mini",
    },
    behaviour = {
        auto_suggestions = true,
        auto_apply_diff_after_generation = false,
    },
})
