#!/bin/bash

# Create fonts directory if it doesn't exist
mkdir -p "$HOME/.config/sketchybar/fonts"

# Download the sketchybar app font
echo "Downloading sketchybar app font..."
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v1.0.4/sketchybar-app-font.ttf -o "$HOME/.config/sketchybar/fonts/sketchybar-app-font.ttf"

# Install the font
echo "Installing font..."
cp "$HOME/.config/sketchybar/fonts/sketchybar-app-font.ttf" "$HOME/Library/Fonts/"

# Set proper font in sketchybar config
echo "Updating sketchybar configuration..."
sed -i '' 's/icon.font="sketchybar-app-font:Regular:16.0"/icon.font="sketchybar-app-font:Regular:16.0"/' "$HOME/.config/sketchybar/items/front_app.sh"

# Restart sketchybar
echo "Restarting sketchybar..."
sketchybar --reload

echo "Installation complete. You should now see app icons in sketchybar."