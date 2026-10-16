---@type LazySpec
return {
  "cxwx/shadowMyName.nvim",
  cmd = { "ShadowMyNameToggle", "ShadowMyNameEnable", "ShadowMyNameDisable", "ShadowMyNameRefresh" },
  opts = {
    enabled = false,
    username = { enabled = true },
    words = { "token", "secret", "password", "api_key" },
    whole_word = true,
    case_sensitive = false,
    highlight = { fg = "#c1c0c3", bg = "#c1c0c3", bold = true },
  },
  config = function(_, opts) require("shadowMyName").setup(opts) end,
  specs = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<Leader>uM"] = { "<Cmd>ShadowMyNameToggle<CR>", desc = "Masquer les infos sensibles (stream)" },
          },
        },
      },
    },
  },
}
