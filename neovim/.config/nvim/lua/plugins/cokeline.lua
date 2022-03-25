local packer_opts = {
  "noib3/nvim-cokeline",
  config = function()
    local ok, cokeline = pcall(require, "cokeline")
    if not ok then
      return
    end

    local get_hex = require("cokeline/utils").get_hex
    local config = {
      show_if_buffers_are_at_least = 1,
      buffers = {
        filter_valid = function(buffer)
          local winid_of_buffer = vim.fn.bufwinid(buffer.number)
          local tabid_of_buffer = vim.fn.win_id2tabwin(winid_of_buffer)[1]
          local current_tabid = vim.api.nvim_get_current_tabpage()
          return current_tabid == tabid_of_buffer
        end,
      },
      default_hl = {
        fg = function(buffer)
          return buffer.is_focused and get_hex("Normal", "fg") or get_hex("Comment", "fg")
        end,
        bg = function(buffer)
          return buffer.is_focused and get_hex("Visual", "bg") or get_hex("Normal", "bg")
        end,
      },
      components = {
        {
          text = function(buffer)
            return " " .. buffer.devicon.icon
          end,
          fg = function(buffer)
            return buffer.devicon.color
          end,
        },
        {
          text = function(buffer)
            return buffer.filename .. " "
          end,
        },
      },
      sidebar = {
        filetype = "NvimTree",
        components = {
          {
            text = " ",
            fg = get_hex("Normal", "fg"),
            bg = get_hex("Normal", "bg"),
            style = "bold",
          },
        },
      },
    }

    cokeline.setup(config)
  end,
}
return packer_opts
