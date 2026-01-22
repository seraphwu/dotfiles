# 使用 brew bundle dump --describe --force --file="~/brewfile" 可以產生說明
tap "bigwig-club/brew"
tap "buo/cask-upgrade"
tap "dart-lang/dart"
tap "lihaoyun6/tap"
tap "sass/sass"
tap "koekeishiya/formulae"

# ==========================================
# [GLOBAL] 核心 CLI 工具 (兩台都裝)
# 說明：CLI 工具佔用資源極少，為了保持操作習慣一致，建議全部保留
# ==========================================
brew "git"
brew "sevenzip"
brew "duti"
brew "openssl"
brew "autoconf"
brew "bash"
brew "bat"
brew "icu4c"
brew "brew-cask-completion"
brew "coreutils"
brew "dnsmasq", restart_service: :changed
brew "ecm"
brew "eza"
brew "fd"
brew "libass"
brew "ffmpeg"             # 雖然編譯久，但作為轉檔機很實用
brew "ffmpegthumbnailer"
brew "findutils"
brew "fzf"
brew "gnupg"
brew "go"
# brew "trash-cli"
brew "grc"
brew "groonga"
brew "handbrake", link: false # 轉檔核心
brew "btop"               # 監控系統必備
brew "ttygif"
brew "httpd"
brew "curlie"
brew "httrack"            # 備份網站用
brew "hugo"               # 寫 Blog 用
brew "imagemagick"
brew "irssi"
brew "joe"
brew "zoxide"
brew "task"
brew "lazygit"            # 必備 Git GUI
brew "helix"              # 輕量編輯器
brew "jq"
brew "libiconv"
brew "libyaml"
brew "mackup"             # 同步設定檔用
brew "mas"
brew "mkvtoolnix"         # 影片處理
brew "multimarkdown"
brew "tmux"               # 終端機多工必備
brew "exiftool"
brew "pandoc"
brew "gemini-cli"
cask "syncthing-app"          # 同步檔案必備
brew "nvm"
brew "opencc"
brew "openvpn"
brew "pipx"
brew "pkgconf"
brew "poppler"
brew "putty"
brew "pyenv"
brew "rbenv"
brew "ripgrep"
brew "scrcpy"             # 安卓投屏 (輕量)
brew "ssh-copy-id"
brew "stow"
brew "utf8proc", args: ["HEAD"]
brew "subversion"
brew "trash", link: true
brew "tree"
brew "unar"
brew "wget"
brew "superfile"
brew "yazi"               # 檔案管理器 (Rust版，快)
brew "zsh"
brew "zsh-autosuggestions"
brew "zsh-completions"
brew "zsh-git-prompt"
brew "zsh-syntax-highlighting"
brew "sass/sass/sass"
brew "uv"
brew "m-cli"

# ==========================================
# [GLOBAL] 必裝字體
# ==========================================
cask "font-jetbrains-maple-mono-nf"
cask "font-maple-mono-nf-cn"
cask "font-noto-sans-cjk"
cask "font-noto-serif-cjk"
cask "font-noto-nerd-font"
cask "font-iosevka-nerd-font"
cask "font-iosevka-term-nerd-font"

# ==========================================
# [GLOBAL] 輕量級/功能性 GUI App (2013 跑得動且實用)
# ==========================================
cask "bitwarden"          # 密碼管理
cask "hiddenbar"          # 整理 Menu Bar
cask "espanso"            # 文字替換 (Rust寫的，輕量)
cask "openinterminal"
cask "aegisub"            # 字幕編輯 (輕量)
cask "aldente"            # 電池保養 (老機器必備)
# cask "alfred"             # 啟動器 (比 Raycast 省資源)
cask "alt-tab"            # 視窗切換
cask "popclip"
cask "shottr"             # 截圖 (輕量)
cask "apparency"
cask "appcleaner"         # 移除軟體
cask "applite"
cask "betterzip"
cask "beyond-compare"
cask "calibre"            # 電子書管理
cask "coconutbattery"     # 電池健康度
cask "commander-one"      # 雙欄檔案管理
cask "cyberduck"          # FTP/SFTP
# cask "db-browser-for-sqlite"
cask "findergo"
cask "fliqlo"             # 螢幕保護程式
# cask "flux"               # 護眼 (老機器沒有 Night Shift)
# cask "github"
cask "handbrake-app"          # 影片轉檔 GUI
cask "iina"               # 播放器 (比 VLC 現代且高效)
cask "iterm2"             # 終端機
cask "itsycal"            # 狀態列日曆
# cask "joplin"             # 筆記 (如果你用 Obsidian，這個可考慮拿掉)
cask "keka"               # 解壓縮
cask "keycastr"
cask "keyclu"
cask "kodi"               # 媒體中心
cask "localsend"          # 區網傳檔 (必備)
cask "loop"               # 視窗管理
cask "losslesscut"        # 無損剪輯
cask "maccy"              # 剪貼簿管理 (輕量)
cask "macs-fan-control"   # 風扇控制 (老機器散熱重要)
cask "marta"              # 檔案管理 (極輕量)
cask "mounty"             # NTFS 讀寫
cask "netnewswire"        # (建議) RSS 閱讀器，比 web 輕
cask "obsidian"           # [核心] 知識庫
cask "notion-calendar"
cask "nvalt"              # 極簡筆記
cask "qbittorrent"        # BT 下載
# cask "qlcolorcode"
cask "qlmarkdown"
cask "qlstephen"
cask "qlvideo"
cask "quicklook-csv"
# cask "quicklook-json"
cask "glance-chamburr", args: { no_quarantine: true }
cask "syntax-highlight", args: { no_quarantine: true }
cask "quicklookase"
cask "raycast"            # 雖然略重，但為了同步習慣保留
cask "reminders-menubar"
cask "switchhosts"
cask "switchkey"
cask "textmate"           # 極簡編輯器
# cask "the-unarchiver"
cask "tor-browser"
cask "bigwig-club/brew/upic" # 圖床工具
cask "visual-studio-code" # 雖然是 Electron，但寫 Code 必備
# cask "vlc"
cask "welly"              # BBS
cask "zed"                # Rust 編輯器 (高性能，推薦在老機器用)

# 下載專用工具 (適合在 2013 上掛機跑)
cask "4k-stogram"
cask "4k-video-downloader+"
cask "4k-youtube-to-mp3"

# ==========================================
# [M-SERIES ONLY] 重型/現代/設計/娛樂軟體
# 說明：這些軟體在 2013 上跑不動、沒必要、或有圖形 Bug
# ==========================================
if Hardware::CPU.arm?
    # --- 系統增強 ---
    brew "yabai"          # 視窗管理 (Intel 版需關 SIP 且不穩)
    brew "skhd"
    cask "dockdoor"       # 現代化預覽 (吃顯卡)
    cask "topnotch"       # 隱藏瀏海 (2013 沒瀏海)
    cask "monitorcontrol" # 2013 螢幕亮度通常直接由系統控

    # --- AI & 重運算 ---
    brew "ollama", restart_service: :changed
    cask "upscayl"        # AI 放大 (沒顯卡跑不動)
    cask "comfyui"        # AI 繪圖
    cask "docker"         # Docker Desktop (Intel 版非常重)

    # --- 瀏覽器 (Arc 很吃資源) ---
    cask "arc"
    cask "brave-browser"
    cask "microsoft-edge"
    # 2013 建議用內建 Safari 或輕量的 Firefox/Orion

    # --- 設計與創意 (Web/Metal 重度依賴) ---
    cask "figma"
    cask "framer"
    cask "gimp"
    cask "inkscape"
    cask "scribus"
    cask "synfigstudio"
    cask "couleurs"       # 選色器
    cask "pika"

    # --- 影音剪輯/錄製 (需要硬體編碼) ---
    cask "obs"            # 直播/錄影
    cask "openshot-video-editor"
    cask "shotcut"
    cask "cap"            # 螢幕錄製 (Web based)
    cask "quickrecorder"
    cask "macwhisper"     # 語音轉文字 (依賴 Neural Engine)

    # --- 社交與通訊 (Electron 記憶體怪獸) ---
    cask "discord"
    cask "slack"
    cask "telegram"       # 其實 Telegram Native 還好，但為了專注可移走
    cask "franz"          # 聚合通訊 (非常重)
    cask "rocket"         # Emoji picker

    # --- 遊戲與娛樂 ---
    cask "steam"
    cask "battle-net"
    cask "openemu@experimental" # 其實 2013 跑得動，看你想不想在上面玩
    cask "spotify"        # 2013 用網頁版或手機 AirPlay 即可，省 App 資源

    # --- 其他 ---
    cask "adobe-acrobat-reader" # 太肥大，用預覽程式即可
    cask "pronotes"
    cask "anytype"        # 類似 Notion，稍重
    cask "heptabase"      # 視覺筆記，吃圖形效能
    cask "wave"           # Wave Terminal (圖形化終端，重)
end

# ==========================================
# [MAS] Mac App Store
# ==========================================
mas "Magnet", id: 441258766        # 2013 最佳視窗管理方案
mas "Hidden Bar", id: 1452453066
mas "Amphetamine", id: 937984704   # 防休眠
# mas "Keka", id: 470158793          # 如果有買 MAS 版

if Hardware::CPU.arm?
    # 這些在舊機器可能沒必要裝
    mas "iMovie", id: 408981434
    mas "Keynote", id: 409183694
    mas "Numbers", id: 409203825
    mas "Pages", id: 409201541
    mas "Xcode", id: 497799835     # 2013 絕對跑不動現代 Xcode
    mas "Disk Speed Test", id: 425264550
end

# 載入字體清單
# 如果要合併時才需要這樣作

# eval(File.read(File.join(File.dirname(__FILE__), "Brewfile.fonts")))