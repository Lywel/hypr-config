-- Keybindings, mouse binds, gestures, submaps.
--
-- HY3 FALLBACK TOGGLE:
-- When hy3 breaks (which happens periodically, flooding the screen with
-- error popups), set USE_HY3 = false here, save, reload Hyprland.
-- That swap activates the vanilla equivalents (movefocus/movewindow/
-- killactive/movetoworkspace) so the system stays usable until hy3
-- gets fixed upstream.
local USE_HY3 = true

local util = require("lua.util")
local A = require("lua.apps")

local mainMod = A.mainMod
local launch  = A.launch

-- Convenience wrapper: shell exec with uwsm-app prefix.
local function app(cmd) return hl.dsp.exec(launch .. " " .. cmd) end
local function sh(cmd)  return hl.dsp.exec(cmd) end

-- ======================================================================
-- System / session
-- ======================================================================

-- Lid switch + manual lock.
hl.bind("switch:Lid Switch", sh(A.lock), { locked = true })
hl.bind(mainMod .. " SHIFT + L", sh(A.lock), { locked = true })

-- Quit Hyprland session via uwsm (safe shutdown path).
hl.bind(mainMod .. " + ESCAPE", sh("uwsm stop"))

-- Standing-desk control (linak).
hl.bind("SHIFT_R + UP",
  sh("cd ~/Documents/linak-desk && uv run linak-controller --forward --move-to stand"))
hl.bind("SHIFT_R + DOWN",
  sh("cd ~/Documents/linak-desk && uv run linak-controller --forward --move-to sit"))

-- ======================================================================
-- Application launchers
-- ======================================================================

hl.bind(mainMod .. " + E",         app(A.file_manager))
hl.bind(mainMod .. " + SPACE",     sh(A.menu))
hl.bind(mainMod .. " + RETURN",    app(A.terminal))
hl.bind(mainMod .. " ALT + RETURN", app(A.browser))
hl.bind(mainMod .. " ALT + 1",     app("gtk-launch helium-work"))

-- Screenshots.
hl.bind(mainMod .. " + Print", app("hyprshot -m region -z"))
hl.bind(mainMod .. " + F6",    app("hyprshot -m region -z"))

-- Window picker via tofi.
hl.bind(mainMod .. " + W", sh(
  [[hyprctl clients -j | jq -r '.[] | select(.mapped==true) | (.class + "|" + .title)' ]] ..
  [[| column -s'|' --table --table-columns-limit 2 ]] ..
  [[| tofi | cut -d' ' -f1 | xargs -I{} hyprctl dispatch focuswindow 'class:{}']]
))

-- Force-kill focused window.
hl.bind(mainMod .. " + X", sh("hyprctl kill"))

-- Hyprsunset toggle (without mainMod).
hl.bind("Print", sh("pgrep hyprsunset && pkill hyprsunset || hyprsunset -t 2500"))

-- Hyprpanel toggle.
hl.bind(mainMod .. " + EQUAL",
  sh("hyprpanel --toggle-window=bar-0 && hyprpanel --toggle-window=bar-1"))
hl.bind(mainMod .. " SHIFT + EQUAL",
  sh([[test -n "$(hyprpanel -l)" && hyprpanel -q || hyprctl dispatch exec hyprpanel]]))

-- tuned-adm power profiles.
hl.bind(mainMod .. " + P",            sh("tuned-adm profile laptop-battery-powersave"))
hl.bind(mainMod .. " SHIFT + P",      sh("tuned-adm profile balanced-battery"))
hl.bind(mainMod .. " CTRL SHIFT + P", sh("tuned-adm profile throughput-performance"))

-- Gamemode toggle (Lua port, replaces scripts/gamemode.sh).
hl.bind(mainMod .. " + G", function() util.toggle_gamemode() end)

-- Screen recording (still a shell script).
hl.bind(mainMod .. " SHIFT + Print", sh("~/.config/hypr/scripts/screen-record.sh"))

-- Yeelights.
hl.bind(mainMod .. " + XF86AudioMedia",
  sh("~/.config/hypr/scripts/yeelights.sh on &> /tmp/main.log"))
hl.bind(mainMod .. " SHIFT + XF86AudioMedia",
  sh("~/.config/hypr/scripts/yeelights.sh off &> /tmp/shift_main.log"))

-- ======================================================================
-- Window state
-- ======================================================================

-- forcerendererreload is not (yet) in the new dispatcher namespace; use raw.
hl.bind(mainMod .. " + R", hl.dispatch_raw("forcerendererreload"))

hl.bind(mainMod .. " SHIFT + F",
  hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + F", hl.dsp.window.center())

-- pypr layout-center.
hl.bind(mainMod .. " + C",     sh("pypr layout_center toggle"))
hl.bind(mainMod .. " + left",  sh("pypr layout_center prev"))
hl.bind(mainMod .. " + right", sh("pypr layout_center next"))

-- ======================================================================
-- Movement / workspaces
-- ======================================================================
-- The block below has TWO halves:
--   * USE_HY3 = false  -> vanilla focus / move dispatchers
--   * USE_HY3 = true   -> hy3:* equivalents via dispatch_raw
-- Last bind wins on a given key, so we register only the active half.

if not USE_HY3 then
  -- Vanilla fallback (current keybinds.conf:49-74).
  hl.bind(mainMod .. " + Q", hl.dsp.window.close())

  hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "d" }))
  hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "l" }))
  hl.bind(mainMod .. " + h",     hl.dsp.focus({ direction = "l" }))
  hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
  hl.bind(mainMod .. " + l",     hl.dsp.focus({ direction = "r" }))
  hl.bind(mainMod .. " + j",     hl.dsp.focus({ direction = "d" }))
  hl.bind(mainMod .. " + k",     hl.dsp.focus({ direction = "u" }))
  hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "u" }))

  hl.bind(mainMod .. " SHIFT + 0", hl.dsp.window.move({ workspace = "10" }))
  for i = 1, 9 do
    hl.bind(mainMod .. " SHIFT + " .. i,
      hl.dsp.window.move({ workspace = tostring(i) }))
  end

  hl.bind(mainMod .. " ALT + down",  hl.dsp.window.move({ direction = "d" }))
  hl.bind(mainMod .. " ALT + h",     hl.dsp.window.move({ direction = "l" }))
  hl.bind(mainMod .. " ALT + l",     hl.dsp.window.move({ direction = "r" }))
  hl.bind(mainMod .. " ALT + left",  hl.dsp.window.move({ direction = "l" }))
  hl.bind(mainMod .. " ALT + right", hl.dsp.window.move({ direction = "r" }))
  hl.bind(mainMod .. " ALT + up",    hl.dsp.window.move({ direction = "u" }))
else
  -- hy3 path (current keybinds.conf:76-105).
  -- TODO: VERIFY POST-UPGRADE. Plugin dispatchers may move to a Lua
  -- namespace like hl.plugins.hy3.* instead of dispatch_raw.
  hl.bind(mainMod .. " + v", hl.dispatch_raw("hy3:makegroup, v, force_ephemeral"))
  hl.bind(mainMod .. " + b", hl.dispatch_raw("hy3:makegroup, h, force_ephemeral"))
  hl.bind(mainMod .. " + t", hl.dispatch_raw("hy3:makegroup, tab, toggle"))
  hl.bind(mainMod .. " + Q", hl.dispatch_raw("hy3:killactive"))

  hl.bind(mainMod .. " + h",     hl.dispatch_raw("hy3:movefocus, left"))
  hl.bind(mainMod .. " + j",     hl.dispatch_raw("hy3:movefocus, down"))
  hl.bind(mainMod .. " + k",     hl.dispatch_raw("hy3:movefocus, up"))
  hl.bind(mainMod .. " + l",     hl.dispatch_raw("hy3:movefocus, right"))
  hl.bind(mainMod .. " + down",  hl.dispatch_raw("hy3:movefocus, down"))
  hl.bind(mainMod .. " + left",  hl.dispatch_raw("hy3:movefocus, left"))
  hl.bind(mainMod .. " + right", hl.dispatch_raw("hy3:movefocus, right"))
  hl.bind(mainMod .. " + up",    hl.dispatch_raw("hy3:movefocus, up"))

  hl.bind(mainMod .. " ALT + h",     hl.dispatch_raw("hy3:movewindow, left"))
  hl.bind(mainMod .. " ALT + j",     hl.dispatch_raw("hy3:movewindow, down"))
  hl.bind(mainMod .. " ALT + k",     hl.dispatch_raw("hy3:movewindow, up"))
  hl.bind(mainMod .. " ALT + l",     hl.dispatch_raw("hy3:movewindow, right"))
  hl.bind(mainMod .. " ALT + down",  hl.dispatch_raw("hy3:movewindow, down"))
  hl.bind(mainMod .. " ALT + left",  hl.dispatch_raw("hy3:movewindow, left"))
  hl.bind(mainMod .. " ALT + right", hl.dispatch_raw("hy3:movewindow, right"))
  hl.bind(mainMod .. " ALT + up",    hl.dispatch_raw("hy3:movewindow, up"))

  hl.bind(mainMod .. " SHIFT + k", hl.dispatch_raw("hy3:changefocus, raise"))

  for i = 1, 9 do
    hl.bind(mainMod .. " SHIFT + " .. i,
      hl.dispatch_raw("hy3:movetoworkspace, " .. i .. ", follow"))
  end
end

-- ======================================================================
-- pypr scratchpads / zoom / menu
-- ======================================================================

hl.bind(mainMod .. " + Z",             sh("pypr zoom ++0.17"))
hl.bind(mainMod .. " SHIFT + Z",       sh("pypr zoom"))
hl.bind(mainMod .. " + semicolon",     sh("pypr menu"))
hl.bind("ALT_R + B",                   sh("pypr toggle beeper"))
hl.bind("ALT_R + M",                   sh("pypr toggle betterbird"))

-- ======================================================================
-- Floating / layout / workspaces
-- ======================================================================

hl.bind(mainMod .. " + O",      hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SLASH",  hl.dsp.layout(""))

hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = "10" }))
for i = 1, 9 do
  hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = tostring(i) }))
end

hl.bind(mainMod .. " CTRL + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " CTRL + l",     hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " CTRL + left",  hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " CTRL + h",     hl.dsp.focus({ workspace = "e-1" }))

-- Special workspace (scratchpad).
hl.bind(mainMod .. " + S",       hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " SHIFT + S", sh("pypr toggle_special magic"))

-- Scroll through workspaces with mainMod + scroll wheel.
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- ======================================================================
-- Mouse binds (move/resize)
-- ======================================================================

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + Control_L", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize({ relative = true }), { mouse = true })
hl.bind(mainMod .. " + ALT_L",     hl.dsp.window.resize(), { mouse = true })

-- ======================================================================
-- Media keys
-- ======================================================================

hl.bind("XF86AudioNext",        sh("playerctl next"),       { locked = true })
hl.bind("XF86AudioPlay",        sh("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",        sh("playerctl previous"),   { locked = true })
hl.bind("XF86AudioMute",        sh("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioLowerVolume", sh("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume", sh("wpctl set-volume --limit 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",
  sh("brightnessctl --device='intel_backlight' --exponent=3 --min-value=1 set 5%-"),
  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",
  sh("brightnessctl --device='intel_backlight' --exponent=3 set +5%"),
  { locked = true, repeating = true })

-- ======================================================================
-- Gestures
-- ======================================================================

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- ======================================================================
-- "clean" submap: disables all keybinds except the escape combo.
-- ======================================================================

hl.define_submap("clean", function()
  -- Only one bind in this submap: mainMod+SHIFT+GRAVE returns to default.
  hl.bind(mainMod .. " SHIFT + GRAVE", hl.dsp.submap("reset"))
end)

-- Enter the clean submap.
hl.bind(mainMod .. " SHIFT + GRAVE", hl.dsp.submap("clean"))

-- ALT+TAB cyclenext (lives outside any submap).
hl.bind("ALT + TAB", hl.dsp.window.cycle_next())
