---@type LazySpec
return {
  {
    "rachartier/tiny-glimmer.nvim",
    event = "VeryLazy",
    opts = {
      overwrite = {
        yank = {
          enabled = true,
          default_animation = {
            name = "fade",
            settings = { from_color = "#c1c0c3", to_color = "Normal", max_duration = 420, min_duration = 250 },
          },
        },
        paste = {
          enabled = true,
          default_animation = {
            name = "reverse_fade",
            settings = { from_color = "#cf8f7c", to_color = "Normal", max_duration = 400, min_duration = 250 },
          },
        },
        search = {
          enabled = true,
          default_animation = {
            name = "pulse",
            settings = { from_color = "#cf8f7c", to_color = "Normal" },
          },
        },
        undo = {
          enabled = true,
          default_animation = {
            name = "fade",
            settings = { from_color = "#c9604f", to_color = "Normal", max_duration = 420, min_duration = 300 },
          },
        },
        redo = {
          enabled = true,
          default_animation = {
            name = "fade",
            settings = { from_color = "#b98aff", to_color = "Normal", max_duration = 420, min_duration = 300 },
          },
        },
      },
      presets = {
        pulsar = {
          enabled = false,
          on_event = { "WinEnter", "BufEnter" },
          default_animation = {
            name = "fade",
            settings = { from_color = "#c1c0c3", to_color = "Normal", max_duration = 600, min_duration = 600 },
          },
        },
      },
    },
  },
  {
    "AstroNvim/astrocore",
    opts = {
      autocmds = {
        highlightyank = false,
      },
    },
  },
  {
    "gbprod/yanky.nvim",
    opts = {
      highlight = { on_yank = false },
    },
  },
}
