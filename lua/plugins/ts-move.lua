local function mv(fn, query)
  return function() require("nvim-treesitter-textobjects.move")[fn](query, "textobjects") end
end

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  keys = {
    { "]f", mv("goto_next_start", "@function.outer"), mode = { "n", "x", "o" }, desc = "Fonction suivante" },
    { "[f", mv("goto_previous_start", "@function.outer"), mode = { "n", "x", "o" }, desc = "Fonction precedente" },
    { "]]", mv("goto_next_start", "@class.outer"), mode = { "n", "x", "o" }, desc = "Classe / impl suivant" },
    { "[[", mv("goto_previous_start", "@class.outer"), mode = { "n", "x", "o" }, desc = "Classe / impl precedent" },
  },
  config = function() require("nvim-treesitter-textobjects").setup {} end,
}
