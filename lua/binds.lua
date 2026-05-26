-- Keybindings, mouse binds, gestures, submaps.
--
-- Style: neovim-inspired. Each section is a list of { lhs, rhs, opts?, desc? }
-- consumed by a single map() helper. Adding/removing/grepping a bind is a
-- one-line change.
--
-- HY3 FALLBACK TOGGLE
-- ===================
-- hy3 breaks periodically and floods the screen with error popups when it does.
-- The fallback bindset (vanilla movefocus/movewindow/...) is intentionally
-- preserved so flipping this flag rescues the system without further edits.

local USE_HY3 = false   -- hy3 fails to build on 0.55; flip back when fixed

local util    = require("lua.util")
local A       = require("lua.apps")

local mod     = A.mainMod
local mod_S   = mod .. " + SHIFT"
local mod_A   = mod .. " + ALT"
local mod_C   = mod .. " + CTRL"

-- ======================================================================
-- Helpers
-- ======================================================================

--- Apply a list of bindings.
--- Each entry is { lhs, rhs, opts?, desc? }.
--- rhs may be a dispatcher table (from hl.dsp.*), a string (treated as raw
--- dispatch), or a Lua function.
local function map(bindings)
  for _, b in ipairs(bindings) do
    local lhs, rhs, opts = b[1], b[2], b[3]
    hl.bind(lhs, rhs, opts)
  end
end

local function exec(cmd) return hl.dsp.exec_raw(cmd) end
local function app(cmd) return hl.dsp.exec_raw(A.launch .. " " .. cmd) end
local function global(s) return hl.dsp.global(s) end
local function focus_dir(d) return hl.dsp.focus({ direction = d }) end
local function move_dir(d) return hl.dsp.window.move({ direction = d }) end
local function move_ws(ws) return hl.dsp.window.move({ workspace = ws }) end
local function focus_ws(ws) return hl.dsp.focus({ workspace = ws }) end

local LOCKED   = { locked = true }
local LOCKED_R = { locked = true, repeating = true }

-- ======================================================================
-- System / session
-- ======================================================================

map({
  { "switch:Lid Switch",  exec(A.lock),                                                                           LOCKED, "Lock on lid close" },
  { mod_S .. " + L",      exec(A.lock),                                                                           LOCKED, "Lock session" },
  { mod .. " + ESCAPE",   exec("uwsm stop"),                                                                      nil,    "Quit Hyprland (uwsm)" },

  -- Standing desk (linak).
  { "SHIFT_R + UP",       exec("cd ~/Documents/linak-desk && uv run linak-controller --forward --move-to stand"), nil,    "Desk: stand" },
  { "SHIFT_R + DOWN",     exec("cd ~/Documents/linak-desk && uv run linak-controller --forward --move-to sit"),   nil,    "Desk: sit" },
})

-- ======================================================================
-- Application launchers
-- ======================================================================

map({
  { mod .. " + E",        app(A.file_manager),           nil, "File manager" },
  { mod .. " + SPACE",    exec(A.menu),                  nil, "App menu (tofi)" },
  { mod .. " + RETURN",   app(A.terminal),               nil, "Terminal" },
  { mod_A .. " + RETURN", app(A.browser),                nil, "Browser" },
  { mod_A .. " + 1",      app("gtk-launch helium-work"), nil, "Helium (work)" },

  { mod .. " + Print",    app("hyprshot -m region -z"),  nil, "Screenshot" },
  { mod .. " + F6",       app("hyprshot -m region -z"),  nil, "Screenshot" },

  -- Hyprland-aware window picker.
  { mod .. " + W", exec(
    [[hyprctl clients -j | jq -r '.[] | select(.mapped==true) | (.class + "|" + .title)' ]] ..
    [[| column -s'|' --table --table-columns-limit 2 ]] ..
    [[| tofi | cut -d' ' -f1 | xargs -I{} hyprctl dispatch focuswindow 'class:{}']]
  ), nil, "Pick window via tofi" },

  { mod .. " + X",                exec("hyprctl kill"),                                                                   nil, "Force-kill window" },
  { "Print",                      exec("pgrep hyprsunset && pkill hyprsunset || hyprsunset -t 2500"),                     nil, "Toggle hyprsunset" },

  { mod .. " + EQUAL",            exec("hyprpanel --toggle-window=bar-0 && hyprpanel --toggle-window=bar-1"),             nil, "Toggle bars" },
  { mod_S .. " + EQUAL",          exec([[test -n "$(hyprpanel -l)" && hyprpanel -q || hyprctl dispatch exec hyprpanel]]), nil, "Restart hyprpanel" },

  { mod .. " + P",                exec("tuned-adm profile laptop-battery-powersave"),                                     nil, "Tuned: powersave" },
  { mod_S .. " + P",              exec("tuned-adm profile balanced-battery"),                                             nil, "Tuned: balanced" },
  { mod .. " + CTRL + SHIFT + P",     exec("tuned-adm profile throughput-performance"),                                       nil, "Tuned: performance" },

  { mod .. " + G",                function() util.toggle_gamemode() end,                                                  nil, "Toggle gamemode" },
  { mod_S .. " + Print",          exec("~/.config/hypr/scripts/screen-record.sh"),                                        nil, "Screen record" },
  { mod .. " + XF86AudioMedia",   exec("~/.config/hypr/scripts/yeelights.sh on  &> /tmp/main.log"),                       nil, "Yeelights on" },
  { mod_S .. " + XF86AudioMedia", exec("~/.config/hypr/scripts/yeelights.sh off &> /tmp/shift_main.log"),                 nil, "Yeelights off" },
})

-- ======================================================================
-- Window state
-- ======================================================================

map({
  { mod .. " + R",       hl.dsp.force_renderer_reload(),                    nil, "Reload renderer" },
  { mod_S .. " + F",     hl.dsp.window.fullscreen({ mode = "fullscreen" }), nil, "Fullscreen" },
  { mod .. " + F",       hl.dsp.window.center(),                            nil, "Center window" },

  -- pypr layout-center.
  { mod .. " + C",       exec("pypr layout_center toggle"),                 nil, "pypr center toggle" },
  { mod .. " + left",    exec("pypr layout_center prev"),                   nil, "pypr center prev" },
  { mod .. " + right",   exec("pypr layout_center next"),                   nil, "pypr center next" },
})

-- ======================================================================
-- Movement / workspaces (USE_HY3-aware)
-- ======================================================================
--
-- Each direction has up to two keys (arrow + vim). The same data drives both
-- focus and window-move bindings. Last bind on a key wins, so we register
-- exactly one of the hy3 / vanilla halves.

local DIRECTIONS = {
  -- { keys[],            vanilla,  hy3      }
  { { "h", "left" },  "l", "left" },
  { { "l", "right" }, "r", "right" },
  { { "j", "down" },  "d", "down" },
  { { "k", "up" },    "u", "up" },
}

local function for_each_direction(fn)
  for _, dir in ipairs(DIRECTIONS) do
    for _, key in ipairs(dir[1]) do
      fn(key, dir[2], dir[3])
    end
  end
end

local movement = {}

if USE_HY3 then
  -- hy3 grouping + kill. Plugin dispatchers go through hl.dsp.global until
  -- outfoxxed publishes a Lua namespace via addLuaFunction.
  movement = {
    { mod .. " + v",   global("hy3:makegroup, v, force_ephemeral"), nil, "hy3: vsplit group" },
    { mod .. " + b",   global("hy3:makegroup, h, force_ephemeral"), nil, "hy3: hsplit group" },
    { mod .. " + t",   global("hy3:makegroup, tab, toggle"),        nil, "hy3: tab group" },
    { mod .. " + Q",   global("hy3:killactive"),                    nil, "hy3: kill" },
    { mod_S .. " + k", global("hy3:changefocus, raise"),            nil, "hy3: raise focus" },
  }
  for_each_direction(function(key, _vanilla, h)
    movement[#movement + 1] = { mod .. " + " .. key, global("hy3:movefocus, " .. h) }
    movement[#movement + 1] = { mod_A .. " + " .. key, global("hy3:movewindow, " .. h) }
  end)
  for i = 1, 9 do
    movement[#movement + 1] = { mod_S .. " + " .. i, global(("hy3:movetoworkspace, %d, follow"):format(i)) }
  end
else
  movement = {
    { mod .. " + Q", hl.dsp.window.close(), nil, "Close window" },
  }
  for_each_direction(function(key, v, _h)
    movement[#movement + 1] = { mod .. " + " .. key, focus_dir(v) }
    movement[#movement + 1] = { mod_A .. " + " .. key, move_dir(v) }
  end)
  for i = 1, 9 do
    movement[#movement + 1] = { mod_S .. " + " .. i, move_ws(tostring(i)) }
  end
  movement[#movement + 1] = { mod_S .. " + 0", move_ws("10") }
end

map(movement)

-- ======================================================================
-- pypr (scratchpad / zoom / menu)
-- ======================================================================

map({
  { mod .. " + Z",           exec("pypr zoom ++0.17"),       nil, "pypr zoom in" },
  { mod_S .. " + Z",         exec("pypr zoom"),              nil, "pypr zoom reset" },
  { mod .. " + semicolon",   exec("pypr menu"),              nil, "pypr menu" },
  { "ALT + B",               exec("pypr toggle beeper"),     nil, "pypr: beeper" },
  { "ALT + M",               exec("pypr toggle betterbird"), nil, "pypr: betterbird" },
})

-- ======================================================================
-- Floating / layout / workspace switching
-- ======================================================================

local workspace_binds = {
  { mod .. " + O",            hl.dsp.window.float({ action = "toggle" }), nil, "Toggle floating" },
  { mod .. " + SLASH",        hl.dsp.layout(""),                          nil, "Layout msg" },
  { mod .. " + 0",            focus_ws("10") },

  { mod_C .. " + right",      focus_ws("e+1") },
  { mod_C .. " + l",          focus_ws("e+1") },
  { mod_C .. " + left",       focus_ws("e-1") },
  { mod_C .. " + h",          focus_ws("e-1") },

  -- Special workspace.
  { mod .. " + S",            hl.dsp.workspace.toggle_special("magic") },
  { mod_S .. " + S",          exec("pypr toggle_special magic") },

  -- Scroll wheel.
  { mod .. " + mouse_down",   focus_ws("e+1") },
  { mod .. " + mouse_up",     focus_ws("e-1") },
}
for i = 1, 9 do
  workspace_binds[#workspace_binds + 1] = { mod .. " + " .. i, focus_ws(tostring(i)) }
end
map(workspace_binds)

-- ======================================================================
-- Mouse binds
-- ======================================================================

-- BindOptions has no `mouse` field; drag/resize dispatchers self-signal
-- mouse capture, so plain bind() works for both button and modifier triggers.
map({
  { mod .. " + mouse:272", hl.dsp.window.drag(),                      nil, "Drag window (LMB)" },
  { mod .. " + Control_L", hl.dsp.window.drag(),                      nil, "Drag window (Ctrl)" },
  { mod .. " + mouse:273", hl.dsp.window.resize(),                    nil, "Resize window (RMB)" },
  { mod .. " + ALT_L",     hl.dsp.window.resize(),                    nil, "Resize window (Alt)" },
})

-- ======================================================================
-- Media keys
-- ======================================================================

map({
  { "XF86AudioNext",         exec("playerctl next"),                                                              LOCKED },
  { "XF86AudioPlay",         exec("playerctl play-pause"),                                                        LOCKED },
  { "XF86AudioPrev",         exec("playerctl previous"),                                                          LOCKED },
  { "XF86AudioMute",         exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),                                  LOCKED },

  { "XF86AudioLowerVolume",  exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),                                   LOCKED_R },
  { "XF86AudioRaiseVolume",  exec("wpctl set-volume --limit 1 @DEFAULT_AUDIO_SINK@ 5%+"),                         LOCKED_R },
  { "XF86MonBrightnessDown", exec("brightnessctl --device='intel_backlight' --exponent=3 --min-value=1 set 5%-"), LOCKED_R },
  { "XF86MonBrightnessUp",   exec("brightnessctl --device='intel_backlight' --exponent=3 set +5%"),               LOCKED_R },
})

-- ======================================================================
-- Gestures
-- ======================================================================

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- ======================================================================
-- Submaps
-- ======================================================================

-- "clean" disables every keybind except the escape combo.
hl.define_submap("clean", function()
  hl.bind(mod_S .. " + GRAVE", hl.dsp.submap("reset"))
end)

map({
  { mod_S .. " + GRAVE", hl.dsp.submap("clean"),     nil, "Enter clean submap" },
  { "ALT + TAB",         hl.dsp.window.cycle_next(), nil, "Cycle next window" },
})
