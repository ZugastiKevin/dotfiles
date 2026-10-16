local M = {}

local here = debug.getinfo(1, "S").source:sub(2)
local ART_FILE = vim.fn.fnamemodify(here, ":h") .. "/jenova.txt"

local RAMP = " .:-=+*#%@"
local DENSITY = {}
for i = 1, #RAMP do
  DENSITY[RAMP:sub(i, i)] = i - 1
end

local phrases = {
  "pret a tout casser (proprement)",
  "les bugs n'ont qu'a bien se tenir",
  "compile d'abord, doute ensuite",
  "un push de plus et dodo",
  "zero warning, zero pitie",
}

local phrase = phrases[1]
local fresh = true
local raw = nil

local function load_art()
  if raw then return raw end
  raw = {}
  if vim.fn.filereadable(ART_FILE) == 1 then
    for _, l in ipairs(vim.fn.readfile(ART_FILE)) do
      raw[#raw + 1] = (l:gsub("\r$", ""))
    end
  end
  return raw
end

-- réduit l'art par blocs (densité moyenne) pour tenir dans max_w x max_h
local function downscale(lines, max_w, max_h)
  local h, w = #lines, 0
  for _, l in ipairs(lines) do
    w = math.max(w, #l)
  end
  local f = math.max(1, math.ceil(h / max_h), math.ceil(w / max_w))

  local grid, lo, hi = {}, math.huge, -math.huge
  for y = 1, h, f do
    local row = {}
    for x = 1, w, f do
      local sum, n = 0, 0
      for dy = 0, f - 1 do
        local l = lines[y + dy]
        if l then
          for dx = 0, f - 1 do
            sum = sum + (DENSITY[l:sub(x + dx, x + dx)] or 0)
            n = n + 1
          end
        end
      end
      local v = n > 0 and sum / n or 0
      lo, hi = math.min(lo, v), math.max(hi, v)
      row[#row + 1] = v
    end
    grid[#grid + 1] = row
  end

  -- étirement du contraste pour que le dessin ne devienne pas fade
  local span = math.max(hi - lo, 0.001)
  local out = {}
  for i, row in ipairs(grid) do
    local chars = {}
    for j, v in ipairs(row) do
      local idx = math.floor((v - lo) / span * (#RAMP - 1) + 0.5)
      chars[j] = RAMP:sub(idx + 1, idx + 1)
    end
    out[i] = table.concat(chars)
  end
  return out
end

function M.frame()
  if fresh then
    math.randomseed((vim.uv or vim.loop).hrtime() % 2147483647)
    phrase = phrases[math.random(#phrases)]
    fresh = false
  end

  -- on garde la place du titre, de la phrase, du menu et du pied de page
  local max_h = math.max(10, vim.o.lines - 20)
  local max_w = math.max(20, vim.o.columns - 6)
  local lines = downscale(load_art(), max_w, max_h)

  vim.list_extend(lines, { "", "g e n e s i s", "", phrase })
  return table.concat(lines, "\n")
end

-- gardés pour rester compatibles avec ta config du dashboard
function M.on_open() end

function M.on_close()
  fresh = true
end

return M