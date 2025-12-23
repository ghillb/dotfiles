local wezterm = require("wezterm")
local config = {}

config.font = wezterm.font_with_fallback {
  'Cascadia Code',
  'JetBrains Mono',
}
config.font_size = 12
-- config.color_scheme = "Bamboo"
config.color_scheme = 'GruvboxDarkHard'
if wezterm.target_triple:find("windows") then
  config.default_prog = {"powershell.exe", "-NoLogo"}
end
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
  {
    key = 'v',
    mods = 'CTRL',
    action = wezterm.action.PasteFrom('Clipboard'),
  },
  {
    key = 's',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SpawnCommandInNewTab {
      args = { 'wsl.exe', 'bash', '-c', 'SKIP_AUTO_TMUX=1 exec bash -ic sshsel' },
      domain = { DomainName = 'local' },
    },
  },
  {
    key = '[',
    mods = 'CTRL|ALT',
    action = wezterm.action.SendKey { key = '[', mods = 'CTRL|ALT' },
  },
  {
    key = ']',
    mods = 'CTRL|ALT',
    action = wezterm.action.SendKey { key = ']', mods = 'CTRL|ALT' },
  },
}

wezterm.on('format-window-title', function(tab, pane)
  return 'tty'
end)

wezterm.on('window-config-reloaded', function(window, pane)
  window:toast_notification('WezTerm', 'Config reloaded!', nil, 4000)
end)

return config
