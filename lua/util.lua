-- Shared helpers: gamemode, powersave and hyprpanel bar visibility.

local M = {}

-- Both reset to false on every config reload, along with the rest of the Lua state.
local gamemode_active = false
local powersave_active = false

local GAMEMODE_LOOK = {
  animations = { enabled = false },
  decoration = {
    rounding = 0,
    blur = { enabled = false },
    shadow = { enabled = false },
    glow = { enabled = false },
    wobble = { enabled = false },
  },
  general = {
    gaps_in = 0,
    gaps_out = 0,
    border_size = 1,
  },
}

local POWERSAVE_LOOK = {
  animations = { enabled = false },
  decoration = {
    blur = { enabled = false },
    shadow = { enabled = false },
    glow = { enabled = false },
    wobble = { enabled = false },
  },
  general = { border_size = 1 },
}

---Runs a module again, bypassing the require() cache.
---@param name string
local function rerun(name)
  package.loaded[name] = nil
  require(name)
end

---Re-applies look.lua and animations.lua, then layers the active modes on top.
local function apply_look()
  rerun("lua.look")
  rerun("lua.animations")
  if powersave_active then hl.config(POWERSAVE_LOOK) end
  if gamemode_active then hl.config(GAMEMODE_LOOK) end
end

---@param text string
local function notify(text)
  hl.notification.create({ text = text, timeout = 2000 })
end

---Toggles gamemode. Turning it on strips effects and gaps and opens cartridges.
function M.toggle_gamemode()
  gamemode_active = not gamemode_active
  apply_look()
  if gamemode_active then hl.exec_cmd("cartridges") end
  notify(gamemode_active and "Gamemode ON" or "Gamemode OFF")
end

---Turns powersave on or off. Powersave disables the GPU-heavy effects and
---shows a 1 px border.
---@param on boolean
function M.set_powersave(on)
  if on == powersave_active then return end
  powersave_active = on
  apply_look()
  notify(on and "Powersave ON" or "Powersave OFF")
end

--- Toggle hyprpanel bar visibility only when current visibility doesn't match.
--- @param bar string  bar window name (e.g. "bar-0")
--- @param show boolean
function M.show_bar(bar, show)
  -- We can't easily read hyprpanel state synchronously from Lua, so shell out.
  -- Fire-and-forget; if state already matches, the toggle is a no-op via the
  -- `is_visible != show` guard below using a small sh wrapper.
  local want = show and "true" or "false"
  hl.exec_cmd(string.format(
    [[sh -c 'is=$(hyprpanel isWindowVisible %s); [ "$is" != "%s" ] && hyprpanel toggleWindow %s']],
    bar, want, bar
  ))
end

_G.util = M
return M
