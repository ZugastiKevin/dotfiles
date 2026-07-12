local function nearest_crate(fname)
  if not fname or fname == "" then return nil end
  local match = vim.fs.find("Cargo.toml", { upward = true, path = vim.fs.dirname(fname) })[1]
  return match and vim.fs.dirname(match) or nil
end

---@type LazySpec
return {
  "mrcjkb/rustaceanvim",
  init = function()
    vim.g.rustaceanvim = {
      server = {
        auto_attach = function(bufnr) return nearest_crate(vim.api.nvim_buf_get_name(bufnr)) ~= nil end,
        root_dir = function(fname, _) return nearest_crate(fname) end,
        default_settings = {
          ["rust-analyzer"] = {
            check = { command = "clippy" },
            checkOnSave = true,
            completion = { autoimport = { enable = true }, autoself = { enable = true } },
            imports = { granularity = { group = "module" }, prefix = "self" },
          },
        },
      },
    }
  end,
}
