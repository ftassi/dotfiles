return {
  'Pocco81/auto-save.nvim',
  opts = {
    trigger_events = { 'InsertLeave', 'BufLeave', 'FocusLost', 'TextChanged' },
    debounce_delay = 1000,
  },
}
