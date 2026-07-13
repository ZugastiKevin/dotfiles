local function dap() return require "dap" end
local function pick(method) return function() require("snacks").picker[method]() end end

local function run_or_debug(kind)
  return function()
    local ft = vim.bo.filetype
    if ft == "rust" then
      pcall(vim.cmd.RustLsp, kind == "debug" and "debuggables" or "runnables")
      return
    end
    if kind == "debug" then
      if ft == "python" then
        pcall(function() require("dap-python").test_method() end)
      else
        dap().continue()
      end
      return
    end
    if ft == "python" then
      vim.cmd("TermExec direction=horizontal cmd='python3 " .. vim.fn.shellescape(vim.fn.expand "%") .. "'")
    elseif ft == "lua" then
      vim.cmd "luafile %"
    elseif ft == "swift" then
      local root = vim.fs.root(0, "Package.swift")
      if root then
        vim.cmd("TermExec direction=horizontal dir=" .. vim.fn.shellescape(root) .. " cmd='swift run'")
      else
        vim.cmd("TermExec direction=horizontal cmd='swift " .. vim.fn.shellescape(vim.fn.expand "%:p") .. "'")
      end
    else
      vim.notify("Run non configure pour '" .. ft .. "'", vim.log.levels.INFO)
    end
  end
end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 },
      autopairs = true,
      cmp = true,
      diagnostics = { virtual_text = false, virtual_lines = false },
      highlighturl = true,
      notifications = true,
    },
    diagnostics = {
      virtual_text = false,
      underline = true,
    },
    options = {
      opt = {
        relativenumber = true,
        number = true,
        spell = false,
        signcolumn = "yes",
        wrap = false,
        cursorline = true,
        scrolloff = 8,
        sidescrolloff = 8,
        splitkeep = "screen",
        timeoutlen = 400,
        updatetime = 900,
        keymodel = "startsel,stopsel",
        foldcolumn = "1",
        foldlevel = 99,
        foldlevelstart = 99,
        foldenable = true,
        autoread = true,
        swapfile = false,
        undofile = true,
        fillchars = { foldopen = "▾", foldclose = "▸", fold = " ", foldsep = " ", diff = "╱", eob = " " },
        winborder = "rounded",
      },
      g = {
        loaded_node_provider = 0,
        loaded_perl_provider = 0,
        loaded_python3_provider = 0,
        loaded_ruby_provider = 0,
        no_rust_maps = 1,
      },
    },
    mappings = {
      n = {
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        ["<D-S-o>"] = { pick "files", desc = "Go to file" },
        ["<D-o>"] = { pick "files", desc = "Go to file" },
        ["<D-e>"] = { pick "recent", desc = "Recent files" },
        ["<D-S-e>"] = { pick "resume", desc = "Recent locations" },
        ["<D-S-a>"] = { pick "commands", desc = "Find action" },
        ["<D-S-f>"] = { pick "grep", desc = "Find in path" },
        ["<D-f>"] = { "/", desc = "Find in file" },
        ["<D-r>"] = { ":%s/", desc = "Replace in file" },
        ["<D-l>"] = { ":", desc = "Go to line" },

        ["<D-1>"] = { "<Cmd>Neotree toggle<CR>", desc = "Project tool window" },
        ["<D-9>"] = {
          function()
            local snacks = require "snacks"
            local buf = vim.api.nvim_buf_get_name(0)
            local root = snacks.git.get_root(buf ~= "" and buf or nil) or snacks.git.get_root(vim.fn.getcwd())
            if root then
              snacks.lazygit { cwd = root }
            else
              vim.notify("Lazygit : pas dans un depot git", vim.log.levels.WARN)
            end
          end,
          desc = "Lazygit",
        },
        ["<D-t>"] = { "<Cmd>1ToggleTerm direction=float<CR>", desc = "Terminal flottant" },
        ["<C-t>"] = { "<Cmd>1ToggleTerm direction=float<CR>", desc = "Terminal flottant" },
        ["<D-S-t>"] = { "<Cmd>2ToggleTerm direction=horizontal size=14<CR>", desc = "Terminal en bas" },
        ["<C-Tab>"] = { "<C-w>w", desc = "Fenetre suivante (rotation)" },
        ["<C-S-Tab>"] = { "<C-w>W", desc = "Fenetre precedente" },

        ["<D-S-r>"] = { "<Cmd>GrugFar<CR>", desc = "Remplacer dans le projet" },
        ["<D-g>"] = { function() require("illuminate").goto_next_reference(true) end, desc = "Occurrence suivante" },
        ["<D-S-g>"] = { function() require("illuminate").goto_prev_reference(true) end, desc = "Occurrence precedente" },
        ["<Leader>uT"] = { "<Cmd>Twilight<CR>", desc = "Twilight (focus bloc courant)" },
        ["<Leader>uW"] = false,
        ["<Leader>uG"] = { "<Cmd>GirlyTheme<CR>", desc = "Choisir un theme girly" },

        ["<Leader>a"] = { desc = "IA (Claude Code)" },
        ["<Leader>a<CR>"] = false,
        ["<Leader>ac"] = false,
        ["<Leader>af"] = false,
        ["<Leader>at"] = false,
        ["<Leader>aF"] = false,
        ["<Leader>H"] = { desc = "Requetes HTTP" },
        ["<leader>M"] = false,
        ["<leader>Ma"] = false,
        ["<leader>Mc"] = false,
        ["<leader>Mi"] = false,
        ["<leader>Mr"] = false,
        ["<leader>Mt"] = false,

        ["<D-[>"] = { "<C-o>", desc = "Navigate back" },
        ["<D-]>"] = { "<C-i>", desc = "Navigate forward" },

        ["<C-Left>"] = { "b", desc = "Mot precedent" },
        ["<C-Right>"] = { "w", desc = "Mot suivant" },
        ["<A-Left>"] = { "b", desc = "Mot precedent" },
        ["<A-Right>"] = { "w", desc = "Mot suivant" },
        ["<A-Up>"] = { "{", desc = "Bloc precedent" },
        ["<A-Down>"] = { "}", desc = "Bloc suivant" },
        ["<D-Left>"] = { "^", desc = "Debut de ligne" },
        ["<D-Right>"] = { "$", desc = "Fin de ligne" },
        ["<D-Up>"] = { "gg", desc = "Debut du fichier" },
        ["<D-Down>"] = { "G", desc = "Fin du fichier" },
        ["<S-D-Left>"] = { "v^", desc = "Selection debut de ligne" },
        ["<S-D-Right>"] = { "v$h", desc = "Selection fin de ligne" },
        ["<S-D-Up>"] = { "vgg", desc = "Selection vers le haut" },
        ["<S-D-Down>"] = { "vG", desc = "Selection vers le bas" },
        ["<C-BS>"] = { "db", desc = "Supprimer le mot precedent" },

        ["<D-s>"] = { "<Cmd>w<CR>", desc = "Save" },
        ["<D-a>"] = { "ggVG", desc = "Select all" },
        ["<D-v>"] = { '"+p', desc = "Paste" },
        ["<D-.>"] = { function() vim.lsp.buf.code_action() end, desc = "Quick fix / code action" },
        ["<D-z>"] = { "u", desc = "Undo" },
        ["<D-S-z>"] = { "<C-r>", desc = "Redo" },
        ["<D-d>"] = { "yyp", desc = "Duplicate line" },
        ["<D-BS>"] = { "dd", desc = "Delete line" },
        ["<D-/>"] = {
          function() vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("gcc", true, false, true), "m", false) end,
          desc = "Comment line",
        },
        ["<C-S-Down>"] = { "<Cmd>m .+1<CR>==", desc = "Move line down" },
        ["<C-S-Up>"] = { "<Cmd>m .-2<CR>==", desc = "Move line up" },

        ["<Leader>fu"] = { function() require("snacks").picker.undo() end, desc = "Historique d'annulation" },

        ["<Leader>r"] = { desc = "Run / Refactor" },
        ["<Leader>rr"] = { run_or_debug "run", desc = "Run" },
        ["<Leader>rd"] = { run_or_debug "debug", desc = "Debug" },
        ["<Leader>rb"] = { function() dap().toggle_breakpoint() end, desc = "Point d'arret" },
        ["<C-S-c>"] = { function() dap().continue() end, desc = "Debug: continuer / resume" },
        ["<C-S-o>"] = { function() dap().step_over() end, desc = "Debug: step over" },
        ["<C-S-n>"] = { function() dap().step_into() end, desc = "Debug: step into" },
        ["<C-S-u>"] = { function() dap().step_out() end, desc = "Debug: step out" },
        ["<C-S-q>"] = { function() dap().terminate() end, desc = "Debug: stop" },
      },
      i = {
        ["<D-t>"] = { "<Esc><Cmd>1ToggleTerm direction=float<CR>", desc = "Terminal flottant" },
        ["<C-t>"] = { "<Esc><Cmd>1ToggleTerm direction=float<CR>", desc = "Terminal flottant" },
        ["<D-S-t>"] = { "<Esc><Cmd>2ToggleTerm direction=horizontal size=14<CR>", desc = "Terminal en bas" },
        ["<C-Left>"] = { "<C-o>b", desc = "Mot precedent" },
        ["<C-Right>"] = { "<C-o>w", desc = "Mot suivant" },
        ["<A-Left>"] = { "<C-o>b", desc = "Mot precedent" },
        ["<A-Right>"] = { "<C-o>w", desc = "Mot suivant" },
        ["<D-Left>"] = { "<Home>", desc = "Debut de ligne" },
        ["<D-Right>"] = { "<End>", desc = "Fin de ligne" },
        ["<D-Up>"] = { "<C-o>gg", desc = "Debut du fichier" },
        ["<D-Down>"] = { "<C-o>G", desc = "Fin du fichier" },
        ["<C-BS>"] = { "<C-w>", desc = "Supprimer le mot precedent" },
        ["<D-s>"] = { "<Esc><Cmd>w<CR>", desc = "Save" },
        ["<D-v>"] = { "<C-r>+", desc = "Paste" },
        ["<D-z>"] = { "<C-o>u", desc = "Undo" },
        ["<C-S-Down>"] = { "<Esc><Cmd>m .+1<CR>==gi", desc = "Move line down" },
        ["<C-S-Up>"] = { "<Esc><Cmd>m .-2<CR>==gi", desc = "Move line up" },
      },
      x = {
        ["S"] = false,
      },
      v = {
        ["<Leader>r"] = { desc = "Refactoring" },
        ["<Leader>c"] = { desc = "Screenshot code" },
        ["<Leader>a"] = { desc = "IA (Claude Code)" },
        ["<Leader>g"] = { desc = "Git" },
        ["<C-Left>"] = { "b", desc = "Mot precedent" },
        ["<C-Right>"] = { "w", desc = "Mot suivant" },
        ["<A-Up>"] = { "{", desc = "Etendre au bloc precedent" },
        ["<A-Down>"] = { "}", desc = "Etendre au bloc suivant" },
        ["<D-Left>"] = { "^", desc = "Debut de ligne" },
        ["<D-Right>"] = { "$", desc = "Fin de ligne" },
        ["<D-Up>"] = { "gg", desc = "Debut du fichier" },
        ["<D-Down>"] = { "G", desc = "Fin du fichier" },
        ["<D-/>"] = { "gc", remap = true, desc = "Comment" },
        ["<D-c>"] = { "y", desc = "Copy" },
        ["<D-x>"] = { "d", desc = "Cut" },
        ["<D-v>"] = { "p", desc = "Paste" },
        ["<D-d>"] = { ":t'><CR>", desc = "Duplicate selection" },
        ["<D-a>"] = { "<Esc>ggVG", desc = "Select all" },
        ["<C-S-Down>"] = { ":m '>+1<CR>gv=gv", desc = "Move selection down" },
        ["<C-S-Up>"] = { ":m '<-2<CR>gv=gv", desc = "Move selection up" },
      },
      t = {
        ["<D-t>"] = { "<Cmd>1ToggleTerm<CR>", desc = "Fermer le terminal flottant" },
        ["<C-t>"] = { "<Cmd>1ToggleTerm<CR>", desc = "Fermer le terminal flottant" },
        ["<D-S-t>"] = { "<Cmd>2ToggleTerm<CR>", desc = "Fermer le terminal du bas" },
        ["<C-Tab>"] = { "<C-\\><C-n><C-w>w", desc = "Fenetre suivante (rotation)" },
        ["<C-S-Tab>"] = { "<C-\\><C-n><C-w>W", desc = "Fenetre precedente" },
        ["<Esc><Esc>"] = { "<C-\\><C-n>", desc = "Mode normal (sortir du terminal)" },
      },
    },
  },
}
