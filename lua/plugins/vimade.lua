---@type LazySpec
return {
  "TaDaa/vimade",
  event = "VeryLazy",
  opts = {
    recipe = { "default", { animate = true } },
    ncmode = "windows",
    fadelevel = 0.42,
    tint = {
      bg = { rgb = { 12, 9, 16 }, intensity = 0.25 },
      fg = { rgb = { 193, 79, 255 }, intensity = 0.12 },
    },
    blocklist = {
      girly = {
        buf_opts = { filetype = { "snacks_dashboard", "alpha", "image" } },
      },
    },
  },
  config = function(_, opts) require("vimade").setup(opts) end,
}
