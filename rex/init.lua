-- Rex config — keybinds migrated from ~/.config/herdr-app/keys.json
-- herdr "space" ≈ Rex session, herdr "tab" ≈ Rex tab.

------------------------------------------------------------------------
-- Pane focus (alt+hjkl / alt+arrows)
------------------------------------------------------------------------
for key, dir in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  rex.bind("alt+" .. key, "pane.focus", { direction = dir })
  -- herdr pane.swap → Rex pane.move
  rex.bind("alt+shift+" .. key, "pane.move", { direction = dir })
end
rex.bind("alt+left", "pane.focus", { direction = "left" })
rex.bind("alt+right", "pane.focus", { direction = "right" })

------------------------------------------------------------------------
-- Font zoom
------------------------------------------------------------------------
rex.bind("cmd+shift+=", "client.font.increase")
rex.bind("cmd+=", "client.font.increase")
rex.bind("cmd+-", "client.font.decrease")
rex.bind("cmd+0", "client.font.reset")

------------------------------------------------------------------------
-- Tabs
------------------------------------------------------------------------
for i = 1, 9 do
  rex.bind("cmd+" .. i, "client.tab.goto", { index = i })
end
rex.bind("cmd+pagedown", "client.tab.next")
rex.bind("cmd+pageup", "client.tab.previous")
rex.bind("ctrl+tab", "client.tab.next")
rex.bind("ctrl+shift+tab", "client.tab.previous")
rex.bind("alt+]", "client.tab.next")
rex.bind("alt+[", "client.tab.previous")
rex.bind("cmd+t", "client.tab.new")
rex.bind("cmd+shift+t", "client.tab.new")
rex.bind("cmd+shift+w", "client.tab.close")
rex.bind("f2", "client.tab.rename")

------------------------------------------------------------------------
-- Sessions (herdr spaces)
------------------------------------------------------------------------
rex.bind("cmd+shift+pagedown", "session.next")
rex.bind("cmd+shift+pageup", "session.previous")
rex.bind("cmd+n", "session.new")
rex.bind("cmd+shift+n", "session.new")
rex.bind("shift+f2", "session.rename")
rex.unbind("cmd+k") -- Rex default: session.switch
rex.bind("cmd+p", "session.switch")

------------------------------------------------------------------------
-- Panes
------------------------------------------------------------------------
rex.bind("cmd+shift+o", "pane.split", { direction = "right" })
rex.bind("cmd+shift+e", "pane.split", { direction = "down" })
rex.bind("cmd+shift+x", "pane.close")
rex.bind("cmd+shift+z", "pane.zoom")
rex.bind("cmd+shift+enter", "pane.zoom")

------------------------------------------------------------------------
-- App
------------------------------------------------------------------------
rex.bind("cmd+shift+b", "client.sidebar.toggle")
rex.bind("cmd+shift+p", "client.palette.toggle")
rex.bind("cmd+,", "client.settings")

------------------------------------------------------------------------
-- Name the session after the focused pane's git root (no-op outside git)
------------------------------------------------------------------------
local function block_cwd(sid, bid)
  local ok, proc = pcall(rex.call, "block.method",
    { session_id = sid, block_id = bid, method = "process" })
  if ok and proc then
    if proc.foreground and proc.foreground.cwd then return proc.foreground.cwd end
    for _, a in ipairs(proc.ancestors or {}) do
      if a.cwd then return a.cwd end
    end
  end
  local ok2, res = pcall(rex.call, "block.method",
    { session_id = sid, block_id = bid, method = "pwd" })
  if ok2 and res and res.pwd then
    local path = res.pwd:gsub("^file://[^/]*", "")
    return (path:gsub("%%(%x%x)", function(h) return string.char(tonumber(h, 16)) end))
  end
end

rex.action({
  name = "session_name_from_git",
  title = "Name Session After Git Root",
  run = function(ctx)
    if not ctx.session_id then return end
    local bid = ctx.block_id
    if not bid then -- e.g. invoked via `rex do -s`: use the focused pane
      local ok, view = pcall(rex.call, "session.view", { session_id = ctx.session_id })
      if ok and view then
        for _, w in ipairs(view.windows or {}) do
          if w.window_id == view.active_window_id then bid = w.focused_block_id end
        end
      end
    end
    if not bid then return end
    local cwd = block_cwd(ctx.session_id, bid)
    if not cwd then return end
    local res = rex.exec.start({ "git", "-C", cwd, "rev-parse", "--show-toplevel" }):wait()
    if not res.ok then return end
    local root = res.stdout:gsub("%s+$", "")
    local name = root:match("([^/]+)$")
    if not name or name == "" then return end
    rex.call("session.set_label", { session_id = ctx.session_id, label = name })
  end,
})

------------------------------------------------------------------------
-- Leader key (tmux-style prefix)
------------------------------------------------------------------------
local leader = "cmd+a"

-- Bind `key` pressed after the leader.
local function lbind(key, action, args)
  rex.bind(leader .. ">" .. key, action, args)
end

lbind(leader, "pane.select_all") -- leader twice: keep select-all reachable
lbind("c", "client.tab.new")
lbind(",", "client.tab.rename")
lbind("r", "session.rename")
lbind("shift+r", "session_name_from_git")
lbind("shift+9", "session.previous")
lbind("shift+0", "session.next")
lbind("b", "client.sidebar.toggle")
lbind("x", "pane.close")
lbind("v", "pane.split", { direction = "right" })
lbind("-", "pane.split", { direction = "down" })
lbind("h", "pane.focus", { direction = "left" })
lbind("j", "pane.focus", { direction = "down" })
lbind("k", "pane.focus", { direction = "up" })
lbind("l", "pane.focus", { direction = "right" })
lbind("n", "client.tab.next")
lbind("p", "client.tab.previous")

------------------------------------------------------------------------
-- Terminal
------------------------------------------------------------------------
rex.bind("cmd+left", "pane.send_key", { key = "alt+b" })       -- word left
rex.bind("cmd+right", "pane.send_key", { key = "alt+f" })      -- word right
rex.bind("cmd+c", "pane.copy")
rex.bind("cmd+shift+c", "pane.copy")
rex.bind("cmd+v", "pane.paste")
rex.bind("cmd+shift+v", "pane.paste")
rex.bind("cmd+f", "client.find.open")
