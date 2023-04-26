vim.api.nvim_create_autocmd("BufWinEnter", {
	callback = function(_)
		-- this line will disble auto commenting
		-- vim.cmd("set fo-=c fo-=r fo-=o")

		-- this line will disble the auto commenting on o and O
		vim.cmd("set fo-=o")
	end,
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"},
	{
		pattern = { "Jenkinsfile*" },
		callback = function(_)
			vim.cmd("set filetype=groovy")
		end
	})

vim.api.nvim_create_autocmd("FileType",
	{
		pattern = { "markdown.mdx" },
		callback = function(_)
			vim.cmd("set filetype=jsx")
		end
	})
