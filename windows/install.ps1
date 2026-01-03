<#
.SYNOPSIS
    Windows Dotfiles Installer (v2.8 - Seraph Edition)
    Feature: Nerd-Font Progress Bar & Manual Scoop JSON parsing
#>

# 0. 初始化與變數定義
$ErrorActionPreference = "Stop"
$DotfilesDir = Split-Path -Parent $PSScriptRoot
$WindowsDir = $PSScriptRoot
$UserHome = $env:USERPROFILE
$ScoopFile = "$WindowsDir\scoopfile.json"
$ScoopFontsFile = "$WindowsDir\scoopfile.fonts.json"

# 設定主控台編碼為 UTF8 以支援 Nerd Fonts
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# ASCII Banner
Write-Host "
  _       __ _           _                   
 | |     / /(_)____   ___| |____  _      __ _____ 
 | | /| / / / / __ \ / __  / __ \| | /| / / ___/
 | |/ |/ / / / / / // /_/ / /_/ /| |/ |/ (__  ) 
 |__/|__/_/_/_/ /_/ \__,_/\____/ |__/|__/____/  
                                                
       :: Seraph's Dotfiles Setup :: v2.8 ::
" -ForegroundColor Magenta

Write-Host "🚀 正在啟動 Windows 環境部署..." -ForegroundColor Cyan

# -----------------------------------------------------------------------------
# helper: 進度條函數 (Nerd Fonts 風格)
# -----------------------------------------------------------------------------
function Write-ProgressBar {
    param(
        [int]$Current,
        [int]$Total,
        [string]$Message
    )
    $Width = 30
    $Percent = $Current / $Total
    $Filled = [math]::Floor($Percent * $Width)
    $Empty = $Width - $Filled
    $PercentText = "{0:P0}" -f $Percent
    
    # Nerd Font / Unicode Blocks
    # ▰ = Completed, ▱ = Empty
    $Bar = ("▰" * $Filled) + ("▱" * $Empty)
    
    # 使用 `r 回到行首，實現刷新效果
    Write-Host "`r   $Bar $PercentText | $Message" -NoNewline -ForegroundColor Cyan
}

# -----------------------------------------------------------------------------
# 1. 系統層級軟體安裝 (Docker)
# -----------------------------------------------------------------------------
Write-Host "`n[1/7] 🐳 檢查 Docker 環境..." -ForegroundColor Cyan
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "   ➜ 嘗試透過 Winget 安裝 Docker..." -ForegroundColor Yellow
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        try {
            winget install -e --id Docker.DockerDesktop --accept-source-agreements --accept-package-agreements
            Write-Host "`n   ⚠️  Docker 安裝完成 (需重啟)。" -ForegroundColor Red
        } catch {
            Write-Host "`n   ❌ Winget 安裝失敗。" -ForegroundColor Red
        }
    }
} else {
    Write-Host "   ✅ Docker 已安裝。" -ForegroundColor Green
}

# -----------------------------------------------------------------------------
# 2. Scoop 核心安裝
# -----------------------------------------------------------------------------
Write-Host "`n[2/7] 🍨 檢查 Scoop..." -ForegroundColor Cyan
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "   ➜ 正在安裝 Scoop..." -ForegroundColor Yellow
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    Write-Host "   ✅ Scoop 安裝完成。" -ForegroundColor Green
} else {
    Write-Host "   ✅ Scoop 已安裝。" -ForegroundColor Green
}

# -----------------------------------------------------------------------------
# 3. 軟體清單匯入 (客製化進度條版)
# -----------------------------------------------------------------------------
Write-Host "`n[3/7] 📦 安裝核心軟體 (Nerd-Bar Mode)..." -ForegroundColor Cyan

if (Test-Path $ScoopFile) {
    try {
        # 解析 JSON
        $JsonData = Get-Content $ScoopFile -Raw | ConvertFrom-Json
        
        # A. 處理 Buckets
        $Buckets = $JsonData.buckets
        Write-Host "   ➜ 正在新增 Buckets..." -ForegroundColor DarkGray
        foreach ($Bucket in $Buckets) {
            # 靜默執行 bucket add
            scoop bucket add $Bucket.Name $Bucket.Source | Out-Null
        }
        
        # B. 處理 Apps (顯示進度條)
        $Apps = $JsonData.apps
        $TotalApps = $Apps.Count
        $Counter = 0
        
        Write-Host "   ➜ 開始安裝 $TotalApps 個軟體..." -ForegroundColor Yellow
        
        foreach ($App in $Apps) {
            $Counter++
            # 取得軟體名稱 (處理 JSON 結構差異)
            $AppName = if ($App.PSObject.Properties.Match('Name')) { $App.Name } else { $App }
            
            # 更新進度條
            Write-ProgressBar -Current $Counter -Total $TotalApps -Message "安裝: $AppName"
            
            # 執行安裝 (隱藏輸出，只顯示錯誤)
            # 使用 global $False 確保裝在 user scope
            scoop install $AppName | Out-Null
        }
        Write-Host "`n   ✅ 軟體安裝作業完成！" -ForegroundColor Green

    } catch {
        Write-Host "`n   ❌ JSON 解析或安裝失敗: $_" -ForegroundColor Red
        Write-Host "   ➜ 嘗試回退到標準 import 模式..."
        scoop import $ScoopFile
    }
} else {
    Write-Host "   ❌ 找不到 scoopfile.json" -ForegroundColor Red
}

# -----------------------------------------------------------------------------
# 4. PowerShell Gallery
# -----------------------------------------------------------------------------
Write-Host "`n[4/7] 🧩 檢查 PowerShell 模組..." -ForegroundColor Cyan
if (-not (Get-Module -ListAvailable PSFzf)) {
    Write-Host "   ➜ 安裝 PSFzf..." -ForegroundColor Yellow
    Install-Module PSFzf -Scope CurrentUser -Force -AllowClobber | Out-Null
    Write-Host "   ✅ PSFzf 安裝完成" -ForegroundColor Green
} else {
    Write-Host "   ✅ PSFzf 已安裝" -ForegroundColor Green
}

# -----------------------------------------------------------------------------
# 5. 字體安裝
# -----------------------------------------------------------------------------
Write-Host "`n[5/7] 🎨 字體安裝" -ForegroundColor Cyan
Write-Host "   ❓ 下載額外 Nerd Fonts? (2GB+)" -ForegroundColor Yellow
$InstallFonts = Read-Host "      [y] 安裝 / [Enter] 跳過"

if ($InstallFonts -match "^[yY]$" -and (Test-Path $ScoopFontsFile)) {
    # 這裡也可以套用進度條，但為了簡單，我們維持 import
    # 或是你可以把上面的邏輯複製下來用在這裡
    Write-Host "   ➜ 正在匯入字體庫 (標準模式)..." -ForegroundColor Magenta
    scoop import $ScoopFontsFile
} else {
    Write-Host "   ⏭️  已跳過。" -ForegroundColor Gray
}

# -----------------------------------------------------------------------------
# 6. 建立連結 (Symlinks)
# -----------------------------------------------------------------------------
Write-Host "`n[6/7] 🔗 建立設定檔連結..." -ForegroundColor Cyan

# 偵測 Terminal 路徑
$ScoopTerminalPath = "$env:USERPROFILE\scoop\persist\windows-terminal\settings.json"
$StoreTerminalPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$TargetTerminalPath = if (Test-Path $(Split-Path $ScoopTerminalPath -Parent)) { $ScoopTerminalPath } elseif (Test-Path $(Split-Path $StoreTerminalPath -Parent)) { $StoreTerminalPath } else { $null }

$Links = @{
    "$WindowsDir\Microsoft.PowerShell_profile.ps1" = $PROFILE;
    "$DotfilesDir\.gitconfig"                      = "$UserHome\.gitconfig";
    "$DotfilesDir\ssh\config"                      = "$UserHome\.ssh\config";
    "$DotfilesDir\lazygit\config.yml"              = "$env:LOCALAPPDATA\lazygit\config.yml";
}
if ($TargetTerminalPath) { $Links["$WindowsDir\Terminal\settings.json"] = $TargetTerminalPath }

# 建立目錄
if (!(Test-Path "$(Split-Path $PROFILE -Parent)")) { New-Item -ItemType Directory -Force -Path "$(Split-Path $PROFILE -Parent)" | Out-Null }
if (!(Test-Path "$UserHome\.ssh")) { New-Item -ItemType Directory -Force -Path "$UserHome\.ssh" | Out-Null }
if (!(Test-Path "$env:LOCALAPPDATA\lazygit")) { New-Item -ItemType Directory -Force -Path "$env:LOCALAPPDATA\lazygit" | Out-Null }

foreach ($Link in $Links.GetEnumerator()) {
    $Src = $Link.Key; $Dst = $Link.Value
    if (-not (Test-Path $Src)) { Write-Host "   ❌ 遺失: $(Split-Path $Src -Leaf)" -ForegroundColor Red; continue }
    
    if (Test-Path $Dst) {
        if ((Get-Item $Dst).LinkType -eq "SymbolicLink") { 
            Write-Host "   ✅ 已連結: $(Split-Path $Dst -Leaf)" -ForegroundColor DarkGray; continue 
        }
        Move-Item $Dst "$Dst.bak.$(Get-Date -Format 'yyyyMMddHHmm')" -Force
    }
    New-Item -ItemType SymbolicLink -Path $Dst -Target $Src | Out-Null
    Write-Host "   🔗 連結: $(Split-Path $Dst -Leaf)" -ForegroundColor Green
}

# -----------------------------------------------------------------------------
# 7. 收尾
# -----------------------------------------------------------------------------
Write-Host "`n[7/7] 🔧 完成設定" -ForegroundColor Cyan
git config --global core.editor "code --wait"
Write-Host "`n🎉 全部完成！請重啟 PowerShell。" -ForegroundColor Magenta