-- General appearance / layout / decoration / misc / rendering / cursor.
-- (Animations live in animations.lua because they are separate API calls.)

hl.config({
  general = {
    gaps_in = 3,
    gaps_out = 6,
    border_size = 1,
    ["col.active_border"]   = "rgba(33ccffee) rgba(00ff99ee) 45deg",
    ["col.inactive_border"] = "rgba(595959aa)",
    resize_on_border = true,
    allow_tearing = true,
    layout = "hy3",
  },

  render = {
    direct_scanout = 1,
    new_render_scheduling = true,
  },

  cursor = {
    hide_on_key_press = true,
  },

  decoration = {
    rounding = 18,
    shadow = {
      enabled = true,
      range = 16,
      render_power = 3,
      color = "rgba(1a1a1aee)",
    },
    blur = {
      enabled = true,
      size = 12,
      passes = 1,
      brightness = 0.5,
      contrast = 1.3,
      vibrancy = 1,
      vibrancy_darkness = 0.5,
    },
  },

  dwindle = {
    pseudotile = true,
    preserve_split = true,
    smart_split = false,
    force_split = 2,
    default_split_ratio = 1.3,
    special_scale_factor = 0.96,
  },

  master = {
    mfact = 0.73,
    allow_small_split = true,
  },

  misc = {
    force_default_wallpaper = -1,
    disable_hyprland_logo = false,
    on_focus_under_fullscreen = 2,
    vfr = true,
    vrr = 2,
  },
})
