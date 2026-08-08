#!/bin/bash
# Per-workspace updater. $1 = workspace id this item represents.
# On aerospace_workspace_change, $FOCUSED_WORKSPACE is set by the trigger.
SID="$1"
source "$CONFIG_DIR/colors.sh"

# Hover: subtle background on non-focused pills (mouse.exited falls through to
# the normal repaint below, which restores the correct state).
case "$SENDER" in
  mouse.entered)
    [ "$SID" != "$(aerospace list-workspaces --focused 2>/dev/null)" ] && \
      sketchybar --animate sin 8 --set space.$SID background.drawing=on background.color=0x30cad3f5
    exit 0
    ;;
esac

# Fall back to querying AeroSpace if the event didn't carry the focused workspace
# (startup paint, or a trigger without the env set).
FOCUSED_WORKSPACE="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

# App icons for windows currently in this workspace (deduped).
apps="$(aerospace list-windows --workspace "$SID" --format '%{app-name}' 2>/dev/null | sort -u)"
icons=""
if [ -n "$apps" ]; then
  while IFS= read -r app; do
    [ -z "$app" ] && continue
    icon_result=":default:"
    source "$CONFIG_DIR/plugins/icon_map.sh" "$app"
    icons+="$icon_result"
  done <<< "$apps"
fi

focused="off"; label_color=$GREY; bg="off"; bg_color=$BACKGROUND_1; icon_color=$WHITE; bg_border=$BACKGROUND_2
if [ "$SID" = "$FOCUSED_WORKSPACE" ]; then
  focused="on"; label_color=$WHITE; bg="on"
  bg_color=0x66c6a0f6   # translucent mauve — glassy, lets the frosted bar/blur show through
  icon_color=$WHITE
  bg_border=$MAGENTA    # crisp mauve edge so the active pill still reads clearly
fi

# Highlight always tracks focus (even when the item is about to hide).
# Animate the transition so the glassy mauve pill fades in/out smoothly.
sketchybar --animate tanh 12 --set space.$SID icon.highlight=$focused \
                                              icon.color=$icon_color \
                                              background.color=$bg_color \
                                              background.border_color=$bg_border

# Show a workspace only if it has windows or is focused.
if [ -n "$icons" ] || [ "$focused" = "on" ]; then
  sketchybar --set space.$SID drawing=on \
                              background.drawing=$bg \
                              label="$icons" \
                              label.drawing=$([ -n "$icons" ] && echo on || echo off) \
                              label.color=$label_color
else
  sketchybar --set space.$SID drawing=off
fi
