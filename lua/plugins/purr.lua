-- purr language support: wires the `purr lsp` language server into AstroLSP.
-- The binary comes from `cargo install --path .` in the purr repo (-> ~/.cargo/bin/purr).
-- Gives live diagnostics (analyzer + gradual type checker), hover, and formatting.

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

    -- format purr buffers on save via the language server
    opts.formatting = opts.formatting or {}
    opts.formatting.format_on_save = opts.formatting.format_on_save or {}
    opts.formatting.format_on_save.allow_filetypes = opts.formatting.format_on_save.allow_filetypes or {}
    table.insert(opts.formatting.format_on_save.allow_filetypes, "purr")
  end,
}
