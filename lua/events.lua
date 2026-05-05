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
  hl.dispatch_raw(([[togglefloating address:0x%s ; ]] ..
    [[resizewindowpixel exact %s %s,address:0x%s ; ]] ..
    [[centerwindow]]):format(addr, w, h, addr))
end

hl.on("window.title", function(ev)
  local title = ev.title or ""
  for _, rule in ipairs(float_rules) do
    if match_any(title, rule.patterns) then
      float_center_resize(ev.address, rule.width, rule.height)
      return
    end
  end
end)

-- ----------------------------------------------------------------------
-- Fullscreen → bar visibility.
-- Hide bar-1 always, hide bar-0 unless multi-monitor. Show both on exit.
-- ----------------------------------------------------------------------

local function monitor_count()
  local p = io.popen("hyprctl monitors -j | jq length")
  if not p then return 1 end
  local n = tonumber((p:read("*l") or "1")) or 1
  p:close()
  return n
end

hl.on("window.fullscreen", function(ev)
  local entered = ev.state == 1 or ev.state == true
  if entered then
    util.show_bar("bar-1", false)
    util.show_bar("bar-0", monitor_count() > 1)
  else
    util.show_bar("bar-0", true)
    util.show_bar("bar-1", true)
  end
end)
