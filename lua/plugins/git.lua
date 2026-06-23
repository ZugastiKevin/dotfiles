---@type LazySpec
return {
  "lewis6991/gitsigns.nvim",
  opts = {
    current_line_blame = false,
    current_line_blame_opts = {
      delay = 350,
      virt_text_pos = "eol",
      ignore_whitespace = false,
    },
    current_line_blame_formatter = "   <author>, <author_time:%R> · <summary>",
  },
  keys = {
    { "<Leader>uB", "<Cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle git blame (ligne)" },
  },
}
