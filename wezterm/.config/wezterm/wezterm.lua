-- wezterm.lua
local wezterm = require 'wezterm';
local config = {}

config.color_scheme = 'rose-pine'
config.font = wezterm.font('JetBrains Mono', { weight = 'Bold', italic = false })
config.font_size = 14.0


-- keybinds
config.keys = {
  {
    key = 'r',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ReloadConfiguration,
  },
  {
    key = 'd',
    mods = 'CMD',
    action = wezterm.action.SplitHorizontal,
  },
  {
    key = 'd',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical,
  },
  {
    key = 'k',
    mods = 'CMD',
    action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
  },
}

-- tabs
config.hide_tab_bar_if_only_one_tab = true

config.audible_bell = "Disabled"
return config
