# Neovim = RustRover — antiseche (keymap fidele)

Lancer : `neovide <dossier>` (GUI). Leader = Espace (raccourcis AstroNvim par defaut OK).
Touches : Ctrl, Cmd, Shift. Aucune touche F (elles demandent Fn sur Mac) -> tout sur Cmd/Ctrl.
Antiseche integree : Espace ? (contextuelle au fichier) · Espace m (deplacements) · :KeyStats (mes touches les plus utilisees)

## L'essentiel (le quotidien)
| Action | Touche |
|---|---|
| Sauvegarder (auto-save actif) | Cmd+S |
| Ouvrir un fichier / recents | Cmd+O / Cmd+E |
| Chercher dans le projet | Cmd+Shift+F |
| Chercher dans le fichier | Cmd+F |
| Arbre projet | Cmd+1 |
| Run / Debug / Point d'arret | Espace r r · Espace r d · Espace r b |
| Taches build (Overseer) | Espace o r |
| Terminal flottant | Cmd+T |
| Lazygit | Cmd+9 |
| Claude Code | Cmd+I (ou Espace a -> menu) |
| Aller a la definition / usages | Cmd+B / Cmd+U |
| Renommer / quick-fix | Ctrl+Shift+R / Cmd+. |
| Commenter | Cmd+/ |
| Probleme suivant / precedent | ]d / [d |
| Panneau d'erreurs | Espace x x |
| Historique d'annulation | Espace f u |
| Sortir du mode insertion | jk (ou Echap) |
| Mes raccourcis (antiseche) | Espace ? |

## Deplacement aux fleches (Mac/IDE)
| Action | Touche |
|---|---|
| Mot precedent / suivant | Ctrl+Gauche / Ctrl+Droite (ou Alt) |
| Bloc / paragraphe precedent / suivant | Alt+Haut / Alt+Bas |
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
| Reprendre la derniere recherche | Cmd+Shift+E |

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
| Fil d'ariane (breadcrumbs) | Espace ; |

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
| Refactor (selection visuelle) | Espace r e extraire fonction · r v extraire variable · r i inline |
| Print de debug | g?v variable · g?p texte · g?d supprime tout · g?t commente/decommente |
| Entourer (surround) | ys + mouvement + caractere · en visuel : S · ds supprime · cs change |
| Screenshot du code (selection) | Espace c s presse-papier · Espace c S fichier |

## Run / Debug
| Action | Touche |
|---|---|
| Run | Espace r r |
| Debug (lancer) | Espace r d |
| Continuer / resume | Ctrl+Shift+C |
| Point d'arret | Espace r b |
| Step over | Ctrl+Shift+O |
| Step into | Ctrl+Shift+N |
| Step out | Ctrl+Shift+U |
| Stop | Ctrl+Shift+Q |
| Run / Debug (C, C++, Obj-C) | Ctrl+R / Ctrl+D |
| Java : run-debug main / relancer dernier debug | Ctrl+R / Ctrl+D |
| Taches Overseer | Espace o o panneau · o r lancer · o b tache shell · o a action · o l relancer la derniere |
| Swift : run (Package.swift ou fichier) | Espace r r (debug Swift non cable) |
(Build : utilise l'alias terminal `cb`, ou le terminal Cmd+T.)

## IA / Outils
| Action | Touche |
|---|---|
| Claude Code : ouvrir/fermer | Cmd+I (normal, visuel, terminal) |
| Claude Code : menu complet | Espace a (resume, continue, modele, diff...) |
| Envoyer la selection a Claude | Espace a s (visuel) |
| Base de donnees (DBUI) | Espace D |
| Requetes HTTP (.http) | Espace H -> menu · Hs envoyer · Ha toutes · Hr rejouer |
| Generer la doc (Doxygen/Javadoc) | Espace l n |

## Confort (QoL)
| Fonction | Touche / comportement |
|---|---|
| Auto-save | automatique (plus besoin de Cmd+S) |
| Session | rouvre le projet la ou tu t'es arretee (auto) |
| Occurrences du symbole | s'allument seules ; suivant/precedent Cmd+G / Cmd+Shift+G |
| Remplacer dans tout le projet | Cmd+Shift+R |
| Presse-papier (apres avoir colle) | [y (plus ancien) / ]y (plus recent) · Espace f y liste |
| Saut eclair (Flash) | tape `s` + 2 lettres -> teleporte |
| Zoom (Neovide) | Cmd+= / Cmd+- / Cmd+0 reset |
| Replier / deplier | za · zR tout ouvrir · zM tout fermer · zK apercu |
| Sortir d'une (), {}, "" en tapant | Tab (Tabout) |
| Lazygit (commit/push/diff/branches) | Cmd+9 |
| Scrollbar a droite (erreurs/git/recherche) | automatique |
| Doc auto au survol : activer/desactiver | Espace u o |
| Redimensionner la fenetre | Cmd+Shift+H/J/K/L |
| Twilight (focus, assombrit le reste) | Espace u T |
| Quickfix avec apercu (nvim-bqf) | automatique dans la quickfix |
| Markdown joli, cmdline flottante, brackets colores | automatique |
| Antiseche contextuelle | Espace ? (ou Cmd+?) · Espace m deplacements |
| Mes touches les plus utilisees | :KeyStats (:KeyStatsReset remet a zero) |
| Animations on/off (curseur, scroll...) | Espace U -> menu · Espace U a vue d'ensemble |
| Theme girly | Espace u G |
| Historique du presse-papier | Espace f y |

## Mode insertion
- jk ou jj -> Echap. Entrer en insertion : i a o.

## Le reste (Leader = Espace)
AstroNvim garde tout : "Espace g g" lazygit, "Espace f w" grep, "Espace e" arbre,
"Espace l" LSP, "Espace d" debug, "Espace o" taches Overseer, "Espace ?" antiseche.
Appuie sur Espace -> which-key affiche le menu.
Note : Espace o ne focus plus l'explorateur (c'est le groupe Overseer) — l'arbre reste sur Cmd+1 / Espace e.
