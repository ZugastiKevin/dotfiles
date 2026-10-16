local M = {}

local CELLS = 14
local FPS = 10

local calm = { { 0x8f, 0xe0, 0xd4 }, { 0x6f, 0xb7, 0xc9 }, { 0xb7, 0x9c, 0xf0 } }
local hot = { { 0xd6, 0x40, 0x5f }, { 0xb7, 0x9c, 0xf0 }, { 0x8f, 0xe0, 0xd4 } }

local timer = nil
local phase = 0
local active = false

local function lerp(a, b, t)
  return math.floor(a + (b - a) * t + 0.5)
end

local function palette_color(palette, t)
  local scaled = t * (#palette - 1)
  local index = math.min(math.floor(scaled) + 1, #palette - 1)
  local frac = scaled - (index - 1)
  local a, b = palette[index], palette[index + 1]
  return string.format("#%02x%02x%02x", lerp(a[1], b[1], frac), lerp(a[2], b[2], frac), lerp(a[3], b[3], frac))
end

local function repaint()
  local palette = vim.api.nvim_get_mode().mode:sub(1, 1) == "i" and hot or calm
  for i = 1, CELLS do
    local t = (math.sin(phase + i * 0.45) + 1) / 2
    vim.api.nvim_set_hl(0, "GirlyWave" .. i, { fg = palette_color(palette, t) })
  end
end

local strip_cache = nil

function M.strip()
  if not active then return "" end
  if not strip_cache then
    local parts = {}
    for i = 1, CELLS do
      parts[#parts + 1] = "%#GirlyWave" .. i .. "#▂"
    end
    strip_cache = " " .. table.concat(parts) .. "%*"
  end
  return strip_cache
end

function M.enable()
  if active then return end
  active = true
  repaint()
  timer = (vim.uv or vim.loop).new_timer()
  timer:start(0, math.floor(1000 / FPS), vim.schedule_wrap(function()
    phase = phase + 0.35
    repaint()
    vim.cmd "redrawstatus"
  end))
end

function M.disable()
  active = false
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
  vim.cmd "redrawstatus"
end

function M.set(on)
  if on then M.enable() else M.disable() end
end

function M.is_active()
  return active
end

return M
