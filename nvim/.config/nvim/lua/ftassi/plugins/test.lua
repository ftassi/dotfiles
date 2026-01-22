return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    -- Adapters
    'rouge8/neotest-rust',
    'olimorris/neotest-phpunit',
  },
  keys = {
    { '<leader>tt', function() require('neotest').run.run() end, desc = '[T]est nearest' },
    { '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = '[T]est [F]ile' },
    { '<leader>ta', function() require('neotest').run.run(vim.fn.getcwd()) end, desc = '[T]est [A]ll' },
    { '<leader>tl', function() require('neotest').run.run_last() end, desc = '[T]est [L]ast' },
    { '<leader>ts', function() require('neotest').summary.toggle() end, desc = '[T]est [S]ummary toggle' },
    { '<leader>to', function() require('neotest').output.open({ enter = true }) end, desc = '[T]est [O]utput' },
    { '<leader>tO', function() require('neotest').output_panel.toggle() end, desc = '[T]est [O]utput panel' },
    { '<leader>tS', function() require('neotest').run.stop() end, desc = '[T]est [S]top' },
    { '<leader>tw', function() require('neotest').watch.toggle(vim.fn.expand('%')) end, desc = '[T]est [W]atch file' },
    { '[t', function() require('neotest').jump.prev({ status = 'failed' }) end, desc = 'Previous failed test' },
    { ']t', function() require('neotest').jump.next({ status = 'failed' }) end, desc = 'Next failed test' },
  },
  config = function()
    require('neotest').setup({
      adapters = {
        require('neotest-rust') {
          args = { '--no-capture' },
          -- Check for project-local cargo command (set in .nvim.lua)
          cargo_test_cmd = function()
            return vim.g.neotest_rust_cargo_cmd or 'cargo test'
          end,
        },
        require('neotest-phpunit') {
          -- Check for project-local phpunit command (set in .nvim.lua)
          phpunit_cmd = function()
            if vim.g.neotest_phpunit_cmd then
              return vim.g.neotest_phpunit_cmd
            end
            return 'vendor/bin/phpunit'
          end,
        },
      },
      status = {
        virtual_text = true,
        signs = true,
      },
      output = {
        open_on_run = false,
      },
      quickfix = {
        open = false,
      },
      icons = {
        passed = '✓',
        failed = '✗',
        running = '⟳',
        skipped = '↓',
        unknown = '?',
      },
    })
  end,
}
