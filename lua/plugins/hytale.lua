local jdk25 = "/Library/Java/JavaVirtualMachines/jdk-25.jdk/Contents/Home"

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
            runtimes = {
              { name = "JavaSE-25", path = jdk25, default = true },
            },
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
