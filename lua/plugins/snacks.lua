---@type LazySpec
return {
  "folke/snacks.nvim",
  opts = {
    input = { enabled = true },
    picker = { ui_select = true },
    image = { enabled = false },
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    indent = {
      enabled = true,
      animate = { enabled = true, duration = { step = 20, total = 300 } },
      scope = { enabled = true, underline = true },
    },
  },
}
