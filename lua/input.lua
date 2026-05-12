-- Input config + per-device tweaks.

hl.config({
  input = {
    kb_layout = "us",
    repeat_rate = 40,
    repeat_delay = 400,
    sensitivity = 0.5,
    accel_profile = "adaptive",
    scroll_factor = 1,
    natural_scroll = false,
    follow_mouse = 1,
    special_fallthrough = false,
    touchpad = {
      natural_scroll = true,
      scroll_factor = 0.3,
      drag_lock = true,
      disable_while_typing = true,
    },
  },
})

hl.device({
  name = "apple-inc.-magic-trackpad-2",
  sensitivity = 0.55,
})

hl.device({
  name = "mx-anywhere-2-mouse",
  accel_profile = "adaptive",
})
