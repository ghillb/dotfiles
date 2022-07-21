local packer_opts = {
  "fgheng/winbar.nvim",
  disable = vim.env.NVIM_EMBEDDED == "true",
  config = function()
    local ok, winbar = pcall(require, "winbar")
    if not ok then
      return
    end

    winbar.setup({
      enabled = true,
      show_file_path = true,
      show_symbols = true,

      colors = {
        path = _G.palette.magenta,
        file_name = _G.palette.aqua,
        symbols = "",
      },

      icons = {
        file_icon_default = "",
        seperator = "",
        editor_state = "●",
        lock_icon = "",
      },

      exclude_filetype = {
        "git",
        "fugitive",
        "alpha",
        "packer",
        "neo-tree",
        "Trouble",
        "spectre_panel",
        "terminal",
        "neoterm",
        "qf",
      },
    })
  end,
}
return packer_opts
