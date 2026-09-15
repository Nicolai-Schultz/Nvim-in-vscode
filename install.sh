#!/usr/bin/env bash
# Sets up Neovim-in-VS Code on a Mac. Safe to re-run.
set -euo pipefail
cd "$(dirname "$0")"

VSCODE_USER="$HOME/Library/Application Support/Code/User"
NVIM_DIR="$HOME/.config/nvim"

echo "==> Homebrew packages"
brew install neovim fzf ripgrep bat
brew install --cask font-jetbrains-mono-nerd-font

echo "==> VS Code extensions"
while read -r ext; do
  [ -n "$ext" ] && code --install-extension "$ext" --force
done < vscode/extensions.txt

echo "==> Config files (symlinked so edits flow back into this repo)"
mkdir -p "$NVIM_DIR" "$VSCODE_USER"
for pair in "nvim/init.lua:$NVIM_DIR/init.lua" \
            "vscode/settings.json:$VSCODE_USER/settings.json" \
            "vscode/keybindings.json:$VSCODE_USER/keybindings.json"; do
  src="$PWD/${pair%%:*}"; dst="${pair#*:}"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then mv "$dst" "$dst.bak"; echo "   backed up $dst -> $dst.bak"; fi
  ln -sfn "$src" "$dst"
done

echo "==> macOS: let held keys repeat in VS Code (needed for hjkl)"
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

cat <<'MSG'

Done. Final manual steps in VS Code:
  1. Fully quit and reopen VS Code (Cmd+Q) so the new font is picked up.
  2. Cmd+Shift+P -> "Custom UI Style: Reload" -> restart when prompted.
     Repeat this after every VS Code update.
  3. If a "installation appears to be corrupt" notice shows, gear -> Don't show again.
MSG
