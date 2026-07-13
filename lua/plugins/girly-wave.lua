---@type LazySpec
return {
  "rebelot/heirline.nvim",
  optional = true,
  opts = function(_, opts)
    if opts.statusline then
      table.insert(opts.statusline, {
        provider = function() return require("girly_gradient").strip() end,
      })
    end
  end,
}
