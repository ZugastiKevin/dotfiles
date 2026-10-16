---@type LazySpec
return {
  "shellRaining/hlchunk.nvim",
  event = "User AstroFile",
  opts = {
    chunk = {
      enable = true,
      duration = 180,
      delay = 80,
      style = {
        { fg = "#8fe0d4" },
        { fg = "#d6405f" },
      },
      chars = {
        horizontal_line = "─",
        vertical_line = "│",
        left_top = "╭",
        left_bottom = "╰",
        right_arrow = "─",
      },
    },
    indent = { enable = false },
    line_num = { enable = false },
    blank = { enable = false },
  },
}
