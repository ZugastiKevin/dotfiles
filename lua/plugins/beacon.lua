---@type LazySpec
return {
  "DanilaMihailov/beacon.nvim",
  event = "VeryLazy",
  config = function()
    require("beacon").setup {
      enabled = true,
      width = 12,
      min_jump = 10,
      highlight = { bg = "#8fe0d4", ctermbg = 13 },
    }
  end,
}
