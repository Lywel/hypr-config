-- Hyprland Lua entry point.
--
-- Architecture
-- ============
-- 1. Common modules in lua/ unconditionally apply the shared baseline
--    (look, input, monitors, binds, rules, ...).
-- 2. A per-host profile in lua/profiles/<hostname>.lua loads LAST and
--    overrides anything host-specific by simply re-declaring it. Hyprland's
--    later-wins semantics handle:
--      - hl.config({...})           -> later values replace earlier ones
--      - hl.monitor({output="X"})   -> last entry for an output wins
--      - hl.bind(lhs, ...)          -> last bind on a given key wins
--      - hl.window_rule({...})      -> additive (cannot remove from a profile)
--    Profiles should therefore be small: only the diff vs. the common base.

local function read_hostname()
  local f = io.open("/etc/hostname", "r")
  if not f then return nil end
  local h = f:read("*l")
  f:close()
  return h and h:gsub("%s+", "") or nil
end

local modules = {
  "lua.apps",
  "lua.look",
  "lua.animations",
  "lua.input",
  "lua.monitors",
  "lua.rules",
  "lua.plugins",
  "lua.binds",
  "lua.events",
  "lua.autostart",
}

for _, mod in ipairs(modules) do
  require(mod)
end

-- Per-host overrides: optional. Missing profile is fine; surface real errors.
local hostname = read_hostname()
if hostname and hostname ~= "" then
  local ok, err = pcall(require, "lua.profiles." .. hostname)
  if not ok and not tostring(err):match("module .* not found") then
    hl.notification.create({
      text = ("Profile '%s' error: %s"):format(hostname, err),
      time_ms = 5000,
    })
  end
end
