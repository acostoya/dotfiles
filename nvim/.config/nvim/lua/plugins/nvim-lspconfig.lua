local function find_python_venv()
	local cwd = vim.fn.getcwd()
	local dir = cwd

	while dir ~= "/" do
		local venv_python = dir .. "/.venv/bin/python"
		if vim.fn.filereadable(venv_python) == 1 then
			return venv_python
		end
		dir = vim.fn.fnamemodify(dir, ":h")
	end

	return "python"
end

return {
	"neovim/nvim-lspconfig",
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Lua
		vim.lsp.config("lua_ls", { capabilities = capabilities })
		-- Python
		vim.lsp.config("ruff", { capabilities = capabilities })
		vim.lsp.config("pyright", {
			capabilities = capabilities,
			settings = {
				python = {
					pythonPath = find_python_venv(),
				},
			},
		})
		-- YAML
		vim.lsp.config("yamlls", { capabilities = capabilities })
		-- JSON
		vim.lsp.config("jsonls", { capabilities = capabilities })

		-- Keymaps
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
	end,
}
