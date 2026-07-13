---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@param opts AstroLSPOpts
  opts = function(_, opts)
    opts.config = opts.config or {}
    opts.config.purr = {
      cmd = { "purr", "lsp" },
      filetypes = { "purr" },
      root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        on_dir(vim.fs.root(bufnr, { ".git", "Cargo.toml" }) or vim.fs.dirname(fname))
      end,
    }
    opts.servers = opts.servers or {}
    table.insert(opts.servers, "purr")
  end,
}
