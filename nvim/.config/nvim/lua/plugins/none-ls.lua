return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        -- Lua
        null_ls.builtins.formatting.stylua,
        -- Python
        null_ls.builtins.formatting.isort,
        -- JSON
        null_ls.builtins.formatting.prettierd,
        -- YAML
        null_ls.builtins.formatting.yamlfmt.with({
          extra_args = { "--formatter", "retain_line_breaks=true" },
        }),
      },
    })

    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
  end,
}
