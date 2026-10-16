local core = {
  { "<D-o>", "Aller a un fichier" },
  { "<D-e>", "Fichiers recents" },
  { "<Leader>fp", "Changer de projet (liste complete)" },
  { "<D-S-f>", "Rechercher dans le projet" },
  { "<D-S-r>", "Remplacer dans le projet" },
  { "<Leader>xx", "Panneau d'erreurs (Trouble)" },
  { "<Leader>rr / <Leader>rd", "Run / Debug" },
  { "<Leader>rb", "Point d'arret" },
  { "<Leader>or", "Lancer une tache (Overseer)" },
  { "<D-1>", "Explorateur (neo-tree)" },
  { "<D-9>", "Lazygit" },
  { "<D-t>", "Terminal flottant" },
  { "<D-i> / <D-b>", "Inspecter (definition) / revenir" },
  { "<Leader>fu", "Historique d'annulation" },
  { "<Leader>uB", "Toggle git blame" },
  { "]f / [f", "Fonction suivante / precedente" },
  { "]] / [[", "Classe / impl suivant / precedent" },
  { "gS", "Split / join arguments" },
  { "<Leader>ux", "Toggle bandeau de scope" },
  { "<Leader>xq / xl", "Quickfix / loclist (editables)" },
  { "s", "Flash : sauter n'importe ou" },
  { "g?v / g?p", "Print de debug (variable / plain)" },
  { "g?d / g?t", "Supprimer / commenter les prints" },
  { "<Leader>re / rv / ri", "Refactor : extraire fct / var / inline (visuel)" },
  { "<Leader>rc / rC", "Supprimer les commentaires (fichier / projet)" },
  { "<Leader>rP / rD", "Commentaires : tout sauf la doc / doc seule" },
  { "<Leader>cs", "Screenshot du code (visuel)" },
  { "<Leader>m", "Cheatsheet des DEPLACEMENTS" },
  { "<Leader>? / <D-?>", "Cette antiseche" },
}

local multicursor = {
  { "<C-g>", "Curseur sur l'occurrence suivante" },
  { "<A-g>", "Sauter l'occurrence" },
  { "<A-q>", "Geler / degeler les curseurs" },
  { "<C-clic>", "Ajouter / retirer un curseur" },
  { "<Leader>Mj / Mk", "Curseur ligne dessous / dessus" },
  { "<Leader>Mn / MN", "Occurrence suivante / precedente" },
  { "<Leader>Ms / MS", "Sauter suivante / precedente" },
  { "<Leader>Ml", "Aligner les colonnes" },
  { "<Leader>Mo", "Un curseur par ligne (operateur)" },
  { "<Leader>Mm / Mp", "Visuel : regex / decouper" },
  { "<Leader>Mr", "Restaurer les curseurs" },
  { "<Leader>Mx", "Supprimer le curseur courant" },
  { "<Left> / <Right>", "Changer de curseur principal" },
  { "<Esc>", "Sortir du multi-curseur" },
}

local look = {
  { "<Leader>Ua", "Menu des animations" },
  { "<Leader>Uv", "Fondu des fenetres inactives" },
  { "<Leader>Ue", "Pluie d'etoiles (drop)" },
  { "<Leader>UV / UE", "Cycle cursor VFX / easing" },
  { "<Leader>Ur / Ul", "Pluie de code / game of life" },
  { "<Leader>uP", "Palette de couleurs (minty)" },
  { "<Leader>uG", "Choisir un theme girly" },
  { "<Leader>uM", "Masquer les infos sensibles" },
}

local tools = {
  { "<Leader>W", "Hydra : gestion des fenetres" },
  { "<Leader>fU", "Time machine (timeline d'undo)" },
  { "<Leader>fK", "Wrapped (stats de la config)" },
  { "<Leader>fi", "Glyphes Nerd Font / emoji" },
  { "<Leader>P", "Coller une image du presse-papier" },
  { "<Leader>uI", "Image : vraie image / donnees" },
  { "<Leader>uH", "Image : image / brut / hex" },
  { "gx", "Image : ouvrir dans la visionneuse" },
}

local per_ft = {
  rust = {
    { "K", "Hover + actions" },
    { "<Leader>lm", "Expand macro" },
    { "<Leader>le", "Expliquer l'erreur" },
    { "<Leader>lc", "Ouvrir Cargo.toml" },
    { "<Leader>lp", "Module parent" },
    { "<Leader>lo", "docs.rs du symbole" },
    { "<Leader>lr", "Search/replace structurel" },
    { "<Leader>lt", "Arbre syntaxique" },
    { "<Leader>lk / lj", "Monter / descendre l'item" },
  },
  cs = {
    { "<Leader>lR", "Debug / attach Unity" },
    { "<D-.>", "Code actions" },
    { "<C-S-r>", "Renommer" },
    { "<D-j>", "Doc au survol" },
    { "<D-u>", "Trouver les usages" },
    { "<D-i> / <D-b>", "Inspecter / revenir" },
  },
  python = {
    { "<Leader>rr", "Lancer le fichier" },
    { "<Leader>rd", "Debug (methode de test)" },
    { "<Leader>lv", "Choisir le venv" },
  },
  c = {
    { "<C-r>", "Run (CMake ou fichier)" },
    { "<C-d>", "Debugger (codelldb)" },
    { "<Leader>lh", "Basculer header/source" },
    { "<Leader>lb / lr / lC", "CMake: build / run / debug" },
    { "<D-.>", "Code actions" },
    { "<C-S-r>", "Renommer" },
  },
  java = {
    { "<C-r>", "Run / Debug (classe main)" },
    { "<C-d>", "Relancer le dernier debug" },
    { "<Leader>li", "Organiser les imports" },
    { "<Leader>lv / lc", "Extraire variable / constante" },
    { "<Leader>lm", "Extraire methode (visuel)" },
    { "<Leader>lt / lT", "Tester methode / classe" },
    { "<Leader>lb", "Build (Overseer)" },
  },
  http = {
    { "<CR>", "Envoyer la requete" },
    { "<Leader>Hs / Ha", "Envoyer (une / toutes)" },
    { "<Leader>Hr", "Rejouer la derniere" },
    { "<Leader>Hi", "Inspecter la requete" },
    { "<Leader>He", "Choisir l'environnement" },
    { "<Leader>Hn / Hp", "Requete suivante / precedente" },
    { "<Leader>Hc / HC", "Copier / coller en cURL" },
    { "<Leader>Ht", "Basculer headers/body" },
  },
  lua = { { "<Leader>rr", "Executer le fichier (luafile)" }, { "<D-j>", "Doc au survol" } },
}

per_ft.cpp = per_ft.c
per_ft.objc = per_ft.c
per_ft.objcpp = per_ft.c

local function cargo_extra()
  return {
    { "<Leader>lv", "Versions de la dependance" },
    { "<Leader>lf", "Features" },
    { "<Leader>lu / lU", "Update (dep / tout)" },
    { "<Leader>lg / lG", "Upgrade (dep / tout)" },
    { "<Leader>lo", "Doc de la dependance" },
  }
end

local movement = {
  {
    "Mot / ligne / fichier",
    {
      { "<C-←> / <C-→>", "Mot precedent / suivant" },
      { "<A-←> / <A-→>", "Mot precedent / suivant" },
      { "<A-↑> / <A-↓>", "Bloc / paragraphe prec. / suiv." },
      { "<D-←> / <D-→>", "Debut / fin de ligne" },
      { "<D-↑> / <D-↓>", "Debut / fin du fichier" },
    },
  },
  {
    "Dans le code",
    {
      { "]f / [f", "Fonction suivante / precedente" },
      { "]] / [[", "Classe / impl suivant / precedent" },
      { "[x", "Remonter au scope parent" },
    },
  },
  {
    "Sauter / chercher",
    {
      { "s", "Flash : sauter n'importe ou a l'ecran" },
      { "n / N", "Occurrence de recherche suiv. / prec." },
      { "* / #", "Chercher le mot sous le curseur" },
      { "<D-g> / <D-S-g>", "Occurrence du mot (illuminate)" },
    },
  },
  {
    "Naviguer le code (LSP)",
    {
      { "<D-i>", "Inspecter : aller a la definition" },
      { "<D-b> / <D-S-b>", "Revenir / ravancer (historique)" },
      { "<D-[> / <D-]>", "Revenir / ravancer (alias)" },
      { "gD", "Aller a la declaration (selon serveur)" },
      { "<D-S-i>", "Aller a l'implementation" },
      { "<C-S-b>", "Aller au type" },
      { "<D-u>", "Usages / references" },
      { "<D-7>", "Structure du fichier (symboles)" },
      { "<D-S-y>", "Aller a un symbole (projet)" },
    },
  },
  {
    "Problemes / git",
    {
      { "]d / [d", "Probleme suivant / precedent" },
      { "]g / [g", "Modif git suivante / precedente" },
    },
  },
  {
    "Fichiers / buffers / fenetres",
    {
      { "<D-o> / <D-e>", "Aller a un fichier / recents" },
      { "<D-S-[> / <D-S-]>", "Buffer precedent / suivant" },
      { "<D-w>", "Fermer le buffer" },
      { "<D-n>", "Nouveau fichier" },
      { "<Leader>bb", "Choisir un buffer dans la liste" },
      { "<C-h/j/k/l>", "Se deplacer entre les fenetres" },
      { "<C-Tab> / <C-S-Tab>", "Fenetre suivante / precedente" },
    },
  },
}

local PAD = 20

local function render(title, sections)
  local lines, hl = {}, {}
  local function add(s, group)
    lines[#lines + 1] = s
    hl[#lines] = group
  end
  add("  " .. title, "Header")
  for _, sec in ipairs(sections) do
    add("", nil)
    add("  " .. sec[1], "Title")
    for _, m in ipairs(sec[2]) do
      add(string.format("   %-" .. PAD .. "s %s", m[1], m[2]), "Entry")
    end
  end
  add("", nil)
  add("   q / <Esc> pour fermer", "Dim")
  return lines, hl
end

local function show(title, sections)
  local platform_key = require("keymap_platform").key
  for _, section in ipairs(sections) do
    for _, entry in ipairs(section[2]) do
      entry[1] = platform_key(entry[1])
    end
  end
  local lines, hl = render(title, sections)
  local width = 0
  for _, l in ipairs(lines) do width = math.max(width, vim.fn.strdisplaywidth(l)) end
  width = width + 3

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  vim.api.nvim_set_hl(0, "CheatBorder", { fg = "#8fe0d4", bg = "NONE" })
  vim.api.nvim_set_hl(0, "CheatTitle", { fg = "#6fb7c9", bold = true })
  vim.api.nvim_set_hl(0, "CheatHeader", { fg = "#8fe0d4", bold = true })
  vim.api.nvim_set_hl(0, "CheatKey", { fg = "#b79cf0", bold = true })
  vim.api.nvim_set_hl(0, "CheatDim", { fg = "#8a7a90", italic = true })

  local ns = vim.api.nvim_create_namespace "cheatsheet"
  local function add_hl(line, group, col_end)
    vim.api.nvim_buf_set_extmark(buf, ns, line, 0, { end_col = col_end, hl_group = group })
  end
  for i, group in pairs(hl) do
    local line = i - 1
    local eol = #lines[i]
    if group == "Header" then
      add_hl(line, "CheatHeader", eol)
    elseif group == "Title" then
      add_hl(line, "CheatTitle", eol)
    elseif group == "Dim" then
      add_hl(line, "CheatDim", eol)
    elseif group == "Entry" then
      add_hl(line, "CheatKey", math.min(3 + PAD, eol))
    end
  end

  local height = math.min(#lines, vim.o.lines - 4)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2 - 1),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " cheatsheet ",
    title_pos = "center",
  })
  vim.wo[win].winhighlight = "FloatBorder:CheatBorder,FloatTitle:CheatHeader,Normal:Normal"
  vim.wo[win].cursorline = false
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  for _, key in ipairs { "q", "<Esc>" } do
    vim.keymap.set("n", key, "<Cmd>close<CR>", { buffer = buf, nowait = true, silent = true })
  end
end

local function open_cheatsheet()
  local ft = vim.bo.filetype
  local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
  local sections = {
    { "Partout", core },
    { "Multi-curseur", multicursor },
    { "Look & animations", look },
    { "Outils", tools },
  }
  if fname == "Cargo.toml" then
    sections[#sections + 1] = { "Ici ( Cargo.toml )", cargo_extra() }
  elseif per_ft[ft] then
    sections[#sections + 1] = { "Ici ( " .. ft .. " )", per_ft[ft] }
  end
  show("Raccourcis", sections)
end

local function open_movement() show("Deplacements", movement) end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = {
    commands = {
      Cheatsheet = { open_cheatsheet, desc = "Raccourcis pertinents (contextuel)" },
      Deplacements = { open_movement, desc = "Cheatsheet des deplacements" },
    },
    mappings = require("keymap_platform").mappings {
      n = {
        ["<Leader>?"] = { open_cheatsheet, desc = "Mes raccourcis (contextuel)" },
        ["<D-?>"] = { open_cheatsheet, desc = "Mes raccourcis (contextuel)" },
        ["<Leader>m"] = { open_movement, desc = "Cheatsheet des deplacements" },
      },
    },
  },
}
