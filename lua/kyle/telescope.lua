local macUnix = vim.fn.has("macunix") == 1

return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()

      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local make_entry = require("telescope.make_entry")
      local conf = require("telescope.config").values

      local live_multigrep = function(opts)
        opts = opts or {}
        opts.cwd = opts.cwd or vim.uv.cwd()

        local finder = finders.new_async_job {
          command_generator = function(prompt)
            if not prompt or prompt == "" then
              return nil
            end

            local pieces = vim.split(prompt, "  ")
            local args = { "rg" }

            if pieces[1] then
              table.insert(args, "-e")
              table.insert(args, pieces[1])
            end

            if pieces[2] then
              table.insert(args, "-g")
              table.insert(args, pieces[2])
            end

            return vim.tbl_flatten {
              args,
              {
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
              }
            }
          end,
          entry_maker = make_entry.gen_from_vimgrep(opts),
          cwd = opts.cwd,
        }

        pickers.new(opts, {
          debounce = 100,
          prompt_title = "Test ftype grep",
          finder = finder,
          previewer = conf.grep_previewer(opts),
          sorter = require("telescope.sorters").empty(),
        }):find()
      end

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
        live_multigrep,
				-- require("telescope.builtin").live_grep,
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
