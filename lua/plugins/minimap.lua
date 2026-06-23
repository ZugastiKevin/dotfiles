---@type LazySpec
return {
  "echasnovski/mini.map",
  event = "VeryLazy",
  config = function()
    local map = require "mini.map"
    map.setup {
      integrations = {
        map.gen_integration.builtin_search(),
        map.gen_integration.diagnostic {
          error = "DiagnosticFloatingError",
          warn = "DiagnosticFloatingWarn",
          info = "DiagnosticFloatingInfo",
          hint = "DiagnosticFloatingHint",
        },
      },
      symbols = { encode = map.gen_encode_symbols.dot "4x2" },
      window = {
        width = 12,
        winblend = 25,
        show_integration_count = false,
        focusable = false,
      },
    }
  end,
}
