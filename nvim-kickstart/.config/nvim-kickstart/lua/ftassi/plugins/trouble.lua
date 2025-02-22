return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {},
  config = function()
    local function mapLeader(key, troubleFunc, description)
      vim.keymap.set('n', '<leader>' .. key, function()
        require('trouble').toggle(troubleFunc)
      end, { desc = description })
    end

    -- Utilizzo della funzione mapLeader per definire i mapping
    mapLeader('xx', nil, 'Toggle Trouble')
    mapLeader('xw', 'workspace_diagnostics', 'Toggle Workspace Diagnostics')
    mapLeader('xd', 'document_diagnostics', 'Toggle Document Diagnostics')
    mapLeader('xq', 'quickfix', 'Toggle Quickfix')
    mapLeader('xl', 'loclist', 'Toggle Location List')

    vim.keymap.set('n', 'gR', function()
      require('trouble').toggle 'lsp_references'
    end)
  end,
}
