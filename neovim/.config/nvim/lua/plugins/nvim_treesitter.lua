return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  main = "nvim-treesitter.configs",
  opts = {
    auto_install = true,
    highlight = {
      enable = true,
    },
  },
}
