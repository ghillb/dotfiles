local ok, tabby = pcall(require, "tabby")
if not ok then
  return
end
local util = require("tabby.util")
local filename = require("tabby.filename")
local hl_tabline = util.extract_nvim_hl("TabLine")
local hl_tabline_sel = util.extract_nvim_hl("TabLineSel")
local hl_tabline_fill = util.extract_nvim_hl("TabLineFill")

local function tab_label(tabid, active)
  local icon = active and "" or ""
  local number = vim.api.nvim_tabpage_get_number(tabid)
  return string.format(" %s %d ", icon, number )
end

local function win_label(winid, top)
  local icon = top and "●" or ""
  return string.format(" %s %s ", icon, filename.unique(winid))
end

---@type table<TabbyTablineLayout, TabbyTablineOpt>
local tabline = {
  hl = "TabLineFill",
  layout = "active_wins_at_tail",
  head = {
    { " ", hl = { fg = hl_tabline.fg, bg = hl_tabline.bg } },
    { "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
  },
  active_tab = {
    label = function(tabid)
      return {
        tab_label(tabid, true),
        hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = "bold" },
      }
    end,
    left_sep = { "", hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
    right_sep = { "", hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
  },
  inactive_tab = {
    label = function(tabid)
      return {
        tab_label(tabid),
        hl = { fg = hl_tabline.fg, bg = hl_tabline.bg, style = "bold" },
      }
    end,
    left_sep = { "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
    right_sep = { "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
  },
  top_win = {
    label = function(winid)
      return {
        win_label(winid, true),
        hl = "TabLine",
      }
    end,
    left_sep = { "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
    right_sep = { "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
  },
  win = {
    label = function(winid)
      return {
        win_label(winid),
        hl = "TabLine",
      }
    end,
    left_sep = { "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
    right_sep = { "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
  },
  tail = {
    { "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
    { " ", hl = { fg = hl_tabline.fg, bg = hl_tabline.bg } },
  },
}

tabby.setup({ tabline = tabline })

