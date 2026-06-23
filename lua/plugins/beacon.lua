---@type LazySpec
return {
  "DanilaMihailov/beacon.nvim",
  event = "VeryLazy",
  config = function()
    require("beacon").setup {
      enable = true,
      size = 12,
      fade = true,
      minimal_jump = 10,
      highlight = { bg = "#ff4fd8", ctermbg = 13 },
    }
  end,
}
