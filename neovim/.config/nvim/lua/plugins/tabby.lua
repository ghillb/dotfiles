local packer_opts = {
  "nanozuki/tabby.nvim",
  config = function()
    if vim.env.NVIM_INIT then
      return
    end
    local tabby = require("tabby")
    local util = require("tabby.util")
    local filename = require("tabby.filename")
    local hl_tabline = util.extract_nvim_hl("TabLine")
    local hl_tabline_sel = util.extract_nvim_hl("TabLineSel")

    local function tab_label(tabid, active)
      local icon = active and "" or ""
      local number = vim.api.nvim_tabpage_get_number(tabid)
      return string.format(" %s %d ", icon, number)
    end

    local function win_label(winid, top)
      local icon = top and "●" or ""
      return string.format(" %s %s ", icon, filename.unique(winid))
    end

    local tabline = {
      hl = "TabLineFill",
      layout = "active_wins_at_tail",
      active_tab = {
        label = function(tabid)
          return {
            tab_label(tabid, true),
            hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = "bold" },
          }
        end,
        left_sep = { "", hl = { fg = hl_tabline_sel.bg, bg = "NONE" } },
        right_sep = { "", hl = { fg = hl_tabline_sel.bg, bg = "NONE" } },
      },
      inactive_tab = {
        label = function(tabid)
          return {
            tab_label(tabid),
            hl = { fg = hl_tabline.fg, bg = "NONE", style = "bold" },
          }
        end,
        left_sep = { " ", hl = { fg = "NONE", bg = "NONE" } },
        right_sep = { " ", hl = { fg = "NONE", bg = "NONE" } },
      },
      top_win = {
        label = function(winid)
          return {
            win_label(winid, true),
          }
        end,
        left_sep = { " ", hl = { fg = "NONE", bg = "NONE" } },
        right_sep = { " ", hl = { fg = "NONE", bg = "NONE" } },
      },
      win = {
        label = function(winid)
          return {
            win_label(winid),
          }
        end,
        left_sep = { " ", hl = { fg = "NONE", bg = "NONE" } },
        right_sep = { " ", hl = { fg = "NONE", bg = "NONE" } },
      },
    }

    tabby.setup({ tabline = tabline })
  end,
}
return packer_opts
