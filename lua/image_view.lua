local M = {}

local uv = vim.uv or vim.loop

M.config = {
  mode = "image",
  symbols = "vhalf",
  header = true,
  scale_step = 1.15,
  min_scale = 0.2,
  max_scale = 6.0,
  max_raw_bytes = 8 * 1024 * 1024,
  max_hex_bytes = 512 * 1024,
}

local EXTENSIONS = vim.split(
  "png,jpg,jpeg,jpe,gif,webp,bmp,tif,tiff,ico,avif,heic,heif,jxl,qoi,tga,pbm,pgm,ppm,pnm,xwd,xpm",
  ",",
  { plain = true }
)

local MODES = { "image", "raw", "hex" }
local MODE_LABEL = { image = "image", raw = "donnees brutes", hex = "hexadecimal" }

local ns = vim.api.nvim_create_namespace "image_view"
local buffers = {}
local hl_cache = {}
local hl_count = 0

local ANSI_16 = vim.split(
  "#000000 #cd0000 #00cd00 #cdcd00 #0000ee #cd00cd #00cdcd #e5e5e5 "
    .. "#7f7f7f #ff0000 #00ff00 #ffff00 #5c5cff #ff00ff #00ffff #ffffff",
  " ",
  { plain = true }
)
local CUBE_LEVELS = { 0, 95, 135, 175, 215, 255 }

local function xterm_hex(n)
  if n < 16 then return ANSI_16[n + 1] end
  if n < 232 then
    n = n - 16
    return string.format(
      "#%02x%02x%02x",
      CUBE_LEVELS[math.floor(n / 36) % 6 + 1],
      CUBE_LEVELS[math.floor(n / 6) % 6 + 1],
      CUBE_LEVELS[n % 6 + 1]
    )
  end
  local v = 8 + (n - 232) * 10
  return string.format("#%02x%02x%02x", v, v, v)
end

local function ensure_hl(fg, bg)
  local key = (fg or "-") .. (bg or "-")
  local group = hl_cache[key]
  if group then return group end
  hl_count = hl_count + 1
  group = "ImageViewC" .. hl_count
  vim.api.nvim_set_hl(0, group, { fg = fg, bg = bg })
  hl_cache[key] = group
  return group
end

local function hl_from_normal(field)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = "Normal", link = false })
  if ok and hl and hl[field] then return string.format("#%06x", hl[field]) end
end

function M.has_graphics()
  if vim.g.neovide or vim.fn.has "gui_running" == 1 then return false end
  if vim.env.KITTY_WINDOW_ID or vim.env.GHOSTTY_RESOURCES_DIR then return true end
  local program = (vim.env.TERM_PROGRAM or ""):lower()
  local term = (vim.env.TERM or ""):lower()
  return program:find "ghostty" ~= nil
    or program:find "wezterm" ~= nil
    or program:find "iterm" ~= nil
    or term:find "kitty" ~= nil
end

local function apply_sgr(params, style)
  if params == "" then
    style.fg, style.bg = nil, nil
    return
  end
  local nums, count = {}, 0
  for part in params:gmatch "[^;]+" do
    count = count + 1
    nums[count] = tonumber(part) or 0
  end
  local i = 1
  while i <= count do
    local code = nums[i]
    if code == 0 then
      style.fg, style.bg = nil, nil
    elseif code == 39 then
      style.fg = nil
    elseif code == 49 then
      style.bg = nil
    elseif code == 38 or code == 48 then
      local kind, color = nums[i + 1], nil
      if kind == 2 then
        color = string.format("#%02x%02x%02x", nums[i + 2] or 0, nums[i + 3] or 0, nums[i + 4] or 0)
        i = i + 4
      elseif kind == 5 then
        color = xterm_hex(nums[i + 2] or 0)
        i = i + 2
      end
      if code == 38 then
        style.fg = color
      else
        style.bg = color
      end
    elseif code >= 30 and code <= 37 then
      style.fg = ANSI_16[code - 29]
    elseif code >= 90 and code <= 97 then
      style.fg = ANSI_16[code - 81]
    elseif code >= 40 and code <= 47 then
      style.bg = ANSI_16[code - 39]
    elseif code >= 100 and code <= 107 then
      style.bg = ANSI_16[code - 91]
    end
    i = i + 1
  end
end

local function parse_ansi(raw_lines)
  local style = {}
  local lines, runs, width = {}, {}, 0
  for index = 1, #raw_lines do
    local line = raw_lines[index]
    local pieces, piece_count = {}, 0
    local pos, col = 1, 0
    while true do
      local start_at, end_at = line:find("\27%[[%d;:?!<>=]*%a", pos)
      local text = line:sub(pos, (start_at or #line + 1) - 1)
      if #text > 0 then
        piece_count = piece_count + 1
        pieces[piece_count] = text
        if style.fg or style.bg then runs[#runs + 1] = { index, col, col + #text, style.fg, style.bg } end
        col = col + #text
      end
      if not start_at then break end
      if line:sub(end_at, end_at) == "m" then apply_sgr(line:sub(start_at + 2, end_at - 1), style) end
      pos = end_at + 1
    end
    local text = table.concat(pieces)
    lines[index] = text
    local display = vim.api.nvim_strwidth(text)
    if display > width then width = display end
  end
  return lines, runs, width
end

local function state_of(buf) return buffers[buf] end

local function window_for(buf)
  if vim.api.nvim_get_current_buf() == buf then return vim.api.nvim_get_current_win() end
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf then return win end
  end
end

local function view_size(win)
  local info = vim.fn.getwininfo(win)[1]
  local width = vim.api.nvim_win_get_width(win) - ((info and info.textoff) or 0)
  local height = vim.api.nvim_win_get_height(win)
  return math.max(width, 1), math.max(height, 1)
end

local function set_lines(buf, lines)
  if not vim.api.nvim_buf_is_valid(buf) then return end
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].modified = false
end

local function human_size(bytes)
  local units = { "o", "Ko", "Mo", "Go" }
  local value, unit = bytes, 1
  while value >= 1024 and unit < #units do
    value = value / 1024
    unit = unit + 1
  end
  if unit == 1 then return string.format("%d %s", value, units[unit]) end
  return string.format("%.1f %s", value, units[unit])
end

local function header_text(st)
  local parts = { vim.fn.fnamemodify(st.path, ":t") }
  if st.info and st.info ~= "" then parts[#parts + 1] = st.info end
  local stat = uv.fs_stat(st.path)
  if stat then parts[#parts + 1] = human_size(stat.size) end
  parts[#parts + 1] = MODE_LABEL[st.mode]
  if st.mode == "image" and st.scale ~= 1 then parts[#parts + 1] = string.format("x%.2f", st.scale) end
  return "  " .. table.concat(parts, "  ·  ")
end

local function fetch_info(buf, st)
  if st.info or vim.fn.executable "magick" == 0 then return end
  st.info = ""
  vim.system(
    { "magick", "identify", "-format", "%m %wx%h", st.path .. "[0]" },
    { text = true },
    vim.schedule_wrap(function(res)
      if not vim.api.nvim_buf_is_valid(buf) then return end
      local out = (res.stdout or ""):gsub("%s+$", "")
      if res.code ~= 0 or out == "" then return end
      st.info = out
      M.refresh(buf)
    end)
  )
end

local function read_bytes(path, limit)
  local fd = uv.fs_open(path, "r", 438)
  if not fd then return nil end
  local stat = uv.fs_fstat(fd)
  local size = stat and stat.size or 0
  local data = uv.fs_read(fd, math.min(size, limit), 0) or ""
  uv.fs_close(fd)
  return data, size
end

local function render_raw(buf, st)
  local data, size = read_bytes(st.path, M.config.max_raw_bytes)
  if not data then
    set_lines(buf, { "Lecture impossible: " .. st.path })
    return
  end
  local lines = vim.split((data:gsub("%z", "^@")), "\n", { plain = true })
  if size > #data then
    lines[#lines + 1] = string.format("--- tronque a %s sur %s ---", human_size(#data), human_size(size))
  end
  if M.config.header then table.insert(lines, 1, header_text(st)) end
  set_lines(buf, lines)
  if M.config.header then
    vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, { end_col = #lines[1], hl_group = "ImageViewHeader" })
  end
end

local function render_hex(buf, st)
  local data, size = read_bytes(st.path, M.config.max_hex_bytes)
  if not data then
    set_lines(buf, { "Lecture impossible: " .. st.path })
    return
  end
  local total = #data
  local lines, count = {}, 0
  if M.config.header then
    count = 1
    lines[1] = header_text(st)
  end
  for offset = 1, total, 16 do
    local chunk = data:sub(offset, offset + 15)
    local hex = string.format(string.rep("%02x ", #chunk), chunk:byte(1, #chunk))
    count = count + 1
    lines[count] = string.format("%08x  %-48s |%s|", offset - 1, hex, (chunk:gsub("[^\32-\126]", ".")))
  end
  if size > total then
    count = count + 1
    lines[count] = string.format("--- tronque a %s sur %s ---", human_size(total), human_size(size))
  end
  set_lines(buf, lines)
  if M.config.header then
    vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, { end_col = #lines[1], hl_group = "ImageViewHeader" })
  end
end

local function render_image(buf, st, win)
  if vim.fn.executable "chafa" == 0 then
    set_lines(buf, {
      header_text(st),
      "",
      "  chafa est introuvable: brew install chafa",
      "  Bascule sur les donnees brutes avec <Leader>ui",
    })
    return
  end

  local width, height = view_size(win)
  local header_rows = M.config.header and 2 or 0
  local cols = math.max(math.floor(width * st.scale), 4)
  local rows = math.max(math.floor((height - header_rows) * st.scale), 2)

  st.token = (st.token or 0) + 1
  local token = st.token

  local args = {
    "chafa",
    "-f",
    "symbols",
    "--symbols",
    M.config.symbols,
    "-c",
    "full",
    "--polite",
    "on",
    "--probe",
    "off",
    "--animate",
    "off",
    "--relative",
    "off",
    "--passthrough",
    "none",
    "-s",
    cols .. "x" .. rows,
  }
  local bg = hl_from_normal "bg"
  if bg then
    args[#args + 1] = "--bg"
    args[#args + 1] = bg
  end
  args[#args + 1] = "--"
  args[#args + 1] = st.path

  vim.system(
    args,
    { text = true },
    vim.schedule_wrap(function(res)
      local current = state_of(buf)
      if not current or current.token ~= token or not vim.api.nvim_buf_is_valid(buf) then return end
      if res.code ~= 0 then
        set_lines(buf, { header_text(st), "", "  chafa: " .. ((res.stderr or ""):gsub("%s+$", "")) })
        return
      end

      local raw = vim.split((res.stdout or ""):gsub("\n$", ""), "\n", { plain = true })
      local art, runs, art_width = parse_ansi(raw)

      local pad_left = math.max(math.floor((width - art_width) / 2), 0)
      local pad_top = math.max(math.floor((height - header_rows - #art) / 2), 0)
      local prefix = string.rep(" ", pad_left)

      local lines, count = {}, 0
      if M.config.header then
        lines[1] = header_text(st)
        lines[2] = ""
        count = 2
      end
      for _ = 1, pad_top do
        count = count + 1
        lines[count] = ""
      end
      local offset = count
      for i = 1, #art do
        lines[offset + i] = prefix .. art[i]
      end

      set_lines(buf, lines)

      if M.config.header then
        vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, { end_col = #lines[1], hl_group = "ImageViewHeader" })
      end
      local set_extmark = vim.api.nvim_buf_set_extmark
      for i = 1, #runs do
        local run = runs[i]
        set_extmark(buf, ns, offset + run[1] - 1, pad_left + run[2], {
          end_col = pad_left + run[3],
          hl_group = ensure_hl(run[4], run[5]),
        })
      end

      if st.scale == 1 and vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == buf then
        pcall(vim.api.nvim_win_set_cursor, win, { 1, 0 })
      end
    end)
  )
end

function M.refresh(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local st = state_of(buf)
  if not st then return end
  local win = window_for(buf)
  if not win then return end

  vim.wo[win][0].wrap = false
  vim.wo[win][0].number = false
  vim.wo[win][0].relativenumber = false
  vim.wo[win][0].signcolumn = "no"
  vim.wo[win][0].foldcolumn = "0"
  vim.wo[win][0].cursorline = false
  vim.wo[win][0].list = false
  vim.wo[win][0].colorcolumn = ""
  vim.wo[win][0].statuscolumn = ""

  if st.mode == "image" then
    render_image(buf, st, win)
  elseif st.mode == "hex" then
    render_hex(buf, st)
  else
    render_raw(buf, st)
  end
end

local function schedule_refresh(buf)
  local st = state_of(buf)
  if not st then return end
  if st.timer then
    st.timer:stop()
  else
    st.timer = uv.new_timer()
  end
  st.timer:start(
    60,
    0,
    vim.schedule_wrap(function()
      if vim.api.nvim_buf_is_valid(buf) then M.refresh(buf) end
    end)
  )
end

local function refresh_all()
  for buf in pairs(buffers) do
    if vim.api.nvim_buf_is_valid(buf) then schedule_refresh(buf) end
  end
end

function M.set_mode(buf, mode)
  buf = buf or vim.api.nvim_get_current_buf()
  local st = state_of(buf)
  if not st then
    vim.notify("Ce buffer n'est pas une image", vim.log.levels.WARN)
    return
  end
  if not MODE_LABEL[mode] then
    vim.notify("Mode inconnu: " .. tostring(mode), vim.log.levels.ERROR)
    return
  end
  st.mode = mode
  M.refresh(buf)
end

function M.toggle(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local st = state_of(buf)
  if not st then return end
  M.set_mode(buf, st.mode == "image" and "raw" or "image")
end

function M.cycle(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local st = state_of(buf)
  if not st then return end
  local index = 1
  for i = 1, #MODES do
    if MODES[i] == st.mode then index = i end
  end
  M.set_mode(buf, MODES[index % #MODES + 1])
end

function M.zoom(buf, factor)
  buf = buf or vim.api.nvim_get_current_buf()
  local st = state_of(buf)
  if not st or st.mode ~= "image" then return end
  st.scale = math.max(M.config.min_scale, math.min(M.config.max_scale, factor and st.scale * factor or 1))
  M.refresh(buf)
end

function M.open_external(path)
  path = path or (state_of(vim.api.nvim_get_current_buf()) or {}).path
  if not path then return end
  local opener = vim.fn.has "mac" == 1 and "open" or (vim.fn.has "win32" == 1 and "explorer" or "xdg-open")
  vim.system { opener, path }
end

local function attach_keymaps(buf)
  local function map(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc, silent = true }) end
  map("<Leader>uI", function() M.toggle(buf) end, "Image: vraie image / donnees brutes")
  map("<Leader>uH", function() M.cycle(buf) end, "Image: mode suivant (image/brut/hex)")
  map("gx", function() M.open_external() end, "Image: ouvrir dans la visionneuse systeme")
  map("+", function() M.zoom(buf, M.config.scale_step) end, "Image: zoom avant")
  map("-", function() M.zoom(buf, 1 / M.config.scale_step) end, "Image: zoom arriere")
  map("=", function() M.zoom(buf, nil) end, "Image: zoom par defaut")
  map("r", function() M.refresh(buf) end, "Image: re-rendu")
end

function M.attach(buf, path)
  if buffers[buf] then
    buffers[buf].path = path
    M.refresh(buf)
    return
  end

  buffers[buf] = { path = path, mode = M.config.mode, scale = 1 }

  vim.bo[buf].buftype = "nowrite"
  vim.bo[buf].swapfile = false
  vim.bo[buf].undolevels = -1
  vim.bo[buf].filetype = "image"
  vim.bo[buf].modifiable = false
  vim.bo[buf].modified = false

  attach_keymaps(buf)
  fetch_info(buf, buffers[buf])

  local group = vim.api.nvim_create_augroup("image_view_buf_" .. buf, { clear = true })
  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = group,
    buffer = buf,
    callback = function() schedule_refresh(buf) end,
  })
  vim.api.nvim_create_autocmd({ "BufWipeout", "BufDelete" }, {
    group = group,
    buffer = buf,
    callback = function()
      local st = buffers[buf]
      if st and st.timer then
        st.timer:stop()
        st.timer:close()
      end
      buffers[buf] = nil
    end,
  })

  M.refresh(buf)
end

function M.preview(path)
  path = vim.fn.expand(path and path ~= "" and path or "%:p")
  if vim.fn.filereadable(path) == 0 then
    vim.notify("Fichier introuvable: " .. path, vim.log.levels.ERROR)
    return
  end
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2) - 1,
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " " .. vim.fn.fnamemodify(path, ":t") .. " ",
    title_pos = "center",
  })
  vim.bo[buf].bufhidden = "wipe"
  buffers[buf] = { path = path, mode = "image", scale = 1 }
  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = buf,
    callback = function() buffers[buf] = nil end,
  })
  attach_keymaps(buf)
  fetch_info(buf, buffers[buf])
  for _, lhs in ipairs { "q", "<Esc>" } do
    vim.keymap.set("n", lhs, function() pcall(vim.api.nvim_win_close, win, true) end, { buffer = buf, silent = true })
  end
  M.refresh(buf)
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  if M.has_graphics() then return end

  vim.api.nvim_set_hl(0, "ImageViewHeader", { link = "Comment", default = true })

  local patterns = {}
  for _, ext in ipairs(EXTENSIONS) do
    patterns[#patterns + 1] = "*." .. ext
    patterns[#patterns + 1] = "*." .. ext:upper()
  end

  local group = vim.api.nvim_create_augroup("image_view", { clear = true })
  vim.api.nvim_create_autocmd("BufReadCmd", {
    group = group,
    pattern = patterns,
    callback = function(ev) M.attach(ev.buf, vim.fn.fnamemodify(ev.match, ":p")) end,
  })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      hl_cache = {}
      hl_count = 0
      vim.api.nvim_set_hl(0, "ImageViewHeader", { link = "Comment", default = true })
      refresh_all()
    end,
  })
  vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
    group = group,
    callback = refresh_all,
  })

  vim.api.nvim_create_user_command(
    "ImageToggle",
    function() M.toggle() end,
    { desc = "Image: vraie image / donnees brutes" }
  )
  vim.api.nvim_create_user_command("ImageCycle", function() M.cycle() end, { desc = "Image: mode suivant" })
  vim.api.nvim_create_user_command("ImageMode", function(a) M.set_mode(nil, a.args) end, {
    nargs = 1,
    complete = function() return MODES end,
    desc = "Image: choisir le mode d'affichage",
  })
  vim.api.nvim_create_user_command("ImageOpen", function(a) M.open_external(a.args ~= "" and a.args or nil) end, {
    nargs = "?",
    complete = "file",
    desc = "Image: ouvrir dans la visionneuse systeme",
  })
  vim.api.nvim_create_user_command("ImagePreview", function(a) M.preview(a.args) end, {
    nargs = "?",
    complete = "file",
    desc = "Image: apercu flottant",
  })
  vim.api.nvim_create_user_command("ImageSymbols", function(a)
    M.config.symbols = a.args
    for buf, st in pairs(buffers) do
      if vim.api.nvim_buf_is_valid(buf) and st.mode == "image" then M.refresh(buf) end
    end
  end, {
    nargs = 1,
    complete = function() return { "vhalf", "half", "block", "sextant", "wedge", "braille", "ascii", "all" } end,
    desc = "Image: jeu de symboles du rendu",
  })
end

return M
