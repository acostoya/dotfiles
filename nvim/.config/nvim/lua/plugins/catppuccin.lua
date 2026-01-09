return {
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "macchiato",
      transparent_background = true,
      custom_highlights = function(colors)
        return {
          NormalFloat = { bg = "NONE" },
          FloatBorder = { bg = "NONE", fg = colors.blue },
        }
      end,
    })
    vim.cmd.colorscheme "catppuccin"
  end
}
