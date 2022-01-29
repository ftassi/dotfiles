local lsp = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

lsp.intelephense.setup{ capabilities = capabilities }
lsp.psalm.setup{
    capabilities = capabilities,
    cmd = {'backend/bin/psalm.phar', '--language-server', '-r', 'backend'},
}

lsp.tsserver.setup{ capabilities = capabilities }

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
--
-- vim.o.updatetime = 250
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})]]
function PrintDiagnostics(opts, bufnr, line_nr, client_id)
  bufnr = bufnr or 0
  line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)
  opts = opts or {['lnum'] = line_nr}

  local line_diagnostics = vim.diagnostic.get(bufnr, opts)
  if vim.tbl_isempty(line_diagnostics) then return end

  local diagnostic_message = ""
  for i, diagnostic in ipairs(line_diagnostics) do
    diagnostic_message = diagnostic_message .. string.format("%d: %s", i, diagnostic.message or "")
    print(diagnostic_message)
    if i ~= #line_diagnostics then
      diagnostic_message = diagnostic_message .. "\n"
    end
  end
  vim.api.nvim_echo({{diagnostic_message, "Normal"}}, false, {})
end

vim.cmd [[ autocmd CursorHold * lua PrintDiagnostics() ]]
