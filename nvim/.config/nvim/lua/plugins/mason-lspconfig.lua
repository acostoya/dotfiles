return {
  "mason-org/mason-lspconfig.nvim",
	dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
	},
	opts = {
		ensure_installed = {
			-- Lua
			"lua_ls",
			-- Python
			"ruff",
			"pyright",
			-- YAML
			"yamlls",
			-- JSON
			"jsonls",
		}
	}
}
