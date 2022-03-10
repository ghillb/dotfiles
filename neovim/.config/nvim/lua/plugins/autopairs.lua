local packer_opts = {
  "windwp/nvim-autopairs",
  config = function()
    local ok, autopairs = pcall(require, "nvim-autopairs")
    if not ok then
      return
    end

    local config = {
      disable_filetype = { "TelescopePrompt" },
      ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
      enable_moveright = true,
      enable_afterquote = true,
      enable_check_bracket_line = true,
      check_ts = true,
    }

    autopairs.setup(config)
  end,
}
return packer_opts
