-- Application aliases (formerly hyprlang $vars).
-- Exported via the global `apps` table; consumed by binds.lua and others.

local M = {}

M.mainMod      = "SUPER"
M.launch       = "uwsm-app --"
M.terminal     = "alacritty"
M.file_manager = "nautilus"
M.menu         = M.launch .. " $(tofi-drun)"
M.browser      = "helium-browser"
M.lock         = "loginctl lock-session"

_G.apps = M
return M
