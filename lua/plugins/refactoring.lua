---@type LazySpec
return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
  opts = {},
  keys = {
    {
      "<Leader>re",
      function() require("refactoring").refactor "Extract Function" end,
      mode = "x",
      desc = "Extraire une fonction",
    },
    {
      "<Leader>rE",
      function() require("refactoring").refactor "Extract Function To File" end,
      mode = "x",
      desc = "Extraire une fonction vers un fichier",
    },
    {
      "<Leader>rv",
      function() require("refactoring").refactor "Extract Variable" end,
      mode = "x",
      desc = "Extraire une variable",
    },
    {
      "<Leader>ri",
      function() require("refactoring").refactor "Inline Variable" end,
      mode = { "n", "x" },
      desc = "Inline la variable",
    },
  },
}
