#!/usr/bin/env python3
"""Claude Code statusline — btop/aitop inspired, catppuccin mocha, braille graphs.

Reads the statusline JSON on stdin and prints one colored line:

    ⚡ Fable 5 │  dotfiles   main ● │  ⣀⣤⣶⣿ 72% 144k │ $1.34 │ +156 -20

The context segment is a live braille sparkline of context-window fill over the
session (green→yellow→peach→red), like a btop graph. History is persisted per
session so the graph actually moves as the context grows.

Run `statusline.py demo` to preview with synthetic data.
"""
import json
import os
import subprocess
import sys

# ── catppuccin mocha palette (matches btop + aitop "catppuccin" theme) ──────
def fg(r, g, b):
    return f"\x1b[38;2;{r};{g};{b}m"

RESET   = "\x1b[0m"
BOLD    = "\x1b[1m"
TEXT    = fg(205, 214, 244)   # text
SUBTEXT = fg(166, 173, 200)   # subtext0
DIM     = fg(108, 112, 134)   # overlay0 — separators / muted labels
PINK    = fg(245, 194, 231)   # git branch
MAUVE   = fg(203, 166, 247)   # model / accent
BLUE    = fg(137, 180, 250)   # directory
TEAL    = fg(148, 226, 213)   # context icon
GREEN   = fg(166, 227, 161)
YELLOW  = fg(249, 226, 175)
PEACH   = fg(250, 179, 135)
RED     = fg(243, 139, 168)

# ── nerd-font glyphs (CaskaydiaCove Nerd Font). Easy to swap. ───────────────
IC_MODEL  = ""   # bolt
IC_DIR    = ""   # folder
IC_BRANCH = ""   # git branch (powerline)
IC_CTX    = ""   # bar chart
IC_CLEAN  = ""   # check
SEP       = f" {DIM}│{RESET} "
SPARK_CELLS = 16          # braille sparkline width in chars (2 samples per cell)

# ── aitop cost gradient (src/ui/widgets/cost_color.rs) ──────────────────────
def cost_color(amount):
    if amount < 1.0:
        return fg(80, 200, 80)      # dim green
    if amount < 5.0:
        return fg(230, 220, 50)     # yellow
    if amount < 10.0:
        return fg(255, 150, 50)     # orange
    return fg(255, 80, 80)          # bright red

# ── context fill → gradient color ───────────────────────────────────────────
def ctx_color(frac):
    if frac < 0.60:
        return GREEN
    if frac < 0.80:
        return YELLOW
    if frac < 0.90:
        return PEACH
    return RED

# ── braille bar (ported from aitop's braille_bar_spans) ─────────────────────
# Both-column braille at 4 heights; length encodes fill, a fixed waveform gives
# organic per-cell height variation, gradient green→yellow→red scaled by fill.
_HEIGHTS = ["⣀", "⣤", "⣶", "⣿"]   # ⣀ ⣤ ⣶ ⣿ (1→4 rows)
_WAVE = [0, -1, 0, 1, 0, 0, -1, 1, 0, -1, 0, 1, 0]
_GRAD = [(166, 227, 161), (249, 226, 175), (243, 139, 168)]  # green, yellow, red

def _lerp(c1, c2, t):
    return tuple(round(a + (b - a) * t) for a, b in zip(c1, c2))

def _grad3(t):
    t = max(0.0, min(1.0, t))
    return _lerp(_GRAD[0], _GRAD[1], t / 0.5) if t <= 0.5 \
        else _lerp(_GRAD[1], _GRAD[2], (t - 0.5) / 0.5)

def braille_bar(ratio, width):
    ratio = max(0.0, min(1.0, ratio))
    filled = round(ratio * width)
    if filled <= 0:
        return f"{DIM}{'⣀' * width}{RESET}"     # dim empty baseline track
    grad_end = ratio ** 0.5              # 80% fill → gradient nearly to red
    out = []
    for i in range(filled):
        span = (filled - 1) or 1
        t = (i / span) * grad_end
        r, g, b = _grad3(t)
        base = int((i / span) * 3)       # thin → thick along the bar
        h = max(0, min(3, base + _WAVE[i % len(_WAVE)]))
        out.append(f"{fg(r, g, b)}{_HEIGHTS[h]}")
    out.append(f"{DIM}{'⣀' * (width - filled)}{RESET}")   # dim baseline track
    return "".join(out) + RESET

# ── helpers ─────────────────────────────────────────────────────────────────
def human(n):
    if n >= 1_000_000:
        return f"{n/1_000_000:.1f}M"
    if n >= 1_000:
        return f"{n/1_000:.0f}k"
    return str(int(n))

def find_repo(start):
    d = start
    for _ in range(30):
        if os.path.isdir(os.path.join(d, ".git")):
            return d
        parent = os.path.dirname(d)
        if parent == d:
            break
        d = parent
    return None

def git_info(cwd):
    repo = find_repo(cwd)
    if not repo:
        return None, False
    branch = None
    head = os.path.join(repo, ".git", "HEAD")
    try:
        with open(head) as f:
            ref = f.read().strip()
        branch = ref.split("/", 2)[-1] if ref.startswith("ref:") else ref[:7]
    except OSError:
        pass
    dirty = False
    try:
        env = dict(os.environ, GIT_OPTIONAL_LOCKS="0")
        r = subprocess.run(
            ["git", "-C", repo, "status", "--porcelain", "-uno"],
            capture_output=True, text=True, timeout=0.4, env=env,
        )
        dirty = bool(r.stdout.strip())
    except Exception:
        pass
    return branch, dirty

def read_context_tokens(transcript_path):
    """Sum input+cache tokens of the most recent assistant usage entry."""
    if not transcript_path or not os.path.isfile(transcript_path):
        return None
    try:
        size = os.path.getsize(transcript_path)
        with open(transcript_path, "rb") as f:
            if size > 65536:
                f.seek(size - 65536)
                f.readline()  # drop partial line
            lines = f.read().decode("utf-8", "replace").splitlines()
        for line in reversed(lines):
            line = line.strip()
            if not line or '"usage"' not in line:
                continue
            try:
                obj = json.loads(line)
            except ValueError:
                continue
            usage = (obj.get("message") or {}).get("usage")
            if not usage:
                continue
            return (
                usage.get("input_tokens", 0)
                + usage.get("cache_read_input_tokens", 0)
                + usage.get("cache_creation_input_tokens", 0)
            )
    except Exception:
        return None
    return None

# ── demo data ────────────────────────────────────────────────────────────────
def demo_data():
    # non-1m model → 200k limit, ~92% fill to show the full green→red bar
    return {
        "model": {"id": "claude-opus-4-8", "display_name": "Opus 4.8"},
        "workspace": {"current_dir": os.path.expanduser("~/Dev/dotfiles")},
        "session_id": "demo",
        "cost": {"total_cost_usd": 1.34, "total_lines_added": 156,
                 "total_lines_removed": 20},
    }, 184000

# ── main ─────────────────────────────────────────────────────────────────────
def main():
    demo = len(sys.argv) > 1 and sys.argv[1] == "demo"
    used = 0
    if demo:
        data, used = demo_data()
    else:
        try:
            data = json.load(sys.stdin)
        except Exception:
            data = {}

    model = data.get("model") or {}
    model_name = model.get("display_name") or model.get("id") or "claude"
    model_id = (model.get("id") or "").lower()

    ws = data.get("workspace") or {}
    cwd = ws.get("current_dir") or data.get("cwd") or os.getcwd()
    home = os.path.expanduser("~")
    dirname = "~" if cwd == home else os.path.basename(cwd.rstrip("/")) or "/"

    session_id = data.get("session_id")
    cost = data.get("cost") or {}
    amount = cost.get("total_cost_usd", 0.0) or 0.0
    added = cost.get("total_lines_added", 0) or 0
    removed = cost.get("total_lines_removed", 0) or 0

    limit = 1_000_000 if "1m" in model_id else 200_000
    if data.get("exceeds_200k_tokens") and limit < 1_000_000:
        limit = 1_000_000

    if not demo:
        used = read_context_tokens(data.get("transcript_path")) or 0
    frac = min(1.0, used / limit) if (limit and used) else 0.0

    # ── assemble segments ───────────────────────────────────────────────────
    seg = []
    seg.append(f"{MAUVE}{IC_MODEL} {BOLD}{model_name}{RESET}")
    seg.append(f"{BLUE}{IC_DIR} {TEXT}{dirname}{RESET}")

    branch, dirty = git_info(cwd)
    if branch:
        flag = f" {YELLOW}●{RESET}" if dirty else f" {GREEN}{IC_CLEAN}{RESET}"
        seg.append(f"{PINK}{IC_BRANCH} {branch}{RESET}{flag}")

    spark = braille_bar(frac, SPARK_CELLS)
    cc = ctx_color(frac)
    ctx_seg = (f"{TEAL}{IC_CTX} {RESET}{spark} "
               f"{cc}{int(frac*100)}%{RESET} "
               f"{DIM}{human(used)}/{human(limit)}{RESET}")
    seg.append(ctx_seg)

    seg.append(f"{cost_color(amount)}${amount:.2f}{RESET}")

    lines = f"{GREEN}+{added}{RESET} {RED}-{removed}{RESET}"
    seg.append(lines)

    sys.stdout.write(SEP.join(seg))

if __name__ == "__main__":
    main()
