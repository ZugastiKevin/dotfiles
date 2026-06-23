---@type LazySpec
return {
  {
    "AmberLehmann/candyland.nvim",
    lazy = true,
  },
  {
    "maxmx03/fluoromachine.nvim",
    lazy = true,
    config = function()
      local ok, fm = pcall(require, "fluoromachine")
      if ok then
        fm.setup {
          glow = true,
          theme = "fluoromachine",
          transparent = false,
        }
      end
    end,
  },
}
