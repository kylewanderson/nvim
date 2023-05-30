return {
	"github/copilot.vim",
	config = function()
		vim.g.copilot_no_tab_map = true
		vim.api.nvim_set_keymap(
			"i",
			"<C-l>",
			'copilot#Accept("<CR>")',
			{ silent = true, expr = true }
		)
		vim.api.nvim_set_keymap(
			"i",
			"<C-0>",
			"copilot#Next()",
			{ silent = true, expr = true }
		)
		vim.api.nvim_set_keymap(
			"i",
			"<C-9>",
			"copilot#Previous()",
			{ silent = true, expr = true }
		)
	end,
}
