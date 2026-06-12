#!/usr/bin/env bash
# macOS developer-friendly defaults.
#
# Each setting is one line so you can comment out anything you don't want.
# Re-run safely: every command is idempotent. Some changes need a logout
# or a `killall Finder` / `killall Dock` to take effect (handled at the end).

set -euo pipefail

if [ "$(uname)" != "Darwin" ]; then
    echo "This script only runs on macOS." >&2
    exit 1
fi

echo "Applying macOS defaults..."

# --- Finder ---
# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true
# Show all file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Show path bar and status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
# Don't write .DS_Store on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Default to list view
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# --- Keyboard ---
# Fast key repeat (great for vim/code navigation)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# Disable autocorrect and smart quotes (annoying in code/markdown)
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
# Full keyboard access: tab moves between all UI controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# --- Dialogs ---
# Expand save and print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# --- Dock ---
# Auto-hide and remove the show/hide delay
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.4

# --- Screenshots ---
# Save to ~/Screenshots if it exists, otherwise keep default
if [ -d "$HOME/Screenshots" ]; then
    defaults write com.apple.screencapture location -string "$HOME/Screenshots"
fi

echo "Restarting Finder and Dock to apply..."
killall Finder >/dev/null 2>&1 || true
killall Dock >/dev/null 2>&1 || true

echo "Done. Some changes need a logout to fully apply."
