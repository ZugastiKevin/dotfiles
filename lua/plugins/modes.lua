---@type LazySpec
return {
  "mvllow/modes.nvim",
  enabled = false,
  event = "VeryLazy",
  opts = {
    colors = {
      insert = "#c9604f",
      visual = "#cf8f7c",
      delete = "#c9604f",
      copy = "#ffd479",
    },
    line_opacity = 0.18,
    set_cursorline = true,
    set_number = true,
  },
}
