local MARKER = "rainbow-delimiters: plugin loaded."

local function patch_health(dir)
  local path = dir .. "/lua/rainbow-delimiters/health.lua"
  local f = io.open(path, "r")
  if not f then return end
  local lines = {}
  for line in f:lines() do
    lines[#lines + 1] = line
  end
  f:close()

  local already = false
  for _, line in ipairs(lines) do
    if line:find(MARKER, 1, true) then
      already = true
      break
    end
  end

  local changed = false
  for i = 1, #lines - 1 do
    if vim.trim(lines[i]) == "return" and lines[i + 1]:find("No custom configuration", 1, true) then
      lines[i], lines[i + 1] = lines[i + 1], lines[i]
      changed = true
      break
    end
  end

  if not already then
    for i = 1, #lines do
      if vim.trim(lines[i]) == "function M.check()" then
        table.insert(lines, i + 1, string.format('\tok(%q)', MARKER))
        changed = true
        break
      end
    end
  end

  if not changed then return end

  local out = io.open(path, "w")
  if not out then return end
  out:write(table.concat(lines, "\n") .. "\n")
  out:close()
end

---@type LazySpec
return {
  "HiPhish/rainbow-delimiters.nvim",
  build = function(plugin) patch_health(plugin.dir) end,
}
