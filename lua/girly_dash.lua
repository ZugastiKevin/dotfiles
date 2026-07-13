local M = {}

local poses = {
  { open = "( ^.^ )", blink = "( -.- )" },
  { open = "( ^w^ )", blink = "( -w- )" },
  { open = "( o.o )", blink = "( -.- )" },
  { open = "( =.= )", blink = "( =.= )" },
  { open = "( ^.~ )", blink = "( -.- )" },
}

local phrases = {
  "prete a tout casser (proprement)",
  "les bugs n'ont qu'a bien se tenir",
  "girly, mais deterministe",
  "compile d'abord, doute ensuite",
  "nyaa~",
  "un push de plus et dodo",
  "zero warning, zero pitie",
  "le rose compile plus vite",
}

local pose = poses[1]
local phrase = phrases[1]
local blinking = false
local fresh = true
local timer = nil

function M.frame()
  if fresh then
    math.randomseed((vim.uv or vim.loop).hrtime() % 2147483647)
    pose = poses[math.random(#poses)]
    phrase = phrases[math.random(#phrases)]
    fresh = false
  end
  local eyes = blinking and pose.blink or pose.open
  return table.concat({
    " /\\_/\\",
    eyes,
    " > ^ <",
    "",
    "a n n a   ♥   n e o v i m",
    "",
    phrase,
  }, "\n")
end

local function stop_timer()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
end

local function schedule_blink()
  stop_timer()
  timer = (vim.uv or vim.loop).new_timer()
  timer:start(math.random(2500, 5200), 0, vim.schedule_wrap(function()
    blinking = true
    pcall(function() require("snacks").dashboard.update() end)
    vim.defer_fn(function()
      blinking = false
      pcall(function() require("snacks").dashboard.update() end)
      if timer then schedule_blink() end
    end, 140)
  end))
end

function M.on_open()
  schedule_blink()
end

function M.on_close()
  stop_timer()
  fresh = true
end

return M
