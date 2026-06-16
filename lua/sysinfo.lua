local M = {}

local uv = vim.uv or vim.loop
local buf, win, timer
local line = ""
local enabled = true

local CMD = [[top -l1 -n0 2>/dev/null | grep -E "CPU usage|PhysMem"; ioreg -r -d 1 -c IOAccelerator -w 0 2>/dev/null | grep -o '"Device Utilization %"=[0-9]*' | head -1]]

local function valid_win() return win and vim.api.nvim_win_is_valid(win) end
local function valid_buf() return buf and vim.api.nvim_buf_is_valid(buf) end

function M.close()
  if valid_win() then pcall(vim.api.nvim_win_close, win, true) end
  win = nil
end

local function render()
  if not enabled or line == "" then return end
  local cols, lines = vim.o.columns, vim.o.lines
  if cols < 30 or lines < 6 then return end
  local w = vim.fn.strwidth(line)
  if not valid_buf() then buf = vim.api.nvim_create_buf(false, true) end
  pcall(vim.api.nvim_buf_set_lines, buf, 0, -1, false, { line })
  local cfg = {
    relative = "editor",
    width = w,
    height = 1,
    row = lines - 2,
    col = math.max(0, cols - w - 1),
    style = "minimal",
    focusable = false,
    zindex = 40,
    noautocmd = true,
  }
  if valid_win() then
    pcall(vim.api.nvim_win_set_config, win, cfg)
  else
    local ok, w_ = pcall(vim.api.nvim_open_win, buf, false, cfg)
    if ok then
      win = w_
      vim.wo[win].winhighlight = "Normal:SysInfo,NormalFloat:SysInfo"
      vim.wo[win].winblend = 0
    end
  end
end

local function poll()
  if not enabled then
    M.close()
    return
  end
  vim.system({ "sh", "-c", CMD }, { text = true }, vim.schedule_wrap(function(res)
    local out = (res and res.stdout) or ""
    local idle = out:match "([%d%.]+)%% idle"
    local cpu = idle and math.floor(100 - tonumber(idle) + 0.5) or nil
    local ram = out:match "PhysMem:%s*(%d+[GM]) used"
    local gpu = out:match 'Utilization %%"=(%d+)'
    local parts = {}
    if cpu then parts[#parts + 1] = "CPU " .. cpu .. "%" end
    if gpu then parts[#parts + 1] = "GPU " .. gpu .. "%" end
    if ram then parts[#parts + 1] = "RAM " .. ram end
    line = table.concat(parts, "  ")
    render()
  end))
end

function M.toggle()
  enabled = not enabled
  if not enabled then M.close() end
  vim.notify("Infos systeme : " .. (enabled and "ON" or "OFF"))
end

function M.setup()
  vim.api.nvim_set_hl(0, "SysInfo", { fg = "#c98fd0", bg = "NONE" })
  if timer then return end
  timer = uv.new_timer()
  timer:start(2000, 3000, vim.schedule_wrap(poll))
  vim.api.nvim_create_user_command("SysInfoToggle", M.toggle, {})
end

return M
