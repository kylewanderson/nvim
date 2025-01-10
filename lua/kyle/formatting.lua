return {
	-- mdx support
	"jxnblk/vim-mdx-js",
	-- {
	-- 	-- Add indentation guides even on blank lines
	-- 	"lukas-reineke/indent-blankline.nvim",
	-- 	-- Enable `lukas-reineke/indent-blankline.nvim`
	-- 	-- See `:help indent_blankline.txt`
	-- 	opts = {
	-- 		char = "┊",
	-- 		show_trailing_blankline_indent = false,
	-- 	},
	-- },
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },
	-- Detect tabstop and shiftwidth automatically
	-- "tpope/vim-sleuth",
  {
    'stevearc/conform.nvim',
    opts = {},
    config = function()
      local conform = require("conform")
      vim.keymap.set(
        {"n", "v"},
        "<leader>fd",
        function()
          conform.format({
            lsp_fallback = true,
            async = false,
            timeout_ms = 500,
          })
        end,
        {desc = "[F]ormat [D]ocument" }
      )
      conform.setup({
        formatters_by_ft = {
          lua = { "stylua", lsp_format = "fallback" },
          -- Conform will run multiple formatters sequentially
          python = { "isort", "black" },
          -- You can customize some of the format options for the filetype (:help conform.format)
          rust = { "rustfmt", lsp_format = "fallback" },
          -- Conform will run the first available formatter
          javascript = { "prettierd", "prettier", stop_after_first = true },
          typescript = { "prettierd", "prettier", stop_after_first = true },
          javascriptreact = { "prettierd", "prettier", stop_after_first = true },
          typescriptreact = { "prettierd", "prettier", stop_after_first = true },
          json = { "prettierd", "prettier", stop_after_first = true },
          css = { "prettierd", "prettier", stop_after_first = true },
          scss = { "prettierd", "prettier", stop_after_first = true },
        },
      })
    end
  }
}
