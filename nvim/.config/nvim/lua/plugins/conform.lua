return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_organize_imports", "ruff_format", "ruff_fix" },
			r = { "air" },
			yaml = { "yamlfmt" },
			json = { "prettier" },
		},
		formatters = {
			yamlfmt = {
				prepend_args = { "-formatter", "retain_line_breaks_single=true" },
			},
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
