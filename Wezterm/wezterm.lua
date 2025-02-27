-- buat file di home directory
-- contoh
-- C:\Users\PCode\.wezterm.lua
-- compu code dibawah ini :
-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- config for on load fullscreen
-- wezterm.on("gui-startup", function(cmd)
-- 	local _, _, window = wezterm.mux.spawn_window(cmd or {})
-- 	window:gui_window():toggle_fullscreen()
-- end)

-- This will hold the configuration.
local config = wezterm.config_builder()

config = {
	automatically_reload_config = true,
}

-- This is where you actually apply your config choices
-- For example, changing the color scheme:
config.color_scheme = "Gruvbox light, soft (base16)"
config.colors = {
	-- background = '#3b224c',
	-- background = "#181616", -- vague.nvim bg
	-- background = "#080808", -- almost black
	-- background = "#0c0b0f", -- dark purple
	-- background = "#020202", -- dark purple
	-- background = "#17151c", -- brighter purple
	-- background = "#16141a",
	-- background = "#0e0e12", -- bright washed lavendar
	-- background = 'rgba(59, 34, 76, 100%)',
	cursor_border = "#928374",
	-- cursor_fg = "#281733",
	cursor_bg = "#928374",
	-- selection_fg = '#281733',
	foreground = "#ebdbb2",
	background = "#272727",
	selection_fg = "#655b53",
	selection_bg = "#ebdbb2",
	scrollbar_thumb = "#d65c0d",

	tab_bar = {
		background = "#0c0b0f",
		-- background = "rgba(0, 0, 0, 0%)",
		active_tab = {
			bg_color = "#665c54",
			fg_color = "#fbf1c7",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = "#3c3836",
			fg_color = "#a89984",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},

		new_tab = {
			-- bg_color = "rgba(59, 34, 76, 50%)",
			bg_color = "#0c0b0f",
			fg_color = "white",
		},
	},
}
-- set config window frame title background
config.window_frame = {
	active_titlebar_bg = bg_custom,
	inactive_titlebar_bg = bg_custom,
}

-- get current folder

-- custom dir active
-- wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
-- 	local title = current_folder or "Pojok Code"
-- 	if tab.is_active then
-- 		return {
-- 			{ Text = " " .. title .. " " },
-- 		}
-- 	end
-- 	return title
-- end)

config.tab_max_width = 16
config.tab_bar_at_bottom = false
config.disable_default_key_bindings = true
config.adjust_window_size_when_changing_font_size = false
config.audible_bell = "Disabled"

-- cinfig image background
-- config.background = {
-- {
-- 	source = { File = "C:/Users/Asep/Pictures/wallpaper_tokyonight.png" },
-- 	horizontal_align = "Center",
-- 	vertical_align = "Middle",
-- 	-- height = "Contain",
-- 	-- width = "Contain",
-- 	-- repeat_x = "NoRepeat",
-- 	-- repeat_y = "NoRepeat",
-- 	opacity = 1,
-- },
-- 	{
-- 		source = { File = "C:/Users/Asep/Pictures/background_ps.png" },
-- 		opacity = 1,
-- 	},
-- }

config.exit_behavior = "Close"

-- and window padding:
config.window_padding = {
	left = 5,
	right = 5,
	top = 10,
	bottom = 10,
}

-- add window size initial coll and row
config.initial_cols = 110
config.initial_rows = 30

-- config.window_decorations = "TITLE | RESIZE"
-- config.window_decorations = "RESIZE"
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

-- add opacity
config.window_background_opacity = 0.77
-- config.win32_system_backdrop = "Mica" -- Acrylic, Mica, or Tabbed

-- set window title text
wezterm.on("format-window-title", function(event)
	return ""
end)

-- set default terminal powershell
config.default_prog = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe" }
-- set default cwd with current active directory
config.default_cwd = os.getenv("PWD")

-- activate font ligature
config.harfbuzz_features = { "liga=1" }
--set font Hasklug Nerd font
-- config.font = wezterm.font_with_fallback({
-- 	{ family = "Hasklug Nerd Font", weight = "Medium" },
-- })
config.font = wezterm.font({
	family = "ZedMono Nerd Font",
	-- family = "Genova",
	-- family = "FiraCode Nerd Font",
	-- family = "Hasklug Nerd Font",
	-- family = "JetBrainsMono Nerd Font",
	-- family = "SauceCodePro Nerd Font",
	weight = "Medium", -- Normal, Medium, Bold, DemiBold,
	stretch = "Normal",
	style = "Normal",
	harfbuzz_features = { "cv29", "cv30", "ss01", "ss03", "ss06", "ss07", "ss09" },
})
config.freetype_load_flags = "NO_HINTING"
config.front_end = "Software" -- WebGpu or OpenGL or Software
-- set font size 16
config.font_size = 12.5
-- add set line height
-- config.line_height = 1.1

config.disable_default_key_bindings = true
config.force_reverse_video_cursor = true
config.hide_mouse_cursor_when_typing = true
-- config.hide_tab_bar_if_only_one_tab = true

-- set environment variable for current directory
config.set_environment_variables = {
	prompt = "$E]7;file://localhost/$P$E\\$E[32m$T$E[0m $E[35m$P$E[36m$_$G$E[0m ",
}
local current_dir = os.getenv("PWD")

-- add keys mapping
config.keys = {
	{ action = wezterm.action.ActivateCommandPalette, mods = "CTRL|SHIFT", key = "P" },
	{ action = wezterm.action.CopyTo("Clipboard"), mods = "CTRL", key = "C" },
	{ action = wezterm.action.DecreaseFontSize, mods = "CTRL", key = "-" },
	{ action = wezterm.action.IncreaseFontSize, mods = "CTRL", key = "=" },
	{ action = wezterm.action.Nop, mods = "ALT", key = "Enter" },
	{ action = wezterm.action.PasteFrom("Clipboard"), mods = "CTRL", key = "V" },
	{ action = wezterm.action.ResetFontSize, mods = "CTRL", key = "0" },
	{ action = wezterm.action.ToggleFullScreen, key = "F11" },
	-- open new tab
	{
		action = wezterm.action.SpawnCommandInNewTab({ args = { "pwsh.exe" }, cwd = current_dir }),
		mods = "CTRL|SHIFT",
		key = "t",
	},
	-- close active tab
	{ key = "w", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
	-- open new window ctrl+shift+n
	{
		key = "n",
		mods = "ALT|SHIFT",
		action = wezterm.action.SpawnCommandInNewWindow({ args = { "pwsh.exe" }, cwd = current_dir }),
	},
	-- rename table title
	{
		key = "E",
		mods = "CTRL|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	-- move tab relative to left shift+alt+{
	{ key = "{", mods = "SHIFT|ALT", action = act.MoveTabRelative(-1) },
	-- move tab relative to right shift+alt+}
	{ key = "}", mods = "SHIFT|ALT", action = act.MoveTabRelative(1) },
	-- add tab navigation ctrl+PageUp
	{ key = "PageUp", mods = "CTRL", action = act.ActivateTabRelative(-1) },
	-- add tab navigation ctrl+PageDown
	{ key = "PageDown", mods = "CTRL", action = act.ActivateTabRelative(1) },
	-- add split vertical ctrl+shift+v
	{ key = "v", mods = "CTRL|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	-- add split horizontal ctrl+shift+h
	{ key = "h", mods = "CTRL|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	-- delete split ctrl+shift+d
	{ key = "d", mods = "CTRL|SHIFT", action = act.CloseCurrentPane({ confirm = true }) },
	-- navigate focus panel up alt+up
	{ key = "UpArrow", mods = "ALT", action = act.ActivatePaneDirection("Up") },
	-- navigate focus panel down alt+down
	{ key = "DownArrow", mods = "ALT", action = act.ActivatePaneDirection("Down") },
	-- navigate focus panel left alt+left
	{ key = "LeftArrow", mods = "ALT", action = act.ActivatePaneDirection("Left") },
	-- navigate focus panel right alt+right
	{ key = "RightArrow", mods = "ALT", action = act.ActivatePaneDirection("Right") },
	-- resize panel up alt+shift+up
	{ key = "UpArrow", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Up", 1 }) },
	-- resize panel down alt+shift+down
	{ key = "DownArrow", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Down", 1 }) },
	-- resize panel left alt+shift+left
	{ key = "LeftArrow", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Left", 1 }) },
	-- resize panel right alt+shift+right
	{ key = "RightArrow", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Right", 1 }) },
	-- key alt + UpArrow will send string ALT + k
	{ key = "UpArrow", mods = "ALT", action = act.SendKey({ key = "k", mods = "ALT" }) },
	-- key alt + DownArrow will send string ALT + j
	{ key = "DownArrow", mods = "ALT", action = act.SendKey({ key = "j", mods = "ALT" }) },
	-- key alt + LeftArrow will send string ALT + LeftArrow
	{ key = "LeftArrow", mods = "ALT", action = act.SendKey({ key = "LeftArrow", mods = "ALT" }) },
	-- key alt + RightArrow will send string ALT + RightArrow
	{ key = "RightArrow", mods = "ALT", action = act.SendKey({ key = "RightArrow", mods = "ALT" }) },
	-- set for duplicate key vscode shift-alt-up
	{ key = "UpArrow", mods = "SHIFT|ALT", action = act.SendKey({ key = "UpArrow", mods = "SHIFT" }) },
	-- set for duplicate key vscode shift-alt-down
	{ key = "DownArrow", mods = "SHIFT|ALT", action = act.SendKey({ key = "DownArrow", mods = "SHIFT" }) },
	-- set ctrl + v for paste Clipboard
	{ key = "v", mods = "CTRL", action = wezterm.action({ PasteFrom = "Clipboard" }) },
	{
		key = "x",
		mods = "CTRL",
		action = wezterm.action_callback(function(window, pane)
			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
			if has_selection then
				window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)

				window:perform_action(act.ClearSelection, pane)
			else
				window:perform_action(act.SendKey({ key = "x", mods = "CTRL" }), pane)
			end
		end),
	},
	{
		key = "c",
		mods = "CTRL",
		action = wezterm.action_callback(function(window, pane)
			local sel = window:get_selection_text_for_pane(pane)
			if not sel or sel == "" then
				window:perform_action(wezterm.action.SendKey({ key = "c", mods = "CTRL" }), pane)
			else
				window:perform_action(wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }), pane)
			end
		end),
	},
}

-- add mouse keys mapping
config.mouse_bindings = {
	{
		event = { Drag = { streak = 1, button = "Left" } },
		mods = "SUPER",
		action = wezterm.action.StartWindowDrag,
	},
	-- drag drop window CTRL + Mouse Left
	{
		event = { Drag = { streak = 1, button = "Left" } },
		mods = "CTRL|SHIFT",
		action = wezterm.action.StartWindowDrag,
	},
	-- shift-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "SHIFT",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
	-- Ctrl-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

-------------- custom tab start -------------------------
-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
-- function tab_title(tab_info)
-- 	local title = tab_info.tab_title
-- 	-- if the tab title is explicitly set, take that
-- 	if title and #title > 0 then
-- 		return title
-- 	end
-- 	-- Otherwise, use the title from the active pane
-- 	-- in that tab
-- 	return tab_info.active_pane.title
-- end
--
-- wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
-- 	local edge_background = "#1a1b26"
-- 	local background = "#1a1b26"
-- 	local foreground = "#808080"
--
-- 	if tab.is_active then
-- 		foreground = "#dfe3f7"
-- 	elseif hover then
-- 		foreground = "#cdcdcd"
-- 	end
--
-- 	local edge_foreground = background
--
-- 	local title = tab_title(tab)
--
-- 	-- ensure that the titles fit in the available space,
-- 	-- and that we have room for the edges.
-- 	title = wezterm.truncate_right(title, max_width + 6)
--
-- 	return {
-- 		{ Background = { Color = edge_background } },
-- 		{ Foreground = { Color = edge_foreground } },
-- 		{ Background = { Color = background } },
-- 		{ Foreground = { Color = foreground } },
-- 		{ Text = title },
-- 		{ Background = { Color = edge_background } },
-- 		{ Foreground = { Color = edge_foreground } },
-- 	}
-- end)
-------------------------------end custom tab ----------------------------------------------
config.show_tab_index_in_tab_bar = false
config.integrated_title_buttons = { "Hide", "Maximize", "Close" }
-- config.integrated_title_buttons = { "Close" }
config.scrollback_lines = 10000
-- config.show_update_window = true
config.use_dead_keys = false
config.unicode_version = 15
config.macos_window_background_blur = 100
-- config.window_close_confirmation = "NeverPrompt"
-- set cursor shape
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 600
config.force_reverse_video_cursor = false

-- and finally, return the configuration to wezterm
return config
