---@type LazySpec
return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.keymap = opts.keymap or {}
    opts.keymap["<CR>"] = { "accept", "fallback" }

    opts.completion = opts.completion or {}
    opts.completion.menu = opts.completion.menu or {}
    opts.completion.menu.auto_show = true
    opts.completion.list = opts.completion.list or {}
    opts.completion.list.selection = { preselect = true, auto_insert = false }

    opts.completion.ghost_text = opts.completion.ghost_text or {}
    opts.completion.ghost_text.enabled = true

    return opts
  end,
}
