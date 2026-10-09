-- Summonable apps. Each one lives on its own special workspace, floating and
-- centered, and is reached from the "apps" submap (Super+U, then its key).
-- Super+U hides the app instead when one is shown on the focused monitor.

local A = require("lua.apps")

local apps = {
  { key = "b", name = "beeper",     class = "Beeper",                   cmd = "beeper",     width = 55, height = 80 },
  { key = "m", name = "betterbird", class = "eu.betterbird.Betterbird", cmd = "eu.betterbird.Betterbird", width = 70, height = 90 },
  { key = "s", name = "slack", class = "com.slack.Slack", cmd = "com.slack.Slack", width = 70, height = 90 },
  { key = "t", name = "teams", class = "com.github.IsmaelMartinez.teams_for_linux", cmd = "com.github.IsmaelMartinez.teams_for_linux", width = 70, height = 90 },
}

for _, app in ipairs(apps) do
  local match = { class = "^(" .. app.class .. ")$" }
  hl.window_rule({ match = match, workspace = "special:" .. app.name })
  hl.window_rule({ match = match, float = true })
  hl.window_rule({ match = match, center = true })
end

local function summon(app)
  if #hl.get_windows({ class = app.class }) == 0 then
    hl.exec_cmd(A.launch .. " " .. app.cmd)
  else
    hl.dispatch(hl.dsp.workspace.toggle_special(app.name))
  end
end

hl.define_submap("apps", "reset", function()
  for _, app in ipairs(apps) do
    hl.bind(app.key, function() summon(app) end)
  end
  hl.bind("catchall", hl.dsp.submap("reset"))
end)

local by_workspace = {}
local by_class = {}
for _, app in ipairs(apps) do
  by_workspace["special:" .. app.name] = app
  by_class[app.class] = app
end

-- Only the app's first window gets the scratch size, so its dialogs keep their own.
hl.on("window.open", function(window)
  local app = by_class[window.class]
  local monitor = hl.get_active_monitor()
  if not app or not monitor or #hl.get_windows({ class = app.class }) > 1 then return end
  hl.dispatch(hl.dsp.window.resize({
    window = window,
    x = math.floor(monitor.width * app.width / 100),
    y = math.floor(monitor.height * app.height / 100),
  }))
  hl.dispatch(hl.dsp.window.center({ window = window, action = "on" }))
end)

hl.bind(A.mainMod .. " + U", function()
  local shown = hl.get_active_special_workspace()
  local app = shown and by_workspace[shown.name]
  if app then
    hl.dispatch(hl.dsp.workspace.toggle_special(app.name))
  else
    hl.dispatch(hl.dsp.submap("apps"))
  end
end)
