-- Plugin configuration (hy3, hyprfocus).
--
-- TODO: VERIFY POST-UPGRADE.
-- The Lua API for plugin config blocks is not yet documented in the
-- Hyprland wiki at the time of writing. Best guess: pass a `plugin` table
-- inside hl.config({...}) keyed by plugin name. If this fails after the
-- upgrade, alternatives to try in order:
--   1. hl.plugin("hy3", { ... })  (hypothetical wrapper)
--   2. hl.dispatch_raw("plugin:hy3:autotile:enabled true")  (per-key)
--   3. Fall back to a shim .conf file sourced by Hyprland alongside Lua.

hl.config({
  plugin = {
    hy3 = {
      autotile = {
        enabled = true,
        trigger_width = 855,
        trigger_height = 500,
      },
      no_gaps_when_only = 1,
      node_collapse_policy = 2,
      tab_first_window = false,
      tabs = {
        height = 1,
        from_top = true,
        render_text = false,
      },
    },

    hyprfocus = {
      enabled = true,
      animate_floating = true,
      animate_workspacechange = true,
      focus_animation = "shrink",

      -- Beziers for focus animations.
      bezier = {
        { "bezIn",         0.5,  0.0,  1.0,  0.5 },
        { "bezOut",        0.0,  0.5,  0.5,  1.0 },
        { "overshot",      0.05, 0.9,  0.1,  1.05 },
        { "smoothOut",     0.36, 0,    0.66, -0.56 },
        { "smoothIn",      0.25, 1,    0.5,  1 },
        { "realsmooth",    0.28, 0.29, 0.69, 1.08 },
        { "easeInOutBack", 0.68, -0.6, 0.32, 1.6 },
      },

      flash = {
        flash_opacity = 0.7,
        in_bezier = "bezIn",
        in_speed = 0.5,
        out_bezier = "bezOut",
        out_speed = 3,
      },

      shrink = {
        shrink_percentage = 0.99,
        in_bezier = "easeInOutBack",
        in_speed = 1.5,
        out_bezier = "easeInOutBack",
        out_speed = 3,
      },
    },
  },
})
