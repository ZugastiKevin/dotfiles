# Kit de survie Neovim (le temps de s'adapter)

Touches : Ctrl, Cmd, Alt, Shift. Ex : "Cmd+Shift+O" = les 3 ensemble.

## 1. Le reflexe vital (modal)
| Tu veux... | Touche |
|---|---|
| Ecrire du texte | i (insere) ou o (nouvelle ligne) |
| Arreter d'ecrire (mode normal) | jk (ou Echap) |
| Sauvegarder | Cmd+S |
| Annuler / refaire | Cmd+Z / Cmd+Shift+Z |
| Fermer l'onglet | :q puis Entree |
| Quitter Neovim | :qa puis Entree |

Regle d'or : les raccourcis Cmd marchent en MODE NORMAL. Si une touche fait un
truc bizarre, appuie i pour ecrire, jk pour ressortir.

## 1bis. Deplacement rapide aux fleches (Mac/IDE)
| Tu veux... | Touche |
|---|---|
| Mot precedent / suivant | Ctrl+Gauche / Ctrl+Droite |
| Debut / fin de ligne | Cmd+Gauche / Cmd+Droite |
| Debut / fin du fichier | Cmd+Haut / Cmd+Bas |
| SELECTIONNER en bougeant | ajoute Shift (Shift+fleche, Shift+Ctrl+fleche, Shift+Cmd+fleche) |
| Supprimer le mot precedent | Ctrl+Backspace |

(Option/⌥ ne marche pas sur ton Mac -> j'utilise Ctrl pour le saut de mot.)

## 2. Naviguer (comme RustRover)
| Action | Touche |
|---|---|
| Ouvrir un fichier | Cmd+Shift+O |
| Fichiers recents | Cmd+E |
| Chercher dans le projet | Cmd+Shift+F |
| Aller a la definition | Cmd+B |
| Revenir / avancer | Cmd+[ / Cmd+] |
| Arbre fichiers | Cmd+1 |
| Rotation fenetre suivante / precedente | Ctrl+Tab / Ctrl+Shift+Tab |
| Aller a la fenetre de gauche (arbre) | Ctrl+H |
| Aller a la fenetre de droite (code) | Ctrl+L |
| Aller a la fenetre du bas (terminal) | Ctrl+J |
| Aller a la fenetre du haut | Ctrl+K |
| Terminal flottant (ouvre/ferme) | Cmd+T |
| Terminal en bas, docke (ouvre/ferme) | Cmd+Shift+T |
| Dans un terminal : repasser en mode normal | Echap Echap |

## 3. Editer
| Action | Touche |
|---|---|
| Renommer | Ctrl+Shift+R |
| Reformater | Ctrl+Shift+L |
| Commenter | Cmd+/ |
| Action / quick-fix | Cmd+. |
| Dupliquer ligne | Cmd+D |
| Supprimer ligne | Cmd+Backspace |
| Selection multiple (occurrence suivante) | Ctrl+G |
| Tout selectionner | Cmd+A |
| Doc fonction | curseur dessus (auto) ou Cmd+J |

## 4. Run / Debug
| Action | Touche |
|---|---|
| Run | Ctrl+R |
| Debug (lancer) | Ctrl+D |
| Continuer / resume | Ctrl+Shift+C |
| Point d'arret | Ctrl+B |
| Step over / into / out | Ctrl+Shift+O / Ctrl+Shift+N / Ctrl+Shift+U |
| Stop | Ctrl+Shift+Q |
| Renommer | Ctrl+Shift+R |
| Probleme suivant / precedent | ]d / [d |

## 4bis. Confort (QoL)
- **Auto-save** : ca sauve tout seul, oublie Cmd+S.
- **Session** : rouvre un projet -> il recharge tes fichiers la ou tu etais.
- **Harpoon** (fichiers epingles) : Ctrl+Shift+A epingle · Ctrl+E menu · Ctrl+1..4 saute.
- **Occurrences** : pose le curseur sur un mot -> toutes ses utilisations s'allument. Cmd+G / Cmd+Shift+G pour sauter.
- **Remplacer dans le projet** : Cmd+Shift+R.
- **Presse-papier** : apres avoir colle, Ctrl+P (plus ancien) / Ctrl+N (plus recent).
- **Saut eclair** : tape `s` + 2 lettres -> le curseur teleporte sur le mot.
- **Replier le code** : `za` (sous le curseur) · `zR` tout ouvrir · `zM` tout fermer · `zK` apercu. (fleches de repli dans la marge gauche)
- **Tabout** : `Tab` pour sortir d'une parenthese/accolade/guillemet quand tu tapes.
- Auto : cmdline flottante (Noice), brackets colores, erreurs en bout de ligne.

## 5. Bonus Vim (mode normal)
- dd couper ligne · yy copier ligne · p coller
- gg haut · G bas · :50 aller ligne 50
- /mot chercher · n suivant
- Espace seule -> menu which-key (appuie et attends)

Liste complete : voir KEYMAP.md
