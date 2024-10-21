local macUnix = vim.fn.has("macunix") == 1
return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").load_extension("lazygit")
			local telescopeActions = require("telescope.actions")
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = { "node_modules" },
          path_display = {
            shorten = {
              len = 1, exclude = {-1, -2, -3}
            },
            truncate = true,
          },
          dynamic_preview_title = true,
					mappings = {
						i = {
							["<C-u>"] = false,
							["<C-d>"] = false,
							["<C-j>"] = telescopeActions.move_selection_next,
							["<C-k>"] = telescopeActions.move_selection_previous,
						},
					},
				},
			})

			-- Enable telescope fzf native, if installed
			pcall(require("telescope").load_extension, "fzf")

			vim.api.nvim_create_user_command("Gb", "Telescope git_branches", {})

			-- See `:help telescope.builtin`
			vim.keymap.set(
				"n",
				"<leader><space>",
				require("telescope.builtin").oldfiles,
				{ desc = "[?] Find recently opened files" }
			)
			vim.keymap.set(
				"n",
				"<leader>?",
				require("telescope.builtin").buffers,
				{ desc = "[ ] Find existing buffers" }
			)
			vim.keymap.set("n", "<leader>/", function()
				-- You can pass additional configuration to telescope to change theme, layout, etc.
				require("telescope.builtin").current_buffer_fuzzy_find(
					require("telescope.themes").get_dropdown({
						winblend = 10,
						previewer = false,
					})
				)
			end, { desc = "[/] Fuzzily search in current buffer" })

			vim.keymap.set("n", "<C-p>", function()
				require("telescope.builtin").find_files({
					hidden = true,
				})
			end, { desc = "[S]earch [F]iles" })
			vim.keymap.set(
				"n",
				"<leader>sh",
				require("telescope.builtin").help_tags,
				{ desc = "[S]earch [H]elp" }
			)
			vim.keymap.set(
				"n",
				"<leader>gg",
				require("telescope.builtin").grep_string,
				{ desc = "[S]earch current [W]ord" }
			)
			vim.keymap.set(
				"n",
				"<leader>sg",
				require("telescope.builtin").live_grep,
				{ desc = "[S]earch by [G]rep" }
			)
			vim.keymap.set(
				"n",
				"<leader>sd",
				require("telescope.builtin").diagnostics,
				{ desc = "[S]earch [D]iagnostics" }
			)
			vim.keymap.set("n", "<leader>sl", function()
				require("telescope.builtin").live_grep({
					cwd = macUnix and "~/.config/nvim" or "~/AppData/Local/nvim",
				})
			end, { desc = "[S]earch [L]SP symbols" })

			vim.keymap.set("n", "<leader>fl", function()
				require("telescope.builtin").find_files({
					cwd = macUnix and "~/.config/nvim" or "~/AppData/Local/nvim",
				})
			end, { desc = "[S]earch [L]SP symbols" })
		end,
	},

	-- Fuzzy Finder Algorithm which requires local dependencies to be built.
	-- Only load if `make` is available. Make sure you have the system
	-- requirements installed.
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		-- NOTE: If you are having trouble with this installation,
		--       refer to the README for telescope-fzf-native for more instructions.
		build = "make",
		cond = function()
			return vim.fn.executable("make") == 1
		end,
	},
  {
    'nvim-telescope/telescope-symbols.nvim',
  }
}
