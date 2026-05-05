-- Event-driven dynamic behavior.
-- Replaces scripts/dynamic_float.sh.

local util = require("lua.util")

-- ----------------------------------------------------------------------
-- Auto-float rules: title-pattern matched, applied with float + center + resize.
-- Add new entries to this table; the dispatcher below stays untouched.
-- ----------------------------------------------------------------------

---@class FloatRule
---@field name      string    purely for documentation
---@field patterns  string[]  Lua patterns to match against window title
---@field width     string    e.g. "20%"  (passed to resizewindowpixel exact)
---@field height    string    e.g. "54%"

---@type FloatRule[]
local float_rules = {
  {
    name = "bitwarden",
    patterns = {
      "%(Bitwarden.*Password Manager%) %- Bitwarden",
      "^Bitwarden$",
    },
    width = "30%",
    height = "54%",
  },
  {
    name = "google-signin",
    patterns = {
      "^Connexion : comptes Google %—",
      "^Sign In %- Google Accounts %— ",
      "^Sign in %- Google Accounts %- Helium$",
    },
    width = "25%",
    height = "54%",
  },
  {
    name = "metamask-firefox",
    patterns = { "^Extension: %(MetaMask%) %- MetaMask %— Firefox" },
    width = "25%",
    height = "54%",
  },
}

local function match_any(s, patterns)
  for _, p in ipairs(patterns) do
    if s:match(p) then return true end
  end
  return false
end

local function float_center_resize(addr, w, h)
  -- The window-targeted variants of float/resize/center don't have a
  -- documented Lua arg shape yet, so use exec_raw for the chained dispatch.
  -- addr already arrives as a hex string (e.g. "0x55..."); pass through.
  hl.dispatch(hl.dsp.exec_raw(
    ("togglefloating address:%s ; resizewindowpixel exact %s %s,address:%s ; centerwindow")
    :format(addr, w, h, addr)
  ))
end

hl.on("window.title", function(w)
  local title = w.title or ""
  for _, rule in ipairs(float_rules) do
    if match_any(title, rule.patterns) then
      float_center_resize(w.address, rule.width, rule.height)
      return
    end
  end
end)

-- ----------------------------------------------------------------------
-- Fullscreen → bar visibility.
-- Hide bar-1 always, hide bar-0 unless multi-monitor. Show both on exit.
-- ----------------------------------------------------------------------

local function monitor_count()
  local mons = hl.get_monitors()
  return mons and #mons or 1
end

hl.on("window.fullscreen", function(w)
  -- Window.fullscreen is an integer (0=none, 1=maximize, 2=fullscreen).
  local entered = (w.fullscreen or 0) > 0
  if entered then
    util.show_bar("bar-1", false)
    util.show_bar("bar-0", monitor_count() > 1)
  else
    util.show_bar("bar-0", true)
    util.show_bar("bar-1", true)
  end
end)
