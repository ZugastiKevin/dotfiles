---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      local jump = vim.tbl_get(opts, "diagnostics", "jump")
      if jump then jump.float = nil end
    end,
  },
}
