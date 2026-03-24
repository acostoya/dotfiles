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
		-- Lua
		vim.lsp.config("lua_ls", {})
		-- Python
		vim.lsp.config("ruff", {})
		vim.lsp.config("pyright", {
			settings = {
				python = {
					pythonPath = find_python_venv(),
				},
			},
		})
		-- YAML
		vim.lsp.config("yamlls", {})
		-- JSON
		vim.lsp.config("jsonls", {})

		-- Keymaps
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
	end,
}
