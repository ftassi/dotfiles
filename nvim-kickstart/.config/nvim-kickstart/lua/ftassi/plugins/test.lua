return {
  "vim-test/vim-test",
  event = "VeryLazy",  -- o l'evento che preferisci
  config = function()
    -- Imposta le variabili globali richieste da vim-test:
    vim.g["test#strategy"] = "neovim"
    vim.g["test#neovim#term_position"] = "vert botright"
    vim.g["test#rust#cargotest#test_options"] = "-- --nocapture"
    
    -- Richiama il modulo dei keymaps per vim-test
    require("ftassi.keymaps.test").test()
  end,
}
