local function jdk(version, fallback)
  local out = vim.fn.systemlist { "/usr/libexec/java_home", "-F", "-v", version }
  return (vim.v.shell_error == 0 and out[1]) or fallback
end
local JDK25 = jdk("25", "/Library/Java/JavaVirtualMachines/jdk-25.jdk/Contents/Home")
local JDK21 = jdk("21", JDK25)

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
    local label = vim.fn.fnamemodify(dir, ":t")

    local function task(name, args)
      return {
        name = name .. " (" .. label .. ")",
        priority = 40,
        builder = function()
          return {
            cmd = { "./gradlew" },
            args = args,
            cwd = dir,
            env = { JAVA_HOME = java_home },
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
