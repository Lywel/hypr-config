-- Shared helpers (gamemode toggle, bar visibility helper, etc.)

local M = {}

-- Track gamemode state in-process so we don't need to query Hyprland.
local gamemode_active = false

--- Toggle gamemode: disables animations, blur, gaps, rounding, and the panel.
--- Reload restores via Hyprland's normal config-reload path. Since we cannot
--- "reload" a Lua script the same way, on disable we re-apply the look config.
function M.toggle_gamemode()
  if not gamemode_active then
    -- Enable gamemode: kill panel, strip eye-candy.
    hl.exec_cmd("hyprpanel -q")
    hl.config({
      animations = { enabled = false },
      decoration = {
        rounding = 0,
        blur = { enabled = false },
        shadow = { enabled = false },
      },
      general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 1,
      },
    })
    hl.exec_cmd("cartridges")
    gamemode_active = true
    hl.notification.create({ text = "Gamemode ON", time_ms = 2000 })
  else
    -- Disable gamemode: restore values from look.lua / animations.lua.
    -- Cheapest reliable path: re-run those modules.
    package.loaded["lua.look"] = nil
    package.loaded["lua.animations"] = nil
    require("lua.look")
    require("lua.animations")
    hl.exec_cmd("uwsm-app -- hyprpanel")
    gamemode_active = false
    hl.notification.create({ text = "Gamemode OFF", time_ms = 2000 })
  end
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
