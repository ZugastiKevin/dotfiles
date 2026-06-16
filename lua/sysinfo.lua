local M = {}

local uv = vim.uv or vim.loop
local timer
local enabled = true

local CMD = [[top -l1 -n0 2>/dev/null | grep -E "CPU usage|PhysMem"; ioreg -r -d 1 -c IOAccelerator -w 0 2>/dev/null | grep -o '"Device Utilization %"=[0-9]*' | head -1]]

local function poll()
  if not enabled then
    vim.g.sysinfo_str = ""
    pcall(vim.cmd.redrawstatus)
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
    vim.g.sysinfo_str = table.concat(parts, "  ")
    pcall(vim.cmd.redrawstatus)
  end))
end

function M.toggle()
  enabled = not enabled
  if not enabled then
    vim.g.sysinfo_str = ""
    pcall(vim.cmd.redrawstatus)
  end
  vim.notify("Infos systeme : " .. (enabled and "ON" or "OFF"))
end

function M.setup()
  if timer then return end
  timer = uv.new_timer()
  timer:start(1000, 3000, vim.schedule_wrap(poll))
  vim.api.nvim_create_user_command("SysInfoToggle", M.toggle, {})
end

return M
