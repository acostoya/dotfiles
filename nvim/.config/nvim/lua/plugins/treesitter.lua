return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup()
    
    -- Install parsers
    vim.cmd("TSInstall lua python javascript html")
    
    -- Enable treesitter-based highlighting and indentation (now native in nvim 0.11+)
    vim.treesitter.language.register("python", "python")
  end,
}
