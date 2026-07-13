---@type LazySpec
return {
  {
    "andrewferrier/debugprint.nvim",
    keys = { { "g?", mode = { "n", "x" }, desc = "Debug print" } },
    cmd = "Debugprint",
    opts = {
      keymaps = {
        normal = {
          delete_debug_prints = "g?d",
          toggle_comment_debug_prints = "g?t",
          jump_prev_debug_print = "",
          jump_next_debug_print = "",
          jump_first_debug_print = "",
          jump_last_debug_print = "",
        },
      },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, { "g?", group = "Debug print", mode = { "n", "x" } })
    end,
  },
}
