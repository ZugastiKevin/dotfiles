local hlsl_ext = { "hlsl", "hlsli", "fx", "fxh", "cginc", "compute", "usf", "ush" }
local glsl_ext = { "glsl", "vert", "frag", "geom", "comp", "tesc", "tese", "rgen", "rchit", "rmiss", "rahit", "rcall", "mesh", "task", "vs", "fs" }

local function register_filetypes()
  local extension = {
    shader = "shaderlab",
    slang = "shaderslang",
    wgsl = "wgsl",
  }
  for _, e in ipairs(hlsl_ext) do
    extension[e] = "hlsl"
  end
  for _, e in ipairs(glsl_ext) do
    extension[e] = "glsl"
  end
  vim.filetype.add { extension = extension }
  vim.treesitter.language.register("hlsl", "shaderlab")
  vim.treesitter.language.register("hlsl", "shaderslang")
end

---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    init = register_filetypes,
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      config = {
        glsl_analyzer = {
          filetypes = { "glsl", "vert", "frag", "geom", "comp", "tesc", "tese", "rgen", "rchit", "rmiss", "rahit" },
        },
        wgsl_analyzer = {
          settings = {
            ["wgsl-analyzer"] = {
              diagnostics = { nagaParsing = true, nagaValidation = true },
              inlayHints = { enabled = true, typeHints = true, parameterHints = true },
            },
          },
        },
        slangd = {
          filetypes = { "hlsl", "shaderslang" },
          settings = {
            slang = {
              inlayHints = { deducedTypes = true, parameterNames = true },
              format = { clangFormatStyle = "file" },
            },
          },
        },
      },
    },
  },
}
