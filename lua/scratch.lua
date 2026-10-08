-- Summonable apps. Each one lives on its own special workspace, floating and
-- centered, and is reached from the "apps" submap (Super+U, then its key).
-- Super+U hides the app instead when one is shown on the focused monitor.

local A = require("lua.apps")

local apps = {
  { key = "b", name = "beeper",     class = "Beeper",                   cmd = "beeper",     size = "monitor_w*0.55 monitor_h*0.8" },
  { key = "m", name = "betterbird", class = "eu.betterbird.Betterbird", cmd = "betterbird", size = "monitor_w*0.7 monitor_h*0.9" },
}

for _, app in ipairs(apps) do
  local match = { class = "^(" .. app.class .. ")$" }
  hl.window_rule({ match = match, workspace = "special:" .. app.name })
  hl.window_rule({ match = match, float = true })
  hl.window_rule({ match = match, center = true })
  hl.window_rule({ match = match, size = app.size })
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
for _, app in ipairs(apps) do
  by_workspace["special:" .. app.name] = app
end

hl.bind(A.mainMod .. " + U", function()
  local shown = hl.get_active_special_workspace()
  local app = shown and by_workspace[shown.name]
  if app then
    hl.dispatch(hl.dsp.workspace.toggle_special(app.name))
  else
    hl.dispatch(hl.dsp.submap("apps"))
  end
end)
