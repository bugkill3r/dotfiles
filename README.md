# dotfiles

A cohesive, theme-aware macOS (Apple Silicon) setup — tiling WM, a custom menu
bar, terminal, editor and shell that all follow **one** Catppuccin flavor.

## Install

**One-liner** (clones to `~/Dev/dotfiles`, then runs the interactive installer):

```sh
curl -fsSL https://raw.githubusercontent.com/bugkill3r/dotfiles/master/install.sh | bash
```

**Or clone and run:**

```sh
git clone https://github.com/bugkill3r/dotfiles ~/Dev/dotfiles
cd ~/Dev/dotfiles
./install.sh            # interactive: pick components + style
./install.sh --all      # everything, non-interactively
./install.sh --dry-run  # preview every action, change nothing (pairs with --all)
./install.sh --help
```

The installer is idempotent (re-run it any time to add components), backs up any
existing real config to `*.bak`, and works on a fresh macOS (bash 3.2). It:

1. installs Homebrew if missing,
2. lets you **multi-select components** and **pick a style**,
3. installs each group's packages, symlinks its configs, starts its services,
4. applies your chosen flavor + bar layout.

### Components

| Group      | What it installs |
|------------|------------------|
| `core`     | bat, eza, fd, ripgrep, fzf, zoxide, gh, lazygit, tmux (+ tpm), sesh, btop, … |
| `shell`    | zsh — oh-my-zsh + fzf-tab + Starship + `.zshrc` |
| `terminal` | Ghostty + config |
| `editor`   | Neovim + lazy.nvim config |
| `wm`       | AeroSpace tiling WM + JankyBorders |
| `bar`      | Sketchybar menu bar (auto-enables `wm` + `fonts`) |
| `fonts`    | Nerd Fonts + `sketchybar-app-font` |
| `theming`  | `theme` / `barstyle` / `gtheme` scripts → `~/.local/bin` |
| `macos`    | macOS system defaults (keyboard, Finder, Dock …) |
| `apps`     | Raycast, OrbStack, Tailscale, Swish |

`Brewfile` is the full package manifest (`brew bundle`), including GUI apps, Mac
App Store apps and VS Code extensions.

## Style

Everything follows one command. Switch the **theme** (Ghostty, tmux, Sketchybar,
btop, yazi, bat, nvim, borders all recolor together):

```sh
theme                 # fzf picker with live preview
theme macchiato       # or: mocha | frappe | latte
```

Tune the **menu bar** — all live, no restart:

```sh
barstyle              # toggle layout
barstyle slab         # one floating frosted bar
barstyle islands      # two bars flanking the notch

barblur               # toggle frost
barblur frost         # frosted glass (blur)
barblur clear         # clear transparency (no blur)

baropacity 60         # bar tint opacity, 0–100
```

## AeroSpace keys (`alt` = modifier)

| Key | Action |
|-----|--------|
| `alt` + `1…9` | focus workspace |
| `alt` + `shift` + `1…9` | move window to workspace |
| `alt` + `hjkl` | focus window |
| `alt` + `shift` + `hjkl` | move window |
| `alt` + `enter` | open Ghostty |
| `alt` + `f` | fullscreen (zoom) |
| `alt` + `-` / `=` | resize |
| `alt` + `shift` + `;` | service mode (reset / float / join) |

Dedicated workspaces: 1 Cursor · 2 Obsidian · 3 Chrome (external monitor) ·
4 Ghostty · 5 Claude · 6 Safari · 7 zoom.

## Post-install

- Grant **Accessibility** to AeroSpace (System Settings ▸ Privacy & Security).
- `exec zsh` for a fresh shell.
- In tmux: `prefix + I` to install plugins.
- Neovim installs plugins on first launch.
