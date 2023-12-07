-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"-c",
		"http.sslVerify=false",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	require("kyle.themes"),
	-- require("kyle.copilot"),
	-- require("kyle.tabnine"),
	require("kyle.toggleterm"),
	require("kyle.lualine"),
	require("kyle.comments"),
	require("kyle.formatting"),
	require("kyle.telescope"),
	require("kyle.git-configs"),
	-- require("kyle.treesitter"),
	require("kyle.treesitternew"),
	require("kyle.lsp"),
	require("kyle.fun"),
	require("kyle.newsnip"),
	require("kyle.flutter-tools"),
	require("kyle.oil"),
	require("kyle.colorizer"),
	require("kyle.harpoon"),
	require("kyle.nvim-bqf"),
	-- require("kyle.treesj"),
	require("kyle.nvim-surround"),
	require("kyle.trouble"),

	-- Navigation
	--
	-- "tpope/vim-vinegar",

	-- NOTE: This is where your plugins related to LSP can be installed.
	--  The configuration is done below. Search for lspconfig to find it below.
	-- Useful plugin to show you pending keybinds.
	{ "folke/which-key.nvim", opts = {} },
}, {})

