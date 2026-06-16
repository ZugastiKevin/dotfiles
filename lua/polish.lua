local extra_path = { vim.fn.expand "~/.cargo/bin", "/opt/homebrew/bin", "/opt/homebrew/sbin" }
for _, p in ipairs(extra_path) do
  if not string.find(":" .. (vim.env.PATH or "") .. ":", ":" .. p .. ":", 1, true) then
    vim.env.PATH = p .. ":" .. (vim.env.PATH or "")
  end
end

if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font:h14"
  vim.g.neovide_padding_top = 6
  vim.g.neovide_padding_bottom = 6
  vim.g.neovide_padding_left = 6
  vim.g.neovide_padding_right = 6
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
  vim.g.neovide_floating_shadow = true
  vim.g.neovide_cursor_animation_length = 0.13
  vim.g.neovide_cursor_short_animation_length = 0.06
  vim.g.neovide_cursor_trail_size = 0.9
  vim.g.neovide_cursor_animate_in_insert_mode = true
  vim.g.neovide_cursor_animate_command_line = true
  math.randomseed((vim.uv or vim.loop).hrtime())
  local vfx_modes = { "railgun", "pixiedust", "torpedo", "sonicboom", "ripple" }
  vim.g.neovide_cursor_vfx_mode = vfx_modes[math.random(#vfx_modes)]
  vim.g.neovide_cursor_vfx_particle_lifetime = 1.4
  vim.g.neovide_cursor_vfx_particle_density = 12.0
  vim.g.neovide_cursor_vfx_particle_speed = 12.0
  vim.g.neovide_cursor_vfx_opacity = 220.0
  vim.g.neovide_scroll_animation_length = 0.2
  vim.g.neovide_refresh_rate = 120
  vim.g.neovide_window_blurred = true
  vim.g.neovide_input_macos_option_key_is_meta = "both"
  vim.g.neovide_input_macos_alt_is_meta = true

  local trail_colors = {
    "#ff4fd8", "#c14fff", "#ff6ac1", "#ff7eb6", "#ff5d8f",
    "#b98aff", "#7df9ff", "#5ef1d6", "#ffd479", "#86d3ff", "#ffae57", "#a8f0c6",
  }
  local function rand_cursor()
    vim.api.nvim_set_hl(0, "Cursor", { bg = trail_colors[math.random(#trail_colors)], fg = "#0c0910" })
  end
  rand_cursor()
  local ct = (vim.uv or vim.loop).new_timer()
  ct:start(5000, 5000, vim.schedule_wrap(rand_cursor))
end

vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Open Neo-tree on startup",
  once = true,
  callback = function()
    vim.schedule(function() pcall(vim.cmd, "Neotree show") end)
  end,
})

vim.ui.input = function(...) return require("snacks").input(...) end
vim.ui.select = function(...) return require("snacks").picker.select(...) end

pcall(function() require("girly").setup() end)

local function float_open()
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(w).relative ~= "" then return true end
  end
  return false
end

pcall(function() require("cat").setup() end)
pcall(function() require("sysinfo").setup() end)

vim.api.nvim_create_autocmd("FileChangedShell", {
  desc = "Recharger sans demander quand le fichier change en dehors",
  callback = function() vim.v.fcs_choice = "reload" end,
})
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  desc = "Detecter les changements disque",
  callback = function()
    if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then pcall(vim.cmd.checktime) end
  end,
})

vim.api.nvim_create_autocmd({ "TermOpen", "BufWinEnter", "WinEnter" }, {
  desc = "Terminal: passer en mode insertion automatiquement",
  callback = function()
    if vim.bo.buftype == "terminal" then vim.cmd "startinsert" end
  end,
})

vim.api.nvim_create_autocmd("CursorHold", {
  desc = "Auto popup: diagnostics or documentation under cursor",
  callback = function()
    if vim.g.auto_doc == false or float_open() or vim.fn.mode() ~= "n" then return end
    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
    if #vim.diagnostic.get(0, { lnum = lnum }) > 0 then
      vim.diagnostic.open_float(nil, { focus = false, scope = "cursor", border = "rounded" })
      return
    end
    local clients = vim.lsp.get_clients { bufnr = 0, method = "textDocument/hover" }
    if #clients == 0 then return end
    local params = vim.lsp.util.make_position_params(0, clients[1].offset_encoding or "utf-16")
    vim.lsp.buf_request(0, "textDocument/hover", params, function(err, result)
      if err or not result or not result.contents then return end
      local lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
      lines = vim.tbl_filter(function(l) return l ~= nil and l ~= "" end, lines)
      if #lines == 0 or float_open() then return end
      vim.lsp.util.open_floating_preview(lines, "markdown", { focusable = false, focus = false, border = "rounded" })
    end)
  end,
})
