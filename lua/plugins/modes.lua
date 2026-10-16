---@type LazySpec
return {
  "mvllow/modes.nvim",
  enabled = false,
  event = "VeryLazy",
  opts = {
    colors = {
      insert = "#d6405f",
      visual = "#b79cf0",
      delete = "#d6405f",
      copy = "#ffd479",
    },
    line_opacity = 0.18,
    set_cursorline = true,
    set_number = true,
  },
}
