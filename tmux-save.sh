#!/bin/bash

# Check if tmux is running
if tmux ls > /dev/null 2>&1; then
    # Tmux is running, run the save script
    tmux run-shell ~/.tmux/plugins/tmux-resurrect/scripts/save.sh
    echo "✅ Tmux sessions saved successfully!"
else
    # Tmux is not running
    echo "❌ No active tmux sessions found!"
fi 