local packer_opts = {
  -- "lewis6991/satellite.nvim",
  "petertriho/nvim-scrollbar",
  config = function()
    local ok, scrollbar = pcall(require, "scrollbar") --satellite
    if not ok then
      return
    end

    local config = {
      excluded_buftypes = {
        "terminal",
        "nofile"
      },
    }

    scrollbar.setup(config)

    require("scrollbar.handlers.gitsigns").setup()
  end,
}
return packer_opts
