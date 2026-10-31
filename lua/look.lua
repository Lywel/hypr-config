-- General appearance / layout / decoration / misc / rendering / cursor.
-- (Animations live in animations.lua because they are separate API calls.)

hl.config({
  general = {
    gaps_in          = 3,
    gaps_out         = 1,
    -- Borders only show in gamemode and powersave (lua/util.lua). Otherwise the
    -- glow marks the focused window.
    border_size      = 0,
    col              = {
      active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
      inactive_border = "rgba(595959aa)",
    },
    resize_on_border = true,
    allow_tearing    = true,
    layout           = "hy3",
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
    wobble = { enabled = true },
    glow = {
      enabled = true,
      range = 20,
      color = { colors = { "rgba(33ccff22)", "rgba(00ff9922)" }, angle = 45 },
      color_inactive = "rgba(00000000)", -- unfocused windows get no glow
    },
  },

  dwindle = {
    preserve_split = true,
    smart_split = false,
    force_split = 2,
    default_split_ratio = 1.3,
  },

  master = {
    mfact = 0.73,
    allow_small_split = true,
  },

  misc = {
    force_default_wallpaper = -1,
    disable_hyprland_logo = false,
    on_focus_under_fullscreen = 2,
    vrr = 2,
  },
})
