Completare la configurazione per php

Ho installato alcuni lsp, ma dato che php non fa parte del mio flusso di lavoro al momento non sto 
facendo il porting di php actor e relativi binding.
ho disabilitato temporaneamente l'lsp di psalm


implementare la ricerca nella directory selezionata dall'albero delle dir.
Nella vecchia config era implementata con nerdtree, devo portarla a filetree. Ad ogni modo è una funzionalità
che uso poco

# Alternative a vim-test per Neovim

## 1. neotest
https://github.com/nvim-neotest/neotest

**Pro:**
- Scritto completamente in Lua
- Progettato specificamente per Neovim
- Interfaccia moderna con supporto per diagnostics, segni e finestre fluttuanti
- Sistema di adapter estensibile
- Supporto per debug dei test
- Integrazione con DAP (Debug Adapter Protocol)
- Supporto per test asincroni
- Visualizzazione ad albero dei test

**Contro:**
- Richiede Neovim 0.7+
- Potrebbe richiedere più configurazione iniziale

Neotest ha già un adapter per Plenary:
https://github.com/nvim-neotest/neotest-plenary

### Esempio di configurazione per neotest con Plenary:

```lua
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-neotest/neotest-plenary",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-plenary"),
      },
      -- Altre opzioni di configurazione
      icons = {
        running = "⟳",
        passed = "✓",
        failed = "✗",
        skipped = "↓",
      },
      summary = {
        open = "botright vsplit | vertical resize 50",
      },
    })
    
    -- Keymaps
    vim.keymap.set("n", "<leader>tn", function() require("neotest").run.run() end, { desc = "Run nearest test" })
    vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run file tests" })
    vim.keymap.set("n", "<leader>ts", function() require("neotest").run.run("tests/") end, { desc = "Run all tests" })
    vim.keymap.set("n", "<leader>tl", function() require("neotest").run.run_last() end, { desc = "Run last test" })
    vim.keymap.set("n", "<leader>to", function() require("neotest").output.open() end, { desc = "Open test output" })
    vim.keymap.set("n", "<leader>tp", function() require("neotest").summary.toggle() end, { desc = "Toggle test panel" })
  end,
}
```

## 2. ultest
https://github.com/rcarriga/vim-ultest

**Pro:**
- Interfaccia moderna
- Supporto per test asincroni
- Compatibile con i runner di vim-test
- Visualizzazione dei risultati inline

**Contro:**
- Richiede un componente compilato
- Meno attivamente mantenuto rispetto a neotest

## 3. overseer.nvim
https://github.com/stevearc/overseer.nvim

**Pro:**
- Task runner generico che può essere configurato per i test
- Interfaccia moderna
- Completamente in Lua
- Molto flessibile

**Contro:**
- Non specifico per i test, quindi richiede più configurazione

## Confronto con vim-test

**vim-test:**
- **Pro:** Ampiamente testato, stabile, supporta molti framework
- **Pro:** Configurazione semplice per casi d'uso comuni
- **Pro:** Grande comunità e supporto
- **Contro:** Scritto in Vimscript
- **Contro:** Interfaccia meno moderna
- **Contro:** Meno integrato con le funzionalità di Neovim

**neotest:**
- **Pro:** Interfaccia moderna e ricca di funzionalità
- **Pro:** Scritto in Lua nativo
- **Pro:** Migliore integrazione con Neovim
- **Pro:** Supporto per debug e visualizzazione avanzata
- **Contro:** Relativamente più nuovo, quindi potenzialmente meno stabile
- **Contro:** Richiede più configurazione iniziale
