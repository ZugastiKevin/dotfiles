# Neovim = RustRover — antiseche (keymap fidele)

Lancer : `neovide <dossier>` (GUI). Leader = Espace (raccourcis AstroNvim par defaut OK).
Touches : Ctrl, Cmd, Shift. Aucune touche F (elles demandent Fn sur Mac) -> tout sur Cmd/Ctrl.

## Deplacement aux fleches (Mac/IDE)
| Action | Touche |
|---|---|
| Mot precedent / suivant | Ctrl+Gauche / Ctrl+Droite |
| Debut / fin de ligne | Cmd+Gauche / Cmd+Droite |
| Debut / fin du fichier | Cmd+Haut / Cmd+Bas |
| Selectionner | ajoute Shift a n'importe quelle fleche/combo |
| Supprimer le mot precedent | Ctrl+Backspace |

## Recherche / navigation fichiers
| Action | Touche |
|---|---|
| Go to file | Cmd+Shift+O  /  Cmd+O |
| Recent files | Cmd+E |
| Find action | Cmd+Shift+A |
| Find in path (grep projet) | Cmd+Shift+F |
| Find in file | Cmd+F |
| Replace in file | Cmd+R |
| Go to line | Cmd+L |
| Arbre projet (ouvre/ferme) | Cmd+1 |
| Back / Forward | Cmd+[ / Cmd+] |

## Fenetres / terminal
| Action | Touche |
|---|---|
| Rotation fenetre suivante / precedente | Ctrl+Tab / Ctrl+Shift+Tab |
| Aller gauche / droite / bas / haut | Ctrl+H / Ctrl+L / Ctrl+J / Ctrl+K |
| Terminal flottant (ouvre/ferme) | Cmd+T |
| Terminal en bas, docke (ouvre/ferme) | Cmd+Shift+T |
| Dans un terminal : repasser en mode normal | Echap Echap |

## Navigation code
| Action | Touche |
|---|---|
| Go to declaration | Cmd+B |
| Go to implementation | Cmd+Shift+I |
| Go to type declaration | Ctrl+Shift+B |
| Find usages | Cmd+U |
| Parameter info | Cmd+P |
| Quick documentation | Cmd+J (ou laisse le curseur dessus) |
| File structure (symbols) | Cmd+7 |
| Go to symbol (projet) | Cmd+Shift+Y |

## Edition
| Action | Touche |
|---|---|
| Rename | Ctrl+Shift+R |
| Reformat code | Ctrl+Shift+L |
| Show intention actions (quick-fix) | Cmd+. |
| Comment line | Cmd+/ |
| Duplicate line | Cmd+D |
| Delete line | Cmd+Backspace |
| Move line | Ctrl+Shift+Haut / Bas |
| Selection multiple (occurrence suivante) | Ctrl+G |
| Save | Cmd+S |
| Undo / Redo | Cmd+Z / Cmd+Shift+Z |
| Select all | Cmd+A |
| Copy / Cut / Paste | Cmd+C / Cmd+X / Cmd+V |
| Probleme suivant / precedent | ]d / [d |
| Detail du probleme | Ctrl+Shift+D |

## Debug (Rust)
| Action | Touche |
|---|---|
| Run | Ctrl+R |
| Debug (lancer) | Ctrl+D |
| Continuer / resume | Ctrl+Shift+C |
| Point d'arret | Ctrl+B |
| Step over | Ctrl+Shift+O |
| Step into | Ctrl+Shift+N |
| Step out | Ctrl+Shift+U |
| Stop | Ctrl+Shift+Q |
(Build : utilise l'alias terminal `cb`, ou le terminal Cmd+T.)

## Confort (QoL)
| Fonction | Touche / comportement |
|---|---|
| Auto-save | automatique (plus besoin de Cmd+S) |
| Session | rouvre le projet la ou tu t'es arretee (auto) |
| Harpoon: epingler / menu / sauter | Ctrl+Shift+A / Ctrl+E / Ctrl+1..4 |
| Occurrences du symbole | s'allument seules ; suivant/precedent Cmd+G / Cmd+Shift+G |
| Remplacer dans tout le projet | Cmd+Shift+R |
| Presse-papier (apres avoir colle) | Ctrl+P (plus ancien) / Ctrl+N (plus recent) |
| Saut eclair (Flash) | tape `s` + 2 lettres -> teleporte |
| Replier / deplier | za · zR tout ouvrir · zM tout fermer · zK apercu |
| Sortir d'une (), {}, "" en tapant | Tab (Tabout) |
| Lazygit (commit/push/diff/branches) | Cmd+9 |
| Scrollbar a droite (erreurs/git/recherche) | automatique |
| Doc auto au survol : activer/desactiver | Espace u o |
| Markdown joli, cmdline flottante, brackets colores | automatique |

## Mode insertion
- jk ou jj -> Echap. Entrer en insertion : i a o.

## Le reste (Leader = Espace)
AstroNvim garde tout : "Espace g g" lazygit, "Espace f w" grep, "Espace e" arbre,
"Espace l" LSP, "Espace d" debug... Appuie sur Espace -> which-key affiche le menu.
