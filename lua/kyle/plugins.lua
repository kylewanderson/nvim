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
  require('kyle.mini'),
  require('kyle.snacks'),
	require("kyle.themes"),
	-- require("kyle.tabnine"),
  require("kyle.avante"),
	require("kyle.toggleterm"),
	require("kyle.lualine"),
	require("kyle.comments"),
	require("kyle.formatting"),
	require("kyle.telescope"),
	require("kyle.git-configs"),
	require("kyle.treesitter"),
	require("kyle.lsp"),
	require("kyle.fun"),
  require("kyle.blink-cmp"),
  require("kyle.nvim-scissors"),
	require("kyle.flutter-tools"),
	require("kyle.oil"),
	require("kyle.colorizer"),
	require("kyle.harpoon"),
	require("kyle.nvim-bqf"),
	require("kyle.treesj"),
	require("kyle.trouble"),

	{ "folke/which-key.nvim", opts = {} },
}, {})
