local M = {}

local uv = vim.uv or vim.loop
local buf, win, timer
local pos, dir = 2, 1
local mode, mode_left = "walk", 0
local enabled = true

local CAT = "\u{F011B}"

local function text()
  if mode == "sleep" then return CAT .. " z" end
  return CAT
end

local function valid_win() return win and vim.api.nvim_win_is_valid(win) end
local function valid_buf() return buf and vim.api.nvim_buf_is_valid(buf) end

function M.close()
  if valid_win() then pcall(vim.api.nvim_win_close, win, true) end
  win = nil
end

local function draw()
  if not enabled then
    M.close()
    return
  end
  local cols = vim.o.columns
  local lines = vim.o.lines
  if cols < 12 or lines < 6 then return end

  mode_left = mode_left - 1
  if mode_left <= 0 then
    local r = math.random(100)
    if r < 68 then
      mode, mode_left = "walk", math.random(10, 30)
    elseif r < 88 then
      mode, mode_left = "sit", math.random(6, 16)
    else
      mode, mode_left = "sleep", math.random(12, 24)
    end
  end

  local t = text()
  local w = vim.fn.strwidth(t)

  local rightmost = cols - w - 28
  if rightmost < 1 then rightmost = cols - w - 1 end
  if mode == "walk" then
    pos = pos + dir
    if pos < 1 then
      pos, dir = 1, 1
    elseif pos > rightmost then
      pos, dir = rightmost, -1
    end
  end
  if pos > rightmost then pos = rightmost end
  if pos < 1 then pos = 1 end

  if not valid_buf() then buf = vim.api.nvim_create_buf(false, true) end
  pcall(vim.api.nvim_buf_set_lines, buf, 0, -1, false, { t })

  local cfg = {
    relative = "editor",
    width = w,
    height = 1,
    row = lines - 2,
    col = pos,
    style = "minimal",
    focusable = false,
    zindex = 30,
    noautocmd = true,
  }
  if valid_win() then
    pcall(vim.api.nvim_win_set_config, win, cfg)
  else
    local ok, w_ = pcall(vim.api.nvim_open_win, buf, false, cfg)
    if ok then
      win = w_
      vim.wo[win].winhighlight = "Normal:CatPet,NormalFloat:CatPet"
      vim.wo[win].winblend = 0
    end
  end
end

function M.toggle()
  enabled = not enabled
  if not enabled then M.close() end
  vim.notify("Chat : " .. (enabled and "ON" or "OFF"))
end

function M.setup()
  vim.api.nvim_set_hl(0, "CatPet", { fg = "#ff6ec7", bg = "NONE" })
  math.randomseed(uv.hrtime())
  if timer then return end
  timer = uv.new_timer()
  timer:start(1500, 220, vim.schedule_wrap(draw))
  vim.api.nvim_create_user_command("CatToggle", M.toggle, {})
end

return M
