#!/usr/bin/env bash
set -euo pipefail

REPO="git@git.gay:CatAnnaDev/nvim-config.git"
CONFIG="$HOME/.config/nvim"

echo "==> Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi
if [ -x /usr/local/bin/brew ]; then eval "$(/usr/local/bin/brew shellenv)"; fi

echo "==> Paquets et police"
brew install neovim ripgrep fd lazygit
brew install --cask neovide font-jetbrains-mono-nerd-font || true
brew install imagemagick ghostscript tectonic || true

echo "==> rust-analyzer (composant rustup)"
if command -v rustup >/dev/null 2>&1; then rustup component add rust-analyzer || true; fi

echo "==> Mermaid (rendu markdown, optionnel)"
if command -v npm >/dev/null 2>&1; then npm install -g @mermaid-js/mermaid-cli || true; fi

echo "==> Config Neovim"
if [ -d "$CONFIG" ] && [ ! -d "$CONFIG/.git" ]; then
  mv "$CONFIG" "$CONFIG.bak.$(date +%s)"
fi
if [ -d "$CONFIG/.git" ]; then
  git -C "$CONFIG" pull --ff-only || true
else
  git clone "$REPO" "$CONFIG"
fi

echo "==> Plugins (Lazy sync)"
nvim --headless "+Lazy! sync" +qa || true

echo "==> Serveurs LSP / debug / formatters (Mason)"
nvim --headless "+MasonInstall clangd jdtls csharpier basedpyright black isort debugpy java-debug-adapter java-test asm-lsp codelldb netcoredbg roslyn glsl_analyzer wgsl-analyzer slang lua-language-server stylua clang-format tree-sitter-cli" +qa || true

echo "==> macOS: liberer Ctrl+fleches (sinon = changement de bureau)"
if [[ "$OSTYPE" == darwin* ]]; then
  for id in 79 80 81 82; do
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$id" '<dict><key>enabled</key><false/></dict>' || true
  done
  /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u 2>/dev/null || true
fi

echo ""
echo "==> Termine ! Lance:  neovide"
echo "    Langages a installer toi-meme si besoin: JDK (java), dotnet (C#), Xcode/CLT (swift), node (js)."
