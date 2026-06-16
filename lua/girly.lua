local M = {}

local statefile = vim.fn.stdpath "data" .. "/girly_theme.txt"

M.order = { "neon", "pastel", "darkpink", "bubblegum", "vaporwave" }

M.themes = {
  neon = {
    label = "Neon",
    bg = "#0c0910", bg_alt = "#090610", float = "#100a16", cursorline = "#1c1126",
    linenr = "#5a4368", visual = "#3a1f44", punct = "#c79fd0", delim = "#9a86a8",
    txt = "#f3d4ec", comment = "#8a7596",
    func = "#ff6ec7", kw = "#b98aff", typ = "#ff9e80", str = "#ffd479",
    num = "#ffae57", prop = "#ff9ad4", param = "#ffc6ec", op = "#ff79c6",
  },
  pastel = {
    label = "Pastel",
    bg = "#1d1a24", bg_alt = "#181520", float = "#221d2c", cursorline = "#272232",
    linenr = "#5c5470", visual = "#3a3450", punct = "#b7a9c9", delim = "#8f86a0",
    txt = "#e6dcf0", comment = "#7d7591",
    func = "#f6a9d0", kw = "#c9b3f5", typ = "#a9e6d2", str = "#f3d9a8",
    num = "#f5c0a0", prop = "#f0b8dd", param = "#e9cdf0", op = "#dcb0e8",
  },
  darkpink = {
    label = "Dark Pink",
    bg = "#140b14", bg_alt = "#0f080f", float = "#1a0f1a", cursorline = "#241423",
    linenr = "#4a3346", visual = "#3a1c38", punct = "#b482b0", delim = "#8a6886",
    txt = "#eccfe6", comment = "#6e5568",
    func = "#e85a9e", kw = "#b061d6", typ = "#d98ac0", str = "#cf8ab0",
    num = "#e0a060", prop = "#e87ab5", param = "#e0acd0", op = "#d56fb8",
  },
  bubblegum = {
    label = "Bubblegum",
    bg = "#1a0e18", bg_alt = "#140a14", float = "#22101f", cursorline = "#2a1426",
    linenr = "#5e3a56", visual = "#431f3d", punct = "#e29fd0", delim = "#a878a0",
    txt = "#ffe0f3", comment = "#8a6a82",
    func = "#ff5cb8", kw = "#ff8ed6", typ = "#ff70c0", str = "#ffc6ec",
    num = "#ffd24d", prop = "#ff9ad8", param = "#ffd0ee", op = "#ff79c6",
  },
  vaporwave = {
    label = "Vaporwave",
    bg = "#0e0a1a", bg_alt = "#0a0714", float = "#140e22", cursorline = "#1a1230",
    linenr = "#4d4470", visual = "#2f2552", punct = "#a9a0e0", delim = "#7d76a8",
    txt = "#e6d6ff", comment = "#6f6699",
    func = "#ff6ec7", kw = "#9d7bff", typ = "#5ef1d6", str = "#ffd479",
    num = "#ff9e80", prop = "#7df9ff", param = "#c9a7ff", op = "#ff79c6",
  },
}

M.current = "neon"

local function read_choice()
  local f = io.open(statefile, "r")
  if not f then return nil end
  local s = f:read "*l"
  f:close()
  if s then s = s:gsub("%s", "") end
  return s
end

local function write_choice(name)
  local f = io.open(statefile, "w")
  if f then
    f:write(name)
    f:close()
  end
end

function M.apply(name)
  local p = M.themes[name]
  if not p then return end
  M.current = name
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
    Pmenu = { bg = p.float, fg = p.txt },
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
    DiagnosticWarn = { fg = p.num },
    DiagnosticHint = { fg = p.kw },
    DiagnosticInfo = { fg = "#86d3ff" },

    RainbowDelimiterRed = { fg = p.func },
    RainbowDelimiterYellow = { fg = p.str },
    RainbowDelimiterBlue = { fg = p.kw },
    RainbowDelimiterOrange = { fg = p.typ },
    RainbowDelimiterGreen = { fg = p.prop },
    RainbowDelimiterViolet = { fg = p.op },
    RainbowDelimiterCyan = { fg = p.param },

    CatPet = { fg = p.func, bg = "NONE" },
  }
  for g, o in pairs(groups) do h(g, o) end
end

function M.pick()
  local items = {}
  for _, n in ipairs(M.order) do
    items[#items + 1] = n
  end
  vim.ui.select(items, {
    prompt = "Theme girly :",
    format_item = function(n) return M.themes[n].label end,
  }, function(choice)
    if choice then
      M.apply(choice)
      write_choice(choice)
      vim.notify("Theme : " .. M.themes[choice].label)
    end
  end)
end

function M.setup()
  M.current = read_choice() or "neon"
  if not M.themes[M.current] then M.current = "neon" end
  vim.api.nvim_create_autocmd("ColorScheme", {
    desc = "Girly theme overrides",
    callback = function() M.apply(M.current) end,
  })
  M.apply(M.current)
  vim.api.nvim_create_user_command("GirlyTheme", function(o)
    if o.args ~= "" and M.themes[o.args] then
      M.apply(o.args)
      write_choice(o.args)
      vim.notify("Theme : " .. M.themes[o.args].label)
    else
      M.pick()
    end
  end, {
    nargs = "?",
    complete = function() return M.order end,
  })
end

return M
