-- Static monitor fallbacks. The `hmonitor` daemon manages dynamic
-- profiles in ~/.config/hypr/monitor-configs/ at runtime; these definitions
-- match conf.d/monitors.conf as a last-resort baseline.
--
-- Note: scale is a STRING in the Lua API (e.g. "1.33", "auto"), not a number.

hl.monitor({
  output   = "eDP-1",
  mode     = "preferred",
  scale    = "auto",
  position = "0x0",
})

hl.monitor({
  output   = "desc:Samsung Electric Company S34J55x HTOM600498",
  mode     = "3440x1440@74.98",
  position = "-3440x0",
  scale    = "1",
})

-- Laptop-on-desk-to-the-right layout (default for pya-max01).
hl.monitor({
  output   = "Dell Inc. DELL S3425DW 23MPR44",
  mode     = "3440x1440@60",
  position = "-3440x0",
  scale    = "1",
})

-- Laptop-on-desk-to-the-right layout (default for pya-max01).
hl.monitor({
  output   = "desc:Dell Inc. DELL S3425DW J6MPR44",
  mode     = "3440x1440@120",
  position = "-3440x-800",
  scale    = "1",
})

-- Laptop-on-desk-to-the-right layout (default for pya-max01).
hl.monitor({
  output   = "desc:Dell Inc. DELL S3425DW 5KDRR44",
  mode     = "3440x1440@120",
  position = "-3440x-800",
  scale    = "1",
})


-- Laptop-on-desk-to-the-right layout (default for pya-max01).
hl.monitor({
  output   = "desc:Dell Inc. DELL S3425DW 3BDRR44",
  mode     = "3440x1440@120",
  position = "-3440x-800",
  scale    = "1",
})
-- Laptop-on-desk-to-the-right layout (default for pya-max01).
hl.monitor({
  output   = "desc:Dell Inc. DELL S3425DW 23MPR44",
  mode     = "3440x1440@120",
  position = "-3440x-800",
  scale    = "1",
})

-- Catch-all fallback for any other display.
hl.monitor({
  output   = "",
  mode     = "preferred",
  position = "1925x0",
  scale    = "1",
})
