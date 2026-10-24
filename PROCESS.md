# PROCESS

## 2026-10-23

- 盤點原電腦（單一 2TB SSD，剩 16GB）：ComfyUI 模型 765GB、Downloads 511GB、Videos 164GB、Pictures 51GB；寫成重灌計畫。
- `.dotfiles` fast-forward 遠端 15 個 commit（都是 macOS 檔案），用 `windows/export.ps1` 重新匯出 scoopfile（核心 148 + 字體 37），commit `33da327`。
- scoop：`cleanup *`（7zip 舊版 dll 被鎖，其餘 68 個清除）、`cache rm *`（15.1GB）；C: 剩餘從 25.7GB → 60.9GB。
- 移除 scoop app：helix、neovim、neovide、darktable、abdownloadmanager、kdenlive；scoopfile 剩核心 142。
- 發現 scoop 新版 manifest 檔名為 `scoop-manifest.json`（不是損壞）。
- `install.ps1`：profile 連結改用 `MyDocuments\PowerShell\...`，避免在 5.1 執行時連到 WindowsPowerShell。
- `windows/setup/autounattend.xml`：修正未跳脫的 `2>&1 >''`（XML 無法解析）、`unattend-01.ps1` 的 `::` 註解（語法錯誤導致整支不執行），加入 PowerShell 7 安裝區塊。
- `.ssh`：兩個 `.ssh`（本機、OneDrive）實際只有兩把私鑰（seraphwu、meijiasha）；存入 Bitwarden 後清除重複與 OneDrive 副本（移到回收筒）。
- 發現公開 repo 歷史中有舊 GitHub token（commit `95b7120` 刪除前的版本）。

## 2026-10-24

- gitconfig 拆成 `git/gitconfig.shared` + Windows 入口 `.gitconfig` + Mac 入口 `git/gitconfig.symlink`；`ssh/config` 加 `github-meijiasha` 別名。兩台的生效設定都比對過。
- 改以 Ventoy 版應答檔（2026-03，較新、cmd/ps1 分開）為主；私人版含 Wi-Fi 密碼 → `.gitignore`；新增 `New-PublicUnattend.ps1` 產生公開版。
- 另一台安裝後沒有 PowerShell 7：原因是隨身碟 `F:\Templates\autounattend.xml` 仍是舊版。已把私人版複製上去（舊版備份到 `F:\Templates\backup\autounattend.20260329.xml`）。
- 隱藏 OneDrive 桌面圖示（HideDesktopIcons 補 `{018D5C66-…}`）。
- 桌布：Ventoy 版用 Pexels 下載，改為讀本機 `img19.jpg`。
- itoc（`unattend-05.cmd`）原在 specialize/SYSTEM 執行 → HKCU 寫不到使用者；移到 UserOnce（在重開機的 unattend-04 之前）。整理 142 → 50 條（去重複、無效、ms-gamebar、關閉通知、AutoEndTasks；修正 WindowsAI 路徑），再加 PrintScreen 共 51 條。
- 參考 Winhance / optimizerDuck / Winslop：只有 Winhance 有 ms-gamebar 導向 `systray.exe`；三者都沒有 PrintScreen 設定。加到 `unattend-01.ps1`（PowerShell）與 `unattend-05.cmd`。
- UAC：曾改 `EnableLUA=0`，發現 scoop 安裝程式會拒絕在管理員權限下執行 → 改為 `EnableLUA=1` + `ConsentPromptBehaviorAdmin=0`。
- Wi-Fi 由 specialize 移到 FirstLogon 第一步（OOBE 期間無網路）；自動建立 `seraphwu`（Administrators，密碼沿用 2024 版應答檔）；FirstLogon 最後改為永久自動登入。公開版移除 Wi-Fi、帳號、密碼，並把永久自動登入換回「關閉自動登入」。
- 使用者回報另一台重裝後卡住一個 PowerShell 視窗；初步查到 `unattend-03.ps1` 有 3 行 winget 缺 `--accept-package-agreements`、`Set-ExecutionPolicy` 缺 `-Force`，且輸出導向日誌、無 `-NonInteractive`，提示看不到。尚未在那台確認與修正。
- 驗證方式：每次修改都檢查 XML 可解析、內嵌 PowerShell 用 5.1 解析器檢查語法、關鍵區塊寫到 HKCU 測試機碼實際執行後刪除、私人版與隨身碟比對雜湊、公開版掃描不含 Wi-Fi/密碼。**未實際重灌驗證整個流程。**
