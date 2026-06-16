---@type LazySpec
return {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    if type(opts.statusline) ~= "table" then return opts end
    table.insert(opts.statusline, {
      provider = function()
        local s = vim.g.sysinfo_str
        if s and s ~= "" then return " " .. s .. " " end
        return ""
      end,
      hl = { fg = "#ff9ad4", bold = true },
    })
    return opts
  end,
}
