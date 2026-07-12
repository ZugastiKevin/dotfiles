---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    treesitter = {
      auto_install = true,
      ensure_installed = {
        "lua",
        "vim",
        "asm",
        "c",
        "cpp",
        "objc",
        "c_sharp",
        "java",
        "python",
        "swift",
        "json",
        "toml",
        "hlsl",
        "glsl",
      },
    },
  },
}
