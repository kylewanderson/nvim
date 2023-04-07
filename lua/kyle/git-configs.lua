return {
	{
		"tpope/vim-fugitive",
		config = function()
			vim.api.nvim_create_user_command("Glme", "Git log -- %", {})
			vim.api.nvim_create_user_command("G", function(args)
				local vimCmd = "vertical Git"
				if args["args"] then
					vimCmd = vimCmd .. " " .. args["args"]
				end
				vim.cmd(vimCmd)
			end, { desc = "Open Git vertically", nargs = "*" })
			vim.keymap.set(
				"n",
				"gl",
				"<cmd>diffget //3<CR>",
				{ desc = "Get the right side of the diff" }
			)
			vim.keymap.set(
				"n",
				"gh",
				"<cmd>diffget //2<CR>",
				{ desc = "Get the left side of the diff" }
			)
		end,
	},
	"tommcdo/vim-fubitive",
	"tpope/vim-rhubarb",
	{
		"kdheepak/lazygit.nvim",
		config = function()
			vim.keymap.set("n", "<leader>lg", ":LazyGit<CR>")
		end,
	},
	{
		-- Adds git releated signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
			})
			vim.keymap.set(
				"n",
				"<leader>gb",
				":Gitsigns blame_line<CR>",
				{ desc = "Blame line" }
			)
			vim.keymap.set(
				"n",
				"<leader>gh",
				":Gitsigns preview_hunk<CR>",
				{ desc = "Preview hunk" }
			)
			vim.keymap.set(
				"n",
				"<leader>gj",
				":Gitsigns next_hunk<CR>",
				{ desc = "Next hunk" }
			)
			vim.keymap.set(
				"n",
				"<leader>gk",
				":Gitsigns prev_hunk<CR>",
				{ desc = "Previous hunk" }
			)
			vim.keymap.set(
				"n",
				"<leader>gs",
				":Gitsigns stage_hunk<CR>",
				{ desc = "Stage hunk" }
			)
			vim.keymap.set(
				"n",
				"<leader>gu",
				":Gitsigns undo_stage_hunk<CR>",
				{ desc = "Undo stage hunk" }
			)
			vim.keymap.set(
				"n",
				"<leader>gr",
				":Gitsigns reset_hunk<CR>",
				{ desc = "Reset hunk" }
			)
			vim.keymap.set(
				"n",
				"<leader>gl",
				":Gitsigns toggle_current_line_blame<CR>"
			)
		end,
	},
}
