---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = {
    autocmds = {
      girly_effects_hl = {
        {
          event = { "VimEnter", "ColorScheme" },
          desc = "Palette girly des effets visuels",
          callback = function()
            local hl = vim.api.nvim_set_hl
            hl(0, "HlSearchLens", { fg = "#c14fff", bg = "#2a1430", italic = true })
            hl(0, "HlSearchLensNear", { fg = "#ff2d95", bg = "#3d1030", bold = true })
            hl(0, "GirlyBubbleContent", { fg = "#ff7eb6", bg = "#33122b", italic = true })
            hl(0, "GirlyBubbleEdge", { fg = "#33122b" })
            hl(0, "GirlySaveFlash", { bg = "#4a1f3d" })
          end,
        },
      },
    },
  },
}
