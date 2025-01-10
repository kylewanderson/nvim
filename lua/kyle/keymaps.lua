-- [[ Basic Keymaps ]]

-- Use k and j to traverse vertically through wrapped words
vim.keymap.set(
	"n",
	"k",
	"v:count == 0 ? 'gk' : 'k'",
	{ expr = true, silent = true }
)
vim.keymap.set(
	"n",
	"j",
	"v:count == 0 ? 'gj' : 'j'",
	{ expr = true, silent = true }
)
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
-- vim.keymap.set('t', '<C-a>', [[<C-\><C-n>]])
vim.keymap.set('t', '<esc><esc>', [[<C-\><C-n>]])
vim.keymap.set("n", "<leader>so", ":so $MYVIMRC<CR>")
vim.keymap.set("n", "<leader>ev", ":tabedit $MYVIMRC<CR>")
vim.keymap.set("n", "<leader>tq", ":tabclose<CR>")
vim.keymap.set("v", "<leader>d", "\"_d")

-- use J and K to move visually selected lines
-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Diagnostic keymaps
local diag_opts = {
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
vim.keymap.set(
	"n",
	"<leader>dk",
	vim.diagnostic.goto_prev,
	{ desc = "Go to previous diagnostic message" }
)
vim.keymap.set(
	"n",
	"<leader>dj",
	vim.diagnostic.goto_next,
	{ desc = "Go to next diagnostic message" }
)
vim.keymap.set(
	"n",
	"<leader>do",
  function()
    vim.diagnostic.open_float(nil, diag_opts)
  end,
	{ desc = "Open floating diagnostic message" }
)
vim.keymap.set(
	"n",
	"<leader>dl",
	vim.diagnostic.setloclist,
	{ desc = "Open diagnostics list" }
)
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "[q", ":cprev<CR>", { noremap = true })
vim.keymap.set("n", "]q", ":cnext<CR>", { noremap = true })
vim.keymap.set("n", "[b", ":bprevious<CR>", { noremap = true })
vim.keymap.set("n", "]b", ":bnext<CR>", { noremap = true })
vim.keymap.set("n", "<C-a>", "<C-^>", { noremap = true })
vim.keymap.set("i", "<C-j>", "<nop>", { noremap = true })
