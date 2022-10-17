local packer_opts = {
  "michaelb/sniprun",
  run = "bash ./install.sh",
  config = function()
    local ok, sniprun = pcall(require, "sniprun")
    if not ok then
      return
    end

    local config = {
      display = {
        -- "Classic",
        -- "VirtualTextOk",
        -- "VirtualTextErr",
        -- "TempFloatingWindow",
        -- "LongTempFloatingWindow",
        "Terminal",
        -- "TerminalWithCode",
        -- "NvimNotify",
        -- "Api"
      },
    }

    sniprun.setup(config)

    vim.keymap.set({ "n", "v" }, "<a-r>", "<Plug>SnipRun")
  end,
}
return packer_opts
