# Config Neovim — branche Windows

Portage de la config macOS. La branche `main` reste la référence ; `windows` ajoute une couche
de compatibilité et ne modifie aucun comportement sur macOS (tout est conditionné par
`vim.fn.has "mac"` / `vim.fn.has "win32"`).

## Installation

```powershell
irm https://git.gay/CatAnnaDev/nvim-config/raw/branch/windows/install.ps1 | iex
```

ou, depuis un clone :

```powershell
.\install.ps1
```

Options : `-SkipDependencies`, `-SkipOptional`, `-Force`, `-Branch <nom>`, `-Repository <url>`.

Le script installe les dépendances via winget, clone la branche dans `%LOCALAPPDATA%\nvim`,
restaure `lazy-lock.json`, puis compile les parsers treesitter et les outils Mason.

## Neovide fortement recommandé

Plusieurs raccourcis (`<C-S-…>`, `<C-/>`, `<C-=>`, `<M-CR>`) ne traversent pas la plupart des
émulateurs de terminal Windows. Ils fonctionnent tous sous Neovide. En terminal, `<C-S-f>`
se replie sur `<C-f>` et entre donc en collision avec « Find in file ».

## Remappage de la touche Cmd

macOS a 109 raccourcis `<D-…>`. Windows n'a pas d'équivalent utilisable, donc
`lua/keymap_platform.lua` traduit chaque `lhs` au chargement.

Règle par défaut : `<D-x>` devient `<M-x>` (Alt). Les exceptions sont dans la table
`M.overrides` en haut du fichier — c'est le seul endroit à éditer pour ajuster un raccourci.

| macOS | Windows | Action |
|---|---|---|
| `<D-o>` / `<D-S-o>` | `<M-o>` / `<M-S-o>` | Aller à un fichier |
| `<D-e>` / `<D-S-e>` | `<M-e>` / `<M-S-e>` | Fichiers récents / emplacements |
| `<D-S-a>` | `<M-S-a>` | Palette d'actions |
| `<D-f>` | `<C-f>` | Rechercher dans le fichier |
| `<D-S-f>` | `<C-S-f>` | Rechercher dans le projet |
| `<D-r>` / `<D-S-r>` | `<M-r>` / `<M-S-r>` | Remplacer (fichier / projet) |
| `<D-l>` | `<M-l>` | Aller à la ligne |
| `<D-1>` / `<D-9>` | `<M-1>` / `<M-9>` | Neo-tree / Lazygit |
| `<D-7>` | `<M-7>` | Structure du fichier |
| `<D-t>` / `<D-S-t>` | `<C-t>` / `<C-S-t>` | Terminal flottant / en bas |
| `<D-w>` / `<D-n>` | `<M-w>` / `<M-n>` | Fermer le buffer / nouveau fichier |
| `<D-S-[>` / `<D-S-]>` | `<M-S-[>` / `<M-S-]>` | Buffer précédent / suivant |
| `<D-b>` / `<D-S-b>` | `<M-b>` / `<M-S-b>` | Retour / avancer |
| `<D-[>` / `<D-]>` | `<C-M-Left>` / `<C-M-Right>` | Navigation arrière / avant |
| `<D-g>` / `<D-S-g>` | `<C-M-g>` / `<C-M-S-g>` | Occurrence suivante / précédente |
| `<D-i>` / `<D-S-i>` | `<C-b>` / `<C-M-b>` | Définition / implémentation |
| `<D-u>` | `<M-u>` | Find usages |
| `<D-p>` / `<D-j>` | `<M-p>` / `<M-j>` | Signature / doc au survol |
| `<D-S-y>` | `<M-S-y>` | Symbole du projet |
| `<D-.>` | `<M-CR>` | Code action (convention JetBrains) |
| `<D-s>` | `<C-s>` | Enregistrer |
| `<D-z>` / `<D-S-z>` | `<C-z>` / `<C-y>` | Annuler / rétablir |
| `<D-v>` | `<C-S-v>` | Coller |
| `<D-c>` / `<D-x>` | `<M-c>` / `<M-x>` | Copier / couper |
| `<D-a>` / `<D-d>` | `<M-a>` / `<M-d>` | Tout sélectionner / dupliquer |
| `<D-BS>` | `<M-BS>` | Supprimer la ligne |
| `<D-/>` | `<C-/>` | Commenter |
| `<D-Left>` / `<D-Right>` | `<Home>` / `<End>` | Début / fin de ligne |
| `<D-Up>` / `<D-Down>` | `<C-Home>` / `<C-End>` | Début / fin du fichier |
| `<S-D-…>` (flèches) | `<S-Home>`, `<S-End>`, `<C-S-Home>`, `<C-S-End>` | Sélections |
| `<D-S-h/j/k/l>` | `<M-S-h/j/k/l>` | Redimensionner la fenêtre |
| `<D-=>` / `<D-->` / `<D-0>` | `<C-=>` / `<C-->` / `<C-0>` | Zoom Neovide |
| `<D-?>` | `<M-?>` | Cheatsheet |

`<M-?>` affiche la cheatsheet déjà traduite : elle montre toujours les touches réellement actives.

### Deux raccourcis natifs sont déplacés

- `<C-f>` ne fait plus page suivante en mode normal (remplacé par « rechercher »). Utiliser `<C-d>`.
- `<C-s>` remplace « Force write » d'AstroNvim par « Save », et en insertion prend la place de
  la signature LSP — celle-ci reste sur `<M-p>`.

Tout le reste (`<C-w>`, `<C-o>`, `<C-i>`, `<C-r>`, `<C-a>`, `<C-v>`, `<C-u>`, `<C-d>`, `<C-q>`,
`<A-g>`, `<A-q>`, `<A-flèches>`, `<C-h/j/k/l>`) est intact.

## Autres correctifs de portage

| Fichier | Correctif |
|---|---|
| `init.lua`, `lua/polish.lua` | Séparateur de `PATH` (`;` au lieu de `:`) — corrompait le `PATH` et rendait Mason introuvable. Chemins Homebrew remplacés par `~/.cargo/bin`, `~/.dotnet/tools`, `~/scoop/shims`. |
| `lua/java_home.lua` | Nouveau. Détection du JDK par version : `JAVA_HOME_<v>`, puis `/usr/libexec/java_home` (macOS), les répertoires vendeurs de `Program Files` / scoop (Windows), `/usr/lib/jvm` (Linux), enfin `JAVA_HOME`. |
| `lua/plugins/hytale.lua`, `lua/overseer/template/user/hytale.lua` | Plus de chemin JDK 25 en dur ; wrapper `gradlew.bat` sur Windows. |
| `lua/plugins/rustaceanvim.lua` | `liblldb` : `.dylib` / `.so` / omis sur Windows (codelldb l'embarque), et `codelldb.cmd`. |
| `lua/plugins/c-java.lua`, `lua/plugins/csharp.lua` | Suffixes `.exe` / `.cmd` pour codelldb et netcoredbg. |
| `lua/plugins/csharp.lua` | `unity_root_of` bouclait indéfiniment sur Windows (la remontée s'arrêtait sur `/`). Chemins normalisés, et les scripts `unity-*` sont ignorés proprement s'ils sont absents. |
| `lua/plugins/codesnap.lua` | `install.ps1` du plugin au lieu de `make build_generator`. |

## Dépendances externes

Requis : `git`, `nvim`, `rg`, `fd`, `zig` (parsers treesitter), `node`, `rustup`.

Optionnels, avec dégradation propre si absents : `neovide`, `lazygit`, `magick` et `chafa`
(prévisualisation d'image), `dotnet`, JDK 21 / 25, `cmake`, `python`.

`chafa` n'est pas dans winget : sans lui, `image_view` n'affiche pas d'aperçu en terminal.
