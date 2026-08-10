#!/bin/bash
# Ghostty title-bar shimmer via the OSC 9;4 progress indicator.
#
# Runs from two places with very different environments:
#   • Claude Code hooks — no usable controlling terminal, and a minimal PATH
#     that does NOT include /opt/homebrew/bin (so `tmux` is not findable)
#   • tmux run-shell    — no tty either
# so it resolves tmux by absolute path and falls back to the attached client's
# terminal when /dev/tty can't be written.
#
# NOTE: `[ -w /dev/tty ]` is not a reliable test — /dev/tty can exist and look
# writable while being "Device not configured". The write itself is the test.
cat > /dev/null 2>/dev/null   # drain hook stdin so Claude doesn't block

action="${1:-start}"
case "$action" in
  start) osc="9;4;3;0"; bell=1 ;;   # progress shimmer + BEL (bell-features=border)
  stop)  osc="9;4;0;0"; bell=0 ;;   # clear
  *)     exit 0 ;;
esac

# Hooks get a minimal PATH; find tmux regardless.
TMUX_BIN=$(command -v tmux 2>/dev/null)
[ -x "$TMUX_BIN" ] || for c in /opt/homebrew/bin/tmux /usr/local/bin/tmux; do
  [ -x "$c" ] && TMUX_BIN="$c" && break
done

LOG="$HOME/.claude/hooks/shimmer.log"
log() { [ -n "${SHIMMER_DEBUG:-}" ] && printf '%s %s %s\n' "$(date +%H:%M:%S)" "$action" "$1" >> "$LOG"; }

# Inside a tmux pane the sequence needs DCS passthrough (allow-passthrough on).
# Writing straight to the client's terminal bypasses tmux — no wrapping.
emit_wrapped() { { printf '\ePtmux;\e\e]%s\a\e\\' "$1" > "$2"; } 2>/dev/null; }
emit_plain()   { { printf '\e]%s\a'               "$1" > "$2"; } 2>/dev/null; }
# BEL, so Ghostty's bell-features (border) fires too — a much thicker cue
# than the thin progress line. Written straight to the client tty, so tmux
# never sees it and can't re-trigger its own bell hook.
emit_bell()    { { printf '\a' > "$1"; } 2>/dev/null; }

# 1) controlling terminal — only if the write actually succeeds
if [ -n "$TMUX" ]; then
  emit_wrapped "$osc" /dev/tty && { log "via /dev/tty (wrapped)"; exit 0; }
else
  emit_plain "$osc" /dev/tty && { log "via /dev/tty (plain)"; exit 0; }
fi

# 2) fallback: every attached tmux client's terminal
if [ -x "$TMUX_BIN" ]; then
  n=0
  while read -r t; do
    [ -n "$t" ] && [ -w "$t" ] || continue
    emit_plain "$osc" "$t" && n=$((n + 1))
    [ "${bell:-0}" = 1 ] && emit_bell "$t"
  done <<EOF
$("$TMUX_BIN" list-clients -F '#{client_tty}' 2>/dev/null)
EOF
  log "via $n client tty(s)"
  exit 0
fi

log "NO tmux binary and no usable tty"
exit 0
