---@type LazySpec
return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "User AstroFile",
    opts = {
      provider_selector = function() return { "treesitter", "indent" } end,
      open_fold_hl_timeout = 0,
    },
    config = function(_, opts)
      local ufo = require "ufo"
      ufo.setup(opts)
      vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Ouvrir tous les replis" })
      vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Fermer tous les replis" })
      vim.keymap.set("n", "zK", function()
        if not ufo.peekFoldedLinesUnderCursor() then vim.lsp.buf.hover() end
      end, { desc = "Apercu du repli" })
    end,
  },
}
