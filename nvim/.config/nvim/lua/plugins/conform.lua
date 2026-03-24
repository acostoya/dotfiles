return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_organize_imports", "ruff_format", "ruff_fix" },
			yaml = { "yamlfmt" },
			json = { "prettier" },
		},
	},
	keys = {
		{
			"<leader>gf",
			function()
				require("conform").format()
			end,
		},
	},
}
