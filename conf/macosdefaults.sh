# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# don't write .DS_Store folders in network and connected drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# prevents leakage of all downloaded files to quarantie db
:>~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2
sudo chflags schg ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2

# Pre-Big Sur titlebars
defaults write -g NSWindowSupportsAutomaticInlineTitle -bool false
