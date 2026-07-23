local function wipe_foreign_buffers(newcwd)
  newcwd = vim.fn.fnamemodify(newcwd, ":p"):gsub("/$", "")
  local home = vim.fn.fnamemodify("~", ":p"):gsub("/$", "")
  if newcwd == "" or newcwd == "/" or newcwd == home then return end
  local prefix = newcwd .. "/"

  local to_delete = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if
      vim.api.nvim_buf_is_valid(buf)
      and vim.bo[buf].buflisted
      and vim.bo[buf].buftype == ""
      and not vim.bo[buf].modified
    then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" and not vim.startswith(vim.fn.fnamemodify(name, ":p"), prefix) then
        to_delete[#to_delete + 1] = buf
      end
    end
  end
  for _, buf in ipairs(to_delete) do
    pcall(vim.api.nvim_buf_delete, buf, { force = false })
  end

  vim.schedule(function()
    for _, client in ipairs(vim.lsp.get_clients()) do
      if vim.tbl_isempty(client.attached_buffers or {}) then pcall(vim.lsp.stop_client, client.id) end
    end
  end)
end

local function hard_close()
  for _, client in ipairs(vim.lsp.get_clients()) do
    pcall(vim.lsp.stop_client, client.id, true)
  end
  pcall(function() require("neo-tree.command").execute { action = "close" } end)
  pcall(vim.cmd, "silent! %bwipeout!")
  pcall(function() require("snacks").dashboard() end)
end

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    opts = {
      commands = {
        ProjectClose = { hard_close, desc = "Vider le projet courant (buffers + LSP)" },
      },
      autocmds = {
        project_cwd = {
          {
            event = { "BufReadPost", "BufNewFile" },
            desc = "Ancrer le cwd sur la racine du projet, tous langages",
            callback = function(args)
              if vim.bo[args.buf].buftype ~= "" then return end
              local name = vim.api.nvim_buf_get_name(args.buf)
              if name == "" or name:match "^%w+://" then return end
              local root = require("project_root").root_of(name)
              if root and root ~= vim.fn.getcwd() then vim.api.nvim_set_current_dir(root) end
            end,
          },
        },
        project_wipe = {
          {
            event = "DirChanged",
            pattern = "global",
            desc = "Fermer les buffers des autres projets en changeant de racine",
            callback = function()
              if vim.g._project_wipe_running then return end
              vim.g._project_wipe_running = true
              wipe_foreign_buffers(vim.v.event.cwd or vim.fn.getcwd())
              vim.schedule(function() vim.g._project_wipe_running = false end)
            end,
          },
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.picker = opts.picker or {}
      opts.picker.sources = opts.picker.sources or {}
      opts.picker.sources.projects = vim.tbl_deep_extend("force", opts.picker.sources.projects or {}, {
        dev = {
          "~/RustroverProjects",
          "~/CLionProjects",
          "~/IdeaProjects",
          "~/RiderProjects",
          "~/SwiftProjects",
        },
        projects = { "~/pas_de_csharp_pour_toi", "~/start_game_project" },
        recent = true,
        max_depth = 2,
        confirm = function(picker, item)
          picker:close()
          local dir = item and (item.file or item.cwd or item.dir or item.text)
          if not dir or dir == "" then return end
          local path = (vim.fn.fnamemodify(dir, ":p"):gsub("/$", ""))
          vim.api.nvim_set_current_dir(path)
          pcall(function() require("neo-tree.command").execute { action = "focus", dir = vim.fn.getcwd() } end)
        end,
      })
    end,
  },
  {
    "jay-babu/project.nvim",
    opts = {
      detection_methods = { "lsp", "pattern" },
      ignore_lsp = { "typos_lsp", "null-ls", "none-ls", "copilot" },
      patterns = {
        "ProjectSettings",
        "Assets",
        "*.slnx",
        "*.sln",
        ".git",
        "package.json",
        "go.mod",
        "Makefile",
        "Package.swift",
        "*.xcodeproj",
        "build.gradle",
      },
      scope_chdir = false,
    },
  },
}
