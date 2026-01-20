#!/usr/bin/env bash
#
# Sets reasonable OS X defaults.
#
# Or, in other words, set shit how I like in OS X.
#
# The original idea (and a couple settings) were grabbed from:
#   https://github.com/mathiasbynens/dotfiles/blob/master/.osx
#   https://mths.be/osx
#   https://short.is/writing/setting-up-a-new-mac
#
# Run ./set-defaults.sh and you'll be good to go.

# Ask for the administrator password upfront
# [中文說明] 執行時先詢問管理者密碼（sudo）
# sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
# [中文說明] 讓 sudo 權限在腳本執行期間保持有效，不用一直輸入密碼
# while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
# [中文說明] 一般介面與使用者體驗設定                                            #
###############################################################################

# Set computer name (as done via System Preferences → Sharing)
# [中文說明] 設定電腦名稱、主機名稱（目前被註解掉，若需要可取消註解並修改名稱）
# sudo scutil --set ComputerName "0x6D746873"
# sudo scutil --set HostName "0x6D746873"
# sudo scutil --set LocalHostName "0x6D746873"
# sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "0x6D746873"

# Set battery and power standby delay to 24 hours (default is 1 hour)
# [中文說明] 設定進入待機模式的延遲時間為 24 小時（預設是 1 小時）
# sudo pmset -a standbydelay 86400
# sudo pmset -a autopoweroffdelay 86400

# Disable battery and power sleep mode
# [中文說明] 完全停用待機與自動斷電功能（讓電腦保持喚醒）
sudo pmset -a standby 0
sudo pmset -a autopoweroff 0

# Disable the sound effects on boot
# [中文說明] 停用開機時的「登」啟動音效
sudo nvram SystemAudioVolume=" "

# 啟用安全性
# [中文說明] 注意：這行指令是「停用」Gatekeeper 安全檢查，允許安裝「任何來源」的 App
sudo spctl --master-disable

# Disable transparency in the menu bar and elsewhere on Yosemite
# [中文說明] 減少系統透明度效果（可提升老舊機器效能）
# defaults write com.apple.universalaccess reduceTransparency -bool true

# Menu bar: hide the Time Machine, Volume, and User icons
# [中文說明] 設定選單列（Menu bar）要顯示哪些圖示
# for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
# 	defaults write "${domain}" dontAutoLoad -array \
# 		"/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
# 		"/System/Library/CoreServices/Menu Extras/Volume.menu" \
# 		"/System/Library/CoreServices/Menu Extras/User.menu"
# done
defaults write com.apple.systemuiserver menuExtras -array \
	"/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
	"/System/Library/CoreServices/Menu Extras/Battery.menu"
# 	"/System/Library/CoreServices/Menu Extras/AirPort.menu" \
# 	 \
# 	"/System/Library/CoreServices/Menu Extras/Clock.menu"

#show Battery Percentage
# [中文說明] 在選單列顯示電池百分比
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Set highlight color to green
# [中文說明] 設定選取文字或檔案時的反白顏色（目前註解掉）
# defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600"

# Set sidebar icon size to medium
# [中文說明] 設定 Finder 側邊欄圖示大小（2 為中等）
# defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Always show scrollbars
# Possible values: `WhenScrolling`, `Automatic` and `Always`
# [中文說明] 設定捲軸顯示方式：總是顯示
# defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Disable smooth scrolling
# (Uncomment if you’re on an older Mac that messes up the animation)
# [中文說明] 停用平滑捲動（適合老舊機型，目前註解掉）
# defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false

# Increase window resize speed for Cocoa applications
# [中文說明] 加速視窗縮放的動畫速度（極快）
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Expand save panel by default
# [中文說明] 預設展開「儲存檔案」的詳細視窗（不用再點箭頭）
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
# [中文說明] 預設展開「列印」的詳細視窗
# defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
# defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true


# Save to disk (not to iCloud) by default
# [中文說明] 預設儲存到本機硬碟，而不是 iCloud
# defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
# [中文說明] 列印工作完成後，自動關閉印表機 App
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the “Are you sure you want to open this application?” dialog
# [中文說明] 停用「你確定要開啟這個從網路下載的應用程式嗎？」的警告視窗
defaults write com.apple.LaunchServices LSQuarantine -bool false
defaults write com.apple.LaunchServices LSQuarantine -bool NO

# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
# [中文說明] 重置 LaunchServices 資料庫以移除「使用...開啟」選單中的重複項目
# /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Display ASCII control characters using caret notation in standard text views
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
# [中文說明] 在文字編輯器中顯示 ASCII 控制字元（例如 ^A）
# defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

# Disable Resume system-wide
# [中文說明] 停用全系統的 Resume 功能（也就是關閉 App 後，下次打開不回復上次視窗狀態）
# defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Disable automatic termination of inactive apps
# [中文說明] 停用系統自動關閉閒置 App 的功能
# defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable the crash reporter
# [中文說明] 停用 App 崩潰時的報告視窗（Crash Reporter）
defaults write com.apple.CrashReporter DialogType -string "none"

# Set Help Viewer windows to non-floating mode
# [中文說明] 讓「輔助說明」視窗不要總是浮在最上層
# defaults write com.apple.helpviewer DevMode -bool true

# Fix for the ancient UTF-8 bug in QuickLook (https://mths.be/bbo)
# Commented out, as this is known to cause problems in various Adobe apps :(
# See https://github.com/mathiasbynens/dotfiles/issues/237
# [中文說明] 修正 QuickLook 的 UTF-8 編碼問題（因可能導致 Adobe 軟體問題而註解掉）
# echo "0x08000100:0" > ~/.CFUserTextEncoding

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
# [中文說明] 在登入畫面點擊時鐘時，顯示 IP、主機名稱、OS 版本等資訊
# sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Restart automatically if the computer freezes
# [中文說明] 電腦當機凍結時自動重新啟動
# sudo systemsetup -setrestartfreeze on

# Never go into computer sleep mode
# [中文說明] 永不進入電腦睡眠模式
# sudo systemsetup -setcomputersleep Off > /dev/null

# Press power button to shutdown without confirm dialog.
# [中文說明] 按下電源鍵直接關機，不顯示確認對話框（目前註解掉）
# defaults write com.apple.loginwindow PowerButtonSleepsSystem -bool no

# Check for software updates daily, not just once per week
# [中文說明] 將系統軟體更新檢查頻率改為每天一次
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Disable Notification Center and remove the menu bar icon
# [中文說明] 停用通知中心並移除選單列圖示（目前註解掉）
# launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

# Disable smart quotes as they’re annoying when typing code
# [中文說明] 停用智慧引號（避免打程式碼時自動變成全形引號）
# defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
# [中文說明] 停用智慧破折號（避免打程式碼時 -- 自動變成 —）
# defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Set a custom wallpaper image. `DefaultDesktop.jpg` is already a symlink, and
# all wallpapers are in `/Library/Desktop Pictures/`. The default is `Wave.jpg`.
# [中文說明] 設定自訂桌布（需要修改路徑）
# rm -rf ~/Library/Application Support/Dock/desktoppicture.db
# sudo rm -rf /System/Library/CoreServices/DefaultDesktop.jpg
# sudo ln -s /path/to/your/image /System/Library/CoreServices/DefaultDesktop.jpg

###############################################################################
# SSD-specific tweaks                                                         #
# [中文說明] 針對 SSD 固態硬碟的優化                                             #
###############################################################################

# Disable local Time Machine snapshots
# [中文說明] 停用 Time Machine 的本機快照（節省 SSD 空間）
sudo tmutil disable local

# Disable hibernation (speeds up entering sleep mode)
# [中文說明] 停用休眠模式（加速進入睡眠，且節省磁碟寫入）
sudo pmset -a hibernatemode 0

# Remove the sleep image file to save disk space
# [中文說明] 移除休眠產生的暫存檔 sleepimage 以節省空間
# sudo rm /Private/var/vm/sleepimage
# Create a zero-byte file instead…
# sudo touch /Private/var/vm/sleepimage
# …and make sure it can’t be rewritten
# sudo chflags uchg /Private/var/vm/sleepimage

# Disable the sudden motion sensor as it’s not useful for SSDs
# [中文說明] 停用突發移動感測器（SSD 不需要防震保護）
# sudo pmset -a sms 0

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
# [中文說明] 觸控板、滑鼠、鍵盤、藍牙週邊與輸入設定                                #
###############################################################################

# Trackpad: enable tap to click for this user and for the login screen
# [中文說明] 啟用觸控板「輕點以點按」（Tap to click）
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: map bottom right corner to right-click
# [中文說明] 將觸控板右下角設為右鍵（目前註解掉）
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
# defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
# defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Trackpad/Mouse: enable right click
# [中文說明] 啟用觸控板/滑鼠的右鍵功能（兩指點按）
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode "TwoButton"

# Mouse: enable swipe between pages
# [中文說明] 滑鼠：啟用頁面滑動切換
# defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseHorizontalSwipe -int 1

# Trackpad: enable three finger drag
# [中文說明] 啟用觸控板「三指拖移」（這是非常實用的舊功能）
defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerDragGesture -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# Trackpad/Mouse: tracking speed fast
# [中文說明] 將觸控板與滑鼠的游標速度調快
defaults write NSGlobalDomain com.apple.trackpad.scaling -int 3
defaults write NSGlobalDomain com.apple.mouse.scaling -int 3

# Trackpad: enable swipe down tree/four finger to app expose
# [中文說明] 啟用三指或四指下滑啟動 App Exposé（顯示當前 App 所有視窗）
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.dock showAppExposeGestureEnabled -int 1

# Disable “natural” (Lion-style) scrolling
# [中文說明] 停用「自然捲動」（恢復傳統捲動方向，目前註解掉）
# defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Increase sound quality for Bluetooth headphones/headsets
# [中文說明] 提升藍牙耳機的音質（提高 Bitpool 最小值）
# defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Enable full keyboard access
# 0 disable
# 1 text boxes and lists only
# 3 all controls (e.g. enable Tab in modal dialogs)
# [中文說明] 啟用全鍵盤控制（按 Tab 鍵可以在對話框的所有按鈕間切換，而不僅是文字框）
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Use scroll gesture with the Ctrl (^) modifier key to zoom
# [中文說明] 啟用 Ctrl + 捲動 來縮放螢幕畫面
# defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
# defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
# Follow the keyboard focus while zoomed in
# [中文說明] 縮放時畫面跟隨鍵盤焦點
# defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

# Disable press-and-hold for keys in favor of key repeat
# [中文說明] 停用長按按鍵跳出特殊字元選單（改為傳統的重複輸入字元）
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
# [中文說明] 設定極快的鍵盤重複輸入速度
defaults write NSGlobalDomain KeyRepeat -int 0

# Set language and text formats
# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
# [中文說明] 設定語言和地區格式（目前設為英文/繁體中文混合，貨幣USD）
# defaults write NSGlobalDomain AppleLanguages -array "en" "zh_TW"
# defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
# defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
# defaults write NSGlobalDomain AppleMetricUnits -bool false

# Set the timezone; see `sudo systemsetup -listtimezones` for other values
# [中文說明] 設定時區為台北
# sudo systemsetup -settimezone "Asia/Taipei" > /dev/null

# Disable auto-correct
# [中文說明] 停用自動更正拼字
# defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Stop iTunes from responding to the keyboard media keys
# [中文說明] 停止 iTunes/Music 搶佔鍵盤媒體鍵（播放/暫停）的控制權
# launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

###############################################################################
# Screen                                                                      #
# [中文說明] 螢幕相關設定                                                       #
###############################################################################

# Require password immediately after sleep or screen saver begins
# [中文說明] 睡眠或螢幕保護程式啟動後，喚醒時「立即」要求輸入密碼
defaults write com.screensaver askForPassword -int 1
defaults write com.screensaver askForPasswordDelay -int 0

# disable Screensaver
# [中文說明] 將登入畫面的閒置時間設為 0（停用預設螢幕保護程式）
sudo defaults write /Library/Preferences/com.apple.screensaver loginWindowIdleTime 0

# Change Screensaver to Fliqlo
# [中文說明] 將螢幕保護程式更改為 "Fliqlo"（翻頁時鐘，需先安裝該螢幕保護程式）
defaults -currentHost write com.apple.screensaver moduleDict -dict moduleName Fliqlo path ~/Library/Screen\ Savers/Fliqlo.saver/ type 0

#defaults write com.apple.screensaver moduleName -string "Fliqlo" modulePath -string "~/Library/Screen\ Savers/Fliqlo.saver"

# Save screenshots to the desktop
# [中文說明] 將截圖路徑改為 ~/Documents/00_Screenshots（請確保資料夾存在）
defaults write com.apple.screencapture location -string "${HOME}/Documents/00_Screenshots"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
# [中文說明] 設定截圖格式為 PNG
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
# [中文說明] 截取視窗時移除陰影（讓截圖更乾淨）
defaults write com.apple.screencapture disable-shadow -bool true

# 設定截圖檔名為 螢幕快照
defaults write com.apple.screencapture name "ScreenShot"

# Enable subpixel font rendering on non-Apple LCDs
# [中文說明] 在非 Apple 的螢幕上啟用次像素字體渲染（改善字體清晰度）
# defaults write NSGlobalDomain AppleFontSmoothing -int 2

# Enable HiDPI display modes (requires restart)
# [中文說明] 啟用 HiDPI 顯示模式（需要重開機）
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

###############################################################################
# Finder                                                                      #
# [中文說明] Finder 檔案總管設定                                                #
###############################################################################

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
# [中文說明] 允許使用 Cmd+Q 關閉 Finder（關閉後桌面圖示會消失）
# defaults write com.apple.finder QuitMenuItem -bool true

# Finder: disable window animations and Get Info animations
# [中文說明] 停用 Finder 視窗動畫和「簡介」動畫
# defaults write com.apple.finder DisableAllAnimations -bool true

# Set Desktop as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
# [中文說明] 設定 Finder 開新視窗時預設開啟「下載項目 (Downloads)」資料夾
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Downloads/"

# Show icons for hard drives, servers, and removable media on the desktop
# [中文說明] 在桌面上顯示硬碟、伺服器、隨身碟圖示（目前註解掉）
# defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
# defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
# defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
# defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: show hidden files by default
# [中文說明] 預設顯示隱藏檔
# defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
# [中文說明] 顯示所有檔案的副檔名
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
# [中文說明] 顯示 Finder 下方狀態列（可用空間、檔案數量）
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
# [中文說明] 顯示 Finder 下方路徑列
defaults write com.apple.finder ShowPathbar -bool true

# Finder: allow text selection in Quick Look
# [中文說明] 允許在 Quick Look（空白鍵預覽）視窗中選取並複製文字
defaults write com.apple.finder QLEnableTextSelection -bool true

# Display full POSIX path as Finder window title
# [中文說明] 在 Finder 視窗標題顯示完整路徑
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# When performing a search, search the current folder by default
# [中文說明] 搜尋時，預設搜尋「目前資料夾」而非「這台 Mac」
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
# [中文說明] 修改檔案副檔名時，不要跳出警告視窗
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Enable spring loading for directories
# [中文說明] 啟用資料夾的彈出式載入（拖曳檔案懸停在資料夾上會自動打開）
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Remove the spring loading delay for directories
# [中文說明] 移除彈出式載入的延遲（即刻打開）
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Avoid creating .DS_Store files on network volumes
# [中文說明] 禁止在網路磁碟機（NAS/SMB）產生 .DS_Store 垃圾檔
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Avoid creating .DS_Store files on USB 
# [中文說明] 禁止在 USB 磁碟機產生 .DS_Store 垃圾檔
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Disable disk image verification
# [中文說明] 開啟 DMG 映像檔時跳過驗證（加速開啟）
# defaults write com.apple.frameworks.diskimages skip-verify -bool true
# defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
# defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Automatically open a new Finder window when a volume is mounted
# [中文說明] 插入新磁碟/隨身碟時自動開啟 Finder 視窗
# defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
# defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
# defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Show item info near icons on the desktop and in other icon views
# [中文說明] 在桌面或圖示檢視中，顯示項目資訊（如圖片尺寸、檔案數量）
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Show item info to the right of the icons on the desktop
# [中文說明] 將桌面圖示的標籤文字顯示在右側而非下方
# /usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist
#
# Enable snap-to-grid for icons on the desktop and in other icon views
# [中文說明] 啟用桌面圖示對齊格線
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Increase grid spacing for icons on the desktop and in other icon views
# [中文說明] 增加桌面圖示的間距
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

# Increase the size of icons on the desktop and in other icon views
# [中文說明] 增加桌面圖示的大小
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist

# Use column view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`, `Nlsv`
# [中文說明] 預設所有 Finder 視窗使用「直欄檢視 (Column View)」
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Disable the warning before emptying the Trash
# [中文說明] 清空垃圾桶時不要跳出警告
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Empty Trash securely by default
# [中文說明] 預設使用安全清空垃圾桶（較慢但較安全，難以復原）
# defaults write com.apple.finder EmptyTrashSecurely -bool true

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
# [中文說明] 允許透過乙太網路（有線網路）使用 AirDrop
# defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Enable the MacBook Air SuperDrive on any Mac
# [中文說明] 允許在任何 Mac 上使用 Apple USB SuperDrive 光碟機
# sudo nvram boot-args="mbasd=1"

# Show the ~/Library folder
# [中文說明] 顯示使用者資源庫 ~/Library 資料夾
# chflags nohidden ~/Library

# Remove Dropbox’s green checkmark icons in Finder
# [中文說明] 移除 Dropbox 在 Finder 中的綠色勾勾圖示（透過修改資源檔）
# file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns
# [ -e "${file}" ] && mv -f "${file}" "${file}.bak"

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
# [中文說明] 預設展開檔案簡介（Get Info）視窗中的一般、開啟檔案應用程式、權限區塊
# defaults write com.apple.finder FXInfoPanesExpanded -dict \
# 	General -bool true \
# 	OpenWith -bool true \
# 	Privileges -bool true

###############################################################################
# Dock, Dashboard, and hot corners                                            #
# [中文說明] Dock 工具列、Dashboard 與熱點設定                                   #
###############################################################################

# Use dark menu bar and Dock
# [中文說明] 使用深色選單列與 Dock
defaults write NSGlobalDomain AppleInterfaceStyle Dark

# Remove Siri icon from status menu
# [中文說明] 移除選單列的 Siri 圖示
defaults write com.apple.Siri StatusMenuVisible -bool false


# Disable Resume system-wide
# This will stop your mac trying to open everything when started
# [中文說明] 停用 App 視窗回復功能，避免重開機時自動開啟上次的一堆視窗
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Check for software updates daily, not just once per week
# [中文說明] 再次設定：每天檢查更新
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Enable highlight hover effect for the grid view of a stack (Dock)
# [中文說明] 在 Dock 的堆疊（Stack）格狀檢視中啟用滑鼠懸停高亮效果
defaults write com.apple.dock mouse-over-hilite-stack -bool true

# Set the icon size of Dock items to 36 pixels
# [中文說明] 設定 Dock 圖示大小為 36 像素
defaults write com.apple.dock tilesize -int 36

# Change minimize/maximize window effect
# [中文說明] 設定視窗最小化效果為「縮放 (Scale)」
defaults write com.apple.dock mineffect -string "scale"

# Minimize windows into their application’s icon
# [中文說明] 將視窗最小化至應用程式圖示本身（而不是在 Dock 右側多出一個縮圖）
defaults write com.apple.dock minimize-to-application -bool true

# Enable spring loading for all Dock items
# [中文說明] 啟用 Dock 圖示的彈出式載入
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Show indicator lights for open applications in the Dock
# [中文說明] 在 Dock 上顯示已開啟應用程式的指示燈（下方的小黑點）
defaults write com.apple.dock show-process-indicators -bool true

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
# [中文說明] 清空 Dock 上的所有圖示（這會移除所有預設釘選的 App，謹慎使用）
defaults write com.apple.dock persistent-apps -array

# Don’t animate opening applications from the Dock
# [中文說明] 停用從 Dock 開啟 App 時的跳動動畫
defaults write com.apple.dock launchanim -bool false

# Speed up Mission Control animations
# [中文說明] 加速 Mission Control 的動畫
defaults write com.apple.dock expose-animation-duration -float 0.1

# Don’t group windows by application in Mission Control
# (i.e. use the old Exposé behavior instead)
# [中文說明] Mission Control 時不要依應用程式分組（恢復舊版 Expose 行為）
defaults write com.apple.dock expose-group-by-app -bool false

# Disable Dashboard
# [中文說明] 停用 Dashboard（儀表板）功能
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
# [中文說明] 不要將 Dashboard 顯示為一個獨立的桌面空間
defaults write com.apple.dock dashboard-in-overlay -bool true

# Don’t automatically rearrange Spaces based on most recent use
# [中文說明] 不要根據最近使用時間自動重新排列桌面空間（Space）
# defaults write com.apple.dock mru-spaces -bool false

# Remove the auto-hiding Dock delay
# [中文說明] 移除 Dock 自動隱藏的延遲（滑鼠靠近立即顯示）
defaults write com.apple.dock autohide-delay -float 0
# Remove the animation when hiding/showing the Dock
# [中文說明] 移除 Dock 顯示/隱藏的動畫時間（瞬間出現）
defaults write com.apple.dock autohide-time-modifier -float 0

# Automatically hide and show the Dock
# [中文說明] 啟用 Dock 自動隱藏
defaults write com.apple.dock autohide -bool true

# Make Dock icons of hidden applications translucent
# [中文說明]讓已隱藏（Cmd+H）的應用程式在 Dock 上呈現半透明狀態
defaults write com.apple.dock showhidden -bool true

# Increase sound qualty for Bluetooth headphones
# [中文說明] 提升藍牙耳機音質設定（設定 Bitpool 參數）
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Max (editable)" 80
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" 80
defaults write com.apple.BluetoothAudioAgent "Apple Initial Bitpool (editable)" 80
defaults write com.apple.BluetoothAudioAgent "Apple Initial Bitpool Min (editable)" 80
defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool" 80
defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Max" 80
defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Min" 80

# Disable the Launchpad gesture (pinch with thumb and three fingers)
# [中文說明] 停用 Launchpad 的手勢（拇指與三指捏合）
# defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

# Reset Launchpad, but keep the desktop wallpaper intact
# [中文說明] 重置 Launchpad 排列
# find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete

# Add iOS Simulator to Launchpad
# [中文說明] 將 iOS 模擬器捷徑加入 Launchpad
# sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/iOS Simulator.app" "/Applications/iOS Simulator.app"

# Add a spacer to the left side of the Dock (where the applications are)
# [中文說明] 在 Dock 左側（App 區）加入一個透明分隔空間
# defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
# Add a spacer to the right side of the Dock (where the Trash is)
# [中文說明] 在 Dock 右側（垃圾桶區）加入一個透明分隔空間
# defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Top left screen corner → Mission Control
# [中文說明] 左上角熱點：Mission Control
# defaults write com.apple.dock wvous-tl-corner -int 2
# defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Desktop
# [中文說明] 右上角熱點：顯示桌面
# defaults write com.apple.dock wvous-tr-corner -int 4
# defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Start screen saver
# [中文說明] 左下角熱點：讓螢幕睡眠（注意：這裡值設為 10 是讓螢幕變黑睡眠，而非 5 啟動保護程式）
defaults write com.apple.dock wvous-bl-corner -int 10
defaults write com.apple.dock wvous-bl-modifier -int 0
# Bottom right screen corner → Put display to sleep
# [中文說明] 右下角熱點：啟動螢幕保護程式（值為 5）
defaults write com.apple.dock wvous-br-corner -int 5
defaults write com.apple.dock wvous-br-modifier -int 0

###############################################################################
# Safari & WebKit                                                             #
# [中文說明] Safari 瀏覽器設定                                                  #
###############################################################################

# Privacy: don’t send search queries to Apple
# [中文說明] 隱私：不要將 Safari 搜尋關鍵字傳送給 Apple
# defaults write com.apple.Safari UniversalSearchEnabled -bool false
# defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Press Tab to highlight each item on a web page
# [中文說明] 按 Tab 鍵可以選取網頁上的每一個項目（連結、按鈕等）
# defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
# defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

# Show the full URL in the address bar (note: this still hides the scheme)
# [中文說明] 在網址列顯示完整 URL（預設會隱藏參數）
# defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Set Safari’s home page to `about:blank` for faster loading
# [中文說明] 將 Safari 首頁設為空白頁，加快開啟速度
defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening ‘safe’ files automatically after downloading
# [中文說明] 禁止 Safari 下載後自動開啟「安全的」檔案（如 zip、圖片，為了安全建議禁止）
# defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Allow hitting the Backspace key to go to the previous page in history
# [中文說明] 允許按 Backspace 鍵返回上一頁
# defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

# Hide Safari’s bookmarks bar by default
# [中文說明] 預設隱藏書籤列
# defaults write com.apple.Safari ShowFavoritesBar -bool false

# Hide Safari’s sidebar in Top Sites
# [中文說明] 在 Top Sites 頁面隱藏側邊欄
# defaults write com.apple.Safari ShowSidebarInTopSites -bool false

# Disable Safari’s thumbnail cache for History and Top Sites
# [中文說明] 停用 Safari 的歷史紀錄與 Top Sites 縮圖快取
# defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Enable Safari’s debug menu
# [中文說明] 啟用 Safari 的隱藏 Debug 選單
# defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Make Safari’s search banners default to Contains instead of Starts With
# [中文說明] 讓 Safari 的頁面搜尋預設為「包含」而非「開頭為」
# defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Remove useless icons from Safari’s bookmarks bar
# [中文說明] 移除書籤列上無用的圖示
# defaults write com.apple.Safari ProxiesInBookmarksBar "()"

# Enable the Develop menu and the Web Inspector in Safari
# [中文說明] 啟用 Safari 的「開發」選單與網頁檢閱器
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
# [中文說明] 在網頁視圖的右鍵選單中加入「檢查元素」選項
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

###############################################################################
# Mail                                                                        #
# [中文說明] Mail 郵件 App 設定                                                #
###############################################################################

# Disable send and reply animations in Mail.app
# [中文說明] 停用郵件傳送與回覆的動畫
# defaults write com.apple.mail DisableReplyAnimations -bool true
# defaults write com.apple.mail DisableSendAnimations -bool true

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
# [中文說明] 複製 Email 地址時只複製 `foo@example.com` 純位址格式
# defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
# [中文說明] 增加 Cmd+Enter 快捷鍵來發送郵件
# defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" -string "@\\U21a9"

# Display emails in threaded mode, sorted by date (oldest at the top)
# [中文說明] 以群組對話模式顯示郵件，並按日期排序
# defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
# defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
# defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

# Disable inline attachments (just show the icons)
# [中文說明] 停用附件內容直接顯示（強制顯示為圖示）
# defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

# Disable automatic spell checking
# [中文說明] 停用郵件自動拼字檢查
# defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

###############################################################################
# Spotlight                                                                   #
# [中文說明] Spotlight 搜尋設定                                                #
###############################################################################

# Hide Spotlight tray-icon (and subsequent helper)
# [中文說明] 隱藏 Spotlight 的選單列圖示（須修改系統檔，較危險）
# sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
# Disable Spotlight indexing for any volume that gets mounted and has not yet
# been indexed before.
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
# sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
# Change indexing order and disable some search results
# Yosemite-specific search results (remove them if your are using OS X 10.9 or older):
# 	MENU_DEFINITION
# 	MENU_CONVERSION
# 	MENU_EXPRESSION
# 	MENU_SPOTLIGHT_SUGGESTIONS (send search queries to Apple)
# 	MENU_WEBSEARCH             (send search queries to Apple)
# 	MENU_OTHER
# [中文說明] 自訂 Spotlight 搜尋結果的順序與啟用項目（停用字體、書籤、網頁搜尋等項目以加速）
# defaults write com.apple.spotlight orderedItems -array \
# 	'{"enabled" = 1;"name" = "APPLICATIONS";}' \
# 	'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
# 	'{"enabled" = 1;"name" = "DIRECTORIES";}' \
# 	'{"enabled" = 1;"name" = "PDF";}' \
# 	'{"enabled" = 1;"name" = "FONTS";}' \
# 	'{"enabled" = 0;"name" = "DOCUMENTS";}' \
# 	'{"enabled" = 0;"name" = "MESSAGES";}' \
# 	'{"enabled" = 0;"name" = "CONTACT";}' \
# 	'{"enabled" = 0;"name" = "EVENT_TODO";}' \
# 	'{"enabled" = 0;"name" = "IMAGES";}' \
# 	'{"enabled" = 0;"name" = "BOOKMARKS";}' \
# 	'{"enabled" = 0;"name" = "MUSIC";}' \
# 	'{"enabled" = 0;"name" = "MOVIES";}' \
# 	'{"enabled" = 0;"name" = "PRESENTATIONS";}' \
# 	'{"enabled" = 0;"name" = "SPREADSHEETS";}' \
# 	'{"enabled" = 0;"name" = "SOURCE";}' \
# 	'{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
# 	'{"enabled" = 0;"name" = "MENU_OTHER";}' \
# 	'{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
# 	'{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
# 	'{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
# 	'{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'
# Load new settings before rebuilding the index
# killall mds > /dev/null 2>&1
# Make sure indexing is enabled for the main volume
# sudo mdutil -i on / > /dev/null
# Rebuild the index from scratch
# sudo mdutil -E / > /dev/null

###############################################################################
# Terminal & iTerm 2                                                          #
# [中文說明] 終端機與 iTerm2 設定                                              #
###############################################################################

# Only use UTF-8 in Terminal.app
# [中文說明] 強制 Terminal 使用 UTF-8 編碼
defaults write com.apple.terminal StringEncodings -array 4

# Use a modified version of the Solarized Dark theme by default in Terminal.app
# [中文說明] 載入 Solarized Dark 佈景主題設定（需要有對應的設定檔存在）
# TERM_PROFILE='Solarized Dark xterm-256color';
# CURRENT_PROFILE="$(defaults read com.apple.terminal 'Default Window Settings')";
# if [ "${CURRENT_PROFILE}" != "${TERM_PROFILE}" ]; then
# 	open "${HOME}/init/${TERM_PROFILE}.terminal";
# 	sleep 1; # Wait a bit to make sure the theme is loaded
# 	defaults write com.apple.terminal 'Default Window Settings' -string "${TERM_PROFILE}";
# 	defaults write com.apple.terminal 'Startup Window Settings' -string "${TERM_PROFILE}";
# fi;

# Enable “focus follows mouse” for Terminal.app and all X11 apps
# i.e. hover over a window and start typing in it without clicking first
# [中文說明] 啟用「焦點跟隨滑鼠」功能（滑鼠移過去就可以輸入，不用點擊）
# defaults write com.apple.terminal FocusFollowsMouse -bool true
# defaults write org.x.X11 wm_ffm -bool true

# Install the Solarized Dark theme for iTerm
# [中文說明] 安裝 iTerm 的 Solarized Dark 主題
# open "${HOME}/init/Solarized Dark.itermcolors"

# Don’t display the annoying prompt when quitting iTerm
# [中文說明] 關閉 iTerm 時不要跳出確認視窗
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

###############################################################################
# Time Machine                                                                #
# [中文說明] Time Machine 備份設定                                             #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
# [中文說明] 插入新硬碟時，不要詢問是否用來做 Time Machine 備份
# defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable local Time Machine backups
# [中文說明] 停用本機快照備份
# hash tmutil &> /dev/null && sudo tmutil disablelocal

###############################################################################
# Activity Monitor                                                            #
# [中文說明] 活動監視器設定                                                    #
###############################################################################

# Show the main window when launching Activity Monitor
# [中文說明] 開啟活動監視器時顯示主視窗
# defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
# [中文說明] 在 Dock 圖示上顯示 CPU 使用率圖表
# defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
# [中文說明] 顯示所有程序（不僅是使用者的程序）
# defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
# [中文說明] 預設依 CPU 使用率排序
# defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
# defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
# [中文說明] 其他內建 App 設定                                                 #
###############################################################################

# Enable the debug menu in Address Book
# [中文說明] 在通訊錄啟用 Debug 選單
# defaults write com.apple.addressbook ABShowDebugMenu -bool true

# Enable Dashboard dev mode (allows keeping widgets on the desktop)
# [中文說明] 啟用 Dashboard 開發模式（允許將 Widget 拖到桌面上）
# defaults write com.apple.dashboard devmode -bool true

# Enable the debug menu in iCal (pre-10.8)
# [中文說明] 在 iCal 啟用 Debug 選單
# defaults write com.apple.iCal IncludeDebugMenu -bool true

# Use plain text mode for new TextEdit documents
# [中文說明] TextEdit 預設使用純文字模式（而非 RTF）
defaults write com.apple.TextEdit RichText -int 0
# Open and save files as UTF-8 in TextEdit
# [中文說明] TextEdit 開啟與儲存預設使用 UTF-8 編碼
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Enable the debug menu in Disk Utility
# [中文說明] 在磁碟工具程式啟用 Debug 選單（可顯示隱藏磁區）
# defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
# defaults write com.apple.DiskUtility advanced-image-options -bool true

###############################################################################
# Mac App Store                                                               #
# [中文說明] App Store 設定                                                   #
###############################################################################

# Enable the WebKit Developer Tools in the Mac App Store
# [中文說明] 在 App Store 啟用 WebKit 開發者工具
# defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable Debug Menu in the Mac App Store
# [中文說明] 在 App Store 啟用 Debug 選單
# defaults write com.apple.appstore ShowDebugMenu -bool true

###############################################################################
# Messages                                                                    #
# [中文說明] 訊息 (iMessage) 設定                                              #
###############################################################################

# Disable automatic emoji substitution (i.e. use plain text smileys)
# [中文說明] 停用自動 Emoji 替換（輸入 :-) 不會變成圖示）
# defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false

# Disable smart quotes as it’s annoying for messages that contain code
# [中文說明] 在訊息中停用智慧引號
# defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

# Disable continuous spell checking
# [中文說明] 停用持續拼字檢查
# defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

###############################################################################
# Google Chrome & Google Chrome Canary                                        #
# [中文說明] Chrome 瀏覽器設定                                                 #
###############################################################################

# Allow installing user scripts via GitHub Gist or Userscripts.org
# [中文說明] 允許從 GitHub Gist 或 Userscripts 安裝腳本
defaults write com.google.Chrome ExtensionInstallSources -array "https://gist.githubusercontent.com/" "http://userscripts.org/*"
defaults write com.google.Chrome.canary ExtensionInstallSources -array "https://gist.githubusercontent.com/" "http://userscripts.org/*"

# Disable the all too sensitive backswipe
# [中文說明] 停用過於敏感的上一頁滑動手勢
# defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
# defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

# Use the system-native print preview dialog
# [中文說明] 使用系統原生的列印預覽，而非 Chrome 自己的
# defaults write com.google.Chrome DisablePrintPreview -bool true
# defaults write com.google.Chrome.canary DisablePrintPreview -bool true

###############################################################################
# GPGMail 2                                                                   #
###############################################################################

# Disable signing emails by default
# [中文說明] 預設不對新郵件進行 GPG 簽章
# defaults write ~/Library/Preferences/org.gpgtools.gpgmail SignNewEmailsByDefault -bool false

###############################################################################
# SizeUp.app                                                                  #
# [中文說明] SizeUp 視窗管理軟體設定                                            #
###############################################################################

# Start SizeUp at login
# [中文說明] 登入時啟動 SizeUp
defaults write com.irradiatedsoftware.SizeUp StartAtLogin -bool true

# Don’t show the preferences window on next start
# [中文說明] 下次啟動時不要顯示偏好設定視窗
defaults write com.irradiatedsoftware.SizeUp ShowPrefsOnNextStart -bool false

###############################################################################
# Sublime Text                                                                #
###############################################################################

# Install Sublime Text settings
# [中文說明] 複製 Sublime Text 設定檔（需有來源檔案）
# cp -r init/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text*/Packages/User/Preferences.sublime-settings 2> /dev/null

###############################################################################
# Transmission.app                                                            #
# [中文說明] Transmission BT 下載軟體設定                                      #
###############################################################################

# Use `~/Documents/Torrents` to store incomplete downloads
# [中文說明] 設定未完成下載的暫存目錄
# defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
# defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Documents/Torrents"

# Don’t prompt for confirmation before downloading
# [中文說明] 下載前不需確認
# defaults write org.m0k.transmission DownloadAsk -bool false

# Trash original torrent files
# [中文說明] 加入下載後將原始 .torrent 種子檔丟入垃圾桶
# defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

# Hide the donate message
# [中文說明] 隱藏捐款提示
# defaults write org.m0k.transmission WarningDonate -bool false
# Hide the legal disclaimer
# [中文說明] 隱藏免責聲明
# defaults write org.m0k.transmission WarningLegal -bool false

###############################################################################
# Twitter.app                                                                 #
###############################################################################

# Disable smart quotes as it’s annoying for code tweets
# [中文說明] 發推特時停用智慧引號（方便貼程式碼）
# defaults write com.twitter.twitter-mac AutomaticQuoteSubstitutionEnabled -bool false

# Show the app window when clicking the menu bar icon
# [中文說明] 點擊選單列圖示時顯示主視窗
# defaults write com.twitter.twitter-mac MenuItemBehavior -int 1

# Enable the hidden ‘Develop’ menu
# [中文說明] 啟用 Twitter App 隱藏的開發選單
# defaults write com.twitter.twitter-mac ShowDevelopMenu -bool true

# Open links in the background
# [中文說明] 在背景開啟連結
# defaults write com.twitter.twitter-mac openLinksInBackground -bool true

# Allow closing the ‘new tweet’ window by pressing `Esc`
# [中文說明] 允許按 Esc 關閉發推視窗
# defaults write com.twitter.twitter-mac ESCClosesComposeWindow -bool true

# Show full names rather than Twitter handles
# [中文說明] 顯示全名而非帳號 ID
# defaults write com.twitter.twitter-mac ShowFullNames -bool true

# Hide the app in the background if it’s not the front-most window
# [中文說明] 如果不是最上層視窗則在背景隱藏
# defaults write com.twitter.twitter-mac HideInBackground -bool true

#QuickLook Enable Text Selection in Quick Look Windows
# [中文說明] 重複設定：允許 QuickLook 選取文字
defaults write com.apple.finder QLEnableTextSelection -bool TRUE



###############################################################################
# Kill affected applications                                                  #
# [中文說明] 重新啟動受影響的應用程式以套用設定                                   #
###############################################################################

for app in "Dock" "Finder"; do
	killall "${app}" > /dev/null 2>&1
done
echo "完成。注意某些設定需要登出或重開機才會生效。"
# echo "Done. Note that some of these changes require a logout/restart to take effect."
# [中文說明] 完成。注意某些設定需要登出或重開機才會生效。
