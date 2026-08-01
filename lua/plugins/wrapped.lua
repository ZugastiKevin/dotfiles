---@type LazySpec
return {
  "aikhe/wrapped.nvim",
  cmd = "WrappedNvim",
  opts = {},
  specs = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<Leader>fK"] = { "<Cmd>WrappedNvim<CR>", desc = "Wrapped (stats de la config)" },
          },
        },
      },
    },
  },
}
