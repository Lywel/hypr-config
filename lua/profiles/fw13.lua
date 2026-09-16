-- Diff vs. lua/monitors.lua: 10 bpc, a fractional scale and a panel ICC profile.
hl.monitor({
  output   = "eDP-1",
  mode     = "preferred",
  scale    = "1.33",
  position = "0x0",
  bitdepth = 10,
  icc      = "/home/maxime/Downloads/BOE0CB4.icm",
})
