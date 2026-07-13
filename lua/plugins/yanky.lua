---@type LazySpec
return {
  { "gbprod/yanky.nvim", event = "VeryLazy" },
  {
    "stevearc/aerial.nvim",
    opts = function(_, opts) opts.on_attach = nil end,
  },
}
