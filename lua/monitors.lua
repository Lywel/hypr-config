-- Monitor layout. Rules are matched most-specific-first: exact output name,
-- then `desc:` substring, then the catch-all. `desc:` matching is a substring
-- test, so keying on the model rather than the serial covers every unit.
--
-- Note: scale is a STRING in the Lua API (e.g. "1.33", "auto"), not a number.

hl.monitor({
  output   = "eDP-1",
  mode     = "preferred",
  scale    = "auto",
  position = "0x0",
})

hl.monitor({
  output   = "desc:Dell Inc. DELL S3425DW",
  mode     = "3440x1440@120",
  position = "-3440x-800",
  scale    = "1",
})

hl.monitor({
  output   = "desc:Dell Inc. DELL S3423DWC",
  mode     = "3440x1440@99.98",
  position = "-3440x-800",
  scale    = "1",
})

hl.monitor({
  output   = "desc:Samsung Electric Company S34J55x",
  mode     = "3440x1440@60",
  position = "-3440x0",
  scale    = "1",
})

-- Anything else: let Hyprland pick the mode and scale, placed left of the laptop.
hl.monitor({
  output   = "",
  mode     = "preferred",
  position = "auto-left",
  scale    = "auto",
})
