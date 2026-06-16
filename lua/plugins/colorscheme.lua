---@type LazySpec
return {
  {
    "maxmx03/fluoromachine.nvim",
    lazy = false,
    priority = 1000,
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
