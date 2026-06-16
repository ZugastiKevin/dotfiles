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

local pink = {
  func = "#ff6ec7",
  kw = "#b98aff",
  typ = "#ff9e80",
  str = "#ffd479",
  num = "#ffae57",
  prop = "#ff9ad4",
  param = "#ffc6ec",
  txt = "#f3d4ec",
  op = "#ff79c6",
  comment = "#8a7596",
  bg = "#0c0910",
  bg_alt = "#090610",
  float = "#100a16",
  cursorline = "#1c1126",
  linenr = "#5a4368",
  visual = "#3a1f44",
  punct = "#c79fd0",
  delim = "#9a86a8",
}

local function apply_pink()
  local p = pink
  local function h(g, o) vim.api.nvim_set_hl(0, g, o) end
  local groups = {
    Normal = { fg = p.txt, bg = p.bg },
    NormalNC = { fg = p.txt, bg = p.bg },
    SignColumn = { bg = p.bg },
    EndOfBuffer = { fg = p.bg },
    NormalFloat = { bg = p.float, fg = p.txt },
    FloatBorder = { fg = p.kw, bg = p.float },
    FloatTitle = { fg = p.func, bold = true },
    CursorLine = { bg = p.cursorline },
    CursorLineNr = { fg = p.func, bold = true },
    LineNr = { fg = p.linenr },
    Visual = { bg = p.visual },
    Search = { bg = p.func, fg = p.bg },
    IncSearch = { bg = p.str, fg = p.bg },
    Pmenu = { bg = "#140d1a", fg = p.txt },
    PmenuSel = { bg = p.visual, fg = p.func, bold = true },
    WinSeparator = { fg = p.visual },

    Function = { fg = p.func, bold = true },
    Identifier = { fg = p.txt },
    Keyword = { fg = p.kw, italic = true },
    Statement = { fg = p.kw },
    Conditional = { fg = p.kw, italic = true },
    Repeat = { fg = p.kw, italic = true },
    Operator = { fg = p.op },
    Type = { fg = p.typ, bold = true },
    StorageClass = { fg = p.kw },
    Structure = { fg = p.typ },
    String = { fg = p.str },
    Character = { fg = p.str },
    Constant = { fg = p.num },
    Number = { fg = p.num },
    Boolean = { fg = p.num, bold = true },
    Float = { fg = p.num },
    Comment = { fg = p.comment, italic = true },
    PreProc = { fg = p.prop },
    Macro = { fg = p.prop },
    Special = { fg = p.op },
    Title = { fg = p.func, bold = true },

    ["@function"] = { fg = p.func, bold = true },
    ["@function.call"] = { fg = p.func },
    ["@function.method"] = { fg = p.func },
    ["@function.method.call"] = { fg = p.func },
    ["@function.builtin"] = { fg = p.func, italic = true },
    ["@function.macro"] = { fg = p.prop },
    ["@constructor"] = { fg = p.typ },
    ["@keyword"] = { fg = p.kw, italic = true },
    ["@keyword.function"] = { fg = p.kw, italic = true },
    ["@keyword.return"] = { fg = p.kw, italic = true, bold = true },
    ["@keyword.import"] = { fg = p.kw, italic = true },
    ["@keyword.operator"] = { fg = p.op },
    ["@conditional"] = { fg = p.kw },
    ["@repeat"] = { fg = p.kw },
    ["@operator"] = { fg = p.op },
    ["@type"] = { fg = p.typ },
    ["@type.builtin"] = { fg = p.typ, italic = true },
    ["@type.definition"] = { fg = p.typ, bold = true },
    ["@string"] = { fg = p.str },
    ["@character"] = { fg = p.str },
    ["@number"] = { fg = p.num },
    ["@boolean"] = { fg = p.num, bold = true },
    ["@constant"] = { fg = p.num },
    ["@constant.builtin"] = { fg = p.num, italic = true },
    ["@variable"] = { fg = p.txt },
    ["@variable.builtin"] = { fg = p.op, italic = true },
    ["@variable.parameter"] = { fg = p.param },
    ["@property"] = { fg = p.prop },
    ["@field"] = { fg = p.prop },
    ["@attribute"] = { fg = p.prop },
    ["@namespace"] = { fg = p.typ, italic = true },
    ["@punctuation.bracket"] = { fg = p.punct },
    ["@punctuation.delimiter"] = { fg = p.delim },
    ["@comment"] = { fg = p.comment, italic = true },

    ["@lsp.type.function"] = { fg = p.func, bold = true },
    ["@lsp.type.method"] = { fg = p.func },
    ["@lsp.type.macro"] = { fg = p.prop },
    ["@lsp.type.keyword"] = { fg = p.kw, italic = true },
    ["@lsp.type.struct"] = { fg = p.typ },
    ["@lsp.type.enum"] = { fg = p.typ, bold = true },
    ["@lsp.type.enumMember"] = { fg = p.num },
    ["@lsp.type.interface"] = { fg = p.typ, italic = true },
    ["@lsp.type.class"] = { fg = p.typ },
    ["@lsp.type.type"] = { fg = p.typ },
    ["@lsp.type.typeAlias"] = { fg = p.typ },
    ["@lsp.type.property"] = { fg = p.prop },
    ["@lsp.type.parameter"] = { fg = p.param },
    ["@lsp.type.variable"] = { fg = p.txt },
    ["@lsp.type.namespace"] = { fg = p.typ, italic = true },
    ["@lsp.type.string"] = { fg = p.str },
    ["@lsp.type.number"] = { fg = p.num },
    ["@lsp.type.comment"] = { fg = p.comment, italic = true },
    ["@lsp.type.builtinType"] = { fg = p.typ, italic = true },

    NeoTreeNormal = { bg = p.bg_alt, fg = p.txt },
    NeoTreeNormalNC = { bg = p.bg_alt, fg = p.txt },
    NeoTreeDirectoryName = { fg = p.kw },
    NeoTreeDirectoryIcon = { fg = p.kw },
    NeoTreeRootName = { fg = p.func, bold = true },
    NeoTreeGitModified = { fg = p.typ },
    NeoTreeFileNameOpened = { fg = p.func },

    DiagnosticError = { fg = "#ff5d8f" },
    DiagnosticWarn = { fg = "#ffc777" },
    DiagnosticHint = { fg = "#c9a7ff" },
    DiagnosticInfo = { fg = "#86d3ff" },

    RainbowDelimiterRed = { fg = "#ff6ec7" },
    RainbowDelimiterYellow = { fg = "#ffd479" },
    RainbowDelimiterBlue = { fg = "#b98aff" },
    RainbowDelimiterOrange = { fg = "#ff9e80" },
    RainbowDelimiterGreen = { fg = "#ff9ad4" },
    RainbowDelimiterViolet = { fg = "#c14fff" },
    RainbowDelimiterCyan = { fg = "#ff79c6" },
  }
  for g, o in pairs(groups) do h(g, o) end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Neon hot-pink overrides",
  callback = apply_pink,
})
apply_pink()

local function float_open()
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(w).relative ~= "" then return true end
  end
  return false
end

pcall(function() require("cat").setup() end)
pcall(function() require("sysinfo").setup() end)

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
