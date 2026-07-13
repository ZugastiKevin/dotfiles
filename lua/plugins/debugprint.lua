---@type LazySpec
return {
  "andrewferrier/debugprint.nvim",
  keys = { { "g?", mode = { "n", "x" } } },
  cmd = { "DeleteDebugPrints", "ToggleCommentDebugPrints", "ResetDebugPrintsCounter" },
  opts = {},
}
