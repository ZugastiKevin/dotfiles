local M = {}

function M.register()
  local ok, Snacks = pcall(require, "snacks")
  if not ok or not Snacks.toggle then return end
  local t = Snacks.toggle

  t.option("spell", { name = "Spell" }):map "<Leader>us"
  t.option("wrap", { name = "Wrap" }):map "<Leader>uw"
  t.option("signcolumn", { off = "no", on = "yes", name = "Sign column" }):map "<Leader>ug"
  t.option("foldcolumn", { off = "0", on = "1", name = "Fold column" }):map "<Leader>u>"
  t.option("conceallevel", { off = 0, on = 2, name = "Conceal" }):map "<Leader>uS"
  t.option("background", { off = "light", on = "dark", name = "Fond sombre" }):map "<Leader>ub"
  t.option("cursorline", { name = "Cursor line" }):map "<Leader>uk"
  t.option("list", { name = "Caracteres invisibles" }):map "<Leader>uj"
  t.option("showtabline", { off = 0, on = 2, name = "Tabline" }):map "<Leader>ut"
  t.option("laststatus", { off = 0, on = 3, name = "Statusline" }):map "<Leader>ul"
  t.diagnostics():map "<Leader>ud"
  t.treesitter():map "<Leader>uy"
  t.inlay_hints():map "<Leader>uh"
  t.indent():map "<Leader>u|"

  t({
    name = "Diagnostics virtual text",
    get = function()
      local c = vim.diagnostic.config() or {}
      return c.virtual_text ~= nil and c.virtual_text ~= false
    end,
    set = function(on) vim.diagnostic.config { virtual_text = on and true or false } end,
  }):map "<Leader>uv"

  t({
    name = "Diagnostics virtual lines",
    get = function()
      local c = vim.diagnostic.config() or {}
      return c.virtual_lines ~= nil and c.virtual_lines ~= false
    end,
    set = function(on) vim.diagnostic.config { virtual_lines = on and true or false } end,
  }):map "<Leader>uV"

  t({
    name = "Autopairs",
    get = function()
      local okp, ap = pcall(require, "nvim-autopairs")
      return okp and not ap.state.disabled
    end,
    set = function(on)
      local okp, ap = pcall(require, "nvim-autopairs")
      if okp then
        if on then ap.enable() else ap.disable() end
      end
    end,
  }):map "<Leader>ua"

  t({
    name = "Doc auto au survol",
    get = function() return vim.g.auto_doc ~= false end,
    set = function(on) vim.g.auto_doc = on end,
  }):map "<Leader>uo"
end

return M
