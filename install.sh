#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Interactive dotfiles installer.
#   ./install.sh          pick components + style interactively
#   ./install.sh --all    install everything, non-interactively
#   ./install.sh --help
#
# Safe to re-run (idempotent). Existing real files are backed up to *.bak.
# Works on a fresh macOS (bash 3.2 — no associative arrays used).
# Also works piped:  curl -fsSL <raw-url>/install.sh | bash   (self-clones).
# ─────────────────────────────────────────────────────────────────────────────
set -uo pipefail

REPO_URL="https://github.com/bugkill3r/dotfiles.git"
DOT="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || echo "")"

export HOMEBREW_NO_REQUIRE_TAP_TRUST=1

# ── colors / ui ──────────────────────────────────────────────────────────────
if [ -t 1 ]; then
  R=$'\e[0m'; B=$'\e[1m'; DIM=$'\e[2m'; GRN=$'\e[32m'; CYN=$'\e[36m'; YEL=$'\e[33m'; RED=$'\e[31m'
else R= B= DIM= GRN= CYN= YEL= RED=; fi
say()  { printf '%s\n' "$*"; }
step() { printf '\n%s==>%s %s\n' "$CYN$B" "$R" "$*"; }
ok()   { printf '  %s✓%s %s\n' "$GRN" "$R" "$*"; }
warn() { printf '  %s!%s %s\n' "$YEL" "$R" "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }
ask()  { local p="$1" v; printf '%s' "$p" >/dev/tty; IFS= read -r v </dev/tty || v=""; printf '%s' "$v"; }

# ── self-clone when run standalone (e.g. curl | bash) ────────────────────────
if [ -z "$DOT" ] || [ ! -f "$DOT/Brewfile" ]; then
  step "Fetching dotfiles"
  DOT="$HOME/Dev/dotfiles"
  if [ ! -d "$DOT/.git" ]; then
    have git || { xcode-select --install 2>/dev/null; echo "Install the Xcode Command Line Tools, then re-run."; exit 1; }
    git clone "$REPO_URL" "$DOT"
  fi
  exec bash "$DOT/install.sh" "$@"
fi

# ── dry-run plumbing ─────────────────────────────────────────────────────────
DRY=0                                    # --dry-run: print actions, change nothing
run() { if [ "$DRY" = 1 ]; then printf '  %s[dry]%s %s\n' "$DIM" "$R" "$*"; else "$@"; fi; }

# ── symlink helper (backs up existing real files) ────────────────────────────
link() {
  local src="$1" dst="$2"
  [ -e "$src" ] || { warn "missing in repo: $src (skipped)"; return 0; }
  if [ "$DRY" = 1 ]; then printf '  %s[dry]%s link %s\n' "$DIM" "$R" "$(printf '%s' "$dst" | sed "s|$HOME|~|")"; return 0; fi
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then mv "$dst" "$dst.bak"; say "  backed up $dst → $dst.bak"; fi
  ln -sfn "$src" "$dst" && ok "$(printf '%s' "$dst" | sed "s|$HOME|~|")"
}
brew_f() { [ "$DRY" = 1 ] && { printf '  %s[dry]%s brew install %s\n' "$DIM" "$R" "$*"; return 0; }; brew install "$@" || warn "some of: $* may have failed — continuing"; }
brew_c() { [ "$DRY" = 1 ] && { printf '  %s[dry]%s brew install --cask %s\n' "$DIM" "$R" "$*"; return 0; }; brew install --cask "$@" || warn "some casks: $* may have failed — continuing"; }

# ── component catalog:  key|label|default ────────────────────────────────────
COMPS=(
  "core|Core CLI  (bat, eza, fd, ripgrep, fzf, zoxide, gh, lazygit, tmux, sesh, btop…)|on"
  "shell|Zsh  (oh-my-zsh + fzf-tab + Starship prompt + .zshrc)|on"
  "terminal|Ghostty terminal + config|on"
  "editor|Neovim + lazy.nvim config|on"
  "wm|AeroSpace tiling WM + JankyBorders|on"
  "bar|Sketchybar menu bar  (needs AeroSpace + fonts)|on"
  "fonts|Nerd Fonts + sketchybar-app-font|on"
  "theming|Theme scripts  (theme · barstyle · gtheme)|on"
  "macos|macOS system defaults  (keyboard, finder, dock…)|off"
  "apps|GUI apps  (Raycast, OrbStack, Tailscale, Swish)|off"
)

SELECTED=""
for e in "${COMPS[@]}"; do
  IFS='|' read -r k l d <<<"$e"; [ "$d" = on ] && SELECTED="$SELECTED $k"
done
is_sel()  { case " $SELECTED " in *" $1 "*) return 0;; esac; return 1; }
add_sel() { is_sel "$1" || SELECTED="$SELECTED $1"; }
del_sel() { SELECTED=" $SELECTED "; SELECTED="${SELECTED// $1 / }"; SELECTED="$(echo $SELECTED)"; }
tog_sel() { is_sel "$1" && del_sel "$1" || add_sel "$1"; }

FLAVOR="mocha"; BARSTYLE="slab"

# ── interactive pickers ──────────────────────────────────────────────────────
pick_components() {
  while true; do
    printf '\n%sComponents%s  —  %snumber%s toggles · %sa%s all · %sn%s none · %sEnter%s continue\n\n' \
      "$B" "$R" "$B" "$R" "$B" "$R" "$B" "$R" "$B" "$R"
    local i=1
    for e in "${COMPS[@]}"; do
      IFS='|' read -r k l d <<<"$e"
      local m="[ ]"; is_sel "$k" && m="${GRN}[x]${R}"
      printf '  %2d) %s %s\n' "$i" "$m" "$l"; i=$((i+1))
    done
    local in; in="$(ask "$B> $R")"
    case "$in" in
      "") break ;;
      a|A) for e in "${COMPS[@]}"; do IFS='|' read -r k l d <<<"$e"; add_sel "$k"; done ;;
      n|N) SELECTED="" ;;
      ''|*[!0-9]*) : ;;
      *) if [ "$in" -ge 1 ] && [ "$in" -le "${#COMPS[@]}" ]; then
           IFS='|' read -r k l d <<<"${COMPS[$((in-1))]}"; tog_sel "$k"
         fi ;;
    esac
  done
}
pick_style() {
  local f; f="$(ask "${B}Theme flavor${R}  1) mocha  2) macchiato  3) frappe  4) latte  [1] > ")"
  case "$f" in 2) FLAVOR=macchiato;; 3) FLAVOR=frappe;; 4) FLAVOR=latte;; *) FLAVOR=mocha;; esac
  local b; b="$(ask "${B}Bar layout${R}    1) slab  2) islands  [1] > ")"
  case "$b" in 2) BARSTYLE=islands;; *) BARSTYLE=slab;; esac
}

# ── component installers ─────────────────────────────────────────────────────
i_core() {
  step "Core CLI"
  brew_f bat eza fd ripgrep fzf zoxide jq gh lazygit tree btop tmux sesh fastfetch
  link "$DOT/tmux/.tmux.conf" "$HOME/.tmux.conf"
  link "$DOT/btop"            "$HOME/.config/btop"
  [ -d "$HOME/.tmux/plugins/tpm" ] || run git clone -q https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  ok "tmux + tpm"
}
i_shell() {
  step "Zsh (oh-my-zsh + Starship)"
  brew_f starship
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    if [ "$DRY" = 1 ]; then run "install oh-my-zsh"; else
      RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" >/dev/null 2>&1 || true
    fi
  fi
  local zc="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  [ -d "$zc/plugins/fzf-tab" ] || run git clone -q https://github.com/Aloxaf/fzf-tab "$zc/plugins/fzf-tab"
  link "$DOT/.zshrc"                "$HOME/.zshrc"
  link "$DOT/.config/starship.toml" "$HOME/.config/starship.toml"
}
i_terminal() { step "Ghostty";  brew_c ghostty; link "$DOT/ghostty/config" "$HOME/.config/ghostty/config"; }
i_editor()   { step "Neovim";   brew_f neovim tree-sitter node; link "$DOT/nvim" "$HOME/.config/nvim"; link "$DOT/.vimrc" "$HOME/.vimrc"; }
i_wm() {
  step "AeroSpace + JankyBorders"
  brew_c nikitabobko/tap/aerospace
  brew_f felixkratz/formulae/borders
  link "$DOT/aerospace/aerospace.toml"  "$HOME/.aerospace.toml"
  link "$DOT/.config/borders/bordersrc" "$HOME/.config/borders/bordersrc"
  run brew services start borders
  run open -a AeroSpace
}
i_bar() {
  step "Sketchybar"
  brew_f felixkratz/formulae/sketchybar macmon
  link "$DOT/sketchybar" "$HOME/.config/sketchybar"
  if ! fc-list 2>/dev/null | grep -qi 'sketchybar-app'; then
    if [ "$DRY" = 1 ]; then run "fetch sketchybar-app-font.ttf → ~/Library/Fonts"; else
      mkdir -p "$HOME/Library/Fonts"
      curl -fsSL -o "$HOME/Library/Fonts/sketchybar-app-font.ttf" \
        "https://github.com/kvndrsslr/sketchybar-app-font/releases/latest/download/sketchybar-app-font.ttf" \
        && ok "sketchybar-app-font" || warn "could not fetch sketchybar-app-font"
    fi
  fi
  run brew services start sketchybar
}
i_fonts() {
  step "Fonts"
  brew_c font-caskaydia-cove-nerd-font font-jetbrains-mono-nerd-font \
         font-maple-mono-nf font-symbols-only-nerd-font
}
i_theming() {
  step "Bar/theme scripts → ~/.local/bin"
  [ "$DRY" = 1 ] || mkdir -p "$HOME/.local/bin"
  for s in theme barstyle barblur baropacity gtheme tmux-window-gradient.py; do
    link "$DOT/bin/$s" "$HOME/.local/bin/$s"
  done
  link "$DOT/.claude/statusline.py" "$HOME/.claude/statusline.py"
}
i_macos() { step "macOS defaults"; run bash "$DOT/macos.sh"; }
i_apps()  { step "GUI apps"; brew_c raycast orbstack tailscale-app swish; }

apply_style() {
  step "Style → $FLAVOR / $BARSTYLE"
  if [ "$DRY" = 1 ]; then
    run "write ~/.config/sketchybar-style=$BARSTYLE, catppuccin-flavor=$FLAVOR"
    run "theme $FLAVOR"; return 0
  fi
  mkdir -p "$HOME/.config"
  printf '%s\n' "$BARSTYLE" > "$HOME/.config/sketchybar-style"
  printf '%s\n' "$FLAVOR"   > "$HOME/.config/catppuccin-flavor"
  if [ -x "$DOT/bin/theme" ]; then "$DOT/bin/theme" "$FLAVOR" >/dev/null 2>&1 || true; ok "applied $FLAVOR"; fi
}

# ── main ─────────────────────────────────────────────────────────────────────
ALL=0
for a in "$@"; do
  case "$a" in
    -h|--help)    sed -n '3,10p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    --all)        ALL=1 ;;
    -n|--dry-run) DRY=1 ;;
    *) say "unknown option: $a  (try --help)"; exit 1 ;;
  esac
done
[ "$DRY" = 1 ] && step "DRY RUN — printing actions, nothing will be installed or changed"

step "Homebrew"
if ! have brew; then
  if [ "$DRY" = 1 ]; then run "install Homebrew"; else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi
if have brew; then ok "brew $(brew --version 2>/dev/null | head -1 | awk '{print $2}')"
elif [ "$DRY" != 1 ]; then say "${RED}Homebrew required${R}"; exit 1; fi

if [ "$ALL" = 1 ]; then
  SELECTED=""; for e in "${COMPS[@]}"; do IFS='|' read -r k l d <<<"$e"; SELECTED="$SELECTED $k"; done
else
  pick_components
  pick_style
fi

# dependency: the bar needs the window manager + fonts
if is_sel bar; then
  is_sel wm    || { add_sel wm;    warn "enabled AeroSpace (Sketchybar needs it)"; }
  is_sel fonts || { add_sel fonts; warn "enabled Fonts (Sketchybar needs the icon font)"; }
fi

printf '\n%sPlan%s: %s%s%s   style: %s%s / %s%s\n' "$B" "$R" "$GRN" "$(echo $SELECTED)" "$R" "$B" "$FLAVOR" "$BARSTYLE" "$R"
[ "$ALL" = 1 ] || { c="$(ask "Proceed? [Y/n] > ")"; case "$c" in n|N) echo "Aborted."; exit 0 ;; esac; }

is_sel core     && i_core
is_sel fonts    && i_fonts
is_sel shell    && i_shell
is_sel terminal && i_terminal
is_sel editor   && i_editor
is_sel wm       && i_wm
is_sel bar      && i_bar
is_sel theming  && i_theming
is_sel macos    && i_macos
is_sel apps     && i_apps
apply_style

cat <<EOF

$(step "Done")
  • Grant Accessibility to AeroSpace   (System Settings ▸ Privacy & Security ▸ Accessibility)
  • Start a new shell:                 exec zsh
  • tmux plugins:                      prefix + I
  • Neovim installs plugins on first launch (lazy.nvim)
  • Switch theme any time:             theme <mocha|macchiato|frappe|latte>
  • Switch bar layout:                 barstyle <slab|islands>

  Re-run anytime to add components. Install literally everything: ./install.sh --all
EOF
