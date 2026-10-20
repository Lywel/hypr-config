-- Summonable apps, reached from the "apps" submap (Super+D, then the app's key).
-- A shown app floats on the current workspace and a hidden one sits on its own
-- special workspace. Super+D alone hides the focused app.

local A = require("lua.apps")

local apps = {
  { key = "b", name = "beeper",     class = "Beeper",                   cmd = "beeper",     width = 55, height = 80 },
  { key = "m", name = "betterbird", class = "eu.betterbird.Betterbird", cmd = "eu.betterbird.Betterbird", width = 70, height = 90 },
  { key = "s", name = "slack", class = "com.slack.Slack", cmd = "com.slack.Slack", width = 70, height = 90 },
  { key = "t", name = "teams", class = "com.github.IsmaelMartinez.teams_for_linux", cmd = "com.github.IsmaelMartinez.teams_for_linux", width = 70, height = 90 },
}

for _, app in ipairs(apps) do
  local match = { class = "^(" .. app.class .. ")$" }
  hl.window_rule({ match = match, float = true })
  hl.window_rule({ match = match, center = true })
end

local function fit(app, window)
  local monitor = hl.get_active_monitor()
  if not monitor then return end
  hl.dispatch(hl.dsp.window.resize({
    window = window,
    x = math.floor(monitor.width * app.width / 100),
    y = math.floor(monitor.height * app.height / 100),
  }))
  hl.dispatch(hl.dsp.window.center({ window = window, action = "on" }))
end

local function hide(app)
  for _, window in ipairs(hl.get_windows({ class = app.class })) do
    hl.dispatch(hl.dsp.window.move({ window = window, workspace = "special:" .. app.name, follow = false }))
  end
end

-- Windows move oldest first so dialogs end up on top, and focus goes to the last
-- used one so a pending dialog stays above its parent.
local function show(app, windows)
  table.sort(windows, function(a, b) return a.stable_id < b.stable_id end)
  local workspace = hl.get_active_workspace()
  local last_used = windows[1]
  for _, window in ipairs(windows) do
    hl.dispatch(hl.dsp.window.move({ window = window, workspace = workspace, follow = false }))
    if window.focus_history_id < last_used.focus_history_id then last_used = window end
  end
  fit(app, windows[1])
  hl.dispatch(hl.dsp.focus({ window = last_used }))
end

local function summon(app)
  local windows = hl.get_windows({ class = app.class })
  local active = hl.get_active_window()
  if #windows == 0 then
    hl.exec_cmd(A.launch .. " " .. app.cmd)
  elseif active and active.class == app.class then
    hide(app)
  else
    show(app, windows)
  end
end

hl.define_submap("apps", "reset", function()
  for _, app in ipairs(apps) do
    hl.bind(app.key, function() summon(app) end)
  end
  hl.bind("catchall", hl.dsp.submap("reset"))
end)

local by_class = {}
for _, app in ipairs(apps) do
  by_class[app.class] = app
end

-- Only the app's first window gets the scratch size, so its dialogs keep their own.
hl.on("window.open", function(window)
  local app = by_class[window.class]
  if not app or #hl.get_windows({ class = app.class }) > 1 then return end
  fit(app, window)
end)

hl.bind(A.mainMod .. " + D", function()
  local active = hl.get_active_window()
  local app = active and by_class[active.class]
  if app then
    hide(app)
  else
    hl.dispatch(hl.dsp.submap("apps"))
  end
end)
