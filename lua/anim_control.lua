local M = {}

local state = {
  cursor = true,
  window = true,
  scroll = true,
  glimmer = true,
  illuminate = true,
  indent = true,
  beacon = true,
  fidget = true,
  minimap = false,
}

local function apply(key)
  local on = state[key]
  if key == "cursor" then
    if vim.g.neovide then
      if on then
        vim.g.neovide_cursor_vfx_mode = vim.g._anim_vfx or "railgun"
      else
        local cur = vim.g.neovide_cursor_vfx_mode
        vim.g._anim_vfx = (cur ~= nil and cur ~= "") and cur or "railgun"
        vim.g.neovide_cursor_vfx_mode = ""
      end
    end
  elseif key == "window" then
    vim.g.minianimate_disable = not on
  elseif key == "scroll" then
    pcall(function() require("neoscroll.config").opts.duration_multiplier = on and 1.0 or 0.0 end)
  elseif key == "glimmer" then
    pcall(function()
      local t = require "tiny-glimmer"
      if on then t.enable() else t.disable() end
    end)
  elseif key == "illuminate" then
    pcall(function()
      local i = require "illuminate"
      if on then i.resume() else i.pause() end
    end)
  elseif key == "indent" then
    pcall(function()
      local s = require "snacks"
      if on then s.indent.enable() else s.indent.disable() end
    end)
  elseif key == "beacon" then
    vim.g.beacon_enable = on and 1 or 0
  elseif key == "fidget" then
    pcall(function() require("fidget.progress").suppress(not on) end)
  elseif key == "minimap" then
    pcall(function()
      local m = require "mini.map"
      if on then m.open() else m.close() end
    end)
  end
end

local items = {
  { key = "cursor", map = "c", label = "Cursor VFX (Neovide)" },
  { key = "window", map = "w", label = "Animations de fenetre" },
  { key = "scroll", map = "s", label = "Smooth scroll" },
  { key = "glimmer", map = "g", label = "Glimmer (yank/paste/search)" },
  { key = "illuminate", map = "i", label = "Illuminate (mot sous curseur)" },
  { key = "indent", map = "n", label = "Guides d'indentation" },
  { key = "beacon", map = "b", label = "Beacon (flash de saut)" },
  { key = "fidget", map = "f", label = "Fidget (progression LSP)" },
  { key = "minimap", map = "m", label = "Minimap" },
}

local cursor_vfx_modes = { "railgun", "torpedo", "pixiedust", "sonicboom", "ripple", "wireframe", "" }
local cursor_vfx_idx = 1
local function cycle_cursor_vfx()
  if not vim.g.neovide then
    vim.notify("Cursor VFX : dispo seulement sous Neovide", vim.log.levels.WARN)
    return
  end
  cursor_vfx_idx = cursor_vfx_idx % #cursor_vfx_modes + 1
  local mode = cursor_vfx_modes[cursor_vfx_idx]
  state.cursor = mode ~= ""
  vim.g.neovide_cursor_vfx_mode = mode
  if mode ~= "" then vim.g._anim_vfx = mode end
  vim.notify("Cursor VFX : " .. (mode == "" and "off (trail seul)" or mode), vim.log.levels.INFO, { title = "Animations" })
end

local scroll_easings = { "linear", "quadratic", "cubic", "quartic", "quintic", "circular", "sine" }
local scroll_easing_idx = 1
local function cycle_scroll_easing()
  local ok, cfg = pcall(require, "neoscroll.config")
  if not ok then
    vim.notify("neoscroll pas charge", vim.log.levels.WARN)
    return
  end
  scroll_easing_idx = scroll_easing_idx % #scroll_easings + 1
  local easing = scroll_easings[scroll_easing_idx]
  cfg.opts.easing = easing
  vim.notify("Scroll easing : " .. easing, vim.log.levels.INFO, { title = "Animations" })
end

function M.menu()
  vim.ui.select(items, {
    prompt = "Animations",
    format_item = function(it) return (state[it.key] and "[x] " or "[ ] ") .. it.label end,
  }, function(it)
    if not it then return end
    state[it.key] = not state[it.key]
    apply(it.key)
    vim.notify(it.label .. " : " .. (state[it.key] and "ON" or "OFF"), vim.log.levels.INFO, { title = "Animations" })
    vim.schedule(M.menu)
  end)
end

function M.register()
  local ok, Snacks = pcall(require, "snacks")
  if ok and Snacks.toggle then
    for _, it in ipairs(items) do
      Snacks
        .toggle({
          name = it.label,
          get = function() return state[it.key] end,
          set = function(v)
            state[it.key] = v
            apply(it.key)
          end,
        })
        :map("<Leader>U" .. it.map)
    end
  end
  local set = vim.keymap.set
  set("n", "<Leader>UV", cycle_cursor_vfx, { desc = "Cycle cursor VFX (Neovide)" })
  set("n", "<Leader>UE", cycle_scroll_easing, { desc = "Cycle scroll easing" })
  set("n", "<Leader>Ur", function() vim.cmd "CellularAutomaton make_it_rain" end, { desc = "Fun: pluie de code" })
  set("n", "<Leader>Ul", function() vim.cmd "CellularAutomaton game_of_life" end, { desc = "Fun: game of life" })
  set("n", "<Leader>Ua", M.menu, { desc = "Vue d'ensemble (picker)" })
  pcall(function() require("which-key").add { { "<Leader>U", group = "Animations" } } end)
end

return M
