local function nearest_crate(fname) return require("rust_root").workspace_root(fname) end

local function codelldb_executable()
  local mason = vim.fn.stdpath "data" .. "/mason"
  if vim.fn.has "win32" == 1 then
    return { command = mason .. "/bin/codelldb.cmd", args = { "--port", "${port}" } }
  end
  local liblldb = mason .. "/opt/lldb/lib/liblldb" .. (vim.fn.has "mac" == 1 and ".dylib" or ".so")
  return { command = mason .. "/bin/codelldb", args = { "--liblldb", liblldb, "--port", "${port}" } }
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
          executable = codelldb_executable(),
        },
      },
    }
  end,
}
