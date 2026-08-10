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

# terminal shaders are opt-in — never enabled by default, not even with --all
./install.sh --shaders                  # enable the default (cursor_tail)
./install.sh --shader ripple_cursor     # enable a specific one
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

## Terminal shaders (opt-in)

47 GLSL shaders live in `ghostty/shaders/`. **Nothing is enabled by default** —
they redraw the terminal and cost GPU/battery, so you turn one on deliberately.

```sh
shader                # list them all, marking the active one
shader cursor_tail    # enable one (reloads Ghostty automatically)
shader next / prev    # cycle, to compare quickly
shader off            # disable
```

When each one costs you:

| Uses | Redraws | Examples |
|------|---------|----------|
| `iCurrentCursor` + `iTimeCursorChange` | only for ~0.2s after the cursor moves — idle otherwise | every `cursor_*` |
| `iChannel0` only | when screen content changes | `bloom`, `bettercrt` |
| `iTime` | continuously while the window is focused — the real battery cost | `galaxy`, `water`, `fireworks` |

Ghostty's own `custom-shader-animation` is `true`, so an **unfocused window never
animates**. Set it to `always` to animate unfocused too (much more expensive).

## Maintenance

```sh
doctor                       # health check: config drift, untracked-but-referenced
                             # files, pane geometry, services, theme, toolchain

tmux-claude-sessions save    # map each tmux pane -> the Claude conversation in it
tmux-claude-sessions restore # resume them in place after a reboot (waits for
                             # tmux-resurrect to recreate the panes first)
tmux-fix-pane-sizes          # re-fit panes taller than their window (runs
                             # automatically after every resurrect restore)

tests/smoke-tmux-restore.sh  # end-to-end save/restore test on an isolated
                             # tmux server — never touches real sessions
```

After a reboot: start tmux (continuum restores the layout automatically), then
`tmux-claude-sessions restore` to bring the conversations back.

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
