---@type LazySpec
return {
  "folke/snacks.nvim",
  opts = {
    input = { enabled = true },
    picker = { ui_select = true },
    image = { enabled = false },
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    indent = {
      enabled = true,
      animate = { enabled = true, duration = { step = 20, total = 300 } },
      scope = { enabled = true, underline = true },
    },
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { key = "f", desc = "Trouver un fichier", action = ":lua Snacks.dashboard.pick('files')" },
          { key = "r", desc = "Fichiers recents", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { key = "g", desc = "Chercher du texte", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { key = "p", desc = "Projets", action = ":lua Snacks.dashboard.pick('projects')" },
          { key = "n", desc = "Nouveau fichier", action = ":ene | startinsert" },
          { key = "L", desc = "Plugins (Lazy)", action = ":Lazy" },
          { key = "q", desc = "Quitter", action = ":qa" },
        },
      },
      sections = {
        function()
          return { header = require("girly_dash").frame(), align = "center", padding = 1 }
        end,
        { section = "keys", gap = 0, padding = 2 },
        { section = "recent_files", title = "Recents", indent = 2, padding = 1, limit = 6 },
        { section = "projects", title = "Projets", indent = 2, padding = 1, limit = 6 },
        { section = "startup" },
      },
    },
  },
  specs = {
    {
      "AstroNvim/astrocore",
      opts = {
        autocmds = {
          girly_dashboard_hl = {
            {
              event = { "VimEnter", "ColorScheme" },
              desc = "Teinte rose du header du dashboard",
              callback = function()
                vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#ff2d95", bold = true })
              end,
            },
          },
          girly_dashboard_blink = {
            {
              event = "User",
              pattern = "SnacksDashboardOpened",
              desc = "Clignement du chat du dashboard",
              callback = function() pcall(function() require("girly_dash").on_open() end) end,
            },
            {
              event = "User",
              pattern = "SnacksDashboardClosed",
              desc = "Arret du clignement",
              callback = function() pcall(function() require("girly_dash").on_close() end) end,
            },
          },
        },
      },
    },
  },
}
