local function highlights()
  local hl = vim.api.nvim_set_hl
  hl(0, "MultiCursorCursor", { bg = "#d6405f", fg = "#0c0910", bold = true })
  hl(0, "MultiCursorVisual", { link = "Visual" })
  hl(0, "MultiCursorSign", { fg = "#8fe0d4" })
  hl(0, "MultiCursorMatchPreview", { bg = "#b79cf0", fg = "#0c0910" })
  hl(0, "MultiCursorDisabledCursor", { bg = "#8a7a90", fg = "#0c0910" })
  hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
  hl(0, "MultiCursorDisabledSign", { fg = "#8a7a90" })
end

---@type LazySpec
return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  event = "User AstroFile",
  config = function()
    local mc = require "multicursor-nvim"
    mc.setup()

    local function map(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true }) end
    local both = { "n", "x" }

    map(both, "<C-g>", function() mc.matchAddCursor(1) end, "Multi-curseur: occurrence suivante")
    map(both, "<A-g>", function() mc.matchSkipCursor(1) end, "Multi-curseur: sauter l'occurrence")
    map(both, "<A-q>", mc.toggleCursor, "Multi-curseur: geler / degeler les curseurs")

    map(both, "<Leader>Mn", function() mc.matchAddCursor(1) end, "Occurrence suivante")
    map(both, "<Leader>MN", function() mc.matchAddCursor(-1) end, "Occurrence precedente")
    map(both, "<Leader>Ms", function() mc.matchSkipCursor(1) end, "Sauter l'occurrence suivante")
    map(both, "<Leader>MS", function() mc.matchSkipCursor(-1) end, "Sauter l'occurrence precedente")
    map(both, "<Leader>Mj", function() mc.lineAddCursor(1) end, "Curseur sur la ligne du dessous")
    map(both, "<Leader>Mk", function() mc.lineAddCursor(-1) end, "Curseur sur la ligne du dessus")
    map(both, "<Leader>Ml", mc.alignCursors, "Aligner les colonnes")
    map(both, "<Leader>Mo", mc.addCursorOperator, "Un curseur par ligne (operateur)")
    map(both, "<Leader>Mq", mc.toggleCursor, "Geler / degeler les curseurs")
    map("n", "<Leader>Mr", mc.restoreCursors, "Restaurer les curseurs")
    map("x", "<Leader>Mm", mc.matchCursors, "Curseurs par regex dans la selection")
    map("x", "<Leader>Mp", mc.splitCursors, "Decouper la selection par regex")

    map("n", "<C-LeftMouse>", mc.handleMouse, "Multi-curseur: ajouter / retirer")
    map("n", "<C-LeftDrag>", mc.handleMouseDrag, "Multi-curseur: glisser")
    map("n", "<C-LeftRelease>", mc.handleMouseRelease, "Multi-curseur: relacher")

    mc.addKeymapLayer(function(layer)
      layer(both, "<Left>", mc.prevCursor, { desc = "Curseur precedent" })
      layer(both, "<Right>", mc.nextCursor, { desc = "Curseur suivant" })
      layer(both, "<Leader>Mx", mc.deleteCursor, { desc = "Supprimer ce curseur" })
      layer("n", "<Esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end, { desc = "Sortir du multi-curseur" })
    end)

    highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("multicursor_girly", { clear = true }),
      callback = highlights,
    })
    pcall(function() require("which-key").add { { "<Leader>M", group = "Multi-curseur" } } end)
  end,
}
