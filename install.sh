#!/usr/bin/env bash
# Bootstrap a machine from this dotfiles repo:
#   1) Homebrew + all packages (Brewfile)
#   2) symlink configs into place
#   3) start services
# Safe to re-run (idempotent). Existing files are backed up to *.bak.
set -uo pipefail
DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
echo "==> Packages (Brewfile)"
HOMEBREW_NO_REQUIRE_TAP_TRUST=1 brew bundle --file="$DOT/Brewfile" || true

echo "==> Symlinks"
link() {
  mkdir -p "$(dirname "$2")"
  [ -e "$2" ] && [ ! -L "$2" ] && mv "$2" "$2.bak" && echo "  backed up $2 → $2.bak"
  ln -sfn "$1" "$2" && echo "  $2 → $1"
}

# ~ dotfiles
link "$DOT/.zshrc"                    "$HOME/.zshrc"
link "$DOT/.vimrc"                    "$HOME/.vimrc"
link "$DOT/tmux/.tmux.conf"           "$HOME/.tmux.conf"
link "$DOT/aerospace/aerospace.toml"  "$HOME/.aerospace.toml"

# ~/.config app dirs
link "$DOT/nvim"                      "$HOME/.config/nvim"
link "$DOT/sketchybar"                "$HOME/.config/sketchybar"
link "$DOT/btop"                      "$HOME/.config/btop"
link "$DOT/alacritty"                 "$HOME/.config/alacritty"

# single-file / partial configs
mkdir -p "$HOME/.config/ghostty"
link "$DOT/ghostty/config"            "$HOME/.config/ghostty/config"
link "$DOT/.config/starship.toml"     "$HOME/.config/starship.toml"
mkdir -p "$HOME/.config/borders"
link "$DOT/.config/borders/bordersrc" "$HOME/.config/borders/bordersrc"
mkdir -p "$HOME/.claude"
link "$DOT/.claude/statusline.py"     "$HOME/.claude/statusline.py"

echo "==> tmux plugin manager (tpm)"
[ -d "$HOME/.tmux/plugins/tpm" ] || git clone -q https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

echo "==> macOS defaults"
bash "$DOT/macos.sh" || true

echo "==> Services"
for svc in sketchybar borders; do
  HOMEBREW_NO_REQUIRE_TAP_TRUST=1 brew services start "$svc" 2>/dev/null || true
done
open -a AeroSpace 2>/dev/null || true

cat <<'EOF'

==> Done.
Next steps:
  • Grant Accessibility to AeroSpace on first launch
  • Open a new shell:  exec zsh
  • In tmux, install plugins:  prefix + I
  • nvim will install plugins on first launch (lazy.nvim)
EOF
