local copilot = require("copilot")

copilot.setup({
    panel = { enabled = false },
    suggestion = { 
        enabled = true, 
        auto_trigger = true,  -- Mostra il ghost text automaticamente
        keymap = {
            accept = "<Tab>",          -- Accetta il suggerimento con Tab
            accept_word = "<C-k>",     -- Accetta una parola alla volta
            accept_line = "<C-l>",     -- Accetta una riga alla volta
            next = "<C-n>",            -- Vai al suggerimento successivo
            prev = "<C-d>",            -- Vai al suggerimento precedente
            dismiss = "<C-f>",         -- Chiudi il suggerimento
        }
    },
    filetypes = {
        ["*"] = true, -- Abilitato per tutti i file
    }
})

require("copilot_cmp").setup()
