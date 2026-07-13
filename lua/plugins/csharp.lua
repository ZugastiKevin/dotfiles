local function netcoredbg_path()
  local p = vim.fn.exepath "netcoredbg"
  if p ~= "" then return p end
  return vim.fn.expand "$MASON/bin/netcoredbg"
end

local vstuc_bin = vim.fn.stdpath "data" .. "/unity-debug/extension/bin/"

local function unity_project_path()
  local path = vim.fn.expand "%:p"
  while true do
    local parent = vim.fn.fnamemodify(path, ":h")
    if parent == path then return "" end
    path = parent
    if vim.fn.isdirectory(path .. "/Assets") == 1 then return path end
  end
end

local synced_projects = {}
local function unity_root_of(file)
  local dir = vim.fn.fnamemodify(file, ":h")
  while dir and dir ~= "/" do
    if vim.fn.isdirectory(dir .. "/Assets") == 1 and vim.fn.filereadable(dir .. "/Packages/manifest.json") == 1 then
      return dir
    end
    dir = vim.fn.fnamemodify(dir, ":h")
  end
  return nil
end

local function ensure_unity_nvim_pkg()
  local root = unity_project_path()
  if root == "" then return end
  local manifest = root .. "/Packages/manifest.json"
  if vim.fn.filereadable(manifest) == 0 then return end
  if table.concat(vim.fn.readfile(manifest), "\n"):find("com.walcht.ide.neovim", 1, true) then return end
  vim.system({ vim.fn.expand "~/.local/bin/unity-nvim", root }, { text = true }, function()
    vim.schedule(function()
      vim.notify(
        "Package Neovim ajoute au projet Unity — dans Unity: Regenerate project files",
        vim.log.levels.INFO,
        { title = "Unity" }
      )
    end)
  end)
end

local function unity_endpoint()
  local probe = vstuc_bin .. "UnityAttachProbe.dll"
  if vim.fn.filereadable(probe) == 0 then return "" end
  local res = vim.system({ "dotnet", probe }, { text = true }):wait(3000).stdout
  if not res or #res == 0 then
    vim.notify("Unity: aucun Editor detecte (l'Unity Editor est-il lance ?)", vim.log.levels.WARN)
    return ""
  end
  for json in vim.gsplit(res, "\n") do
    if json ~= "" then
      local ok, probes = pcall(vim.json.decode, json)
      if ok and probes then
        for _, p in pairs(probes) do
          if p.isBackground == false then return p.address .. ":" .. p.debuggerPort end
        end
      end
    end
  end
  return ""
end

local function configure_dap()
  local dap = require "dap"

  dap.adapters.coreclr = {
    type = "executable",
    command = netcoredbg_path(),
    args = { "--interpreter=vscode" },
  }

  dap.adapters.vstuc = {
    type = "executable",
    command = "dotnet",
    args = { vstuc_bin .. "UnityDebugAdapter.dll" },
    name = "Attach to Unity",
  }

  dap.configurations.cs = {
    {
      type = "vstuc",
      request = "attach",
      name = "Attach to Unity Editor",
      logFile = vim.fs.joinpath(vim.fn.stdpath "data", "vstuc.log"),
      projectPath = unity_project_path,
      endPoint = unity_endpoint,
    },
    {
      type = "coreclr",
      name = "Launch (.NET)",
      request = "launch",
      program = function()
        local default = vim.fn.getcwd() .. "/bin/Debug/"
        return vim.fn.input("Chemin de la DLL : ", default, "file")
      end,
      cwd = "${workspaceFolder}",
      stopAtEntry = false,
    },
    {
      type = "coreclr",
      name = "Attach to process",
      request = "attach",
      processId = require("dap.utils").pick_process,
    },
  }
end

---@type LazySpec
return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function() configure_dap() end,
  },
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      autocmds = {
        unity_csproj_sync = {
          {
            event = { "BufWritePost", "BufReadPost" },
            pattern = "*.cs",
            desc = "Ajoute le .cs au bon .csproj Unity (roslyn le voit sans regen Unity)",
            callback = function(args)
              local file = vim.api.nvim_buf_get_name(args.buf)
              if file == "" or not file:find("/Assets/", 1, true) then return end
              if args.event == "BufReadPost" then
                local root = unity_root_of(file)
                if not root or synced_projects[root] then return end
                synced_projects[root] = true
                vim.system(
                  { vim.fn.expand "~/.local/bin/unity-csproj-sync-all", root },
                  { text = true },
                  function(res)
                    local n = res.stdout and tonumber(res.stdout:match "synced (%d+)")
                    if n and n > 0 then
                      vim.schedule(function()
                        vim.notify(n .. " fichier(s) ajoute(s) aux .csproj Unity — roslyn recharge", vim.log.levels.INFO, { title = "Unity" })
                      end)
                    end
                  end
                )
              else
                vim.system(
                  { vim.fn.expand "~/.local/bin/unity-csproj-sync", file },
                  { text = true },
                  function(res)
                    if res.stdout and res.stdout:find("added", 1, true) then
                      vim.schedule(function()
                        vim.notify("Ajoute au .csproj Unity — roslyn recharge tout seul", vim.log.levels.INFO, { title = "Unity" })
                      end)
                    end
                  end
                )
              end
            end,
          },
        },
        csharp_keymaps = {
          {
            event = "FileType",
            pattern = "cs",
            desc = "Keymaps C# (.NET / Unity)",
            callback = function(args)
              pcall(ensure_unity_nvim_pkg)
              local function map(lhs, rhs, desc, mode)
                vim.keymap.set(mode or "n", lhs, rhs, { buffer = args.buf, silent = true, desc = desc })
              end
              map("<Leader>lR", function() require("dap").continue() end, "C#: lancer / debug (choisir config)")
              map("<Leader>lr", function()
                vim.cmd "LspRestart"
                vim.notify("roslyn relance — indexation ~1-2 min (regarde fidget)", vim.log.levels.INFO, { title = "Unity" })
              end, "C#: relancer roslyn (re-indexer la solution)")
              map("<Leader>lo", function() vim.lsp.buf.code_action { context = { only = { "source.organizeImports" } }, apply = true } end, "C#: organiser les usings")
              map("<Leader>rr", function() require("dap").continue() end, "C#: lancer / debug")
            end,
          },
        },
      },
    },
  },
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      filewatching = "auto",
      broad_search = true,
      lock_target = true,
    },
    config = function(_, opts)
      vim.lsp.config("roslyn", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
        settings = {
          ["csharp|completion"] = {
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_show_name_completion_suggestions = true,
            dotnet_provide_regex_completions = true,
          },
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "openFiles",
            dotnet_compiler_diagnostics_scope = "openFiles",
          },
          ["csharp|symbol_search"] = {
            dotnet_search_reference_assemblies = true,
          },
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            dotnet_enable_inlay_hints_for_parameters = true,
          },
        },
      })
      require("roslyn").setup(opts)
    end,
  },
}
