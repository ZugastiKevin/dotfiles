---@type LazySpec
return {
  "stevearc/overseer.nvim",
  optional = true,
  opts = function(_, opts)
    opts.templates = require("astrocore").list_insert_unique(opts.templates or { "builtin" }, { "user.hytale" })
  end,
}
