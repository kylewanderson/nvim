local opt = vim.opt;

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = -1
opt.foldenable = true
