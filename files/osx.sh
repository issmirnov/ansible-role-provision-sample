#!/bin/bash

set -x

# Sources:
# https://github.com/mathiasbynens/dotfiles/blob/master/.macos
# https://github.com/ricbra/dotfiles/blob/master/bin/setup_osx



# ==============================================
# MENU
# ==============================================
# 24-Hour Time
defaults write NSGlobalDomain AppleICUForce12HourTime -bool false

# Menu bar: show remaining battery time (on pre-10.8); hide percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"
defaults write com.apple.menuextra.battery ShowTime -string "YES"



# ==============================================
# Files and folders
# ==============================================

# Show the ~/Library directory
chflags nohidden "${HOME}/Library"


# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network volumes and USB sticks
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# ==============================================
# Dock
# ==============================================

# Move to the left
defaults write com.apple.dock orientation -string "left"

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool true

# autohide dock
defaults write com.apple.dock autohide -bool true

# remove delay
defaults write com.apple.dock autohide-delay -float 0

# hide recent apps on mojave
defaults write com.apple.dock show-recents -bool false

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# ==============================================
# DEVELOPER
# ==============================================

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Enable the debug menu in Disk Utility
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true


# ==============================================
# Keyboard
# ==============================================

defaults write -g ApplePressAndHoldEnabled -bool false # enable key repeat

# ==============================================
# System
# ==============================================


# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Allow text selection in the Quick Look window
defaults write com.apple.finder QLEnableTextSelection -bool true

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

# Disable useless dashboard
defaults write com.apple.dashboard mcx-disabled -boolean YES && killall Dock

# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
# Follow the keyboard focus while zoomed in
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# ==============================================
# Screen
# ==============================================

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Enable subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 2



# ==============================================
# Bloatware
# ==============================================

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# ==============================================
# Kill affected applications
# ==============================================

function killallApps() {
    killall "Finder" > /dev/null 2>&1
    killall "SystemUIServer" > /dev/null 2>&1
    killall "Dock" > /dev/null 2>&1

    appsToKill=(
    "Activity Monitor"
    "Dashboard"
    "Disk Utility"
    "Photos"
    "Safari"
    "System Preferences"
    "TextWrangler"
    "Time Machine"
    "Xcode"
    )

    for app in "${appsToKill[@]}"
    do
        killall "${app}" > /dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            # We just killed an app so restart it
            open -a "${app}"
        fi
    done

    echo "Note that some of these changes require a logout/restart to take effect."
}

killallApps
