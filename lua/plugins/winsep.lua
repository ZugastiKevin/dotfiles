---@type LazySpec
return {
  "nvim-zh/colorful-winsep.nvim",
  event = "VeryLazy",
  opts = {
    hi = { fg = "#ff4fd8", bg = "NONE" },
    smooth = true,
    exponential_smoothing = true,
  },
}
