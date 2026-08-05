local M = {}

local WINDOWS_VENDORS = { "Java", "Eclipse Adoptium", "Microsoft", "Zulu", "Amazon Corretto", "openjdk" }

local function usable(dir)
  if not dir or dir == "" then return nil end
  return vim.fn.isdirectory(dir .. "/bin") == 1 and dir or nil
end

local function from_macos(version)
  local out = vim.fn.systemlist { "/usr/libexec/java_home", "-F", "-v", version }
  if vim.v.shell_error == 0 then return usable(out[1]) end
  return usable("/Library/Java/JavaVirtualMachines/jdk-" .. version .. ".jdk/Contents/Home")
end

local function from_windows(version)
  local roots = { vim.env.ProgramFiles, vim.env["ProgramFiles(x86)"], vim.fs.normalize "~/scoop/apps" }
  for _, root in ipairs(roots) do
    if root and root ~= "" then
      for _, vendor in ipairs(WINDOWS_VENDORS) do
        local pattern = vim.fs.normalize(root .. "/" .. vendor) .. "/*" .. version .. "*"
        local matches = vim.fn.glob(pattern, false, true)
        table.sort(matches)
        for i = #matches, 1, -1 do
          local home = usable(matches[i]) or usable(matches[i] .. "/current")
          if home then return home end
        end
      end
    end
  end
  return nil
end

local function from_linux(version)
  local matches = vim.fn.glob("/usr/lib/jvm/*" .. version .. "*", false, true)
  table.sort(matches)
  for i = #matches, 1, -1 do
    local home = usable(matches[i])
    if home then return home end
  end
  return nil
end

function M.find(version)
  local pinned = usable(vim.env["JAVA_HOME_" .. version])
  if pinned then return pinned end

  local found
  if vim.fn.has "mac" == 1 then
    found = from_macos(version)
  elseif vim.fn.has "win32" == 1 then
    found = from_windows(version)
  else
    found = from_linux(version)
  end

  return found or usable(vim.env.JAVA_HOME)
end

return M
