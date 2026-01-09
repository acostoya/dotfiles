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
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      
      -- lua_ls
      vim.lsp.config.lua_ls = {
        cmd = { "lua-language-server" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
        capabilities = capabilities,
      }
      
      -- pyright
      vim.lsp.config.pyright = {
        cmd = { "pyright-langserver", "--stdio" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
        capabilities = capabilities,
        settings = {
          python = {
            pythonPath = vim.fn.exepath("./.venv/bin/python"),
          },
        },
      }
      
      -- ruff
      vim.lsp.config.ruff = {
        cmd = { "ruff", "server" },
        root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
        capabilities = capabilities,
        init_options = {
          settings = {
            lineLength = 79,
          },
        },
      }
      
      -- jsonls
      vim.lsp.config.jsonls = {
        cmd = { "vscode-json-language-server", "--stdio" },
        root_markers = { "package.json", ".git" },
        capabilities = capabilities,
      }
      
      -- yamlls
      vim.lsp.config.yamlls = {
        cmd = { "yaml-language-server", "--stdio" },
        root_markers = { ".git" },
        capabilities = capabilities,
      }
      
      -- Enable LSP servers
      vim.lsp.enable({ "lua_ls", "pyright", "ruff", "jsonls", "yamlls" })
    end,
  },
}
