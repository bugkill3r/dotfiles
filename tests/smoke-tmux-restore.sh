#!/usr/bin/env bash
# End-to-end smoke test of the save/restore chain on an ISOLATED tmux server.
# TMUX_TMPDIR gives us a private server socket, and @resurrect-dir a private
# save dir, so the real sessions and real resurrect state are never touched.
set -uo pipefail

SM=/tmp/cc-smoke
RD=$SM/resurrect
REAL_STATE="$HOME/.local/share/tmux/claude-sessions.json"
BACKUP=/tmp/cc-smoke-claude-state.bak
PLUG="$HOME/.tmux/plugins/tmux-resurrect/scripts"
SPDIR="$(cd "$(dirname "$0")" && pwd)"

pass=0; fail=0
ok(){ printf '  \033[32m✓\033[0m %s\n' "$1"; pass=$((pass+1)); }
no(){ printf '  \033[31m✗\033[0m %s\n' "$1"; fail=$((fail+1)); }
hdr(){ printf '\n\033[1m%s\033[0m\n' "$1"; }

# --- isolate -----------------------------------------------------------------
rm -rf "$SM"; mkdir -p "$RD"
export TMUX_TMPDIR="$SM"
unset TMUX                      # don't inherit the outer session
[ -f "$REAL_STATE" ] && cp "$REAL_STATE" "$BACKUP"

cleanup() {
  tmux kill-server 2>/dev/null
  [ -f "$BACKUP" ] && cp "$BACKUP" "$REAL_STATE"
  rm -rf "$SM" "$BACKUP"
}
trap cleanup EXIT

hdr "1. build an isolated session"
tmux new-session -d -s smoke -c /tmp -x 120 -y 40 2>/dev/null
tmux new-window  -t smoke -c "$HOME/Dev/dotfiles" 2>/dev/null
tmux new-window  -t smoke -c "$HOME/.config" 2>/dev/null
tmux split-window -t smoke:3 -c /usr/local 2>/dev/null
tmux send-keys -t smoke:1.1 "# marker-one" C-m 2>/dev/null
sleep 6   # let shells finish starting before we snapshot
W=$(tmux list-windows -t smoke 2>/dev/null | wc -l | tr -d ' ')
P=$(tmux list-panes -a 2>/dev/null | wc -l | tr -d ' ')
[ "$W" = "3" ] && ok "3 windows created" || no "expected 3 windows, got $W"
[ "$P" = "4" ] && ok "4 panes created"   || no "expected 4 panes, got $P"
echo "     server socket: $(tmux display-message -p '#{socket_path}' 2>/dev/null)"

hdr "2. configure + SAVE"
tmux set -g @resurrect-dir "$RD"
# CRITICAL: the isolated server loads ~/.tmux.conf, whose post-save hook runs
# saved 11 Claude pane(s) -> /Users/saurabh/.local/share/tmux/claude-sessions.json. Left enabled it would overwrite the REAL claude
# session map with this empty test server's panes. Disable it here.
tmux set -gu @resurrect-hook-post-save-all
tmux set -g @resurrect-capture-pane-contents 'on'
tmux set -g @resurrect-hook-post-restore-all 'tmux-fix-pane-sizes >/dev/null 2>&1 || true'
"$PLUG/save.sh" >/dev/null 2>&1
sleep 1
SAVES=$(ls "$RD"/tmux_resurrect_*.txt 2>/dev/null | wc -l | tr -d ' ')
[ "$SAVES" -ge 1 ] && ok "save file written to isolated dir" || no "no save file created"
LASTF=$(ls -t "$RD"/tmux_resurrect_*.txt 2>/dev/null | head -1)
SP=$(grep -c '^pane' "$LASTF" 2>/dev/null || echo 0)
[ "$SP" = "4" ] && ok "4 panes recorded in save" || no "save recorded $SP panes (want 4)"
grep -q 'dotfiles' "$LASTF" && ok "working directories captured" || no "cwds missing from save"
CONT=$(ls "$RD"/pane_contents* 2>/dev/null | wc -l | tr -d ' ')
[ "$CONT" -ge 1 ] && ok "pane contents archived" || no "pane contents NOT archived"
[ -L "$RD/last" ] && ok "'last' symlink points at newest save" || no "'last' symlink missing"

hdr "3. simulate reboot (kill the whole server)"
tmux kill-server 2>/dev/null; sleep 1
if tmux list-sessions >/dev/null 2>&1; then no "server still alive"; else ok "server gone — state destroyed"; fi

hdr "4. restore-race guard: restore with NO server running"
OUT=$(tmux-claude-sessions restore 2>&1)
if echo "$OUT" | grep -qi "server isn't running"; then ok "clear error instead of a crash"
else no "unexpected output: $(echo "$OUT" | head -1)"; fi

hdr "5. RESTORE"
tmux new-session -d -s placeholder 2>/dev/null   # resurrect needs a live server
tmux set -g @resurrect-dir "$RD"
# resurrect's restore requires an ATTACHED client (normally provided by
# continuum firing on attach), so give it a real pty-backed one.
python3 "$SPDIR/pty_client.py" placeholder 30 >/dev/null 2>&1 &
PTY=$!; sleep 3
CLIENTS=$(tmux list-clients 2>/dev/null | wc -l | tr -d ' ')
[ "$CLIENTS" -ge 1 ] && ok "pty client attached" || no "no client attached"
# invoke exactly as continuum does: inside tmux, so $TMUX (and therefore
# resurrect's socket lookup) is set.
tmux run-shell "$PLUG/restore.sh" >/dev/null 2>&1
sleep 5
if tmux has-session -t smoke 2>/dev/null; then ok "session 'smoke' restored"; else no "session NOT restored"; fi
W2=$(tmux list-windows -t smoke 2>/dev/null | wc -l | tr -d ' ')
P2=$(tmux list-panes -s -t smoke 2>/dev/null | wc -l | tr -d ' ')
[ "$W2" = "3" ] && ok "all 3 windows back" || no "restored $W2 windows (want 3)"
[ "$P2" = "4" ] && ok "all 4 panes back"   || no "restored $P2 panes (want 4)"
tmux list-panes -s -t smoke -F '#{pane_current_path}' 2>/dev/null | grep -q 'dotfiles' \
  && ok "working directory restored" || no "cwd NOT restored"
tmux capture-pane -p -t smoke:1.1 2>/dev/null | grep -q 'marker-one' \
  && ok "scrollback restored (pane contents)" || no "scrollback NOT restored"

hdr "6. geometry invariant after restore"
MM=$(tmux list-panes -a -F '#{pane_height} #{window_height}' 2>/dev/null | awk '$1 > $2' | wc -l | tr -d ' ')
[ "$MM" = "0" ] && ok "no pane taller than its window" || no "$MM pane(s) with bad geometry"
tmux-fix-pane-sizes >/dev/null 2>&1 && ok "fixer runs clean against restored layout" || no "fixer errored"

printf '\n\033[1m%d passed, %d failed\033[0m\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
