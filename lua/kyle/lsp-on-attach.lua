	return function(_, bufnr)
		-- NOTE: Remember that lua is a real programming language, and as such it is possible
		-- to define small helper and utility functions so you don't have to repeat yourself
		-- many times.
		--
		-- In this case, we create a function that lets us more easily define mappings specific
		-- for LSP related items. It sets the mode, buffer and description for us each time.
		local nmap = function(keys, func, desc)
			if desc then
				desc = "LSP: " .. desc
			end

			vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
		end
		vim.api.nvim_create_autocmd("CursorHold", {
			buffer = bufnr,
			callback = function()
				local opts = {
					focusable = false,
					close_events = {
						"BufLeave",
						"CursorMoved",
						"InsertEnter",
						"FocusLost",
					},
					border = "rounded",
					source = "always",
					prefix = " ",
					scope = "cursor",
				}
				vim.diagnostic.open_float(nil, opts)
			end,
		})
		--[[ vim.lsp.handlers["textDocument/publishDiagnostics"] =
				vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
					hover = true,
					underline = true,
					virtual_text = true,
					signs = true,
					update_in_insert = false,
				}) ]]

		nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
		vim.keymap.set(
			"v",
			"<leader>ca",
			vim.lsp.buf.code_action,
			{ buffer = bufnr, desc = "[C]ode [A]ction" }
		)

		nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
		nmap(
			"gr",
      function ()
        require("telescope.builtin").lsp_references({
          fname_width = 1000
        })
      end,
			"[G]oto [R]eferences"
		)
		nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
		nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
		nmap(
			"<leader>ds",
			require("telescope.builtin").lsp_document_symbols,
			"[D]ocument [S]ymbols"
		)
		nmap(
			"<leader>ws",
			require("telescope.builtin").lsp_dynamic_workspace_symbols,
			"[W]orkspace [S]ymbols"
		)

		-- See `:help K` for why this keymap
		nmap("K", vim.lsp.buf.hover, "Hover Documentation")
		nmap("<C-q>", vim.lsp.buf.signature_help, "Signature Documentation")

		-- Lesser used LSP functionality
		nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
		nmap(
			"<leader>wa",
			vim.lsp.buf.add_workspace_folder,
			"[W]orkspace [A]dd Folder"
		)
		nmap(
			"<leader>wr",
			vim.lsp.buf.remove_workspace_folder,
			"[W]orkspace [R]emove Folder"
		)
		nmap("<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, "[W]orkspace [L]ist Folders")
		nmap("<leader>fd", vim.lsp.buf.format)

		-- Create a command `:Format` local to the LSP buffer
		vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
			vim.lsp.buf.format()
		end, { desc = "Format current buffer with LSP" })
	end
