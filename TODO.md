# TODO

## 進行中
- [ ] 用目前版本重裝，確認不再出現「電腦意外地重新啟動」，也不再卡住 PowerShell 視窗
- [x] ~~「電腦意外地重新啟動」~~：16:31 版 Order 1 超過長度上限，已換回 14:04 版並重新修正（2026-10-24）
- [x] 卡住 PowerShell 視窗的推測原因已修正（winget 同意條款參數、`-Force`、`-NonInteractive`），待重裝驗證
- [ ] 在剛重灌的電腦上依 `HANDOFF.md`「下一步」檢查安裝結果

## 重灌前（原電腦 ASUS 15）
- [ ] 依重灌計畫備份資料到 4TB 硬碟（ComfyUI 模型、Downloads、Videos、Pictures、`scoop\persist`、`~\dev` 含 `.env`、`~\.claude` 等）
- [ ] 安裝 Windows 時拔掉 4TB 備份硬碟（應答檔會自動清空第一顆硬碟）
- [ ] 確認要用哪個 ISO（25H2 或 build 26300）

## 應答檔
- [ ] Win+Shift+S：把 `ms-screenclip` 導向 `systray.exe`（比照 ms-gamebar）
- [ ] 視情況處理 `ms-gamingoverlay:` 提示
- [ ] 確認永久自動登入在首次登入後仍有效
- [ ] 確認 FirstLogon 在 UAC 開啟下能 `netsh wlan add profile user=all`

## install.ps1 / dotfiles
- [ ] README 與流程改用 HTTPS clone（新電腦沒有 SSH 金鑰）
- [ ] `scoop install` 失敗時列出，不再 `Out-Null` 吞掉
- [ ] 字體安裝改為參數控制，不用 `Read-Host`
- [ ] 補 winget、VS Code 擴充、npm global、uv tools 的還原
- [ ] Mac bootstrap 連結 `ssh/config`

## 安全
- [ ] 撤銷 commit `95b7120` 前留在歷史中的 GitHub token
- [ ] OneDrive 網頁版回收筒永久刪除 `.ssh`

## 已完成
- [x] scoopfile 重新匯出並移除不用的 app（2026-10-23）
- [x] install.ps1 固定連結 PowerShell 7 profile 路徑
- [x] gitconfig 拆分共用 / Windows / Mac
- [x] ssh/config 雙帳號
- [x] 私鑰存入 Bitwarden，清除本機重複與 OneDrive 副本
- [x] autounattend：PowerShell 7、OneDrive 圖示、深色桌布、itoc 整理並改在 UserOnce、UAC、ms-gamebar、PrintScreen、首次登入連 Wi-Fi、自動建立帳號、永久自動登入
