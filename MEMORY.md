# MEMORY（這個 repo 的長期事實與決定）

## 安全
- 本 repo 是**公開**的。不 commit 私鑰、token、Wi-Fi 名稱/密碼、帳號密碼。
- `windows/autounattend.xml`（含 Wi-Fi 與帳號密碼）只放本機與 Ventoy 隨身碟，已在 `.gitignore`。repo 裡只放 `windows/setup/autounattend.xml`（由 `New-PublicUnattend.ps1` 產生）。
- SSH 私鑰存在 Bitwarden，不放 OneDrive、不放 repo。

## Windows 應答檔的決定
- 以 Ventoy 版（schneegans 產生器，2026-03）為底，之後的修改都是手動的；**不要**用第 3 行的產生器網址重新產生（會失去所有自訂）。自訂處以 `[custom]` / `[自訂]` 註解標示。
- 使用者設定（HKCU）一律放 UserOnce 或 FirstLogon；specialize 以 SYSTEM 執行，寫 HKCU 不會到使用者身上。
- UAC 開啟（`EnableLUA=1`）、管理員提權不詢問（`ConsentPromptBehaviorAdmin=0`）：因為 Scoop 拒絕在管理員權限下安裝。
- 帳號 `seraphwu` 在 Administrators 群組（平常一般權限、需要時自動提權），開機永久自動登入（密碼存 Winlogon，可遠端桌面登入）。
- Wi-Fi 在首次登入（FirstLogon 第一步）才連，OOBE 期間不連網。
- 移除 Xbox 與剪取工具，並以 `systray.exe` 接手 `ms-gamebar` / `ms-gamebarservices`、關閉 `PrintScreenKeyForSnippingEnabled`，避免跳出「需要新的應用程式」。
- 桌布用本機 `C:\Windows\Web\Wallpaper\Windows\img19.jpg`，不上網下載。
- 不關閉通知、不設 `AutoEndTasks`（使用者需要 LINE/Discord 通知、怕關機遺失未存檔案）。
- 只切一個 C:（使用者決定）；備份用 4TB 外接硬碟。

## dotfiles 結構
- gitconfig：`git/gitconfig.shared`（共用）被 `.gitconfig`（Windows）與 `git/gitconfig.symlink`（Mac）include；dotfiles 必須在 `~/.dotfiles`。
- `ssh/config`：`github.com` 用 OpenSSH 預設金鑰（seraphwu），`github-meijiasha` 用 `~/.ssh/meijiasha/id_rsa`。不要把 meijiasha 金鑰加進 ssh-agent。
- `windows/install.ps1` 以 `MyDocuments\PowerShell\Microsoft.PowerShell_profile.ps1` 為 profile 連結目標（不用 `$PROFILE`）。
- scoopfile 用 `windows/export.ps1` 匯出（自動拆成核心與字體兩份）。
- 文件、註解用繁體中文；`.cmd` 內的註解用英文（cmd 以系統 ANSI 編碼讀檔）。
