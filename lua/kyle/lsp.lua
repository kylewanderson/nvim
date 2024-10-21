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
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}

	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
	local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
	-- for _, ls in ipairs(language_servers) do
	-- 	require('lspconfig')[ls].setup({
	-- 		capabilities = capabilities
	-- 		-- you can add other fields for setting up lsp server in this table
	-- 	})
	-- end

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
local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    -- local suffix = ('  %d '):format(endLnum - lnum)
    local suffix = (' %d Lines '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, {chunkText, hlGroup})
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, {suffix, 'MoreMsg'})
    return newVirtText
end

-- global handler
-- `handler` is the 2nd parameter of `setFoldVirtTextHandler`,
-- check out `./lua/ufo.lua` and search `setFoldVirtTextHandler` for detail.
require('ufo').setup({
    fold_virt_text_handler = handler
})

-- buffer scope handler
-- will override global handler if it is existed
-- local bufnr = vim.api.nvim_get_current_buf()
-- require('ufo').setFoldVirtTextHandler(bufnr, handler)
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
			{ "j-hui/fidget.nvim", tag = 'legacy', opts = {} },

			-- Additional lua configuration, makes nvim stuff amazing!
			"folke/neodev.nvim",
		},
		config = lspConfig,
	},
	{
		"rmagatti/goto-preview",
		config = function()
			require("goto-preview").setup({
				default_mappings = true,
				width = 120,
				height = 30,
			})
		end,
	},
	{
		"kevinhwang91/promise-async"
	},
	{
		"kevinhwang91/nvim-ufo",
		requires = "kevinhwang91/promise-async",
		config = function()
			vim.keymap.set("n", "zR", require("ufo").openAllFolds)
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
		end,
}
}
