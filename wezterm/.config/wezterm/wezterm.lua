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
  {
    key = 'Enter',
    mods = 'SHIFT',
    action = wezterm.action { SendString = '\x1b\r' },
  },
  {
    key = 'v',
    mods = 'CTRL|ALT',
    action = wezterm.action_callback(function(window, pane)
      local handle = io.popen(os.getenv("HOME") .. "/.local/bin/clip2path 2>/dev/null")
      if handle then
        local result = handle:read("*a") or ""
        handle:close()
        if result ~= "" then
          pane:send_text(result)
        end
      end
    end),
  },
}

wezterm.on('format-window-title', function(tab, pane)
  return 'tty'
end)

local marker = os.getenv("HOME") .. "/.cache/wezterm-loaded"
local f = io.open(marker, "r")
local is_reload = f ~= nil
if f then f:close() end

io.open(marker, "w"):close()

local notified = false
wezterm.on('window-config-reloaded', function(window, pane)
  if is_reload and not notified then
    window:toast_notification('WezTerm', 'Config reloaded ✓', nil, 1000)
    notified = true
  end
end)

return config
