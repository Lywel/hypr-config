-- Hyprland Lua entry point
-- Profile-aware: dispatches to lua/profiles/<hostname>.lua when present.

local function read_hostname()
  local f = io.open("/etc/hostname", "r")
  if not f then return nil end
  local h = f:read("*l")
  f:close()
  if h then h = h:gsub("%s+", "") end
  return h
end

-- Shared modules (load order matters for some side-effecting calls).
require("lua.apps")
require("lua.look")
require("lua.animations")
require("lua.input")
require("lua.monitors")
require("lua.rules")
require("lua.plugins")
require("lua.binds")
require("lua.events")
require("lua.autostart")

-- Per-host overrides (optional).
local hostname = read_hostname()
if hostname and hostname ~= "" then
  local ok, err = pcall(require, "lua.profiles." .. hostname)
  if not ok then
    -- Missing profile is fine; surface other errors.
    if not tostring(err):match("module .* not found") then
      hl.notification.create({
        text = "Profile '" .. hostname .. "' error: " .. tostring(err),
        time_ms = 5000,
      })
    end
  end
end
