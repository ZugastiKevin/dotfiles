---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  optional = true,
  opts = function(_, opts)
    local nls = require "null-ls"
    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      nls.builtins.formatting.clang_format,
      nls.builtins.formatting.csharpier.with {
        command = vim.fn.stdpath "data" .. "/mason/bin/csharpier",
      },
    })
  end,
}
