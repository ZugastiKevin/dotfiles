---@type LazySpec
return {
  {
    "mg979/vim-visual-multi",
    event = "User AstroFile",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-g>",
        ["Find Subword Under"] = "<C-g>",
      }
      vim.g.VM_theme = "purplegray"
      vim.g.VM_silent_exit = 1
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    opts = {
      direction = "float",
      float_opts = {
        border = "rounded",
        width = function() return math.floor(vim.o.columns * 0.85) end,
        height = function() return math.floor(vim.o.lines * 0.8) end,
      },
      size = 14,
    },
  },
}
