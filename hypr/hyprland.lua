------------------
---- MONITORS ----
------------------

-- SAMSUNG S90D
hl.monitor({
	output = "DP-1",
	mode = "3840x2160@120",
	position = "0x0",
	scale = 1.25,
	bitdepth = 10,
	cm = "hdr",
})

-- ASUS VG278
hl.monitor({
	output = "HDMI-A-1",
	mode = "1920x1080@60",
	position = "-1920x0",
	scale = 1.0,
	bitdepth = 10,
	cm = "hdr",
})

hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})

for i = 1, 10 do
	if i <= 5 then
		hl.workspace_rule({ workspace = tostring(i), monitor = "DP-1" })
	else
		hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1", gaps_in = 5, gaps_out = 8 })
	end
end

------------------
---- PROGRAMS ----
------------------

local terminal = "ghostty"
local file_manager = "dolphin"
local menu = "wofi --show drun"

------------------
---- AUTOSTART ----
------------------

hl.on("hyprland.start", function()
	hl.exec_cmd("quickshell")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("hyprpaper")
end)

------------------
---- LOOK AND FEEL ----
------------------

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 12,

		border_size = 2,

		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing = false,

		layout = "dwindle",
	},

	decoration = {
		rounding = 10,
		rounding_power = 0,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
	dwindle = {
		preserve_split = true, -- You probably want this
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
	master = {
		new_status = "master",
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
	scrolling = {
		fullscreen_on_one_column = true,
	},
})

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		repeat_rate = 35,
		repeat_delay = 200,

		follow_mouse = 1,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = false,
		},
	},
})

---------------------
---- KEYBINDINGS ----
---------------------

local main_mod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(main_mod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(main_mod .. " + W", hl.dsp.window.close())

hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(file_manager))
hl.bind(main_mod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(main_mod .. " + SHIFT + L", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ 1 && hyprlock"))
hl.bind(main_mod .. " + P", hl.dsp.window.pseudo())

--- Scripts
hl.bind(main_mod .. " + D", hl.dsp.exec_cmd("~/.config/hypr/scripts/focus_discord.sh"))
hl.bind("CTRL + SHIFT + S", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot_tool.sh"))
-- Move focus with main_mod + vimkeys
hl.bind(main_mod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Move windows with main_mod + arrow keys
hl.bind(main_mod .. " + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(main_mod .. " + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(main_mod .. " + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(main_mod .. " + down", hl.dsp.window.move({ direction = "down" }))

-- Switch workspaces with main_mod + [0-9]
-- Move active window to a workspace with main_mod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	-- F1-10 to moving windows
	hl.bind("F" .. tostring(i), hl.dsp.window.move({ workspace = i }))
	--hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(main_mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(main_mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with main_mod + scroll
hl.bind(main_mod .. " + TAB", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with main_mod + LMB/RMB and dragging
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
