#!/bin/bash

# Since we run this with ansible, we have to split up the sudo and non sudo
# commands, and run this file with the "become: yes" arg. Otherwise, the script
# will hang or we change the root user's local prefs.

if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi


# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName


# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Disable local Time Machine backups
hash tmutil &> /dev/null && sudo tmutil disablelocal

# ==============================================
# SSD-specific tweaks                                                         #
# ==============================================

# Disable hibernation (speeds up entering sleep mode)
sudo pmset -a hibernatemode 0

# Remove the sleep image file to save disk space
sudo rm /private/var/vm/sleepimage
# Create a zero-byte file instead…
sudo touch /private/var/vm/sleepimage
# …and make sure it can’t be rewritten
sudo chflags uchg /private/var/vm/sleepimage

# Disable the sudden motion sensor as it’s not useful for SSDs
sudo pmset -a sms 0

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true
