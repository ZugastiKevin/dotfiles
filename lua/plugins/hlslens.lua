local function search(keys)
  return function()
    local ok, msg = pcall(vim.cmd, "normal! " .. vim.v.count1 .. keys)
    if not ok then
      vim.notify((msg or ""):gsub("^.*:E%d+:%s*", ""), vim.log.levels.WARN)
      return
    end
    require("hlslens").start()
  end
end

---@type LazySpec
return {
  "kevinhwang91/nvim-hlslens",
  keys = {
    { "n", search "n", desc = "Occurrence suivante (avec compteur)" },
    { "N", search "N", desc = "Occurrence precedente (avec compteur)" },
    { "*", search "*", desc = "Chercher le mot (avant)" },
    { "#", search "#", desc = "Chercher le mot (arriere)" },
  },
  opts = {
    calm_down = true,
    nearest_only = false,
  },
}
