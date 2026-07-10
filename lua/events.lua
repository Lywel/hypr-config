-- Event-driven dynamic behavior.
-- Replaces scripts/dynamic_float.sh.

local util = require("lua.util")

-- ---------------------------------------------------------------------------
-- Auto-float rules
--
-- When a window's title changes and matches any of the Lua patterns in a
-- rule, the window is floated, centered, and resized to the given
-- percentage of the *active* monitor's dimensions.
--
-- We listen on `window.title` (not `window.open`) because some apps create a
-- window with a generic title (e.g. "Chrome") and only set the real title a
-- few ms later (e.g. "Bitwarden ..."). The title event fires for each change.
--
-- Note: `window.monitor` is nil during early title events (the window may
-- not be mapped yet), so we use `hl.get_active_monitor()` instead — by
-- definition the window being created lives on the focused monitor.
--
-- To add a rule, append an entry to `rules` below.
-- ---------------------------------------------------------------------------

---@class FloatRule
---@field width    integer    width as percent of monitor width  (1..100)
---@field height   integer    height as percent of monitor height (1..100)
---@field patterns string[]   Lua patterns matched against window title

---@type FloatRule[]
local rules = {
  {
    width = 30,
    height = 54,
    patterns = {
      "%(Bitwarden.*Password Manager%) %- Bitwarden",
      "^Bitwarden$",
    }
  },
  {
    width = 25,
    height = 54,
    patterns = {
      "^Connexion : comptes Google %—",
      "^Sign In %- Google Accounts %— ",
      "^Sign in %- Google Accounts %- Helium$",
      "^title: Meet - [a-z0-9]+-[a-z0-9]+-[a-z0-9]+$",
    }
  },
  {
    width = 25,
    height = 54,
    patterns = {
      "^Extension: %(MetaMask%) %- MetaMask %— Firefox",
    }
  },
}

---Return true if `title` matches any pattern in `rule`.
---@param title string
---@param rule  FloatRule
---@return boolean
local function matches(title, rule)
  for _, pattern in ipairs(rule.patterns) do
    if title:match(pattern) then return true end
  end
  return false
end

hl.on("window.title", function(window)
  local title = window.title or ""
  for _, rule in ipairs(rules) do
    if matches(title, rule) then
      local monitor = hl.get_active_monitor()
      if not monitor then return end

      hl.dispatch(hl.dsp.window.float({ window = window, action = "on" }))
      hl.dispatch(hl.dsp.window.center({ window = window, action = "on" }))
      hl.dispatch(hl.dsp.window.resize({
        window = window,
        x = math.floor(monitor.width * rule.width / 100),
        y = math.floor(monitor.height * rule.height / 100),
      }))
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
