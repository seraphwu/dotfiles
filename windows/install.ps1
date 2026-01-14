<#
.SYNOPSIS
    Windows Dotfiles Installer (v2.6 - Seraph Edition)
    整合 Docker, Scoop, Fonts, SSH Config 與繁體中文介面
    Fixes: OneDrive Profile path & Terminal Preview support
#>

# 0. 初始化與變數定義
$ErrorActionPreference = "Stop"
$DotfilesDir = Split-Path -Parent $PSScriptRoot
$WindowsDir = $PSScriptRoot
$UserHome = $env:USERPROFILE
$ScoopFile = "$WindowsDir\scoopfile.json"
$ScoopFontsFile = "$WindowsDir\scoopfile.fonts.json"

# ASCII Banner
Write-Host "
  _       __ _            _                       
 | |     / /(_)____   ___| |____  _      __ _____ 
 | | /| / / / / __ \ / __  / __ \| | /| / / ___/
 | |/ |/ / / / / / // /_/ / /_/ /| |/ |/ (__  ) 
 |__/|__/_/_/_/ /_/ \__,_/\____/ |__/|__/____/  
                                                
      :: Seraph's Dotfiles Setup :: v2.6 ::
" -ForegroundColor Magenta

Write-Host "🚀 正在啟動 Windows 環境部署..." -ForegroundColor Cyan

# -----------------------------------------------------------------------------
# 1. 系統層級軟體安裝 (Docker Desktop via Winget)
# -----------------------------------------------------------------------------
Write-Host "`n[1/7] 🐳 檢查 Docker 環境..." -ForegroundColor Cyan

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "   ➜ 未偵測到 Docker，正在嘗試透過 Winget 安裝..." -ForegroundColor Yellow
    
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        try {
            # 使用 Winget 安裝
            winget install -e --id Docker.DockerDesktop --accept-source-agreements --accept-package-agreements
            
            Write-Host "   ⚠️  Docker 已安裝完成。" -ForegroundColor Red
            Write-Host "      請注意：您可能需要『重新啟動電腦』才能讓 WSL 2 生效。" -ForegroundColor Gray
            Write-Host "      提示：請確保已執行 'wsl --install'。" -ForegroundColor Gray
        } catch {
            Write-Host "   ❌ Winget 安裝失敗，請手動下載 Docker Desktop 安裝檔。" -ForegroundColor Red
        }
    } else {
        Write-Host "   ❌ 找不到 Winget，跳過 Docker 安裝。" -ForegroundColor Red
    }
} else {
    Write-Host "   ✅ Docker 已安裝。" -ForegroundColor Green
}

# -----------------------------------------------------------------------------
# 2. Scoop 核心安裝
# -----------------------------------------------------------------------------
Write-Host "`n[2/7] 🍨 檢查 Scoop 套件管理器..." -ForegroundColor Cyan

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "   ➜ 正在安裝 Scoop..." -ForegroundColor Yellow
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod -Uri [https://get.scoop.sh](https://get.scoop.sh) | Invoke-Expression
    Write-Host "   ✅ Scoop 安裝完成。" -ForegroundColor Green
} else {
    Write-Host "   ✅ Scoop 已安裝。" -ForegroundColor Green
}

# -----------------------------------------------------------------------------
# 3. 軟體清單匯入
# -----------------------------------------------------------------------------
Write-Host "`n[3/7] 📦 還原核心軟體清單 (Infrastructure as Code)..." -ForegroundColor Cyan

if (Test-Path $ScoopFile) {
    Write-Host "   ➜ 正在匯入 scoopfile.json (這可能需要一點時間)..." -ForegroundColor Yellow
    scoop import $ScoopFile
} else {
    Write-Host "   ❌ 找不到 scoopfile.json！請檢查檔案路徑。" -ForegroundColor Red
}

# -----------------------------------------------------------------------------
# 4. PowerShell Gallery 模組
# -----------------------------------------------------------------------------
Write-Host "`n[4/7] 🧩 檢查 PowerShell 擴充模組..." -ForegroundColor Cyan

if (-not (Get-Module -ListAvailable PSFzf)) {
    Write-Host "   ➜ 正在安裝 PSFzf (用於模糊搜尋)..." -ForegroundColor Yellow
    Install-Module PSFzf -Scope CurrentUser -Force -AllowClobber
} else {
    Write-Host "   ✅ PSFzf 已安裝。" -ForegroundColor Green
}

# -----------------------------------------------------------------------------
# 5. 互動式字體安裝
# -----------------------------------------------------------------------------
Write-Host "`n[5/7] 🎨 字體安裝 (Nerd Fonts)" -ForegroundColor Cyan
Write-Host "   ℹ️  核心字體 (Maple-Mono-NF-CN) 已包含在主清單中，將會自動安裝。" -ForegroundColor Gray
Write-Host "   ❓ 您是否想要下載並安裝『額外』的 Nerd Fonts？(下載量約 2GB+)" -ForegroundColor Yellow

$InstallFonts = Read-Host "      請輸入 [y] 安裝，或直接按 [Enter] 跳過"

if ($InstallFonts -match "^[yY]$") {
    if (Test-Path $ScoopFontsFile) {
        Write-Host "   ➜ 正在匯入額外字體庫..." -ForegroundColor Magenta
        scoop import $ScoopFontsFile
    } else {
        Write-Host "   ⚠️  找不到 scoopfile.fonts.json，跳過安裝。" -ForegroundColor Red
    }
} else {
    Write-Host "   ⏭️  已跳過額外字體安裝。" -ForegroundColor Gray
}

# -----------------------------------------------------------------------------
# 6. 建立連結 (Symlinks)
# -----------------------------------------------------------------------------
Write-Host "`n[6/7] 🔗 建立設定檔連結 (Symlinks)..." -ForegroundColor Cyan

# A. 偵測 Windows Terminal (含 Preview)
$ScoopTerminalPath = "$env:USERPROFILE\scoop\persist\windows-terminal\settings.json"
$StoreTerminalPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$PreviewTerminalPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
$TargetTerminalPath = $null

if (Test-Path "$(Split-Path $ScoopTerminalPath -Parent)") {
    $TargetTerminalPath = $ScoopTerminalPath
    Write-Host "   🔎 偵測到 Scoop 版 Windows Terminal" -ForegroundColor Gray
} elseif (Test-Path "$(Split-Path $StoreTerminalPath -Parent)") {
    $TargetTerminalPath = $StoreTerminalPath
    Write-Host "   🔎 偵測到 Store/Winget 版 Windows Terminal" -ForegroundColor Gray
} elseif (Test-Path "$(Split-Path $PreviewTerminalPath -Parent)") {
    $TargetTerminalPath = $PreviewTerminalPath
    Write-Host "   🔎 偵測到 Preview 版 Windows Terminal" -ForegroundColor Gray
}

# B. 定義連結清單
# 使用 $PROFILE 自動變數解決 OneDrive 路徑偏移問題
$Links = @{
    "$WindowsDir\Microsoft.PowerShell_profile.ps1" = $PROFILE;
    "$DotfilesDir\.gitconfig"                      = "$UserHome\.gitconfig";
    "$DotfilesDir\ssh\config"                      = "$UserHome\.ssh\config";
}

if ($TargetTerminalPath) {
    $Links["$WindowsDir\Terminal\settings.json"] = $TargetTerminalPath
} else {
    Write-Host "   ⚠️  找不到 Windows Terminal，跳過設定檔連結。" -ForegroundColor Yellow
}

# C. 確保目錄存在
# 自動偵測 Profile 父目錄 (可能是 OneDrive/Documents/PowerShell)
$ProfileDir = Split-Path -Parent $PROFILE
if (!(Test-Path $ProfileDir)) { 
    New-Item -ItemType Directory -Force -Path $ProfileDir | Out-Null 
    Write-Host "   📁 建立 Profile 目錄: $ProfileDir" -ForegroundColor Gray
}

if (!(Test-Path "$UserHome\.ssh")) { 
    New-Item -ItemType Directory -Force -Path "$UserHome\.ssh" | Out-Null 
}

# D. 執行連結
foreach ($Link in $Links.GetEnumerator()) {
    $Src = $Link.Key
    $Dst = $Link.Value

    if (-not (Test-Path $Src)) {
        Write-Host "   ❌ 來源遺失: $Src" -ForegroundColor Red
        continue
    }

    if (Test-Path $Dst) {
        $Item = Get-Item $Dst
        if ($Item.LinkType -eq "SymbolicLink") {
            Write-Host "   ✅ 連結已存在: $(Split-Path $Dst -Leaf)" -ForegroundColor DarkGray
            continue
        } else {
            $Backup = "$Dst.bak.$(Get-Date -Format 'yyyyMMddHHmm')"
            Write-Host "   ⚠️  發現舊檔，已備份至: $Backup" -ForegroundColor DarkGray
            Move-Item $Dst $Backup -Force
        }
    }

    try {
        New-Item -ItemType SymbolicLink -Path $Dst -Target $Src | Out-Null
        Write-Host "   🔗 連結成功: $(Split-Path $Dst -Leaf) -> $(Split-Path $Src -Leaf)" -ForegroundColor Green
    } catch {
        Write-Host "   ❌ 連結失敗: $Dst (請嘗試以系統管理員身分執行)" -ForegroundColor Red
    }
}

# -----------------------------------------------------------------------------
# 7. 全域設定與收尾
# -----------------------------------------------------------------------------
Write-Host "`n[7/7] 🔧 套用全域設定..." -ForegroundColor Cyan
git config --global core.editor "code --wait"

Write-Host "`n🎉🎉🎉 安裝流程全部完成！ 🎉🎉🎉" -ForegroundColor Magenta
Write-Host "   請務必『重新啟動 PowerShell』以載入新的設定檔與字體。" -ForegroundColor Yellow
Write-Host "   享受您的新環境吧！" -ForegroundColor Cyan