local KINDS = { "all", "plain", "doc" }

local function resolve_kind(arg)
  if not arg or arg == "" then return "all" end
  if vim.tbl_contains(KINDS, arg) then return arg end
  vim.notify("Filtre inconnu '" .. arg .. "' (attendu : " .. table.concat(KINDS, ", ") .. ")", vim.log.levels.WARN)
end

local function report(removed, dry_run)
  local verb = dry_run and "a supprimer" or "supprimes"
  vim.notify(("%d commentaires %s"):format(removed, verb), vim.log.levels.INFO, { title = "Strip comments" })
end

local function strip_buffer(args)
  local kind = resolve_kind(args.fargs[1])
  if not kind then return end
  local opts = { kind = kind, dry_run = args.bang }
  if args.range > 0 then
    opts.first, opts.last = args.line1 - 1, args.line2 - 1
  end
  local removed, err = require("strip_comments").strip_buffer(0, opts)
  if removed then
    report(removed, args.bang)
  else
    vim.notify(err or "echec", vim.log.levels.WARN, { title = "Strip comments" })
  end
end

local function strip_project(args)
  local kind = resolve_kind(args.fargs[2])
  if not kind then return end
  require("strip_comments").strip_project(args.fargs[1], { kind = kind, dry_run = args.bang })
end

local function run(cmd)
  return function() vim.cmd(cmd) end
end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = {
    commands = {
      StripComments = {
        strip_buffer,
        desc = "Supprimer les commentaires (fichier ou selection)",
        range = true,
        bang = true,
        nargs = "?",
        complete = function() return KINDS end,
      },
      StripCommentsProject = {
        strip_project,
        desc = "Supprimer les commentaires dans tout le projet",
        bang = true,
        nargs = "*",
        complete = function(_, line)
          return #vim.split(vim.trim(line), "%s+") > 2 and KINDS or { "*.rs", "*.lua", "*.c", "*.cpp", "*.cs", "*.java", "*.py", "*.ts" }
        end,
      },
    },
    mappings = {
      n = {
        ["<Leader>rc"] = { run "StripComments", desc = "Supprimer les commentaires (fichier)" },
        ["<Leader>rP"] = { run "StripComments plain", desc = "Supprimer les commentaires sauf la doc" },
        ["<Leader>rD"] = { run "StripComments doc", desc = "Supprimer seulement la doc" },
        ["<Leader>rC"] = { run "StripCommentsProject", desc = "Supprimer les commentaires (projet)" },
      },
      v = {
        ["<Leader>rc"] = { ":StripComments<CR>", desc = "Supprimer les commentaires (selection)" },
      },
    },
  },
}
