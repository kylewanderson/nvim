return {
	"chrisgrieser/nvim-scissors",
	dependencies = "nvim-telescope/telescope.nvim",
	opts = {
		snippetDir = "snippets",
	},
  config = function()
    require("blink.cmp").setup {
      sources = {
        providers = {
          snippets = {
            opts = {
              search_paths = { "snippets" },
            },
          }
        }
      }
    }
    vim.keymap.set(
      "n",
      "<leader>se",
      require("scissors").editSnippet,
      { desc = "Snippet: Edit" }
    )

    -- when used in visual mode, prefills the selection as snippet body
    vim.keymap.set(
      { "n", "x" },
      "<leader>sa",
      require("scissors").addNewSnippet,
      { desc = "Snippet: Add" }
    )
  end
}
