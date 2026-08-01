local function splits() return require "smart-splits" end

---@type LazySpec
return {
  "nvimtools/hydra.nvim",
  opts = {
    Fenetres = {
      mode = "n",
      body = "<Leader>W",
      config = {
        color = "pink",
        invoke_on_body = true,
        hint = { type = "window", position = "middle" },
      },
      hint = [[
                 Fenetres

   _h_ _j_ _k_ _l_   redimensionner
   _H_ _J_ _K_ _L_   se deplacer
   _s_   split horizontal
   _v_   split vertical
   _x_   echanger deux fenetres
   _=_   egaliser
   _o_   fermer les autres
   _c_   fermer celle-ci

   _<Esc>_  sortir
]],
      heads = {
        { "h", function() splits().resize_left() end },
        { "j", function() splits().resize_down() end },
        { "k", function() splits().resize_up() end },
        { "l", function() splits().resize_right() end },
        { "H", function() splits().move_cursor_left() end },
        { "J", function() splits().move_cursor_down() end },
        { "K", function() splits().move_cursor_up() end },
        { "L", function() splits().move_cursor_right() end },
        { "s", "<C-w>s" },
        { "v", "<C-w>v" },
        { "x", "<C-w>x" },
        { "=", "<C-w>=" },
        { "o", "<C-w>o" },
        { "c", "<C-w>c" },
        { "<Esc>", nil, { exit = true, nowait = true } },
      },
    },
  },
}
