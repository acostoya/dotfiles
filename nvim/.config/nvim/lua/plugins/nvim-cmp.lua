return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
	},
	config = function()
		local cmp = require("cmp")
		local border = {
			{ "╭", "CmpBorder" },
			{ "─", "CmpBorder" },
			{ "╮", "CmpBorder" },
			{ "│", "CmpBorder" },
			{ "╯", "CmpBorder" },
			{ "─", "CmpBorder" },
			{ "╰", "CmpBorder" },
			{ "│", "CmpBorder" },
		}
		cmp.setup({
			mapping = cmp.mapping.preset.insert(),
			window = {
				completion = {
					border = border,
				},
				documentation = {
					border = border,
				},
			},
			sources = {
				{ name = "nvim_lsp" },
				{ name = "buffer" },
			},
		})
	end,
}
