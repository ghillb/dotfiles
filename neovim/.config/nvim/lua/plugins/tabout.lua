local packer_opts = {
  "abecodes/tabout.nvim",
  wants = { "nvim-treesitter" },
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
      wants = { "nvim-treesitter" },
      after = { "nvim-cmp" },
    }

    tabout.setup(config)
  end,
}
return packer_opts
