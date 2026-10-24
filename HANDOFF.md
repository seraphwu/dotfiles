# HANDOFF：Windows 重灌（autounattend）— 2026-10-24

> 給接手的人或 AI：這份文件讓沒看過先前對話的人也能接著做。
> 這個 repo 是**公開**的，任何 Wi-Fi 名稱、密碼都**不能**寫進來。

## 目前狀態

- Ventoy 隨身碟已準備好，用來自動安裝 Windows 11（Home）。
- 應答檔（autounattend.xml）有兩份：

| 檔案 | 內容 | 位置 |
|---|---|---|
| **私人版** | 含 Wi-Fi 名稱/密碼、seraphwu 帳號密碼 | 本機 `~/.dotfiles/windows/autounattend.xml`（已加入 `.gitignore`），以及隨身碟 `F:\Templates\autounattend.xml` |
| **公開版** | 由私人版產生，移除 Wi-Fi、帳號、密碼（安裝時手動選 Wi-Fi、手動建帳號） | `windows/setup/autounattend.xml`（在 repo 裡） |

- 公開版的產生方式：`windows/setup/New-PublicUnattend.ps1`。私人版有改動時重跑它；它找不到預期內容、或輸出仍含 Wi-Fi/密碼時會直接中止。
- Ventoy 設定：`F:\ventoy\ventoy.json` 的 `auto_install` 指向 `/Templates/autounattend.xml`，套用在 `/ISO/Windows` 底下的 ISO。
- 隨身碟根目錄另有 `PowerShell-7.6.8-win-x64.msi`（離線安裝 PowerShell 7 用）、`lockscreen.png`（鎖定畫面）。
- 本機私人版與隨身碟一致（雜湊相同，2026-10-24 晚間更新）。最新 commit 見 `git log`。

## 安裝流程與各階段做的事（私人版）

| 階段 | 執行身分 | 主要內容 |
|---|---|---|
| windowsPE | — | **自動清空第一顆硬碟**並分割（整顆一個 C:）、版本 Home |
| specialize | SYSTEM | 移除 App（Xbox 全系列、剪取工具等）、`EnableLUA=1` + `ConsentPromptBehaviorAdmin=0`、深色桌布（讀本機 `img19.jpg`）、`unattend-01.ps1`：ms-gamebar / ms-gamebarservices 導向 `systray.exe`、DefaultUser 範本設定 |
| oobeSystem | — | 自動建立 `seraphwu`（**Administrators** 群組）、自動登入一次；OOBE 期間**沒有網路** |
| FirstLogon | seraphwu（提升權限） | ① 連 Wi-Fi 並等網路可用 → … → 安裝 PowerShell 7（先找隨身碟 MSI，找不到從 GitHub 下載，失敗在桌面留 `PowerShell7-安裝失敗.txt`）→ 刪除含密碼暫存檔 → **永久開啟自動登入**（密碼存 Winlogon DefaultPassword） |
| UserOnce | seraphwu（一般權限） | 深色模式、隱藏桌面圖示（含 OneDrive）、桌布、`unattend-05.cmd`（整理後的 itoc，51 條）、`unattend-03.ps1`（winget：Terminal、QuickLook、VS Code、Chrome、PowerShell；scoop + git、7zip；輸入法）、`unattend-04.cmd`（**5 秒後重開機**） |

## ⚠️ 已解決：啟動指令超過長度上限 → 「電腦意外地重新啟動」

**現象**：重灌時在第一次重開機後（ASUS 標誌＋轉圈圈）出現「電腦意外地重新啟動或發生意外的錯誤。Windows 無法進行安裝」。

**原因**（已由 `C:\Windows\Panther\setuperr.log` 確認）：
```
... Microsoft-Windows-Deployment ... /settings/RunSynchronous/RunSynchronousCommand/[Order="1"]/Path
... Description = 值無效。
The provided unattend file is not valid; hrResult = 0x80220005
```
另一台電腦上的 Claude 為了處理「卡住視窗」，在所有 `powershell.exe` 啟動指令加了 ` -NonInteractive`（16 字元），使 specialize **Order 1（解出所有腳本的指令）從 248 → 264 字元**，超過 `RunSynchronousCommand/Path` 的長度上限，整份應答檔被判定無效。日誌中失敗值為 530 bytes = 265 字元（含結尾），吻合。上限推測為 259 字元（未查證官方文件；已知 248、253 可用，264 失敗）。

**規則**：修改任何 `RunSynchronousCommand/Path` 或 `SynchronousCommand/CommandLine` 後都要檢查長度；**specialize Order 1 不能再加長**。

**修正（2026-10-24 晚間，以 14:04 版為底）**：
- `unattend-03.ps1`：QuickLook、VS Code、Chrome 的 winget 補上 `--accept-source-agreements --accept-package-agreements`；`Set-ExecutionPolicy ... -Force`（winget 保留，不像 16:31 版整段移除）
- PowerShell 7 下載：查詢最新版 `-TimeoutSec 30`、MSI 下載 `-TimeoutSec 300`
- `-NonInteractive` **只加在**：Specialize.ps1（143 字元）、DefaultUser.ps1（144）、FirstLogon.ps1（143）、UserOnce 的 RunOnce 值（141，RunOnce 上限 260）；Order 1 維持 248
- 全部啟動指令最長 253（windowsPE 原本的 `defender.vbs` 行）
- 隨身碟備份：`F:\Templates\backup\autounattend.20261024-before-noninteractive.xml`（14:04 版）、`F:\Templates\backup\autounattend.20261024-1631-too-long.xml`（無效的 16:31 版）

## ⚠️ 待確認：另一台重裝後卡住一個 PowerShell 視窗

那次安裝用的是 14:04 版（已進到桌面）。推測原因：各階段輸出導向日誌、啟動參數沒有 `-NonInteractive`，若 winget（缺同意條款參數）或 `Set-ExecutionPolicy`（缺 `-Force`）在等輸入，提示只會寫進日誌，視窗看起來像卡住。上述修正已處理這些，**尚未重裝驗證**。

若再發生，在那台電腦上看：
```powershell
# 進度列文字：'Running scripts to configure this user account' = UserOnce；'...finalize your Windows installation' = FirstLogon
Get-Content $env:TEMP\UserOnce.log -Tail 30
Get-Content C:\Windows\Setup\Scripts\FirstLogon.log -Tail 30
Get-Process winget, msiexec, powershell -ErrorAction SilentlyContinue | Select Name, Id, StartTime
```
日誌最後一行 `*** Will now execute command «…»` 就是正在執行的步驟。

## 安裝出錯時怎麼抓日誌

在錯誤畫面按 **Shift + F10**（cmd）。先 `echo list volume | diskpart` 找 Label 為 `Ventoy` 的代號（下例 `E:`）：
```
mkdir E:\setuplogs
copy C:\Windows\Panther\setup*.log E:\setuplogs\
xcopy /e /i /y C:\Windows\Panther\UnattendGC E:\setuplogs\UnattendGC
copy C:\Windows\Setup\Scripts\*.log E:\setuplogs\
```
- 在 windowsPE 階段（藍色背景、還沒重開機）沒有 C:：安裝程式在 `X:`，目標硬碟是 `W:`（應答檔 diskpart `ASSIGN LETTER=W`），日誌在 `X:\Windows\Panther\`。
- windowsPE 的 `cscript.exe defender.vbs` 視窗停在 `Scanning for newly created SYSTEM registry hive file...` 是正常的，會等系統登錄檔產生後自己關閉。
- `for %d in (...)` 寫法只能在 cmd 直接輸入，PowerShell 或 .bat 內不能用。

## 下一步：在剛重灌的電腦上檢查

用 PowerShell（不需系統管理員）執行，逐項對照預期值：

```powershell
# 1. 日誌是否有錯誤
Get-ChildItem C:\Windows\Setup\Scripts\*.log, $env:TEMP\UserOnce.log -ErrorAction SilentlyContinue | Select Name, Length, LastWriteTime
Select-String C:\Windows\Setup\Scripts\*.log, $env:TEMP\UserOnce.log -Pattern 'WARN|Warning|Error|Exception|failed' -ErrorAction SilentlyContinue | Select -First 40
Test-Path C:\Users\Public\Desktop\PowerShell7-安裝失敗.txt          # 預期 False

# 2. 帳號、UAC、自動登入
whoami /groups | Select-String 'Administrators'                      # 預期有（Administrators 群組）
whoami /groups | Select-String 'High Mandatory'                      # 預期沒有（平常是一般權限）
Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' | Select EnableLUA, ConsentPromptBehaviorAdmin   # 預期 1, 0
Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' | Select AutoAdminLogon, DefaultUserName, AutoLogonCount  # 預期 1, seraphwu, (空)

# 3. 軟體
Test-Path "$env:ProgramFiles\PowerShell\7\pwsh.exe"                  # 預期 True
Get-Command scoop, git, 7z -ErrorAction SilentlyContinue | Select Name, Source   # 預期都在 ~\scoop
winget list --accept-source-agreements | Select-String 'Terminal|QuickLook|Visual Studio Code|Chrome|PowerShell'
Get-AppxPackage *Xbox*, *GamingApp*, *ScreenSketch* | Select Name   # 預期只剩 Microsoft.XboxGameCallableUI（系統元件）

# 4. 設定
Get-ItemProperty 'HKCU:\Control Panel\Keyboard' | Select PrintScreenKeyForSnippingEnabled, InitialKeyboardIndicators, KeyboardDelay  # 預期 0, 2, 0
Get-ItemProperty 'HKCU:\Control Panel\Mouse' | Select MouseSpeed, MouseThreshold1, MouseThreshold2   # 預期 0, 0, 0（itoc 生效的證明）
Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' | Select SystemUsesLightTheme, AppsUseLightTheme  # 預期 0, 0
(Get-ItemProperty 'HKCU:\Control Panel\Desktop').WallPaper           # 預期 C:\Windows\Setup\Scripts\Wallpaper（內容為 img19.jpg）
(Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel').'{018D5C66-4533-4307-9B53-224DE2ED1FE6}'  # 預期 1（隱藏 OneDrive）
(Get-ItemProperty 'Registry::HKEY_CLASSES_ROOT\ms-gamebar\shell\open\command').'(default)'   # 預期 "C:\WINDOWS\System32\systray.exe"

# 5. 網路（Wi-Fi 應在首次登入時自動連上）
netsh wlan show interfaces | Select-String 'State|SSID'
```

手動確認：
- 重開機後是否**不用輸入密碼**就直接進桌面。
- 按 **PrtSc** 不會跳出剪取工具/商店提示；按 **Win+G** 不會跳出「需要新的應用程式」。
- 按 **Win+Shift+S** 會不會跳出提示（已知未處理，見下方）。

## 未解決 / 已知問題

1. **Win+Shift+S**（`ms-screenclip:`）沒有導向，剪取工具移除後推測仍會跳提示。可比照 ms-gamebar 加到 `unattend-01.ps1`。
2. 推測執行遊戲時可能出現 `ms-gamingoverlay:` 提示，未處理。
3. 「首次登入用完自動登入次數後，Windows 是否會自己關掉自動登入」未實測；FirstLogon 最後會重新開啟，需在新電腦確認。
4. FirstLogon 在 UAC 開啟下是否以提升權限執行（`netsh wlan add profile user=all` 需要）未實測。
5. 應答檔第 3 行產生器網址註解已過時（仍寫 `InteractiveLocal`、`DisableUac=true`、Pexels 桌布）；**不要**用它重新產生，否則所有自訂修改都會消失。
6. `F:\ISO\Windows\Windows11_Client_x64_zh-tw_26300_9457.iso`（build 26300）是否為正式版未確認。
7. 舊的公開 GitHub token 留在本 repo 歷史（commit `95b7120` 之前），需到 https://github.com/settings/tokens 撤銷。
8. OneDrive 網頁版回收筒裡的 `.ssh` 需手動永久刪除。
9. `windows/install.ps1` 仍有缺口：README 用 SSH clone（新電腦應改 HTTPS）、`scoop install` 錯誤被吞掉、字體詢問是互動式、未涵蓋 winget/VS Code 擴充/npm/uv 還原。
10. Mac 的 `script/bootstrap` 只連結 `*.symlink`，`ssh/config` 在 Mac 上不會被連結。

## 關鍵檔案

| 檔案 | 說明 |
|---|---|
| `windows/autounattend.xml` | 私人版（gitignore，只在原電腦與隨身碟） |
| `windows/setup/autounattend.xml` | 公開版 |
| `windows/setup/New-PublicUnattend.ps1` | 私人版 → 公開版 |
| `windows/install.ps1` | 重灌後還原 scoop、PowerShell profile、gitconfig、ssh config、Terminal 設定 |
| `windows/scoopfile.json`、`scoopfile.fonts.json` | scoop 清單（2026-10-23 匯出，已移除 helix/neovim/neovide/darktable/abdownloadmanager/kdenlive） |
| `.gitconfig` / `git/gitconfig.symlink` / `git/gitconfig.shared` | Windows 入口 / Mac 入口 / 共用設定 |
| `ssh/config` | GitHub 雙帳號（`github.com` = seraphwu，`github-meijiasha` = meijiasha） |
| `TODO.md`、`PROCESS.md`、`MEMORY.md` | 待辦、過程紀錄、長期決定 |

私鑰（`~/.ssh/id_rsa`、`~/.ssh/meijiasha/id_rsa`）在 Bitwarden，不在 repo。
