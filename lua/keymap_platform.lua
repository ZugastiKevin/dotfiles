local M = {}

M.has_super_key = vim.fn.has "mac" == 1

M.overrides = {
  ["<D-s>"] = "<C-s>",
  ["<D-z>"] = "<C-z>",
  ["<D-S-z>"] = "<C-y>",
  ["<D-v>"] = "<C-S-v>",
  ["<D-/>"] = "<C-/>",
  ["<D-.>"] = "<M-CR>",

  ["<D-f>"] = "<C-f>",
  ["<D-S-f>"] = "<C-S-f>",

  ["<D-t>"] = "<C-t>",
  ["<D-S-t>"] = "<C-S-t>",

  ["<D-i>"] = "<C-b>",
  ["<D-S-i>"] = "<C-M-b>",

  ["<D-g>"] = "<C-M-g>",
  ["<D-S-g>"] = "<C-M-S-g>",

  ["<D-[>"] = "<C-M-Left>",
  ["<D-]>"] = "<C-M-Right>",

  ["<D-Left>"] = "<Home>",
  ["<D-Right>"] = "<End>",
  ["<D-Up>"] = "<C-Home>",
  ["<D-Down>"] = "<C-End>",
  ["<D-S-Left>"] = "<S-Home>",
  ["<D-S-Right>"] = "<S-End>",
  ["<D-S-Up>"] = "<C-S-Home>",
  ["<D-S-Down>"] = "<C-S-End>",

  ["<D-=>"] = "<C-=>",
  ["<D-->"] = "<C-->",
  ["<D-0>"] = "<C-0>",
}

local function split_modifiers(chord)
  local modifiers, key = {}, chord
  while true do
    local modifier, rest = key:match "^([CSMAD])%-(.+)$"
    if not modifier then break end
    modifiers[modifier] = true
    key = rest
  end
  return modifiers, key
end

local function translate_chord(chord)
  local modifiers, key = split_modifiers(chord)
  if not modifiers.D then return nil end
  local shift = modifiers.S and "S-" or ""
  local override = M.overrides["<D-" .. shift .. key .. ">"]
  if override then return override end
  local prefix = (modifiers.C or modifiers.M or modifiers.A) and "<C-M-" or "<M-"
  return prefix .. shift .. key .. ">"
end

function M.key(lhs)
  if M.has_super_key or type(lhs) ~= "string" then return lhs end
  return (lhs:gsub("<([^<>]+)>", translate_chord))
end

function M.mappings(modes)
  if M.has_super_key then return modes end
  for _, maps in pairs(modes) do
    local translated = {}
    for lhs, rhs in pairs(maps) do
      local target = M.key(lhs)
      if target ~= lhs then
        translated[target] = rhs
        maps[lhs] = nil
      end
    end
    for lhs, rhs in pairs(translated) do
      if maps[lhs] == nil then maps[lhs] = rhs end
    end
  end
  return modes
end

function M.keys(specs)
  if M.has_super_key then return specs end
  for _, spec in ipairs(specs) do
    spec[1] = M.key(spec[1])
  end
  return specs
end

return M
