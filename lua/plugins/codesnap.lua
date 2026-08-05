---@type LazySpec
return {
  "mistricky/codesnap.nvim",
  build = vim.fn.has "win32" == 1 and "powershell -ExecutionPolicy Bypass -File ./install.ps1" or "make build_generator",
  cmd = { "CodeSnap", "CodeSnapSave" },
  keys = {
    { "<Leader>cs", "<Esc><Cmd>CodeSnap<CR>", mode = "x", desc = "Screenshot du code (presse-papier)" },
    { "<Leader>cS", "<Esc><Cmd>CodeSnapSave<CR>", mode = "x", desc = "Screenshot du code (fichier)" },
  },
  opts = {
    save_path = "~/Pictures/CodeSnap",
    has_breadcrumbs = true,
    mac_window_bar = true,
    bg_color = "#ff2d95",
    watermark = "",
    code_font_family = "JetBrainsMono Nerd Font",
  },
}
