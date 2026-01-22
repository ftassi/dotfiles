local function get_lsp_client_names()
  local clients = {}

  for _, client in pairs(vim.lsp.get_clients { bufnr = 0 }) do
    clients[#clients + 1] = client.name
  end

  return '[ ' .. table.concat(clients, ', ') .. ' ]'
end

return {
  'hoob3rt/lualine.nvim',
  opts = {
    options = {
      theme = 'onedark',
    },
    sections = {
      lualine_c = {
        { 'filename', file_status = true, path = 0 },
      },
      lualine_x = {
        {
          get_lsp_client_names,
          cond = function()
            return next(vim.lsp.get_clients { bufnr = 0 }) ~= nil
          end,
        },
      },
    },
    tabline = {
      lualine_b = {
        { 'filename', file_status = true, path = 1 },
      },
    },
  },
}
