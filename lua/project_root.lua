local M = {}

M.anchors = {
  "Cargo.toml",
  "*.slnx",
  "*.sln",
  "*.csproj",
  "*.fsproj",
  "settings.gradle",
  "settings.gradle.kts",
  "build.gradle",
  "build.gradle.kts",
  "pom.xml",
  "CMakeLists.txt",
  "compile_commands.json",
  "Makefile",
  "meson.build",
  "Package.swift",
  "*.xcworkspace",
  "*.xcodeproj",
  "ProjectSettings",
  "go.mod",
  "package.json",
  "pyproject.toml",
  ".git",
}

M.containers = {
  "~/RustroverProjects",
  "~/CLionProjects",
  "~/IdeaProjects",
  "~/RiderProjects",
  "~/SwiftProjects",
  "~/pas_de_csharp_pour_toi",
  "~/start_game_project",
  "~",
}

local function normalize(p) return (vim.fs.normalize(vim.fn.fnamemodify(p, ":p")):gsub("/$", "")) end

local stop_at
local function stops()
  if not stop_at then
    stop_at = {}
    for _, c in ipairs(M.containers) do
      stop_at[normalize(c)] = true
    end
  end
  return stop_at
end

local patterns
local function anchor_patterns()
  if not patterns then
    patterns = {}
    for _, a in ipairs(M.anchors) do
      patterns[#patterns + 1] = "^" .. a:gsub("[%.%-]", "%%%0"):gsub("%*", ".*") .. "$"
    end
  end
  return patterns
end

local cache = {}

function M.is_root(dir)
  dir = normalize(dir)
  local hit = cache[dir]
  if hit ~= nil then return hit end

  local found = false
  local ok, iter = pcall(vim.fs.dir, dir)
  if ok then
    for name in iter do
      for _, pattern in ipairs(anchor_patterns()) do
        if name:match(pattern) then
          found = true
          break
        end
      end
      if found then break end
    end
  end

  cache[dir] = found
  return found
end

function M.invalidate() cache = {} end

function M.root_of(path)
  if not path or path == "" then return nil end
  local dir = vim.fn.isdirectory(path) == 1 and path or vim.fs.dirname(path)
  local stop, found = stops(), nil
  dir = normalize(dir)

  while dir and dir ~= "" do
    if stop[dir] then break end
    if M.is_root(dir) then found = dir end
    local parent = vim.fs.dirname(dir)
    if not parent or parent == dir then break end
    dir = parent
  end

  return found
end

return M
