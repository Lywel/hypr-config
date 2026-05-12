-- Framework 13 (fw13) profile overrides.

local A   = require("lua.apps")
local mod = A.mainMod

-- On this laptop the binary is "helium", not "helium-browser".
A.browser = "helium"

hl.bind(mod .. " + ALT + RETURN", hl.dsp.exec_raw(A.launch .. " " .. A.browser))
