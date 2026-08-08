#!/usr/bin/env bash
# macOS power-user defaults. Re-runnable, no sudo. A few need a logout to apply.
# Every setting here is reversible via System Settings or `defaults delete`.
set -uo pipefail

echo "==> Keyboard"
defaults write NSGlobalDomain KeyRepeat -int 2                       # fastest repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15               # short delay
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false   # repeat > accent popup (vim)
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false   # no smart quotes (code)
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

echo "==> Trackpad: tap to click"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "==> Finder"
defaults write com.apple.finder AppleShowAllFiles -bool true         # hidden files (toggle: cmd+shift+.)
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"  # list view
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"  # search current folder
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true   # no .DS_Store on network
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
chflags nohidden "$HOME/Library" 2>/dev/null || true

echo "==> Dock"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0                # instant show
defaults write com.apple.dock autohide-time-modifier -float 0.3
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mru-spaces -bool false                 # don't auto-rearrange spaces
defaults write com.apple.dock expose-animation-duration -float 0.15

echo "==> Screenshots → ~/Pictures/Screenshots as PNG, no shadow"
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

echo "==> Dialogs & misc"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
defaults write com.apple.LaunchServices LSQuarantine -bool false     # no "are you sure you want to open"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "==> Restarting Finder / Dock"
for app in Finder Dock SystemUIServer; do killall "$app" 2>/dev/null || true; done

echo "==> Done. Log out/in for keyboard + a few others to fully take effect."
