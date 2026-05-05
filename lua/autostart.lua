-- Autostart: run-once-at-session-start commands and run-on-every-reload commands.
-- Replaces conf.d/exec.conf.

-- ===== exec-once equivalents (run on hyprland.start) =====
hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm finalize")

  hl.exec_cmd("uwsm-app -- secret-tool lookup type unlock-keyring")
  hl.exec_cmd("uwsm-app -- /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
  hl.exec_cmd("uwsm-app -- batsignal -w 9 -c 6 -d 3")
  hl.exec_cmd("uwsm-app -- hyprpanel")
  hl.exec_cmd("uwsm-app -- nm-applet --indicator")
  hl.exec_cmd("uwsm-app -- pypr")
  hl.exec_cmd("uwsm-app -- udiskie --no-automount --notify")

  -- usbwatch: still references the debug-build path. Flagged for future cleanup.
  hl.exec_cmd("uwsm-app -- ~/Documents/usbwatch-rs/target/release/usbwatch run " ..
              "--rules ~/.config/hypr/scripts/usbwatch_scrcpy.yml")

  hl.exec_cmd("uwsm-app -- hyprpm reload -n")

  -- Hyprland Monitor Manager - auto-manage displays and lid.
  hl.exec_cmd("hmonitor daemon")
end)

-- ===== exec equivalent (runs on every reload) =====
-- Top-level call: re-runs every time this Lua file is loaded.
hl.exec_cmd("hmonitor refresh")
