return {
  'echasnovski/mini.nvim',
  version = false,
  config = function ()
    require('mini.ai').setup({
      mappings = {
        -- Main textobject prefixes
        around = 'a',
        inside = 'i',

        -- Next/last variants
        around_next = 'an',
        inside_next = 'in',
        around_last = 'al',
        inside_last = 'il',

        -- Move cursor to corresponding edge of `a` textobject
        goto_left = 'g[',
        goto_right = 'g]',
      }
    })
    require('mini.surround').setup({
      mappings = {
        add = 'sa', -- Add surrounding in Normal and Visual modes
        delete = 'sd', -- Delete surrounding
        find = 'sf', -- Find surrounding (to the right)
        find_left = 'sF', -- Find surrounding (to the left)
        highlight = 'sh', -- Highlight surrounding
        replace = 'sr', -- Replace surrounding
        update_n_lines = 'sn', -- Update `n_lines`

        suffix_last = 'l', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
      },
    })
    require('mini.pairs').setup()
    require('mini.bracketed').setup()
  end
}
