#!/usr/bin/env python3
"""Attach a real pty-backed tmux client and hold it open.

tmux-resurrect's restore needs an attached client (normally you get one because
continuum fires restore when you attach). A headless `tmux attach` has no tty,
so this forks a pty to give the client a real terminal.

    pty_client.py <session> <seconds>
"""
import os, pty, sys, time

session = sys.argv[1] if len(sys.argv) > 1 else "placeholder"
hold = float(sys.argv[2]) if len(sys.argv) > 2 else 25.0

pid, fd = pty.fork()
if pid == 0:                       # child: becomes the tmux client
    os.environ["TERM"] = "xterm-256color"
    os.execvp("tmux", ["tmux", "attach", "-t", session])
else:                              # parent: drain output, keep the pty alive
    os.set_blocking(fd, False)
    end = time.time() + hold
    while time.time() < end:
        try:
            os.read(fd, 65536)
        except (BlockingIOError, OSError):
            pass
        time.sleep(0.1)
    try:
        os.kill(pid, 15)
    except ProcessLookupError:
        pass
