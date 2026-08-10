#!/bin/bash
# Ghostty title-bar shimmer via the OSC 9;4 progress indicator.
#
# Runs from two places with very different environments:
#   • Claude Code hooks   — usually NO usable controlling terminal
#   • tmux run-shell      — no tty either
# so it tries the controlling terminal first and falls back to the attached
# tmux client's terminal.
#
# NOTE: `[ -w /dev/tty ]` is not a reliable test — /dev/tty can exist and look
# writable while being "Device not configured". The write itself is the test,
# which is why each attempt is checked rather than probed up front.
cat > /dev/null 2>/dev/null   # drain hook stdin so Claude doesn't block

action="${1:-start}"
case "$action" in
  start) osc="9;4;3;0" ;;   # indeterminate progress -> shimmer
  stop)  osc="9;4;0;0" ;;   # clear
  *)     exit 0 ;;
esac

# Inside a tmux pane the sequence must be wrapped in DCS passthrough
# (requires `set -g allow-passthrough on`). Writing straight to the client's
# terminal bypasses tmux, so it must NOT be wrapped.
# Braces around the redirect so the SHELL's own "Device not configured"
# error is suppressed too — 2>/dev/null on printf alone doesn't cover it.
emit_wrapped() { { printf '\ePtmux;\e\e]%s\a\e\\' "$1" > "$2"; } 2>/dev/null; }
emit_plain()   { { printf '\e]%s\a'               "$1" > "$2"; } 2>/dev/null; }

# 1) controlling terminal — only if the write actually succeeds
if [ -n "$TMUX" ]; then
  emit_wrapped "$osc" /dev/tty && exit 0
else
  emit_plain "$osc" /dev/tty && exit 0
fi

# 2) fallback: the terminal of every attached tmux client
tmux list-clients -F '#{client_tty}' 2>/dev/null | while read -r t; do
  [ -n "$t" ] && emit_plain "$osc" "$t"
done
exit 0
