local packer_opts = {
  "rafcamlet/nvim-luapad",
  config = function()
    local ok, luapad = pcall(require, "luapad")
    if not ok then
      return
    end

    local config = {
      count_limit = 150000,
      error_indicator = false,
      eval_on_move = true,
      error_highlight = "WarningMsg",
      on_init = function()
        print("Luapad initialized!")
      end,
      context = {},
    }
    luapad.setup(config)
  end,
}
return packer_opts
