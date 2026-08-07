#!/usr/bin/env python3
"""Theme-aware gradient tmux window bar with per-window app icons.

The gradient stops are read from Ghostty's active theme (current-theme), so the
bar follows whatever theme is set — Catppuccin any flavor, Nord, etc. Falls back
to Catppuccin if the palette can't be read. Each window is prefixed with a
nerd-font icon based on its running command; the active window is highlighted.
"""
import subprocess, sys, shutil, os, re

TMUX = shutil.which("tmux") or "/opt/homebrew/bin/tmux"
THEME_FILE = os.path.expanduser("~/.config/ghostty/current-theme")

# fallback gradient (catppuccin) if the theme palette can't be read
FALLBACK = [(137,180,250),(116,199,236),(148,226,213),(166,227,161),
            (249,226,175),(250,179,135),(243,139,168),(203,166,247)]

def read_palette():
    """Build a hue-ordered gradient from the terminal's ANSI palette
    (blue→cyan→green→yellow→red→magenta) as set by the active Ghostty theme."""
    try:
        pal = {}
        with open(THEME_FILE) as f:
            for line in f:
                m = re.match(r'\s*palette\s*=\s*(\d+)\s*=\s*#?([0-9a-fA-F]{6})', line)
                if m:
                    n, h = int(m.group(1)), m.group(2)
                    pal[n] = (int(h[0:2],16), int(h[2:4],16), int(h[4:6],16))
        stops = [pal[i] for i in (4,6,2,3,1,5) if i in pal]  # hue order
        if len(stops) >= 3:
            return stops
    except Exception:
        pass
    return FALLBACK

STOPS = read_palette()

def grad(t):
    if t <= 0: return STOPS[0]
    if t >= 1: return STOPS[-1]
    x = t * (len(STOPS) - 1); i = int(x); f = x - i
    a, b = STOPS[i], STOPS[min(i + 1, len(STOPS) - 1)]
    return tuple(round(a[j] + (b[j] - a[j]) * f) for j in range(3))

# running command → nerd-font icon
ICONS = {
    "nvim":"", "vim":"", "vi":"",
    "node":"", "npm":"", "npx":"", "yarn":"",
    "python":"", "python3":"", "ipython":"", "jupyter":"",
    "git":"", "lazygit":"", "gitui":"",
    "docker":"", "lazydocker":"",
    "go":"", "cargo":"", "rustc":"", "ruby":"",
    "yazi":"", "fzf":"", "ssh":"",
    "claude":"", "btop":"", "htop":"", "top":"",
}
DEFAULT_ICON = ""  # plain shells get no icon

def main():
    sess = sys.argv[1] if len(sys.argv) > 1 else \
        subprocess.run([TMUX,"display-message","-p","#S"],
                       capture_output=True, text=True).stdout.strip()
    out = subprocess.run(
        [TMUX,"list-windows","-t",sess,"-F",
         "#{window_index}\t#{window_name}\t#{window_active}\t#{pane_current_command}"],
        capture_output=True, text=True).stdout.strip().splitlines()

    segs = []
    for line in out:
        idx, name, active, cmd = (line.split("\t") + ["","","",""])[:4]
        icon = ICONS.get(cmd, DEFAULT_ICON)
        label = f"{icon} {idx}:{name}" if icon else f"{idx}:{name}"
        segs.append((f" {label} ", active == "1"))

    total = sum(len(t) for t, _ in segs) or 1
    buf, pos = [], 0
    for text, active in segs:
        if active:
            buf.append("#[bg=colour8,bold]")   # theme-aware highlight (ANSI grey)
        for ch in text:
            r, g, b = grad(pos / (total - 1) if total > 1 else 0)
            safe = "##" if ch == "#" else ch
            buf.append(f"#[fg=#{r:02x}{g:02x}{b:02x}]{safe}")
            pos += 1
        if active:
            buf.append("#[bg=default,nobold]")
    sys.stdout.write("".join(buf) + "#[default]")

if __name__ == "__main__":
    main()
