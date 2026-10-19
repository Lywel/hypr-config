-- Diff vs. lua/monitors.lua: this panel is driven at 10 bpc.
hl.monitor({
  output   = "eDP-1",
  mode     = "preferred",
  scale    = "1",
  position = "0x0",
  bitdepth = 10,
})

hl.monitor({
  output   = "desc:Samsung Electric Company S34J55x HTOM600498",
  mode     = "3440x1440@59.97Hz",
  position = "auto-left",
  scale    = "1",
})

local A = require("lua.apps")

hl.unbind(A.mainMod .. " + ALT + RETURN")
hl.bind(A.mainMod .. " + ALT + 1", hl.dsp.exec_raw(A.launch .. " " .. A.browser))
hl.bind(A.mainMod .. " + ALT + RETURN", hl.dsp.exec_raw(A.launch .. " gtk-launch helium-work"))
