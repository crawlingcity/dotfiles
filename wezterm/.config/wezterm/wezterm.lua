-- wezterm.lua
local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

-- OS detection
local is_windows = wezterm.target_triple:find("windows") ~= nil

-- On Mac:     SUPER = 'CMD',  pane_nav = 'CMD|ALT',  tmux_nav = 'CMD|CTRL',  link_mod = 'CMD'
-- On Windows: SUPER = 'ALT', pane_nav = 'ALT|SHIFT', tmux_nav = 'ALT|CTRL', link_mod = 'CTRL'
local SUPER    = is_windows and 'ALT'       or 'CMD'
local PANE_NAV = is_windows and 'ALT|SHIFT' or 'CMD|ALT'
local TMUX_NAV = is_windows and 'ALT|CTRL'  or 'CMD|CTRL'
local LINK_MOD = is_windows and 'CTRL'      or 'CMD'

local function shell_args()
  if is_windows then
    return { 'pwsh.exe', '-NoLogo' }
    -- alternatives:
    -- Git Bash: { 'C:/Program Files/Git/bin/bash.exe', '-l' }
    -- WSL:      { 'wsl.exe', '--cd', '~' }
  else
    return { os.getenv("SHELL") }
  end
end

config.default_prog = shell_args()

config.color_scheme = 'nord'
config.font = wezterm.font('JetBrains Mono', { weight = 'Bold', italic = false })
config.font_size = is_windows and 12.0 or 14.0

-- keybinds
config.keys = {
  {
    key = 'r',
    mods = SUPER .. '|SHIFT',
    action = act.ReloadConfiguration,
  },
  {
    key = 'd',
    mods = SUPER,
    action = act.SplitHorizontal {
      domain = "CurrentPaneDomain",
    },
  },
  {
    key = 'd',
    mods = SUPER .. '|SHIFT',
    action = act.SplitVertical {
      domain = "CurrentPaneDomain",
    },
  },
  {
    key = 'k',
    mods = SUPER,
    action = act.ClearScrollback 'ScrollbackAndViewport',
  },
  -- home / end
  {
    key = 'LeftArrow',
    mods = SUPER,
    action = act.SendKey { key = 'Home' },
  },
  {
    key = 'RightArrow',
    mods = SUPER,
    action = act.SendKey { key = 'End' },
  },
  -- moving around wezterm panes
  { key = 'UpArrow',    mods = PANE_NAV, action = act{ ActivatePaneDirection = "Up"    } },
  { key = 'DownArrow',  mods = PANE_NAV, action = act{ ActivatePaneDirection = "Down"  } },
  { key = 'LeftArrow',  mods = PANE_NAV, action = act{ ActivatePaneDirection = "Left"  } },
  { key = 'RightArrow', mods = PANE_NAV, action = act{ ActivatePaneDirection = "Right" } },
  -- moving around tmux panes
  {
    key = 'UpArrow', mods = TMUX_NAV,
    action = act.Multiple {
      act.SendKey { key = "a", mods = "CTRL" },
      act.SendKey { key = "UpArrow" },
    },
  },
  {
    key = 'DownArrow', mods = TMUX_NAV,
    action = act.Multiple {
      act.SendKey { key = "a", mods = "CTRL" },
      act.SendKey { key = "DownArrow" },
    },
  },
  {
    key = 'LeftArrow', mods = TMUX_NAV,
    action = act.Multiple {
      act.SendKey { key = "a", mods = "CTRL" },
      act.SendKey { key = "LeftArrow" },
    },
  },
  {
    key = 'RightArrow', mods = TMUX_NAV,
    action = act.Multiple {
      act.SendKey { key = "a", mods = "CTRL" },
      act.SendKey { key = "RightArrow" },
    },
  },
  {
    key = 'Enter',
    mods = SUPER .. '|SHIFT',
    action = wezterm.action.TogglePaneZoomState,
  },
}

-- Windows-only keybinds
if is_windows then
  table.insert(config.keys, {
    key = 'c', mods = 'CTRL',
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ''
      if has_selection then
        window:perform_action(act.CopyTo 'ClipboardAndPrimarySelection', pane)
      else
        window:perform_action(act.SendKey { key = 'c', mods = 'CTRL' }, pane)
      end
    end),
  })
  table.insert(config.keys, { key = 'v', mods = 'CTRL', action = act.PasteFrom 'Clipboard' })
  table.insert(config.keys, { key = 'w', mods = 'CTRL', action = act.CloseCurrentPane { confirm = false } })
  table.insert(config.keys, { key = 'd', mods = 'CTRL', action = act.CloseCurrentPane { confirm = false } })
end

-- tabs
config.window_decorations = is_windows and "TITLE|RESIZE" or "RESIZE"
config.hide_tab_bar_if_only_one_tab = false
config.audible_bell = "Disabled"
config.window_frame = {
  font = wezterm.font { family = 'Roboto', weight = 'Bold' },
  font_size = 12.0,
  active_titlebar_bg = '#20232c',
  inactive_titlebar_bg = '#20232c',
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
    [93]  = '#aabbff',
    [129] = '#aabbff',
    [135] = '#aabbff',
  },
  tab_bar = {
    inactive_tab_edge = '#20232c',
  },
}

config.inactive_pane_hsb = {
  saturation = 0.5,
  brightness = 0.6,
}

-- mouse
config.mouse_bindings = {
  -- single click only selects text
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelection 'ClipboardAndPrimarySelection',
  },
  -- CMD+click (Mac) / CTRL+click (Windows) opens hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = LINK_MOD,
    action = act.OpenLinkAtMouseCursor,
  },
}

-- bar
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
bar.apply_to_config(config)

-- ensure bar plugin doesn't hide the tab bar
config.hide_tab_bar_if_only_one_tab = false

return config
