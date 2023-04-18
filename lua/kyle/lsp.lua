-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local lspConfig = function()
	local on_attach = require("kyle.lsp-on-attach")

	-- Enable the following language servers
	--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
	--
	--  Add any additional override configuration in the following tables. They will be passed to
	--  the `settings` field of the server config. You must look up that documentation yourself.
	local servers = {
		-- clangd = {},
		-- gopls = {},
		-- pyright = {},
		-- rust_analyzer = {},
		tsserver = {
			settings = {
				javascript = {
					-- preferences = {
					--   quoteStyle = 'single',
					-- },
					-- implicitProjectConfig = {
					--   checkJs = true,
					-- },
				},
				typescript = {
					-- preferences = {
					--   quoteStyle = 'single',
					-- },
					-- implicitProjectConfig = {
					--   checkJs = true,
					-- },
				},
			},
		},
		lua_ls = {
			Lua = {
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
			},
		},
		cssls = {},
		html = {},
		jsonls = {},
		yamlls = {},
	}

	-- Setup neovim lua configuration
	require("neodev").setup()

	-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

	-- Setup mason so it can manage external tooling
	require("mason").setup()

	-- Ensure the servers above are installed
	local mason_lspconfig = require("mason-lspconfig")

	mason_lspconfig.setup({
		ensure_installed = vim.tbl_keys(servers),
	})

	mason_lspconfig.setup_handlers({
		function(server_name)
			require("lspconfig")[server_name].setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = servers[server_name],
			})
		end,
	})
end

return {
	{
		-- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ "j-hui/fidget.nvim", opts = {} },

			-- Additional lua configuration, makes nvim stuff amazing!
			"folke/neodev.nvim",
		},
		config = lspConfig,
	},
}
