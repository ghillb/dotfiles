local packer_opts = {
  "windwp/nvim-autopairs",
  config = function()
    if vim.env.NVIM_INIT then return end
    local autopairs = require("nvim-autopairs")

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
