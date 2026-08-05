---@type LazySpec
return {
  "mrjones2014/smart-splits.nvim",
  keys = require("keymap_platform").keys {
    { "<D-S-h>", function() require("smart-splits").resize_left() end, desc = "Reduire largeur fenetre" },
    { "<D-S-l>", function() require("smart-splits").resize_right() end, desc = "Agrandir largeur fenetre" },
    { "<D-S-j>", function() require("smart-splits").resize_down() end, desc = "Reduire hauteur fenetre" },
    { "<D-S-k>", function() require("smart-splits").resize_up() end, desc = "Agrandir hauteur fenetre" },
  },
  opts = {},
}
