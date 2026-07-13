---@type LazySpec
return {
  {
    "mason-org/mason.nvim",
    opts = {
      registries = {
        "github:Crashdummyy/mason-registry",
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "codelldb",
        "netcoredbg",
        "clang-format",
        "tree-sitter-cli",
        "debugpy",
        "roslyn",
        "csharpier",
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed =
        require("astrocore").list_insert_unique(opts.ensure_installed, { "asm_lsp", "glsl_analyzer" })
    end,
  },
}
