local packer_opts = {
  "akinsho/toggleterm.nvim",
  config = function()
    local ok, toggleterm = pcall(require, "toggleterm")
    if not ok then
      return
    end

    local config = {
      size = 20,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = false,
      shading_factor = 0,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = "bash",
      float_opts = {
        border = "single",
        winblend = 0,
        highlights = {
          border = "Border",
          background = "NONE",
        },
      },
    }

    toggleterm.setup(config)
  end,
}
return packer_opts
