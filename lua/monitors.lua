-- Static monitor fallbacks. The `hmonitor` daemon manages dynamic
-- profiles in ~/.config/hypr/monitor-configs/ at runtime; these definitions
-- match conf.d/monitors.conf as a last-resort baseline.

hl.monitor({
  output = "eDP-1",
  mode = "preferred",
  scale = 1.33,
  position = "0x0",
  bitdepth = 10,
})

hl.monitor({
  output = "desc:Samsung Electric Company S34J55x HTOM600498",
  mode = "3440x1440@59.97Hz",
  position = "-3440x0",
  scale = 1,
})

-- Laptop-on-desk-to-the-right layout (default for pya-max01).
hl.monitor({
  output = "desc:Dell Inc. DELL S3425DW J6MPR44",
  mode = "3440x1440@120",
  position = "-3440x-800",
  scale = 1,
})

-- Catch-all fallback for any other display.
hl.monitor({
  output = "",
  mode = "preferred",
  position = "1925x0",
  scale = 1,
})
