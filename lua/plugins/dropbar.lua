---@type LazySpec
return {
  "Bekaboo/dropbar.nvim",
  event = "User AstroFile",
  opts = {
    bar = {
      enable = function(buf, win)
        if vim.bo[buf].buftype ~= "" or vim.fn.win_gettype(win) ~= "" then return false end
        return vim.bo[buf].filetype ~= "" and not vim.wo[win].diff
      end,
    },
    icons = {
      ui = { bar = { separator = "  ", extends = "…" } },
    },
  },
  keys = {
    { "<Leader>;", function() require("dropbar.api").pick() end, desc = "Dropbar: naviguer le fil d'ariane" },
  },
  config = function(_, opts)
    require("dropbar").setup(opts)
    local h = vim.api.nvim_set_hl
    h(0, "DropBarIconKindFunction", { fg = "#ff5eb4" })
    h(0, "DropBarIconUISeparator", { fg = "#9a8aa8" })
    h(0, "DropBarCurrentContext", { fg = "#8fe0d4", bold = true })
  end,
}
