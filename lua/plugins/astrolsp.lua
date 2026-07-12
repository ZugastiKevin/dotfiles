---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    features = {
      codelens = true,
      inlay_hints = true,
      semantic_tokens = true,
    },
    formatting = {
      format_on_save = {
        enabled = true,
        allow_filetypes = {},
        ignore_filetypes = {},
      },
      disabled = { "roslyn" },
      timeout_ms = 1000,
    },
    config = {
      sourcekit = {
        filetypes = { "swift" },
      },
    },
    autocmds = {
      lsp_codelens_refresh = {
        cond = "textDocument/codeLens",
        {
          event = { "InsertLeave", "BufEnter" },
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.enable(true, { bufnr = args.buf }) end
          end,
        },
      },
    },
    mappings = {
      n = {
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },

        ["<D-b>"] = {
          function() vim.lsp.buf.definition() end,
          desc = "Go to declaration",
          cond = "textDocument/definition",
        },
        ["<D-S-i>"] = {
          function() require("snacks").picker.lsp_implementations() end,
          desc = "Go to implementation",
          cond = "textDocument/implementation",
        },
        ["<C-S-b>"] = {
          function() require("snacks").picker.lsp_type_definitions() end,
          desc = "Go to type declaration",
          cond = "textDocument/typeDefinition",
        },
        ["<D-u>"] = {
          function() require("snacks").picker.lsp_references() end,
          desc = "Find usages",
          cond = "textDocument/references",
        },
        ["<D-p>"] = {
          function() vim.lsp.buf.signature_help() end,
          desc = "Parameter info",
          cond = "textDocument/signatureHelp",
        },
        ["<D-j>"] = {
          function() vim.lsp.buf.hover() end,
          desc = "Quick documentation",
          cond = "textDocument/hover",
        },
        ["<C-S-r>"] = {
          function()
            local ok = pcall(vim.cmd.IncRename, vim.fn.expand "<cword>")
            if not ok then vim.lsp.buf.rename() end
          end,
          desc = "Rename",
          cond = "textDocument/rename",
        },
        ["<C-S-l>"] = {
          function() vim.lsp.buf.format { async = true } end,
          desc = "Reformat code",
          cond = "textDocument/formatting",
        },
        ["<D-.>"] = {
          function() vim.lsp.buf.code_action() end,
          desc = "Show intention actions",
          cond = "textDocument/codeAction",
        },
        ["<D-7>"] = {
          function() require("snacks").picker.lsp_symbols() end,
          desc = "File structure (symbols)",
          cond = "textDocument/documentSymbol",
        },
        ["<D-S-y>"] = {
          function() require("snacks").picker.lsp_workspace_symbols() end,
          desc = "Go to symbol (project)",
          cond = "workspace/symbol",
        },
        ["]d"] = {
          function()
            vim.diagnostic.jump { count = 1 }
            vim.diagnostic.open_float { focus = false, scope = "cursor", border = "rounded" }
          end,
          desc = "Probleme suivant",
        },
        ["[d"] = {
          function()
            vim.diagnostic.jump { count = -1 }
            vim.diagnostic.open_float { focus = false, scope = "cursor", border = "rounded" }
          end,
          desc = "Probleme precedent",
        },
        ["<C-S-d>"] = { function() vim.diagnostic.open_float() end, desc = "Detail du probleme" },

        ["<Leader>uH"] = {
          function() require("astrolsp.toggles").buffer_inlay_hints() end,
          desc = "Toggle inlay hints (buffer)",
        },
      },
      i = {
        ["<C-S-l>"] = {
          function() vim.lsp.buf.format { async = true } end,
          desc = "Reformat code",
          cond = "textDocument/formatting",
        },
        ["<D-p>"] = {
          function() vim.lsp.buf.signature_help() end,
          desc = "Parameter info",
          cond = "textDocument/signatureHelp",
        },
      },
    },
    on_attach = function(_, _) end,
  },
}
