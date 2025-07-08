-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
-- Fix for Hyprland
config.enable_wayland = false

-- Color scheme
config.color_scheme = 'tokyonight' --'Batman' 'AdventureTime'

-- Font
config.font = wezterm.font("JetBrains Mono", {weight="Regular", stretch="Normal", style="Normal"})

-- Enable scroll to prompt - https://wezterm.org/config/lua/keyassignment/ScrollToPrompt.html
local act = wezterm.action
config.keys = {
  { key = 'UpArrow', mods = 'SHIFT', action = act.ScrollToPrompt(-1) },
  { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollToPrompt(1) },
}

-- triple-left-click mouse action is set to automatically select the entire command output
config.mouse_bindings = {
  {
    event = { Down = { streak = 3, button = 'Left' } },
    action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
    mods = 'NONE',
  },
}

-- and finally, return the configuration to wezterm
return config
