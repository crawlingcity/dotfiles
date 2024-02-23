-- wezterm.lua
local wezterm = require 'wezterm';
local config = {}

config.color_scheme = 'Nord'

config.keys = {
  {
    key = 'r',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ReloadConfiguration,
  },
}

return config
