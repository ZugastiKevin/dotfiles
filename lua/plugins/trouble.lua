---@type LazySpec
return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  opts = {
    focus = true,
    warn_no_results = false,
  },
  keys = {
    { "<Leader>xx", "<Cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (projet)" },
    { "<Leader>xX", "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Diagnostics (buffer)" },
    { "<Leader>xs", "<Cmd>Trouble symbols toggle<CR>", desc = "Symboles du fichier" },
    { "<Leader>xr", "<Cmd>Trouble lsp toggle<CR>", desc = "References / definitions LSP" },
    { "<Leader>xL", "<Cmd>Trouble loclist toggle<CR>", desc = "Location list" },
    { "<Leader>xQ", "<Cmd>Trouble qflist toggle<CR>", desc = "Quickfix list" },
  },
}
