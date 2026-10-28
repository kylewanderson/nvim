-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local lspConfig = function()
  local on_attach = require("kyle.lsp-on-attach")

  -- Enable the following language servers
  local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    ts_ls = {
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
    angularls = {},
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

  -- merge in blink.cmp's completion capabilities
  capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

  -- Setup mason so it can manage external tooling
  require("mason").setup()

  -- Configure each server via vim.lsp.config() instead of setup_handlers
  for server_name, server_opts in pairs(servers) do
    vim.lsp.config(server_name, vim.tbl_deep_extend("force", server_opts, {
      capabilities = capabilities,
      on_attach = on_attach,
    }))
  end

  -- Ensure the servers above are installed, and auto-enable them
  local mason_lspconfig = require("mason-lspconfig")
  mason_lspconfig.setup({
    ensure_installed = vim.tbl_keys(servers),
    automatic_enable = true, -- calls vim.lsp.enable() for installed servers (this is also the default)
  })

  -- fold handler function for nvim-ufo
  local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    -- local suffix = ('  %d '):format(endLnum - lnum)
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
