-- Autostart commands.
-- Replaces conf.d/exec.conf.

-- Commands launched once per session via uwsm-app (scoped to user systemd).
local uwsm_apps = {
  "secret-tool lookup type unlock-keyring",
  "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
  "batsignal -w 9 -c 6 -d 3",
  "nm-applet --indicator",
  "pypr",
  "udiskie --no-automount --notify",
  -- TODO: usbwatch still references the debug-build path; revisit when the
  -- binary lands in $PATH.
  "~/Documents/usbwatch-rs/target/release/usbwatch run --rules ~/.config/hypr/scripts/usbwatch_scrcpy.yml",
  "hyprpm reload -n",
  "solaar --window hide",
}

-- Commands launched once per session directly (no uwsm wrapper).
local once = {
  "uwsm finalize",
  "hmonitor daemon", -- auto-manages displays + lid
}

hl.on("hyprland.start", function()
  for _, cmd in ipairs(once) do
    hl.exec_cmd(cmd)
  end
  for _, cmd in ipairs(uwsm_apps) do
    hl.exec_cmd("uwsm-app -- " .. cmd)
  end
end)

-- Runs on every config (re)load. hmonitor reads its profile DB and applies
-- the matching layout, so triggering a refresh after each reload keeps the
-- declared monitors.lua fallbacks consistent with hmonitor's view.
hl.exec_cmd("hmonitor refresh")
