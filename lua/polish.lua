vim.filetype.add {
  extension = {
    ui = function(_, bufnr)
      for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, 30, false)) do
        if line:match "^%s*<%?xml" or line:match "^%s*<%a" then return "xml" end
      end
      return "hytaleui"
    end,
    purr = "purr",
  },
}

local is_windows = vim.fn.has "win32" == 1
local path_separator = is_windows and ";" or ":"
local extra_path = is_windows
    and { vim.fs.normalize "~/.cargo/bin", vim.fs.normalize "~/.dotnet/tools", vim.fs.normalize "~/scoop/shims" }
  or { vim.fs.normalize "~/.cargo/bin", "/opt/homebrew/bin", "/opt/homebrew/sbin" }
for _, p in ipairs(extra_path) do
  local current = vim.env.PATH or ""
  local surrounded = path_separator .. current .. path_separator
  local already_present = string.find(surrounded, path_separator .. p .. path_separator, 1, true) ~= nil
  if vim.fn.isdirectory(p) == 1 and not already_present then vim.env.PATH = p .. path_separator .. current end
end

vim.lsp.log.set_level(vim.log.levels.OFF)

if vim.g.neovide then
  vim.g.neovide_confirm_quit = true
  vim.g.neovide_padding_top = 10
  vim.g.neovide_padding_bottom = 10
  vim.g.neovide_padding_left = 14
  vim.g.neovide_padding_right = 14
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
  vim.g.neovide_floating_shadow = true
  vim.g.neovide_cursor_animation_length = 0.13
  vim.g.neovide_cursor_short_animation_length = 0.06
  vim.g.neovide_cursor_trail_size = 0.9
  vim.g.neovide_cursor_animate_in_insert_mode = true
  vim.g.neovide_cursor_animate_command_line = true
  math.randomseed((vim.uv or vim.loop).hrtime())
  vim.g.neovide_cursor_vfx_mode = { "railgun", "pixiedust" }
  vim.g.neovide_progress_bar_enabled = true
  vim.g.neovide_progress_bar_height = 8
  vim.g.neovide_progress_bar_hide_delay = 1.2
  vim.g.neovide_cursor_vfx_particle_lifetime = 1.4
  vim.g.neovide_cursor_vfx_particle_density = 12.0
  vim.g.neovide_cursor_vfx_particle_speed = 12.0
  vim.g.neovide_cursor_vfx_opacity = 220.0
  vim.g.neovide_scroll_animation_length = 0.2
  vim.g.neovide_scroll_animation_far_lines = 1
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_window_blurred = true
  vim.g.neovide_input_macos_option_key_is_meta = "both"

  vim.g.neovide_cursor_smooth_blink = true
  vim.g.neovide_position_animation_length = 0.15
  vim.g.neovide_floating_corner_radius = 0.35
  vim.g.neovide_opacity = 1.0
  vim.g.neovide_normal_opacity = 0.92
  vim.g.neovide_light_angle_degrees = 40
  vim.g.neovide_light_radius = 6
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_underline_stroke_scale = 1.4
  vim.g.neovide_theme = "dark"

  local trail_colors = {
    "#8fe0d4", "#b79cf0", "#b79cf0", "#6fb7c9", "#d6405f",
    "#b98aff", "#7df9ff", "#5ef1d6", "#ffd479", "#86d3ff", "#ffae57", "#a8f0c6",
  }
  local function rand_cursor()
    vim.api.nvim_set_hl(0, "Cursor", { bg = trail_colors[math.random(#trail_colors)], fg = "#0c0910" })
  end
  rand_cursor()
  local ct = (vim.uv or vim.loop).new_timer()
  ct:start(5000, 5000, vim.schedule_wrap(rand_cursor))

  vim.g.neovide_scale_factor = 1.0
  local function nv_scale(delta)
    vim.g.neovide_scale_factor = math.max(0.5, math.min(3.0, vim.g.neovide_scale_factor * delta))
  end
  local platform_key = require("keymap_platform").key
  vim.keymap.set({ "n", "i", "v", "t" }, platform_key "<D-=>", function() nv_scale(1.1) end, { desc = "Neovide zoom +" })
  vim.keymap.set({ "n", "i", "v", "t" }, platform_key "<D-->", function() nv_scale(1 / 1.1) end, { desc = "Neovide zoom -" })
  vim.keymap.set({ "n", "i", "v", "t" }, platform_key "<D-0>", function() vim.g.neovide_scale_factor = 1.0 end, { desc = "Neovide zoom reset" })
end

local aug = vim.api.nvim_create_augroup("anna_polish", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Open Neo-tree on startup",
  group = aug,
  once = true,
  callback = function()
    vim.schedule(function() pcall(vim.cmd, "Neotree show") end)
  end,
})

pcall(function() require("girly").setup() end)
pcall(function() require("image_view").setup() end)

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  group = aug,
  once = true,
  callback = function()
    pcall(function() require("anim_control").register() end)
    pcall(function() require("editor_toggles").register() end)
    pcall(function() require("keyfreq").register() end)
    pcall(function() require("sparkle").register() end)
    pcall(function() require("girly_gradient").enable() end)
  end,
})

local doc_win = nil

local function close_doc()
  if doc_win and vim.api.nvim_win_is_valid(doc_win) then pcall(vim.api.nvim_win_close, doc_win, true) end
  doc_win = nil
end

local function float_open()
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(w)
    if config.relative ~= "" and (config.zindex or 50) >= 50 and w ~= doc_win then return true end
  end
  return false
end

vim.api.nvim_create_autocmd("FileChangedShell", {
  desc = "Recharger sans demander quand le fichier change en dehors",
  group = aug,
  callback = function() vim.v.fcs_choice = "reload" end,
})
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI" }, {
  desc = "Detecter les changements disque",
  group = aug,
  callback = function()
    if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then pcall(vim.cmd.checktime) end
  end,
})

vim.api.nvim_create_autocmd({ "TermOpen", "BufWinEnter", "WinEnter" }, {
  desc = "Terminal: passer en mode insertion automatiquement",
  group = aug,
  callback = function()
    if vim.bo.buftype == "terminal" then vim.cmd "startinsert" end
  end,
})

vim.api.nvim_create_autocmd("CursorHold", {
  desc = "Auto popup: diagnostics or documentation under cursor",
  group = aug,
  callback = function()
    close_doc()
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
      local _, win = vim.lsp.util.open_floating_preview(lines, "markdown",
        { focusable = false, focus = false, border = "rounded" })
      doc_win = win
    end)
  end,
})

do
  local inlay_hint_ns = vim.api.nvim_create_namespace "nvim.lsp.inlayhint"
  local set_extmark = vim.api.nvim_buf_set_extmark
  vim.api.nvim_buf_set_extmark = function(buffer, ns, line, col, opts)
    if ns ~= inlay_hint_ns then return set_extmark(buffer, ns, line, col, opts) end
    local ok, result = pcall(set_extmark, buffer, ns, line, col, opts)
    if ok then return result end
  end
end
