local wezterm = require("wezterm")
local config = {}

config.font = wezterm.font 'Cascadia Code'
config.font_size = 12
-- config.color_scheme = "Bamboo"
config.color_scheme = 'GruvboxDarkHard'
config.default_prog = {"powershell.exe", "-NoLogo"}
config.hide_tab_bar_if_only_one_tab = true

config.keys = {
  {
    key = 'Backspace',
    mods = 'CTRL',
    action = wezterm.action.SendKey { key = 'w', mods = 'CTRL' },
  },
  {
    key = 'F11',
    action = wezterm.action.ToggleFullScreen,
  },
  {
    key = 't',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ShowLauncher,
  },
  {
    key = '\\',
    mods = 'CTRL|ALT',
    action = wezterm.action.SendKey { key = '\\', mods = 'CTRL|ALT' },
  },
  {
    key = 'c',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CopyTo('Clipboard'),
  },
}

wezterm.on('format-window-title', function(tab, pane)
  return 'tty'
end)

wezterm.on('window-config-reloaded', function(window, pane)
  window:toast_notification('WezTerm', 'Configuration reloaded!', nil, 4000)
end)

return config
