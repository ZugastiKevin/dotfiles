local M = {}

M.config = {
  trim_leading_blank = true,
  protect_files = {
    "%.lock$",
    "%-lock%.json$",
    "%.min%.js$",
    "%.min%.css$",
    "%.sum$",
    "^%.env",
  },
  protect = {
    "^#!",
    "^//go:",
    "@generated",
    "^//#%s*sourceMappingURL",
    "^/[/*]%s*eslint",
    "^/[/*]%s*prettier%-ignore",
    "^/[/*]%s*biome%-ignore",
    "^/[/*]%s*@ts%-",
    "^/[/*]%s*clang%-format",
    "^#%s*%-%*%-",
    "^#%s*type:%s*ignore",
    "^#%s*noqa",
    "^#%s*pyright:",
    "^#%s*ruff:",
    "^#%s*fmt:%s*[on]",
    "SPDX%-License%-Identifier",
  },
}

local DOC_RULES = {
  { "^///", "^////" },
  { "^//!", nil },
  { "^/%*%*", "^/%*%*%*" },
  { "^/%*!", nil },
  { "^%-%-%-", "^%-%-%-%-" },
}

local SKIP_DIRS = {
  [".git"] = true,
  target = true,
  node_modules = true,
  build = true,
  dist = true,
  out = true,
  bin = true,
  obj = true,
  venv = true,
  [".venv"] = true,
  [".cache"] = true,
  __pycache__ = true,
  Library = true,
  Temp = true,
  DerivedData = true,
}

local function is_doc(text)
  for _, rule in ipairs(DOC_RULES) do
    if text:find(rule[1]) and not (rule[2] and text:find(rule[2])) then return true end
  end
  return false
end

local function is_protected(text)
  for _, pattern in ipairs(M.config.protect) do
    if text:find(pattern) then return true end
  end
  return false
end

local function each_tree(ltree, fn)
  for _, tree in pairs(ltree:trees()) do
    fn(tree)
  end
  for _, child in pairs(ltree:children()) do
    each_tree(child, fn)
  end
end

local function line_at(bufnr, row) return vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] end

local function collect(bufnr, first, last, kind)
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, nil, { error = false })
  if not ok or not parser then return nil end
  if not pcall(parser.parse, parser, true) then return nil end

  local seen, found = {}, {}
  each_tree(parser, function(tree)
    local stack = { tree:root() }
    while #stack > 0 do
      local node = table.remove(stack)
      local sr, sc, er, ec = node:range()
      if sr <= last and er >= first then
        if node:type():find("comment", 1, true) then
          if ec == 0 and er > sr then
            er = er - 1
            ec = #(line_at(bufnr, er) or "")
          end
          local key = sr .. ":" .. sc .. ":" .. er .. ":" .. ec
          if not seen[key] then
            seen[key] = true
            found[#found + 1] = { sr, sc, er, ec, vim.treesitter.get_node_text(node, bufnr) }
          end
        else
          for child in node:iter_children() do
            stack[#stack + 1] = child
          end
        end
      end
    end
  end)

  local keep = {}
  for _, item in ipairs(found) do
    local text = item[5]
    local wanted = kind == "all" or (kind == "doc") == is_doc(text)
    if wanted and not is_protected(text) then keep[#keep + 1] = item end
  end

  table.sort(keep, function(a, b)
    if a[1] ~= b[1] then return a[1] > b[1] end
    return a[2] > b[2]
  end)
  return keep
end

local function join(head, tail)
  local left, right = head:sub(-1), tail:sub(1, 1)
  if left:match "[%(%[{]" or right:match "[%)%]},;%.]" then return head .. tail end
  return head .. " " .. tail
end

local function cut(bufnr, sr, sc, er, ec)
  local prefix = (line_at(bufnr, sr) or ""):sub(1, sc)
  local suffix = (line_at(bufnr, er) or ""):sub(ec + 1)
  local head = prefix:gsub("%s+$", "")
  local tail = suffix:gsub("^%s+", "")

  if head == "" and tail == "" then
    vim.api.nvim_buf_set_lines(bufnr, sr, er + 1, false, {})
  elseif head == "" then
    vim.api.nvim_buf_set_lines(bufnr, sr, er + 1, false, { prefix .. tail })
  elseif tail == "" then
    vim.api.nvim_buf_set_lines(bufnr, sr, er + 1, false, { head })
  else
    vim.api.nvim_buf_set_lines(bufnr, sr, er + 1, false, { join(head, tail) })
  end
end

---@param bufnr integer
---@param opts? { first?: integer, last?: integer, kind?: string, dry_run?: boolean }
---@return integer|nil removed, string|nil err
function M.strip_buffer(bufnr, opts)
  opts = opts or {}
  bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
  if not vim.api.nvim_buf_is_loaded(bufnr) then return nil, "buffer non charge" end
  if not vim.bo[bufnr].modifiable then return nil, "buffer non modifiable" end

  local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
  for _, pattern in ipairs(M.config.protect_files) do
    if name:find(pattern) then return nil, "fichier protege (" .. name .. ")" end
  end

  local first = opts.first or 0
  local last = opts.last or (vim.api.nvim_buf_line_count(bufnr) - 1)
  local targets = collect(bufnr, first, last, opts.kind or "all")
  if not targets then return nil, "pas de parser treesitter pour '" .. vim.bo[bufnr].filetype .. "'" end
  if opts.dry_run or #targets == 0 then return #targets end

  local touched_top = false
  for _, item in ipairs(targets) do
    if item[1] == 0 then touched_top = true end
    cut(bufnr, item[1], item[2], item[3], item[4])
  end

  if touched_top and M.config.trim_leading_blank then
    local drop, total = 0, vim.api.nvim_buf_line_count(bufnr)
    while drop < total and (line_at(bufnr, drop) or ""):match "^%s*$" do
      drop = drop + 1
    end
    if drop > 0 and drop < total then vim.api.nvim_buf_set_lines(bufnr, 0, drop, false, {}) end
  end

  return #targets
end

---@param path string
---@param opts? { kind?: string, dry_run?: boolean }
---@return integer|nil removed, string|nil err
function M.strip_file(path, opts)
  opts = opts or {}
  local listed = vim.fn.bufexists(path) == 1
  local bufnr = vim.fn.bufadd(path)
  local was_loaded = vim.api.nvim_buf_is_loaded(bufnr)
  vim.fn.bufload(bufnr)

  local removed, err
  if vim.bo[bufnr].modified then
    err = "modifications non enregistrees"
  else
    removed, err = M.strip_buffer(bufnr, opts)
    if removed and removed > 0 and not opts.dry_run then
      local ok, write_err = pcall(vim.api.nvim_buf_call, bufnr, function() vim.cmd "silent noautocmd keepalt write" end)
      if not ok then
        removed, err = nil, tostring(write_err)
      end
    end
  end

  if not listed and not was_loaded then pcall(vim.api.nvim_buf_delete, bufnr, { force = true }) end
  return removed, err
end

local function glob_matcher(glob)
  local ok, matcher = pcall(function() return vim.glob.to_lpeg(glob) end)
  if ok and matcher then return function(name) return matcher:match(name) ~= nil end end
  local pattern = "^" .. glob:gsub("[%^%$%(%)%%%.%[%]%+%-%?]", "%%%0"):gsub("%*", ".*") .. "$"
  return function(name) return name:match(pattern) ~= nil end
end

local function walk(dir, matches, acc)
  for name, kind in vim.fs.dir(dir) do
    if kind == "directory" then
      if not SKIP_DIRS[name] and name:sub(1, 1) ~= "." then walk(dir .. "/" .. name, matches, acc) end
    elseif kind == "file" and matches(name) then
      acc[#acc + 1] = dir .. "/" .. name
    end
  end
end

local function list_files(root, glob)
  if vim.fn.executable "rg" == 1 then
    local res = vim.system({ "rg", "--files", "--glob", glob, "--", root }, { text = true }):wait()
    if res.code == 0 then return vim.split(res.stdout or "", "\n", { trimempty = true }) end
    if res.code == 1 then return {} end
  end
  local acc = {}
  walk(root, glob_matcher(glob), acc)
  return acc
end

---@param glob? string
---@param opts? { kind?: string, dry_run?: boolean, root?: string }
function M.strip_project(glob, opts)
  opts = opts or {}
  local buf_name = vim.api.nvim_buf_get_name(0)
  local root = opts.root
    or (buf_name ~= "" and require("project_root").root_of(buf_name))
    or vim.fn.getcwd()

  if not glob or glob == "" then
    local ext = buf_name ~= "" and vim.fn.fnamemodify(buf_name, ":e") or ""
    if ext == "" then
      vim.notify("Precise un filtre, par exemple :StripCommentsProject *.rs", vim.log.levels.WARN)
      return
    end
    glob = "*." .. ext
  end

  local files = list_files(root, glob)
  if #files == 0 then
    vim.notify(("Aucun fichier '%s' sous %s"):format(glob, vim.fn.fnamemodify(root, ":~")), vim.log.levels.WARN)
    return
  end

  local kind = opts.kind or "all"
  if not opts.dry_run then
    local prompt = ("Supprimer les commentaires (%s) dans %d fichiers '%s' sous %s ?"):format(
      kind,
      #files,
      glob,
      vim.fn.fnamemodify(root, ":~")
    )
    local choice = vim.fn.confirm(prompt, "&Oui\n&Non\n&Simulation", 2)
    if choice == 3 then
      opts = vim.tbl_extend("force", opts, { dry_run = true })
    elseif choice ~= 1 then
      return
    end
  end

  local changed, removed, skipped = 0, 0, {}
  for _, file in ipairs(files) do
    local count, err = M.strip_file(file, { kind = kind, dry_run = opts.dry_run })
    if count == nil then
      skipped[#skipped + 1] = vim.fn.fnamemodify(file, ":.") .. " (" .. (err or "?") .. ")"
    elseif count > 0 then
      changed = changed + 1
      removed = removed + count
    end
  end

  local verb = opts.dry_run and "a supprimer" or "supprimes"
  local msg = ("%d commentaires %s dans %d/%d fichiers"):format(removed, verb, changed, #files)
  if #skipped > 0 then msg = msg .. "\nIgnores (" .. #skipped .. ") :\n  " .. table.concat(skipped, "\n  ", 1, math.min(#skipped, 8)) end
  vim.notify(msg, #skipped > 0 and vim.log.levels.WARN or vim.log.levels.INFO, { title = "Strip comments" })
end

return M
