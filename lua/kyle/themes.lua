return {
	{
		-- Theme inspired by Atom
		"navarasu/onedark.nvim",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("onedark")
		end,
	},

	{
		"nordtheme/vim",
		-- priority = 1000,
		-- config = function()
		--   vim.cmd.colorscheme 'gruvbox-material'
		-- end,
	},

	{
		"sainnhe/gruvbox-material",
		-- priority = 1000,
		-- config = function()
		--   vim.cmd.colorscheme 'gruvbox-material'
		-- end,
	},

	{
		"folke/tokyonight.nvim",
		-- priority = 1000,
		-- config = function()
		--   vim.cmd.colorscheme 'tokyonight-storm'
		-- end,
	},
}
