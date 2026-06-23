local function rust_action(action)
  return function() vim.cmd.RustLsp(action) end
end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = {
    autocmds = {
      rust_keymaps = {
        {
          event = "FileType",
          pattern = "rust",
          desc = "Keymaps Rust (rustaceanvim)",
          callback = function(args)
            local function map(lhs, rhs, desc)
              vim.keymap.set("n", lhs, rhs, { buffer = args.buf, silent = true, desc = desc })
            end
            map("<Leader>lm", rust_action "expandMacro", "Rust: expand macro")
            map("<Leader>le", rust_action "explainError", "Rust: expliquer l'erreur")
            map("<Leader>lc", rust_action "openCargo", "Rust: ouvrir Cargo.toml")
            map("<Leader>lp", rust_action "parentModule", "Rust: module parent")
            map("<Leader>lo", rust_action "openDocs", "Rust: docs.rs du symbole")
            map("<Leader>lr", rust_action "ssr", "Rust: structural search/replace")
            map("<Leader>lt", rust_action "syntaxTree", "Rust: arbre syntaxique")
            map("<Leader>lk", function() vim.cmd.RustLsp { "moveItem", "up" } end, "Rust: monter l'item")
            map("<Leader>lj", function() vim.cmd.RustLsp { "moveItem", "down" } end, "Rust: descendre l'item")
            map("<Leader>lR", rust_action "runnables", "Rust: runnables")
            map("<Leader>lT", rust_action "testables", "Rust: testables")
            map("<Leader>lW", rust_action "reloadWorkspace", "Rust: reload workspace")
            map("<Leader>lP", rust_action "rebuildProcMacros", "Rust: rebuild proc-macros")
            map("K", function() vim.cmd.RustLsp { "hover", "actions" } end, "Hover + actions (Rust)")
          end,
        },
      },
      crates_keymaps = {
        {
          event = { "BufRead", "BufNewFile" },
          pattern = "Cargo.toml",
          desc = "Keymaps crates.nvim",
          callback = function(args)
            local function map(lhs, fn, desc)
              vim.keymap.set(
                "n",
                lhs,
                function() require("crates")[fn]() end,
                { buffer = args.buf, silent = true, desc = desc }
              )
            end
            map("<Leader>lv", "show_versions_popup", "Crates: versions")
            map("<Leader>lf", "show_features_popup", "Crates: features")
            map("<Leader>lu", "update_crate", "Crates: update (cette dep)")
            map("<Leader>lU", "update_all_crates", "Crates: update tout")
            map("<Leader>lg", "upgrade_crate", "Crates: upgrade (cette dep)")
            map("<Leader>lG", "upgrade_all_crates", "Crates: upgrade tout")
            map("<Leader>lo", "open_documentation", "Crates: doc de la dep")
          end,
        },
      },
    },
  },
}
