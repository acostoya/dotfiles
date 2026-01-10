return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "ruff", "jsonls", "yamlls" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })
      lspconfig.pyright.setup({
        capabilities = capabilities,
        settings = {
          python = {
            pythonPath = vim.fn.exepath("./.venv/bin/python"),
          },
        },
      })
      lspconfig.ruff.setup({
        capabilities = capabilities,
        init_options = {
          settings = {
            lineLength = 79,
          },
        },
      })
      lspconfig.jsonls.setup({
        capabilities = capabilities,
      })
      lspconfig.yamlls.setup({
        capabilities = capabilities,
      })
    end,
  },
}
