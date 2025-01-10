return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- 'nvim-neotest/neotest-jest',
    "marilari88/neotest-vitest",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-vitest") {
          -- Filter directories when searching for test files. Useful in large projects (see Filter directories notes).
          filter_dir = function(name, rel_path, root)
            return name ~= "node_modules"
          end,
        },
        -- require('neotest-jest')({
        --   jestCommand = "npm test --",
        --   jestConfigFile = "custom.jest.config.ts",
        --   env = { CI = true },
        --   cwd = function(path)
        --     return vim.fn.getcwd()
        --   end,
        -- }),
      }
    })
    vim.keymap.set("n", "<leader>tt", ":Neotest run<CR>")
    -- vim.keymap.set("n", "<leader>T", ":TestFile<CR>")
  end,
}
