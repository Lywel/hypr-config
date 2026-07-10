-- Plugin configuration (hy3, hyprfocus).
--
-- Both blocks live under the top-level `plugin` key. hl.config() walks the
-- table recursively, joining keys with '.', so this matches the legacy
-- `plugin:hy3:autotile:enabled` flat namespace exactly.
--
-- hyprfocus is now a first-party plugin in hyprwm/hyprland-plugins. Install:
--   hyprpm add https://github.com/hyprwm/hyprland-plugins
--   hyprpm enable hyprfocus
-- (hy3 is already managed via outfoxxed/hy3.)

hl.config({
  plugin = {
    hy3 = {
      -- autotile = {
      --   enabled = true,
      --   trigger_width = 855,
      --   trigger_height = 500,
      -- },
      -- no_gaps_when_only = 1,
      -- node_collapse_policy = 2,
      -- tab_first_window = false,
      -- tabs = {
      --   height = 1,
      --   from_top = true,
      --   render_text = false,
      -- },
    },
    dynamic_cursors = {
    },
  },
})
