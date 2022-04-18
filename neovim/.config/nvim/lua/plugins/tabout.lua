local packer_opts = {
  "abecodes/tabout.nvim",
  wants = { "nvim-treesitter" },
  after = { "nvim-cmp" },
  config = function()
    local ok, tabout = pcall(require, "tabout")
    if not ok then
      return
    end

    local config = {
      tabkey = "",
      backwards_tabkey = "",
      act_as_tab = true,
      act_as_shift_tab = true,
      enable_backwards = true,
      completion = false,
      default_tab = "<c-t>",
      default_shift_tab = "<c-d>",
      tabouts = {
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = "`", close = "`" },
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
      },
      ignore_beginning = true,
      exclude = {},
    }
    tabout.setup(config)
  end,
}
return packer_opts
