-- Event-driven dynamic behavior.
-- Replaces scripts/dynamic_float.sh: socat-based event loop -> hl.on() handlers.

local util = require("lua.util")

-- ----------------------------------------------------------------------
-- Bitwarden / Google sign-in / MetaMask: float + center + percentage size.
-- The size depends on which app it is.
-- ----------------------------------------------------------------------

--- Apply float + center + size to a window by address.
--- @param address string  hex window address (without 0x prefix)
--- @param width string    e.g. "20%"
--- @param height string   e.g. "54%"
local function float_center_resize(address, width, height)
  hl.dispatch_raw(string.format(
    "togglefloating address:0x%s ; " ..
    "resizewindowpixel exact %s %s,address:0x%s ; " ..
    "centerwindow",
    address, width, height, address
  ))
end

-- Hyprland event: window title change.
-- Payload shape (per wiki socket2 spec): { address = "...", title = "..." }.
hl.on("window.title", function(ev)
  local title   = ev.title or ""
  local address = ev.address or ""

  -- Bitwarden (post-load title contains the long product name).
  if title:match("%(Bitwarden.*Password Manager%) %- Bitwarden")
      or title == "Bitwarden" then
    float_center_resize(address, "20%", "54%")
    return
  end

  -- Google sign-in (FR + EN variants across browsers).
  if title:match("^Connexion : comptes Google %—")
      or title:match("^Sign In %- Google Accounts %— ")
      or title == "Sign in - Google Accounts - Helium" then
    float_center_resize(address, "25%", "54%")
    return
  end

  -- MetaMask popup (Firefox only; Chromium spawns its own window class).
  if title:match("^Extension: %(MetaMask%) %- MetaMask %— Firefox") then
    float_center_resize(address, "25%", "54%")
    return
  end
end)

-- ----------------------------------------------------------------------
-- Fullscreen: hide bar-1 always; hide bar-0 unless multi-monitor.
-- ----------------------------------------------------------------------

--- Count active monitors via hyprctl. Synchronous shell-out.
local function monitor_count()
  local p = io.popen("hyprctl monitors -j | jq length")
  if not p then return 1 end
  local n = tonumber((p:read("*l") or "1")) or 1
  p:close()
  return n
end

hl.on("window.fullscreen", function(ev)
  -- ev.state: 1 = entered fullscreen, 0 = left fullscreen.
  local is_fs = ev.state == 1 or ev.state == true

  if is_fs then
    util.show_bar("bar-1", false)
    util.show_bar("bar-0", monitor_count() > 1)
  else
    util.show_bar("bar-0", true)
    util.show_bar("bar-1", true)
  end
end)
