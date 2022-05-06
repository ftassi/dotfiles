local lsp = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- vim.lsp.set_log_level('debug')

-- You can configure intelphense to work for a specific version of php
-- configuring it like this:
-- settings = {
    -- intelephense = {
    --     environment = {phpVersion = "7.4"},
    -- },
    -- logging = {enabled = false, level = 'debug', path = '/var/log/phpactor.log'},
-- },
-- This configuration should be done in .nvimrc file at project level as you most likely
-- want to customize php version per project
lsp.intelephense.setup{ 
    capabilities = capabilities,
}

lsp.psalm.setup{
    capabilities = capabilities,
    cmd = {'bin/psalm-language-server'},
    filetypes = {"php"},
    root_dir = lsp.util.root_pattern("psalm.xml", "psalm.xml.dist")
}

lsp.tsserver.setup {
    before_init = function(params)
        params.processId = vim.NIL
    end,
    cmd = require'lspcontainers'.command('tsserver'),
    root_dir = lsp.util.root_pattern(".git", vim.fn.getcwd()),
    capabilities = capabilities
}

local cmp = require'cmp'
cmp.setup {
    formatting = {
        format = lspkind.cmp_format({with_text = false, maxwidth = 50})
    },
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    completeopt = 'longest,menuone',
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
            },
        ['<Tab>'] = function(fallback)
            if vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n')
            else
                fallback()
            end
        end,
    },
    sources  = {
        { name = 'nvim_lsp' },
    }
}

require "lsp_signature".setup({
        floating_window = false,
    });
-- require "lsp_signature".setup({
--     zindex = 50,
--     bind = true,
--     hint_enable = false,
--     always_trigger = true,
-- }, bufnr)
