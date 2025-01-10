return {
	"stevearc/oil.nvim",
	config = function()
		require("oil").setup({
			keymaps = {
				["g?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["cd"] = "actions.cd",
				["~"] = "actions.tcd",
				["g."] = "actions.toggle_hidden",
			},
			use_default_keymaps = false,
			view_options = {
				show_hidden = true,
			},
		})
		vim.keymap.set(
			"n",
			"-",
			require("oil").open,
			{ desc = "Open parent directory" }
		)
	end,
}
