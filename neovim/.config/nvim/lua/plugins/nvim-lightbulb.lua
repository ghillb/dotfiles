local packer_opts = {
  "kosayoda/nvim-lightbulb",
  config = function()
    local ok, lightbulb = pcall(require, "nvim-lightbulb")
    if not ok then
      return
    end

    local lightbulb_sign = "" --

    vim.fn.sign_define("LightBulbSign", { text = lightbulb_sign, texthl = "", linehl = "", numhl = "" })

    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      callback = function()
        lightbulb.update_lightbulb()
      end,
    })

    local config = {
      ignore = { ft = {"null-ls"} },
      sign = {
        enabled = false,
        priority = 15,
      },
      float = {
        enabled = false,
        text = lightbulb_sign,
        win_opts = {},
      },
      virtual_text = {
        enabled = false,
        text = lightbulb_sign,
        hl_mode = "replace",
      },
      status_text = {
        enabled = true,
        text = lightbulb_sign,
        text_unavailable = "",
      },
    }

    lightbulb.setup(config)
  end,
}
return packer_opts
