---@type LazySpec
return {
  "mistweaverco/kulala.nvim",
  ft = { "http", "rest" },
  keys = {
    { "<Leader>Hs", mode = { "n", "x" }, desc = "Kulala: envoyer la requete" },
    { "<Leader>Ha", mode = { "n", "x" }, desc = "Kulala: envoyer toutes les requetes" },
    { "<Leader>Hr", desc = "Kulala: rejouer la derniere" },
    { "<Leader>Hb", desc = "Kulala: ouvrir le scratchpad" },
    { "<Leader>Ho", desc = "Kulala: ouvrir le panneau" },
  },
  opts = {
    global_keymaps = true,
    global_keymaps_prefix = "<Leader>H",
    kulala_keymaps_prefix = "",
  },
}
