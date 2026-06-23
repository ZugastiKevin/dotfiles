---@type LazySpec
return {
  "j-hui/fidget.nvim",
  event = "LspAttach",
  opts = {
    progress = {
      display = { done_icon = "✓" },
    },
    notification = {
      window = { winblend = 0, border = "rounded" },
    },
  },
}
