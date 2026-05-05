-- Bezier curves + per-leaf animation settings.
-- Curves are declared via hl.curve(), animations via hl.animation().

hl.config({ animations = { enabled = true } })

hl.curve("easeOutQuint",   { 0.23, 1,    0.32, 1 })
hl.curve("easeInOutCubic", { 0.65, 0.05, 0.36, 1 })
hl.curve("linear",         { 0,    0,    1,    1 })
hl.curve("almostLinear",   { 0.5,  0.5,  0.75, 1 })
hl.curve("quick",          { 0.15, 0,    0.1,  1 })

local function anim(leaf, speed, bezier, style)
  hl.animation({
    leaf = leaf,
    enabled = true,
    speed = speed,
    bezier = bezier,
    style = style,
  })
end

anim("global",        10,   "default")
anim("border",        5.39, "easeOutQuint")
anim("windows",       4.79, "easeOutQuint")
anim("windowsIn",     4.1,  "easeOutQuint", "popin 87%")
anim("windowsOut",    1.49, "linear",       "popin 87%")
anim("fadeIn",        1.73, "almostLinear")
anim("fadeOut",       1.46, "almostLinear")
anim("fade",          3.03, "quick")
anim("layers",        3.81, "easeOutQuint")
anim("layersIn",      4,    "easeOutQuint", "fade")
anim("layersOut",     1.5,  "linear",       "fade")
anim("fadeLayersIn",  1.79, "almostLinear")
anim("fadeLayersOut", 1.39, "almostLinear")
anim("workspaces",    1.94, "almostLinear", "fade")
anim("workspacesIn",  1.21, "almostLinear", "fade")
anim("workspacesOut", 1.94, "almostLinear", "fade")
anim("zoomFactor",    7,    "quick")
