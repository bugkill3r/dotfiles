#!/bin/bash

# Check if tmux session exists, if not create it
if ! tmux has-session -t work 2>/dev/null; then
    echo "Creating new work tmux session..."
    
    # Start a new detached session named "work"
    tmux new-session -d -s work -n "editor" -c ~/Dev/rzp
    
    # Configure window 1 (editor) - just cd to ~/Dev/rzp and clear
    tmux send-keys -t work:1 "cd ~/Dev/rzp" C-m
    tmux send-keys -t work:1 "clear" C-m
    
    # Create window 2 (testing) with 4 panes
    tmux new-window -t work:2 -n "testing" -c ~/Dev/rzp
    tmux split-window -t work:2 -h -c ~/Dev/rzp
    tmux split-window -t work:2.1 -v -c ~/Dev/rzp
    tmux split-window -t work:2.0 -v -c ~/Dev/rzp
    
    # Create window 3 (demo servers) with 4 panes for SSH
    tmux new-window -t work:3 -n "servers" -c ~/Dev/rzp
    tmux split-window -t work:3 -h -c ~/Dev/rzp
    tmux split-window -t work:3.1 -v -c ~/Dev/rzp
    tmux split-window -t work:3.0 -v -c ~/Dev/rzp
    
    # Create window 4 (utilities) for other tools
    tmux new-window -t work:4 -n "utils" -c ~/Dev/rzp
    
    # Select window 1 (editor) as the starting window
    tmux select-window -t work:1
    
    # Save the session for resurrect
    sleep 1
    tmux run-shell ~/.tmux/plugins/tmux-resurrect/scripts/save.sh
    
    echo "Tmux work session created successfully!"
else
    echo "Work session already exists"
fi

# Attach to the session
echo "Attaching to work session..."
tmux attach-session -t work 