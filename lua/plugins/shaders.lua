local hlsl_ext = { "hlsl", "hlsli", "fx", "fxh", "cginc", "compute", "shader", "usf", "ush" }
local glsl_ext = { "glsl", "vert", "frag", "geom", "comp", "tesc", "tese", "rgen", "rchit", "rmiss", "rahit", "rcall", "mesh", "task", "vs", "fs" }

local function register_filetypes()
  local extension = {}
  for _, e in ipairs(hlsl_ext) do
    extension[e] = "hlsl"
  end
  for _, e in ipairs(glsl_ext) do
    extension[e] = "glsl"
  end
  vim.filetype.add { extension = extension }
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
      },
    },
  },
}
