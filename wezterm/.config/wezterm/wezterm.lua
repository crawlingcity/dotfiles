-- wezterm.lua
local wezterm = require 'wezterm';
local act = wezterm.action
local config = {}

config.color_scheme = 'nord'
config.font = wezterm.font('JetBrains Mono', { weight = 'Bold', italic = false })
config.font_size = 14.0

-- keybinds
config.keys = {
  {
    key = 'r',
    mods = 'CMD|SHIFT',
    action = act.ReloadConfiguration,
  },
  {
    key = 'd',
    mods = 'CMD',
    action = act.SplitHorizontal {
      domain = "CurrentPaneDomain",
      args = { os.getenv("SHELL") },
    }
  },
  {
    key = 'd',
    mods = 'CMD|SHIFT',
    action = act.SplitVertical {
      domain = "CurrentPaneDomain",
      args = { os.getenv("SHELL") },
    },
  },
  {
    key = 'k',
    mods = 'CMD',
    action = act.ClearScrollback 'ScrollbackAndViewport',
  },
  -- home / end
  {
    key = 'LeftArrow',
    mods = 'CMD',
    action = act.SendKey { key = 'Home' },
  },
  {
    key = 'RightArrow',
    mods = 'CMD',
    action = act.SendKey { key = 'End' },
  },
  -- moving around
  {
    key = 'UpArrow',
    mods = 'CMD|ALT',
    action = act{ ActivatePaneDirection="Up" }
  },
  {
    key = 'DownArrow',
    mods = 'CMD|ALT',
    action = act{ ActivatePaneDirection="Down" }
  },
  {
    key = 'LeftArrow',
    mods = 'CMD|ALT',
    action = act{ ActivatePaneDirection="Left" }
  },
  {
    key = 'RightArrow',
    mods = 'CMD|ALT',
    action = act{ ActivatePaneDirection="Right" }
  },
  -- moving around tmux edition
  {
    key = 'UpArrow',
    mods = 'CMD|CTRL',
    action = act.Multiple {
      act.SendKey { key = "a", mods = "CTRL" },
      act.SendKey { key = "UpArrow" },
    },
  },
  {
    key = 'DownArrow',
    mods = 'CMD|CTRL',
    action = act.Multiple {
      act.SendKey { key = "a", mods = "CTRL" },
      act.SendKey { key = "DownArrow" },
    },
  },
  {
    key = 'LeftArrow',
    mods = 'CMD|CTRL',
    action = act.Multiple {
      act.SendKey { key = "a", mods = "CTRL" },
      act.SendKey { key = "LeftArrow" },
    },
  },
  {
    key = 'RightArrow',
    mods = 'CMD|CTRL',
    action = act.Multiple {
      act.SendKey { key = "a", mods = "CTRL" },
      act.SendKey { key = "RightArrow" },
    },
  },
  {
    key = 'Enter',
    mods = 'CMD|SHIFT',
    action = wezterm.action.TogglePaneZoomState,
  },
}

-- tabs
-- config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = false
config.audible_bell = "Disabled"
config.window_frame = {
  font = wezterm.font { family = 'Roboto', weight = 'Bold' },
  font_size = 12.0,
  active_titlebar_bg = '#20232c',
  inactive_titlebar_bg = '#20232c',
}

config.colors = {
  tab_bar = {
    inactive_tab_edge = '#20232c',
  },
}

-- colors
config.colors = {
  foreground = '#d9dde7',
  background = '#20232c',
  ansi = {
    '#3c4150',
    '#b2656b',
    '#a8bd90',
    '#e5cc93',
    '#87a0be',
    '#ae8fab',
    '#93becd',
    '#e5e8ef',
  },
  brights = {
    '#4d5568',
    '#b2656b',
    '#a8bd90',
    '#e5cc93',
    '#87a0be',
    '#ae8fab',
    '#98baba',
    '#eceef3',
  },
  indexed = {
    [93] = '#aabbff',   -- Common purple in 256-color palette
    [129] = '#aabbff',  -- Another purple shade
    [135] = '#aabbff',  -- Yet another purple
  },
}

config.inactive_pane_hsb = {
  saturation = 0.5,
  brightness = 0.6,
}

-- mouse
config.mouse_bindings = {
  -- Change the default click behavior so that it only selects
  -- text and doesn't open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelection 'ClipboardAndPrimarySelection',
  },

  -- and make CTRL-Click open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = act.OpenLinkAtMouseCursor,
  },
  -- NOTE that binding only the 'Up' event can give unexpected behaviors.
  -- Read more below on the gotcha of binding an 'Up' event only.
}

-- bar
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
bar.apply_to_config(config)

return config
