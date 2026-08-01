---@type LazySpec
return {
  { "nvzone/volt", lazy = true },
  {
    "nvzone/minty",
    cmd = { "Shades", "Huefy" },
    specs = {
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["<Leader>uP"] = { "<Cmd>Huefy<CR>", desc = "Palette de couleurs (minty)" },
            },
          },
        },
      },
    },
  },
}
