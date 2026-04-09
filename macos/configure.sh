#!/usr/bin/env bash
#
# Configure macOS defaults for development

set -e

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

step() { echo ""; echo -e "${BLUE}➜${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }

echo ""
warn "This will change macOS system settings."
echo "Close System Settings before continuing."
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

# Ask for administrator password upfront
sudo -v

# Keep sudo alive until script completes
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################

step "Configuring general UI/UX settings"

# Set computer name (as done via System Settings → General → About)
sudo scutil --set ComputerName "MacBook Anthony"
sudo scutil --set HostName "MacBook Anthony"
sudo scutil --set LocalHostName "MacBookAnthony"

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Set sidebar icon size to medium
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Display ASCII control characters using caret notation in standard text views
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

# Save to disk (not iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable "reopen windows when logging back in"
defaults write com.apple.loginwindow TALLogoutSavesState -bool false
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false

# Disable automatic capitalization as it's annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they're annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it's annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they're annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

success "General settings configured"

###############################################################################
# Trackpad, mouse, keyboard, and input                                        #
###############################################################################

step "Configuring keyboard and input"

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Faster key repeat (lower than System Settings UI allows)
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain KeyRepeat -int 2

# Click anywhere on a scroll bar to jump to that position
defaults write NSGlobalDomain AppleScrollerPagingBehavior -bool true

# Set language and text formats (Vancouver → metric, CAD)
defaults write NSGlobalDomain AppleLanguages -array "en"
defaults write NSGlobalDomain AppleLocale -string "en_CA@currency=CAD"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

success "Keyboard and input configured"

###############################################################################
# Screen                                                                      #
###############################################################################

step "Configuring screen settings"

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

success "Screen settings configured"

###############################################################################
# Finder                                                                      #
###############################################################################

step "Configuring Finder"

# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Disable disk image verification (faster .dmg mounts)
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Show the ~/Library folder
chflags nohidden ~/Library || true
xattr -d com.apple.FinderInfo ~/Library 2>/dev/null || true

# Expand the following File Info panes:
# "General", "Open with", and "Sharing & Permissions"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

success "Finder configured"

###############################################################################
# Dock and hot corners                                                        #
###############################################################################

step "Configuring Dock"

# Enable highlight hover effect for the grid view of a stack (Dock)
defaults write com.apple.dock mouse-over-hilite-stack -bool true

# Change minimize/maximize window effect
defaults write com.apple.dock mineffect -string "scale"

# Minimize windows into their application's icon
defaults write com.apple.dock minimize-to-application -bool true

# Wipe all (default) app icons from the Dock
defaults write com.apple.dock persistent-apps -array

# Show only open applications in the Dock
defaults write com.apple.dock static-only -bool true

# Don't animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Don't show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Don't auto-rearrange Spaces by most recent use
defaults write com.apple.dock mru-spaces -bool false

# Faster Mission Control animation
defaults write com.apple.dock expose-animation-duration -float 0.1

# Disable Stage Manager (Ventura+)
defaults write com.apple.WindowManager GloballyEnabled -bool false
defaults write com.apple.WindowManager AutoHide -bool false

# Hide desktop widgets (Sonoma+)
defaults write com.apple.WindowManager StandardHideWidgets -bool true
defaults write com.apple.WindowManager StageManagerHideWidgets -bool true

# Disable wallpaper tinting in windows (Sonoma+)
defaults write NSGlobalDomain AppleReduceDesktopTinting -bool true

# Hot corners
# Possible values:
#  0: no-op      2: Mission Control   3: Application windows
#  4: Desktop    5: Screen saver on   6: Screen saver off
# 10: Sleep     11: Launchpad        12: Notification Center  13: Lock Screen
# Top left → Sleep display
defaults write com.apple.dock wvous-tl-corner -int 10
defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right → Mission Control
defaults write com.apple.dock wvous-tr-corner -int 2
defaults write com.apple.dock wvous-tr-modifier -int 0

success "Dock configured"

###############################################################################
# Time Machine                                                                #
###############################################################################

step "Configuring Time Machine"

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

success "Time Machine configured"

###############################################################################
# Activity Monitor                                                            #
###############################################################################

step "Configuring Activity Monitor"

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

success "Activity Monitor configured"

###############################################################################
# TextEdit                                                                    #
###############################################################################

step "Configuring TextEdit"

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0

# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

success "TextEdit configured"

###############################################################################
# Photos                                                                      #
###############################################################################

step "Configuring Photos"

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

success "Photos configured"

###############################################################################
# Apply changes                                                               #
###############################################################################

step "Restarting affected applications"

for app in "Activity Monitor" "cfprefsd" "Dock" "Finder" "Photos" \
	"SystemUIServer" "WindowManager"; do
	killall "${app}" &> /dev/null || true
done

echo ""
success "macOS defaults configured!"
echo ""
warn "Some changes require a logout/restart to take effect."
echo ""
