-- Window rules. Includes the 3 stray windowrule blocks formerly in
-- hyprland.conf (suppress-maximize-events, fix-xwayland-drags, move-hyprland-run).

-- Suppress maximize events globally. The duplicate from windowrules.conf:102
-- has been removed; this single block is the authoritative one.
hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland.
hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})

-- Hyprland-run: bottom-left positioning.
hl.window_rule({
  name = "move-hyprland-run",
  match = { class = "hyprland-run" },
  move = "20 monitor_h-120",
  float = true,
})

-- ===== Generic class/title rules (from former windowrules.conf) =====

local function rule(t) hl.window_rule(t) end

rule({ match = { class = "^$", title = "^$" }, no_blur = true })
rule({ match = { title = "^(Overwatch)$" }, immediate = true })
rule({ match = { title = "^(Open File)$" }, float = true })
rule({ match = { title = "^(Zoom Workplace)$" }, float = true })

rule({
  name = "Steam Proton",
  match = { class = "steam_proton" },
  decorate = false,
  opacity = 1,
  no_anim = true,
  no_shadow = true,
  rounding = 0,
})

rule({ match = { title = "^(Sword Of The Sea)$" }, immediate = true })
rule({ match = { class = "^(tunic.exe)$" }, immediate = true })
rule({ match = { class = "^(dev.suyu_emu.suyu)$" }, immediate = true })
rule({ match = { class = "^(org.eden_emu.eden)$" }, immediate = true })
rule({ match = { class = "^(Ryujinx)$" }, immediate = true })
rule({ match = { title = "^(Trackmania)$" }, immediate = true })
rule({ match = { class = "^(UltiMaker-Cura)$" }, center = true })
rule({ match = { class = "^(hyprland-share-picker)$" }, float = true })
rule({ match = { class = "^(eu.betterbird.Betterbird)$" }, float = true })
rule({ match = { class = "^(Matplotlib)$" }, float = true })
rule({ match = { class = "^(Matplotlib)$" }, center = true })
rule({ match = { class = "^(imv)$" }, float = true })
rule({ match = { class = "^(imv)$" }, center = true })
rule({ match = { class = "^(imv)$" }, size = "1920 1080" })
rule({ match = { class = "^(scrcpy)$" }, float = true })
rule({ match = { class = "^(org.kde.kdeconnect.daemon)$" }, float = true })
rule({ match = { class = "^(org.kde.kdeconnect.handler)$" }, float = true })
rule({ match = { class = "^(qv4l2)$" }, float = true })
rule({ match = { class = "^(org.kde.kdeconnect.app)$" }, float = true })
rule({ match = { class = "^(org.freedesktop.impl.portal.desktop.kde)$" }, float = true })
rule({ match = { class = "^(Waydroid)$" }, float = true })

-- Bitwarden: float + center + size. Note: dynamic_float (events.lua) also
-- applies a percentage-based resize when title changes after the password
-- manager finishes loading; this rule covers the initial window.
rule({ match = { title = "^(Bitwarden)$" }, float = true })
rule({ match = { title = "^(Bitwarden)$" }, center = true })
rule({ match = { title = "^(Bitwarden)$" }, size = "920 780" })

rule({ match = { title = "^(Bluetooth Devices)$" }, float = true })
rule({ match = { class = "^(Cadence)$" }, float = true })
rule({ match = { class = "^(org.gnome.Evolution)$" }, float = true })
rule({ match = { class = "^(Catia)$" }, float = true })
rule({ match = { title = "^(Dolphin 2412)$" }, float = true })
rule({ match = { title = "^(EspNow Lights)$" }, float = true })
rule({ match = { class = "^(Jack-keyboard)$" }, float = true })
rule({ match = { class = "^(Ledger Live)$" }, float = true })
rule({ match = { class = "^(Ledger Live)$" }, size = "1368 1026" })
rule({ match = { class = "^(mpv)$" }, float = true })
rule({ match = { title = "^(Minecraft)$" }, center = true })
rule({ match = { title = "^(Minecraft)$" }, dim_around = true })
rule({ match = { title = "^(Minecraft)$" }, float = true })
rule({ match = { title = "^(Minecraft)$" }, immediate = true })
rule({ match = { title = "^(Minecraft)$" }, size = "2200 1300" })
rule({ match = { title = "^(Picture-in-Picture)$" }, float = true })
rule({ match = { class = "^(QjackCtl)$" }, center = true })
rule({ match = { class = "^(QjackCtl)$" }, float = true })
rule({ match = { title = "^(.*opfullpath.*)$" }, stay_focused = true })

rule({ match = { class = "^(YouTube Music)$" }, center = true })
rule({ match = { class = "^(YouTube Music)$" }, float = true })
rule({ match = { title = "^(blueman-manager)$" }, float = true })
rule({ match = { class = "^(clipse)$" }, float = true })
rule({ match = { class = "^(clipse)$" }, size = "622 652" })
rule({ match = { class = "^(com.github.Aylur.ags)$", title = "Settings$" }, float = true })
rule({ match = { class = "^(com.github.wwmm.easyeffects)$" }, center = true })
rule({ match = { class = "^(com.github.wwmm.easyeffects)$" }, float = true })
rule({ match = { class = "^(com.saivert.pwvucontrol)$" }, float = true })
rule({ match = { class = "^(com.usebottles.bottles)$" }, float = true })
rule({ match = { class = "^(contour)$" }, max_size = "2468 1425" })
rule({ match = { class = "^(cpupower-gui)$" }, float = true })
rule({ match = { class = "^(electron)$" }, float = true })
rule({ match = { class = "^(firefox-nightly)$" }, max_size = "2468 1425" })
rule({ match = { class = "^(firefox-nightly)$", title = "^$" }, float = true })
rule({ match = { class = "^(insta360 studio.exe)$" }, float = true })
rule({ match = { class = "^(.*\\.exe)$" }, float = true })
rule({ match = { class = "^(nm-connection-editor)$" }, float = true })
rule({ match = { class = "^(org.gabmus.whatip)$" }, float = true })
rule({ match = { class = "^(org.gnome.Nautilus)$" }, float = true })
rule({ match = { class = "^(org.gnome.seahorse.Application)$" }, float = true })
rule({ match = { class = "^(org.prismlauncher.PrismLauncher)$" }, float = true })
rule({ match = { class = "^(python3)$", title = "^(Tor Browser)$" }, float = true })
rule({ match = { class = "^(rdesktop)$" }, float = true })

rule({ match = { class = "^(wezterm_hidden)$" }, float = true })
rule({ match = { class = "^(wezterm_hidden)$" }, size = "360 40" })
rule({ match = { class = "^(wezterm_hidden)$" }, center = true })
rule({ match = { class = "^(wezterm_hidden)$" }, pin = true })
rule({ match = { class = "^(wezterm_hidden)$" }, stay_focused = true })
rule({ match = { class = "^(wezterm_hidden)$" }, dim_around = true })

rule({ match = { class = "^(xdg-desktop-portal-gtk)$" }, float = true })

rule({ match = { class = "Chromium" }, float = true })
rule({ match = { class = "io.missioncenter.MissionCenter" }, float = true })
