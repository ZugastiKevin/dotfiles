---@type LazySpec
return {
  "echasnovski/mini.animate",
  event = "VeryLazy",
  opts = function()
    local animate = require "mini.animate"
    return {
      cursor = { enable = false },
      scroll = { enable = false },
      resize = { timing = animate.gen_timing.cubic { duration = 80, unit = "total" } },
      open = { timing = animate.gen_timing.cubic { duration = 120, unit = "total" } },
      close = { timing = animate.gen_timing.cubic { duration = 120, unit = "total" } },
    }
  end,
}
