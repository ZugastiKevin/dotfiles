local ACCENTS = {
  insert = "#ff2d95",
  visual = "#c14fff",
  replace = "#ff5d8f",
  change = "#7df9ff",
  delete = "#ff5d8f",
  yank = "#ffd479",
}

local OPACITY = 0.2

local function normal_bg()
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = "Normal", link = false })
  if ok and hl and hl.bg then return hl.bg end
  return 0x0c0910
end

local function blend(accent, base, alpha)
  local ar = tonumber(accent:sub(2, 3), 16)
  local ag = tonumber(accent:sub(4, 5), 16)
  local ab = tonumber(accent:sub(6, 7), 16)
  local br = math.floor(base / 65536) % 256
  local bg = math.floor(base / 256) % 256
  local bb = base % 256
  return string.format(
    "#%02x%02x%02x",
    math.floor(ar * alpha + br * (1 - alpha) + 0.5),
    math.floor(ag * alpha + bg * (1 - alpha) + 0.5),
    math.floor(ab * alpha + bb * (1 - alpha) + 0.5)
  )
end

local function cursorline(accent, base) return { winhl = { CursorLine = { bg = blend(accent, base, OPACITY) } } } end

local function preset()
  local base = normal_bg()
  return {
    name = "girlypop",
    modes = {
      i = cursorline(ACCENTS.insert, base),
      v = cursorline(ACCENTS.visual, base),
      V = cursorline(ACCENTS.visual, base),
      ["\22"] = cursorline(ACCENTS.visual, base),
      s = cursorline(ACCENTS.visual, base),
      S = cursorline(ACCENTS.visual, base),
      R = cursorline(ACCENTS.replace, base),
      c = cursorline(ACCENTS.change, base),
      no = {
        operators = {
          d = cursorline(ACCENTS.delete, base),
          c = cursorline(ACCENTS.change, base),
          y = cursorline(ACCENTS.yank, base),
        },
      },
    },
  }
end

---@type LazySpec
return {
  "rasulomaroff/reactive.nvim",
  event = "VeryLazy",
  config = function()
    local reactive = require "reactive"
    local function load() reactive.add_preset(preset()) end
    load()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("reactive_girlypop", { clear = true }),
      callback = function() vim.schedule(load) end,
    })
  end,
}
