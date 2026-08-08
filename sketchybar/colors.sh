#!/bin/bash

# Theme-aware palette — follows the active catppuccin flavor written by `theme`
# to ~/.config/catppuccin-flavor. sketchybar reads this at startup, so `theme`
# kicks the service to recolor the whole bar (see bin/theme apply_full).

FLAVOR="$(cat "$HOME/.config/catppuccin-flavor" 2>/dev/null || echo mocha)"

case "$FLAVOR" in
  latte)
    c_text=4c4f69; c_grey=7c7f93; c_red=d20f39; c_green=40a02b; c_blue=1e66f5
    c_yellow=df8e1d; c_peach=fe640b; c_mauve=8839ef
    c_base=eff1f5; c_surface0=ccd0da; c_surface1=bcc0cc; c_crust=dce0e8 ;;
  frappe)
    c_text=c6d0f5; c_grey=949cbb; c_red=e78284; c_green=a6d189; c_blue=8caaee
    c_yellow=e5c890; c_peach=ef9f76; c_mauve=ca9ee6
    c_base=303446; c_surface0=414559; c_surface1=51576d; c_crust=232634 ;;
  macchiato)
    c_text=cad3f5; c_grey=939ab7; c_red=ed8796; c_green=a6da95; c_blue=8aadf4
    c_yellow=eed49f; c_peach=f5a97f; c_mauve=c6a0f6
    c_base=24273a; c_surface0=363a4f; c_surface1=494d64; c_crust=181926 ;;
  mocha|*)
    c_text=cdd6f4; c_grey=9399b2; c_red=f38ba8; c_green=a6e3a1; c_blue=89b4fa
    c_yellow=f9e2af; c_peach=fab387; c_mauve=cba6f7
    c_base=1e1e2e; c_surface0=313244; c_surface1=45475a; c_crust=11111b ;;
esac

# Accents (fully opaque)
export BLACK=0xff${c_crust}
export WHITE=0xff${c_text}
export RED=0xff${c_red}
export GREEN=0xff${c_green}
export BLUE=0xff${c_blue}
export YELLOW=0xff${c_yellow}
export ORANGE=0xff${c_peach}
export MAGENTA=0xff${c_mauve}
export GREY=0xff${c_grey}
export TRANSPARENT=0x00000000

# Bar + surfaces (alpha baked in: bar ~50% frosted, pill fills ~38%)
export BAR_COLOR=0x80${c_base}
export BAR_BORDER_COLOR=0xff${c_surface1}
export ICON_COLOR=$WHITE
export LABEL_COLOR=$WHITE
export BACKGROUND_1=0x60${c_surface0}
export BACKGROUND_2=0x60${c_surface1}

export POPUP_BACKGROUND_COLOR=0xff${c_base}
export POPUP_BORDER_COLOR=$WHITE
export SHADOW_COLOR=$BLACK
