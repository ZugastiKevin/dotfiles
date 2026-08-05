local jdk_lookup = require "java_home"
local JDK25 = jdk_lookup.find "25"
local JDK21 = jdk_lookup.find "21" or JDK25
local GRADLE_WRAPPER = vim.fn.has "win32" == 1 and "gradlew.bat" or "./gradlew"

local function gradle_dir(dir)
  local start = (dir and dir ~= "") and dir or vim.fn.getcwd()
  local wrapper = vim.fs.find("gradlew", { upward = true, path = start })[1]
  return wrapper and vim.fs.dirname(wrapper) or nil
end

return {
  condition = {
    callback = function(search) return gradle_dir(search.dir) ~= nil end,
  },
  generator = function(search, cb)
    local dir = gradle_dir(search.dir)
    if not dir then return cb {} end
    local java_home = dir:find "Minigame" and JDK21 or JDK25
    local task_env = java_home and { JAVA_HOME = java_home } or {}
    local label = vim.fn.fnamemodify(dir, ":t")

    local function task(name, args)
      return {
        name = name .. " (" .. label .. ")",
        priority = 40,
        builder = function()
          return {
            cmd = { GRADLE_WRAPPER },
            args = args,
            cwd = dir,
            env = task_env,
            components = { "default" },
          }
        end,
      }
    end

    cb {
      task("Hytale: gradle build", { "build" }),
      task("Hytale: gradle build sans tests", { "build", "-x", "test" }),
      task("Hytale: gradle clean build", { "clean", "build" }),
      task("Hytale: gradle test", { "test" }),
    }
  end,
}
