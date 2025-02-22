-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    opts = {
      enable_check_bracket_line = true,
    },
  },
  { 'zbirenbaum/copilot.lua' },
  { 'janko-m/vim-test' },
  { 'alx741/vim-rustfmt' },
  { 'AndrewRadev/tagalong.vim' },
  { 'numToStr/Comment.nvim', opts = {} },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
}
