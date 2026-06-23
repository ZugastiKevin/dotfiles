local function has_file(name) return vim.fs.find(name, { upward = true, path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)) })[1] ~= nil end

local function buf_map(buf, lhs, rhs, desc, mode)
  vim.keymap.set(mode or "n", lhs, rhs, { buffer = buf, silent = true, desc = desc })
end

local function compile_run_single()
  local file = vim.fn.expand "%:p"
  local out = vim.fn.expand "%:p:r"
  local cc = vim.bo.filetype == "c" and "clang" or "clang++"
  local std = vim.bo.filetype == "c" and "-std=c17" or "-std=c++20"
  local cmd = string.format("%s %s -g -O0 %s -o %s && %s", cc, std, vim.fn.shellescape(file), vim.fn.shellescape(out), vim.fn.shellescape(out))
  vim.cmd "write"
  vim.cmd("TermExec direction=horizontal cmd=" .. vim.fn.shellescape(cmd))
end

local function codelldb_path()
  local p = vim.fn.exepath "codelldb"
  if p ~= "" then return p end
  return vim.fn.expand "$MASON/bin/codelldb"
end

local function configure_dap()
  local dap = require "dap"

  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = codelldb_path(),
      args = { "--port", "${port}" },
    },
  }

  local native = {
    {
      name = "Launch (fichier compile)",
      type = "codelldb",
      request = "launch",
      program = function() return vim.fn.input("Executable : ", vim.fn.expand "%:p:r", "file") end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},
    },
    {
      name = "Attach to process",
      type = "codelldb",
      request = "attach",
      pid = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
    },
  }

  dap.configurations.cpp = native
  dap.configurations.c = native
  dap.configurations.objc = native
  dap.configurations.objcpp = native
end

---@type LazySpec
return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    config = configure_dap,
  },
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          ["<Leader>o"] = { desc = "Taches (Overseer)" },
          ["<Leader>oo"] = { "<Cmd>OverseerToggle<CR>", desc = "Overseer: panneau" },
          ["<Leader>or"] = { "<Cmd>OverseerRun<CR>", desc = "Overseer: lancer une tache" },
          ["<Leader>ob"] = { "<Cmd>OverseerBuild<CR>", desc = "Overseer: creer une tache" },
          ["<Leader>oa"] = { "<Cmd>OverseerQuickAction<CR>", desc = "Overseer: action rapide" },
          ["<Leader>ol"] = { "<Cmd>OverseerRestartLast<CR>", desc = "Overseer: relancer la derniere" },
          ["<Leader>ln"] = { function() require("neogen").generate() end, desc = "Generer la doc (Doxygen/Javadoc)" },
        },
      },
      autocmds = {
        c_cpp_keymaps = {
          {
            event = "FileType",
            pattern = { "c", "cpp", "objc", "objcpp" },
            desc = "Keymaps C/C++ (clangd, CMake, build/run)",
            callback = function(args)
              local buf = args.buf
              buf_map(buf, "<Leader>lh", "<Cmd>ClangdSwitchSourceHeader<CR>", "Basculer header/source")
              buf_map(buf, "<A-o>", "<Cmd>ClangdSwitchSourceHeader<CR>", "Basculer header/source")
              buf_map(buf, "<Leader>lb", "<Cmd>CMakeBuild<CR>", "CMake: build")
              buf_map(buf, "<Leader>lr", "<Cmd>CMakeRun<CR>", "CMake: run")
              buf_map(buf, "<Leader>lD", "<Cmd>CMakeDebug<CR>", "CMake: debug")
              buf_map(buf, "<Leader>lg", "<Cmd>CMakeGenerate<CR>", "CMake: generate")
              buf_map(buf, "<Leader>lt", "<Cmd>CMakeSelectBuildTarget<CR>", "CMake: choisir la cible")
              buf_map(buf, "<Leader>lT", "<Cmd>CMakeSelectBuildType<CR>", "CMake: type de build")
              buf_map(buf, "<C-r>", function()
                if has_file "CMakeLists.txt" then
                  vim.cmd "CMakeRun"
                else
                  compile_run_single()
                end
              end, "Run (CMake ou fichier seul)")
              buf_map(buf, "<C-d>", function()
                if has_file "CMakeLists.txt" then
                  vim.cmd "CMakeDebug"
                else
                  require("dap").continue()
                end
              end, "Debug (CMake ou codelldb)")
            end,
          },
        },
        java_keymaps = {
          {
            event = "FileType",
            pattern = "java",
            desc = "Keymaps Java (jdtls, tests, build/run)",
            callback = function(args)
              local buf = args.buf
              local jdtls = function() return require "jdtls" end
              buf_map(buf, "<Leader>li", function() jdtls().organize_imports() end, "Java: organiser les imports")
              buf_map(buf, "<Leader>lv", function() jdtls().extract_variable() end, "Java: extraire variable")
              buf_map(buf, "<Leader>lc", function() jdtls().extract_constant() end, "Java: extraire constante")
              buf_map(buf, "<Leader>lv", function() jdtls().extract_variable(true) end, "Java: extraire variable", "v")
              buf_map(buf, "<Leader>lc", function() jdtls().extract_constant(true) end, "Java: extraire constante", "v")
              buf_map(buf, "<Leader>lm", function() jdtls().extract_method(true) end, "Java: extraire methode", "v")
              buf_map(buf, "<Leader>lt", function() jdtls().test_nearest_method() end, "Java: tester la methode")
              buf_map(buf, "<Leader>lT", function() jdtls().test_class() end, "Java: tester la classe")
              buf_map(buf, "<Leader>lb", "<Cmd>OverseerRun<CR>", "Build (Gradle/Maven via Overseer)")
              buf_map(buf, "<C-r>", function() require("dap").continue() end, "Run / Debug (classe main)")
              buf_map(buf, "<C-d>", function() require("dap").run_last() end, "Relancer le dernier debug")
            end,
          },
        },
      },
    },
  },
}
