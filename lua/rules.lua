-- Window rules.
--
-- Style: bucket rules by their shape, drive them from data tables, fall back to
-- explicit calls only for the genuinely one-of-a-kind specimens.

local rule = hl.window_rule

-- ======================================================================
-- Class-only floats
-- ======================================================================

local float_classes = {
  "hyprland-share-picker", "eu.betterbird.Betterbird", "scrcpy",
  "org.kde.kdeconnect.daemon", "org.kde.kdeconnect.handler",
  "org.kde.kdeconnect.app", "org.freedesktop.impl.portal.desktop.kde",
  "qv4l2", "Waydroid", "Cadence", "org.gnome.Evolution", "Catia",
  "Jack-keyboard", "Ledger Live", "mpv", "clipse",
  "com.saivert.pwvucontrol", "com.usebottles.bottles", "cpupower-gui",
  "electron", "insta360 studio.exe", ".*\\.exe", "nm-connection-editor",
  "org.gabmus.whatip", "org.gnome.Nautilus", "org.gnome.seahorse.Application",
  "org.prismlauncher.PrismLauncher", "rdesktop", "xdg-desktop-portal-gtk",
  "Chromium", "io.missioncenter.MissionCenter", "Matplotlib", "QjackCtl",
  "com.github.wwmm.easyeffects", "YouTube Music", "imv",
}
for _, cls in ipairs(float_classes) do
  rule({ match = { class = "^(" .. cls .. ")$" }, float = true })
end

-- ======================================================================
-- Class-only "center"
-- ======================================================================

local center_classes = {
  "UltiMaker-Cura", "QjackCtl", "com.github.wwmm.easyeffects",
  "YouTube Music", "Matplotlib", "imv",
}
for _, cls in ipairs(center_classes) do
  rule({ match = { class = "^(" .. cls .. ")$" }, center = true })
end

-- ======================================================================
-- Title-only floats
-- ======================================================================

local float_titles = {
  "Open File", "Zoom Workplace", "Bluetooth Devices", "Dolphin 2412",
  "EspNow Lights", "Picture-in-Picture", "blueman-manager",
  "_crx_nngceckbapebfimnlniiiahkandclblb",
}
for _, t in ipairs(float_titles) do
  rule({ match = { title = "^(" .. t .. ")$" }, float = true })
end

-- ======================================================================
-- "immediate" (tearing-friendly games / fullscreen apps)
-- ======================================================================

local immediate_classes = { "tunic.exe", "dev.suyu_emu.suyu", "org.eden_emu.eden", "Ryujinx" }
local immediate_titles  = { "Overwatch", "Sword Of The Sea", "Trackmania" }

for _, cls in ipairs(immediate_classes) do
  rule({ match = { class = "^(" .. cls .. ")$" }, immediate = true })
end
for _, t in ipairs(immediate_titles) do
  rule({ match = { title = "^(" .. t .. ")$" }, immediate = true })
end

-- ======================================================================
-- Multi-property apps (float + center + size, etc.)
-- ======================================================================

---@class WindowSpec
---@field by      "class"|"title"
---@field name    string                  identifier (becomes regex ^(name)$)
---@field float?  boolean
---@field center? boolean
---@field size?   string                  "W H"
---@field extras? table[]                 list of additional rule({...}) bodies (arbitrary keys)

---@type WindowSpec[]
local app_specs = {
  -- Bitwarden initial popup. The dynamic-resize for the post-load title is
  -- handled in lua/events.lua.
  { by = "title", name = "Bitwarden",   float = true, center = true,     size = "920 780" },

  -- Ledger Live: float + fixed size.
  { by = "class", name = "Ledger Live", float = true, size = "1368 1026" },

  -- Minecraft: float, center, dim, immediate, fixed size.
  {
    by = "title",
    name = "Minecraft",
    float = true,
    center = true,
    size = "2200 1300",
    extras = { { dim_around = true }, { immediate = true } },
  },

  -- clipse picker.
  { by = "class", name = "clipse", float = true, size = "622 652" },

  -- Hidden wezterm helper window: float + pin + dim + size + always-focus.
  {
    by = "class",
    name = "wezterm_hidden",
    float = true,
    center = true,
    size = "360 40",
    extras = {
      { pin = true },
      { stay_focused = true },
      { dim_around = true },
    },
  },
}

for _, s in ipairs(app_specs) do
  local match = { [s.by] = "^(" .. s.name .. ")$" }
  -- Each property of the spec becomes its own one-property rule (Hyprland
  -- prefers single-property rules; multi-property rules don't always merge).
  if s.float then rule({ match = match, float = true }) end
  if s.center then rule({ match = match, center = true }) end
  if s.size then rule({ match = match, size = s.size }) end
  for _, extra in ipairs(s.extras or {}) do
    extra.match = match
    rule(extra)
  end
end

-- ======================================================================
-- One-of-a-kind rules
-- ======================================================================

-- Suppress maximize events globally.
rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

-- Fix XWayland drag glitches.
rule({
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

-- Hyprland-run launcher: bottom-left positioning.
rule({
  name = "move-hyprland-run",
  match = { class = "hyprland-run" },
  move = "20 monitor_h-120",
  float = true,
})

-- Steam Proton overlay: kill all decorations.
rule({
  name = "Steam Proton",
  match = { class = "steam_proton" },
  decorate = false,
  opacity = 1,
  no_anim = true,
  no_shadow = true,
  rounding = 0,
})

-- No-blur on completely empty class+title (avoids wasting blur on transients).
rule({ match = { class = "^$", title = "^$" }, no_blur = true })

-- Sticky-focus window naming convention.
rule({ match = { title = "^(.*opfullpath.*)$" }, stay_focused = true })

-- Specific compound matchers.
rule({ match = { class = "^(com.github.Aylur.ags)$", title = "Settings$" }, float = true })
rule({ match = { class = "^(firefox-nightly)$", title = "^$" }, float = true })
rule({ match = { class = "^(python3)$", title = "^(Tor Browser)$" }, float = true })

-- Per-class size caps.
rule({ match = { class = "^(contour)$" }, max_size = "2468 1425" })
rule({ match = { class = "^(firefox-nightly)$" }, max_size = "2468 1425" })
