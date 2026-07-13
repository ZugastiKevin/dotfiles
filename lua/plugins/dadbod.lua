---@type LazySpec
return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = { { "tpope/vim-dadbod", lazy = true } },
  cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
  keys = { { "<Leader>D", "<Cmd>DBUIToggle<CR>", desc = "Base de donnees (DBUI)" } },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_save_location = vim.fn.stdpath "data" .. "/dadbod_ui"
  end,
}
