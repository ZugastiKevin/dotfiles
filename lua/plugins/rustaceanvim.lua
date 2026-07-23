local function nearest_crate(fname) return require("rust_root").workspace_root(fname) end

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
            checkOnSave = true,
            completion = { autoimport = { enable = true }, autoself = { enable = true } },
            imports = { granularity = { group = "module" }, prefix = "self" },
          },
        },
      },
      dap = {
        adapter = {
          type = "server",
          port = "${port}",
          host = "127.0.0.1",
          executable = {
            command = vim.fn.stdpath "data" .. "/mason/bin/codelldb",
            args = {
              "--liblldb",
              vim.fn.stdpath "data" .. "/mason/opt/lldb/lib/liblldb.dylib",
              "--port",
              "${port}",
            },
          },
        },
      },
    }
  end,
}
