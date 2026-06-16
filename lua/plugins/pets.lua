local function graphics_terminal()
  if vim.g.neovide then return false end
  local prog = (vim.env.TERM_PROGRAM or ""):lower()
  local term = (vim.env.TERM or ""):lower()
  return prog == "ghostty"
    or prog == "wezterm"
    or term:find "ghostty"
    or term:find "kitty"
    or vim.env.KITTY_WINDOW_ID ~= nil
end

local function restore_assets()
  local src = vim.fn.stdpath "config" .. "/petscat"
  local dst = vim.fn.stdpath "data" .. "/lazy/pets.nvim"
  if vim.fn.isdirectory(dst) == 0 then return end
  if vim.fn.isdirectory(dst .. "/media/cat") == 0 and vim.fn.isdirectory(src .. "/media/cat") == 1 then
    vim.fn.system { "cp", "-R", src .. "/media/cat", dst .. "/media/" }
  end
  if vim.fn.filereadable(dst .. "/lua/pets/pets/cat.lua") == 0 and vim.fn.filereadable(src .. "/cat.lua") == 1 then
    vim.fn.system { "cp", src .. "/cat.lua", dst .. "/lua/pets/pets/cat.lua" }
  end
end

local function patch_hologram()
  local ok, term = pcall(require, "hologram.terminal")
  if not ok then return end
  term.move_cursor = function(row, col)
    term.write "\x1b[s"
    term.write("\x1b[" .. row .. ";" .. col .. "H")
  end
end

local function init()
  restore_assets()
  patch_hologram()
end

return {
  "giusgad/pets.nvim",
  dependencies = { "MunifTanjim/nui.nvim", "edluffy/hologram.nvim" },
  cmd = { "PetsNew", "PetsNewCustom" },
  init = init,
  opts = {
    row = 9,
    col = 0,
    speed_multiplier = 1.1,
    default_pet = "cat",
    default_style = "cc0",
    random = false,
    death_animation = false,
    popup = { width = "35%", winblend = 100, avoid_statusline = false },
  },
  specs = {
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        if not graphics_terminal() then return end
        opts.autocmds = opts.autocmds or {}
        opts.autocmds.pets_autospawn = {
          {
            event = "VimEnter",
            once = true,
            desc = "Faire apparaitre le chat pixel dans le terminal",
            callback = function()
              vim.defer_fn(function() pcall(vim.cmd, "PetsNew minette") end, 800)
            end,
          },
        }
      end,
    },
  },
}
