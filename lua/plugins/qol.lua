---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "User AstroFile",
    opts = {
      max_lines = 3,
      multiline_threshold = 1,
      trim_scope = "outer",
      mode = "cursor",
      separator = "─",
      zindex = 20,
    },
    keys = {
      { "<Leader>ux", "<Cmd>TSContext toggle<CR>", desc = "Toggle bandeau de scope" },
      { "[x", function() require("treesitter-context").go_to_context(vim.v.count1) end, desc = "Sauter au scope parent" },
    },
  },
  {
    "echasnovski/mini.splitjoin",
    event = "User AstroFile",
    opts = {
      mappings = { toggle = "gS" },
    },
  },
}
