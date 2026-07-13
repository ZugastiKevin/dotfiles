return {
  "AstroNvim/astrocore",
  opts = function(_, opts)
    if opts.diagnostics and opts.diagnostics.jump then opts.diagnostics.jump.float = nil end
    return opts
  end,
}
