-- leader m command for formatting code blocks
return {
  'Wansmer/treesj',
  keys = { '<leader>m', '<leader>j', '<leader>s' },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('treesj').setup({--[[ your config ]]})
  end,
}
