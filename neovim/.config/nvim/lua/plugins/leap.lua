local packer_opts = {
  "ggandor/leap.nvim",
  disable = vim.env.NVIM_EMBEDDED == "true",
  requires = { "tpope/vim-repeat" },
  config = function()
    local ok, leap = pcall(require, "leap")
    if not ok then
      return
    end

    local config = {
      max_aot_targets = nil,
      highlight_unlabeled = false,
      case_sensitive = false,
      -- Sets of characters that should match each other.
      -- Obvious candidates are braces and quotes ('([{', ')]}', '`"\'').
      equivalence_classes = { " \t\r\n" },
      -- Leaving the appropriate list empty effectively disables "smart" mode,
      -- and forces auto-jump to be on or off.
      safe_labels = nil,
      labels = nil,
      -- These keys are captured directly by the plugin at runtime.
      -- (For `prev_match`, I suggest <s-enter> if possible in the terminal/GUI.)
      special_keys = {
        repeat_search = "<enter>",
        next_match = "<enter>",
        prev_match = "<tab>",
        next_group = "<space>",
        prev_group = "<tab>",
      },
    }

    leap.setup(config)
    leap.set_default_keymaps()
    -- vim.api.nvim_set_hl(0, "LeapBackdrop", { fg = "#707070" })
  end,
}
return packer_opts
