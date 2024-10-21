return {
	"JoosepAlviste/nvim-ts-context-commentstring",
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				toggler = {
					line = "gcl",
					block = "gsl",
				},
				opleader = {
					line = "gc",
					block = "gs",
				},
				pre_hook = require(
					"ts_context_commentstring.integrations.comment_nvim"
				).create_pre_hook(),
			})
		end,
	},
	-- 'tpope/vim-commentary',
}
