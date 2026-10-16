local M = {}

local namespace = vim.api.nvim_create_namespace "girly_sparkle"
local glyphs = { "✦", "✧", "·", "＊" }
local steps = { "#d3d2d6", "#9d8d8c", "#5a4a47" }
local last_burst = 0

local function set_step_colors(step)
  vim.api.nvim_set_hl(0, "GirlySparkle", { fg = steps[step], bold = step == 1 })
end

local function burst(buf)
  local win = vim.fn.bufwinid(buf)
  if win == -1 then return end

  local first = vim.fn.line("w0", win)
  local last = vim.fn.line("w$", win)
  if last <= first then return end

  local row = vim.api.nvim_win_get_cursor(win)[1] - 1
  local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ""
  vim.hl.range(buf, namespace, "GirlySaveFlash", { row, 0 }, { row, #line }, { timeout = 180 })

  set_step_colors(1)
  local marks = {}
  for _ = 1, 7 do
    local sparkle_row = math.random(first, last) - 1
    local text = vim.api.nvim_buf_get_lines(buf, sparkle_row, sparkle_row + 1, false)[1] or ""
    local col = #text > 2 and math.random(0, #text - 1) or 0
    local ok, mark = pcall(vim.api.nvim_buf_set_extmark, buf, namespace, sparkle_row, col, {
      virt_text = { { glyphs[math.random(#glyphs)], "GirlySparkle" } },
      virt_text_pos = "overlay",
      priority = 500,
    })
    if ok then marks[#marks + 1] = mark end
  end

  local step = 1
  local timer = (vim.uv or vim.loop).new_timer()
  timer:start(140, 140, vim.schedule_wrap(function()
    step = step + 1
    if step > #steps or not vim.api.nvim_buf_is_valid(buf) then
      timer:stop()
      timer:close()
      if vim.api.nvim_buf_is_valid(buf) then
        for _, mark in ipairs(marks) do
          pcall(vim.api.nvim_buf_del_extmark, buf, namespace, mark)
        end
      end
      return
    end
    set_step_colors(step)
  end))
end

function M.register()
      vim.api.nvim_set_hl(0, "GirlySaveFlash", { bg = "#2a1d1a" })
  set_step_colors(1)

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("girly_sparkle", { clear = true }),
    desc = "Etincelles roses a la sauvegarde",
    callback = function(args)
      if vim.g.girly_sparkle == false then return end
      if vim.bo[args.buf].buftype ~= "" then return end
      local now = (vim.uv or vim.loop).hrtime()
      if now - last_burst < 4e9 then return end
      last_burst = now
      burst(args.buf)
    end,
  })
end

return M
