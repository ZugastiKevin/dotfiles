local jdk25 = require("java_home").find "25"

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      treesitter = { ensure_installed = { "groovy" } },
    },
  },
  {
    "mfussenegger/nvim-jdtls",
    optional = true,
    opts = {
      settings = {
        java = {
          configuration = {
            runtimes = jdk25 and {
              { name = "JavaSE-25", path = jdk25, default = true },
            } or {},
          },
          import = {
            gradle = {
              enabled = true,
              wrapper = { enabled = true },
            },
          },
        },
      },
    },
  },
}
