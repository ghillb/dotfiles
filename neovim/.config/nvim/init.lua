require("settings")
require("utils")
require("events")
require("plugins")
require("theme")
require("keymaps")

local ok, localrc = pcall(require, "localrc")
if ok then
  localrc.settings.load()
end
