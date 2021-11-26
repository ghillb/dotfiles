local ok, alpha = pcall(require, 'alpha')
if not ok then
  return
end

local dashboard = require("alpha.themes.dashboard")
local fortune = require("alpha.fortune")

dashboard.section.header.val = {
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
}

dashboard.section.buttons.val = {
  dashboard.button( "r", "  > Recent files"   , ":Telescope oldfiles<cr>"),
  dashboard.button( "e", "  > Edit new"       , ":ene <BAR> startinsert <cr>"),
  dashboard.button( "p", "  > Projects"       , ":Telescope project<cr>"),
  dashboard.button( "u", "  > Update"         , ":PackerSync<cr>"),
  dashboard.button( "s", "  > Settings"       , ":e $VC/init.vim<cr>"),
  dashboard.button( "h", "?  > Help"           , ":h ref | wincmd o<cr>"),
  dashboard.button( "q", "  > Quit"           , ":bd<cr>"),
}

dashboard.section.footer.val = fortune()
alpha.setup(dashboard.opts)

