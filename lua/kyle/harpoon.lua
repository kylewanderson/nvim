return {
	'ThePrimeagen/harpoon',
	config = function ()
		vim.keymap.set("n", "<leader>ha", ":lua require('harpoon.mark').add_file()<CR>", {silent = true})
		vim.keymap.set("n", "<leader>ho", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", {silent = true})
		vim.keymap.set("n", "<leader>hn", ":lua require('harpoon.ui').nav_next()<CR>", {silent = true})
		vim.keymap.set("n", "<leader>hp", ":lua require('harpoon.ui').nav_prev()<CR>", {silent = true})
	end
}
