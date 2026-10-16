local M = {}

local counts = {}
local descs = {}
local index = {}
local lengths = {}
local pending = ""
local max_len = 0
local dirty = false
local store = vim.fn.stdpath "data" .. "/keyfreq.json"

local function load()
  local file = io.open(store, "r")
  if not file then return end
  local ok, data = pcall(vim.json.decode, file:read "*a")
  file:close()
  if ok and type(data) == "table" then counts = data end
end

local function save()
  if not dirty then return end
  local file = io.open(store, "w")
  if not file then return end
  file:write(vim.json.encode(counts))
  file:close()
  dirty = false
end

local function rebuild_index()
  index = {}
  local seen = {}
  for _, mode in ipairs { "n", "x" } do
    for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
      local raw = vim.api.nvim_replace_termcodes(map.lhs, true, true, true)
      if #raw >= 2 and #raw <= 24 then
        index[raw] = map.lhs
        if map.desc and map.desc ~= "" then descs[map.lhs] = map.desc end
        seen[#raw] = true
      end
    end
  end
  lengths = vim.tbl_keys(seen)
  table.sort(lengths, function(a, b) return a > b end)
  max_len = lengths[1] or 0
end

local function observe(_, typed)
  if not typed or typed == "" or max_len == 0 then return end
  local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
  if mode ~= "n" and mode ~= "v" and mode ~= "V" and mode ~= "\22" then
    pending = ""
    return
  end
  pending = (pending .. typed):sub(-max_len)
  for _, len in ipairs(lengths) do
    if #pending >= len then
      local pretty = index[pending:sub(-len)]
      if pretty then
        counts[pretty] = (counts[pretty] or 0) + 1
        dirty = true
        pending = ""
        return
      end
    end
  end
end

function M.stats()
  local rows = {}
  for lhs, n in pairs(counts) do
    rows[#rows + 1] = { lhs = lhs, n = n }
  end
  table.sort(rows, function(a, b) return a.n > b.n end)

  local total = 0
  for _, row in ipairs(rows) do
    total = total + row.n
  end

  local lines = { "", "  Tes raccourcis les plus utilises", "" }
  local hl = { [2] = "Title" }
  local shown = math.min(#rows, 25)
  if shown == 0 then
    lines[#lines + 1] = "  Rien encore : les stats se remplissent en tapant."
  end
  for i = 1, shown do
    local row = rows[i]
    local label = row.lhs:gsub("^ ", "Espace "):gsub("^<Space>", "Espace ")
    local bar = string.rep("█", math.max(1, math.floor(row.n / rows[1].n * 24)))
    lines[#lines + 1] = string.format("  %-18s %5d  %s", label, row.n, bar)
    hl[#lines] = i <= 5 and "GirlyKeyTop" or "Comment"
  end
  lines[#lines + 1] = ""
  lines[#lines + 1] = string.format("  %d frappes mappees comptees au total  ·  q pour fermer", total)
  hl[#lines] = "Comment"

  vim.api.nvim_set_hl(0, "GirlyKeyTop", { fg = "#c9604f", bold = true })

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  local width = 60
  local height = #lines
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
    title = " KeyStats ",
    title_pos = "center",
  })
  local ns = vim.api.nvim_create_namespace "keyfreq_stats"
  for line, group in pairs(hl) do
    vim.hl.range(buf, ns, group, { line - 1, 0 }, { line - 1, -1 })
  end
  vim.keymap.set("n", "q", function() vim.api.nvim_win_close(win, true) end, { buffer = buf, nowait = true })
end

function M.reset()
  counts = {}
  dirty = true
  save()
  vim.notify("Stats des touches remises a zero", vim.log.levels.INFO, { title = "KeyStats" })
end

function M.register()
  load()
  rebuild_index()
  vim.on_key(observe, vim.api.nvim_create_namespace "keyfreq")

  local aug = vim.api.nvim_create_augroup("keyfreq", { clear = true })
  vim.api.nvim_create_autocmd("VimLeavePre", { group = aug, callback = save })
  vim.api.nvim_create_autocmd("User", {
    group = aug,
    pattern = "LazyLoad",
    callback = function() vim.defer_fn(rebuild_index, 100) end,
  })

  local timer = (vim.uv or vim.loop).new_timer()
  timer:start(300000, 300000, vim.schedule_wrap(save))

  vim.api.nvim_create_user_command("KeyStats", M.stats, { desc = "Raccourcis les plus utilises" })
  vim.api.nvim_create_user_command("KeyStatsReset", M.reset, { desc = "Remettre les stats a zero" })
end

return M
