# dotfiles

Personal dotfiles for Manjaro/Arch Linux, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's included

| Module | Tool | Notes |
|---|---|---|
| `zsh` | Zsh + [Zinit](https://github.com/zdharma-continuum/zinit) | Autosuggestions, syntax highlighting, fzf-tab, history search |
| `kitty` | [Kitty](https://sw.kovidgoyal.net/kitty/) | Split panes, powerline tabs, Catppuccin Mocha |
| `starship` | [Starship](https://starship.rs/) | Two-line prompt, git status, language versions, time |
| `bat` | [bat](https://github.com/sharkdp/bat) | Replaces `cat`, Catppuccin Mocha theme |
| `ripgrep` | [ripgrep](https://github.com/BurntSushi/ripgrep) | Smart-case, searches hidden files, common dirs excluded |
| `mise` | [mise](https://mise.jdx.dev/) | Node LTS + Python 3.12 globally |
| `git` | Git | Global `.gitignore` |

All configs use [Catppuccin Mocha](https://github.com/catppuccin/catppuccin) as the color scheme.

## Quick start

```bash
git clone https://github.com/neero0x01/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash bootstrap.sh
```

`bootstrap.sh` will:
1. Install all required packages via `pacman`
2. Install mise, sdkman, and starship
3. Apply performance sysctl tweaks and configure Timeshift snapshots
4. Symlink all configs with `stow`

> **Note:** This script is written for Manjaro/Arch. Don't run it on other distros without reviewing it first.

## Manual setup

If you only want specific configs, stow individual modules:

```bash
cd ~/dotfiles
stow zsh        # ~/.zshrc
stow kitty      # ~/.config/kitty/
stow starship   # ~/.config/starship.toml
stow bat        # ~/.config/bat/
stow ripgrep    # ~/.config/ripgrep/
stow mise       # ~/.config/mise/
stow git        # ~/.config/git/ignore
```

To remove a symlink:

```bash
stow -D zsh
```

## Shell features

**Plugins (via Zinit)**
- `zsh-autosuggestions` — ghost-text completions from history
- `fast-syntax-highlighting` — realtime command highlighting
- `zsh-history-substring-search` — `↑`/`↓` or `^P`/`^N` to search history by prefix
- `fzf-tab` — `Tab` opens an fzf picker for completions

**Key bindings**
| Key | Action |
|---|---|
| `Tab` | fzf completion picker |
| `Ctrl+R` | fzf history search |
| `Ctrl+T` | fzf file picker |
| `Alt+C` | fzf directory jump |
| `↑` / `^P` | History substring search up |
| `↓` / `^N` | History substring search down |

**Aliases**
```
ls / ll / la / lt / l   → eza with icons and git status
cat                     → bat (syntax highlighted)
catt                    → real cat (bypass bat)
lg                      → lazygit
cd                      → zoxide (smart directory jump)
sysupdate               → timeshift snapshot + pacman -Syu
```

## Kitty features

- **Splits:** `Ctrl+Shift+D` (vertical) / `Ctrl+Shift+E` (horizontal)
- **Navigate splits:** `Ctrl+Shift+H/J/K/L`
- **Zoom pane:** `Ctrl+Shift+Z` (toggle fullscreen for current split)
- **Cycle layouts:** `Ctrl+Shift+Space`
- **New tab:** `Ctrl+Shift+T` | **Close tab:** `Ctrl+Shift+W`
- **Switch tabs:** `Ctrl+Alt+1–5`
- **Font size:** `Ctrl+=` / `Ctrl+-` / `Ctrl+Shift+Backspace` (reset)

## Runtime versions

Managed by mise (`~/.config/mise/config.toml`). Override per project with a local `.mise.toml`.

```
node    → LTS
python  → 3.12
java    → install manually: sdk install java 21-tem
```
