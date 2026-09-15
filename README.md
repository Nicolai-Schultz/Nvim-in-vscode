# Nvim-in-vscode

VS Code configured to look and feel like Neovim: [vscode-neovim](https://github.com/vscode-neovim/vscode-neovim)
for real Neovim editing, fzf/ripgrep pickers, a stripped UI, and Vim keys in the file explorer.

## Install (macOS)

```bash
git clone https://github.com/Nicolai-Schultz/Nvim-in-vscode.git
cd Nvim-in-vscode && ./install.sh
```

The script installs Homebrew deps (neovim, fzf, ripgrep, bat, JetBrains Mono Nerd Font), the VS Code
extensions, and symlinks the config files into place (existing files are backed up as `*.bak`).

## Layout

| Path | Goes to |
|---|---|
| `nvim/init.lua` | `~/.config/nvim/init.lua` — lazy.nvim, plugins, VS Code keymaps |
| `vscode/settings.json` | VS Code user settings — theme, stripped UI, Custom UI Style CSS |
| `vscode/keybindings.json` | Vim keys for the file explorer |
| `vscode/extensions.txt` | extensions to install |

## Keys

Leader is `Space`.

| Editor (normal mode) | |
|---|---|
| `<Space><Space>` | VS Code quick open |
| `<Space>ff` / `fg` | fzf find files / grep |
| `<Space>fr` / `fc` / `ft` | resume search / git-changed files / TODOs |
| `<Space>fs` | go to symbol |
| `<Space>e` | toggle explorer |
| `<Space>o` / `r` | open folder / open recent |
| `<Space>F` | fullscreen (drops the 25px top padding) |
| `:PadOn` / `:PadOff` | fix padding manually |
| `s` / `S` | flash.nvim jump / treesitter select |

| Explorer | |
|---|---|
| `j` `k` `h` `l` | move / collapse / expand-open |
| `gg` `G` `Ctrl-d` `Ctrl-u` `H` | top / bottom / page / collapse all |
| `a` `A` `r` `d` | new file / folder / rename / delete |
| `y` `x` `p` `Y` | copy / cut / paste / copy path |
| `/` | filter |
| `q` `Esc` | back to editor |

Plugins (via lazy.nvim, auto-installed on first start): nvim-surround, mini.ai, flash.nvim.

## Notes

- Custom UI Style patches VS Code's core files for the hidden title bar and CSS. Re-run
  **Custom UI Style: Reload** after each VS Code update; **Rollback** restores stock files.
- `Cmd+B` toggles the sidebar, `Cmd+J` the panel — the activity bar is hidden so these matter.
