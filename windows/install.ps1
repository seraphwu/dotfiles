<#
.SYNOPSIS
    Windows Dotfiles Installer (Added Docker Support)
#>

$DotfilesDir = Split-Path -Parent $PSScriptRoot
$UserHome = $env:USERPROFILE

Write-Host "🚀 Starting Windows Setup..." -ForegroundColor Cyan

# -----------------------------------------------------------------------------
# 1. 系統層級軟體安裝 (Docker Desktop)
# -----------------------------------------------------------------------------
# 使用 Winget 安裝 Docker (比 Scoop 更適合安裝驅動層級軟體)
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "🐳 Docker not found. Installing Docker Desktop via Winget..." -ForegroundColor Yellow
    
    # 檢查 Winget 是否可用
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        # 安裝 Docker Desktop
        winget install -e --id Docker.DockerDesktop --accept-source-agreements --accept-package-agreements
        
        Write-Host "⚠️ Docker installed. You may need to RESTART Windows/WSL for it to work." -ForegroundColor Red
        Write-Host "   Please ensure WSL 2 is enabled (wsl --install)." -ForegroundColor Gray
    } else {
        Write-Host "❌ Winget not found. Please install Docker Desktop manually." -ForegroundColor Red
    }
} else {
    Write-Host "✅ Docker is already installed." -ForegroundColor Green
}

# -----------------------------------------------------------------------------
# 2. Scoop 安裝與設定
# -----------------------------------------------------------------------------
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Scoop..." -ForegroundColor Yellow
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    irm get.scoop.sh | iex
}

scoop bucket add extras
scoop bucket add nerd-fonts
scoop bucket add java

$Apps = @("git", "sudo", "oh-my-posh", "terminal-icons", "posh-git", "zoxide", "fzf", "eza", "scoop-search", "jq", "fd", "bat")
Write-Host "📦 Installing Core Tools..." -ForegroundColor Yellow
foreach ($App in $Apps) { scoop install $App }

# 補裝 PowerShell Gallery 模組 (Scoop 沒包的)
if (-not (Get-Module -ListAvailable PSFzf)) {
    Write-Host "📦 Installing PSFzf Module..." -ForegroundColor Yellow
    Install-Module PSFzf -Scope CurrentUser -Force -AllowClobber
}

# 匯入軟體清單
$ScoopFile = "$PSScriptRoot\scoopfile.json"
if (Test-Path $ScoopFile) { scoop import $ScoopFile }

# -----------------------------------------------------------------------------
# 3. 建立連結 (Symlinks) - 智慧路徑偵測版
# -----------------------------------------------------------------------------

# 定義可能的 Terminal 設定檔路徑
$ScoopTerminalPath = "$env:USERPROFILE\scoop\persist\windows-terminal\settings.json"
$StoreTerminalPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$TargetTerminalPath = $null

# 自動判斷路徑
if (Test-Path "$(Split-Path $ScoopTerminalPath -Parent)") {
    $TargetTerminalPath = $ScoopTerminalPath
    Write-Host "🔎 Detected Scoop version of Windows Terminal." -ForegroundColor Gray
} elseif (Test-Path "$(Split-Path $StoreTerminalPath -Parent)") {
    $TargetTerminalPath = $StoreTerminalPath
    Write-Host "🔎 Detected Store/Winget version of Windows Terminal." -ForegroundColor Gray
}

# 定義基本連結
$Links = @{
    "$DotfilesDir\windows\Microsoft.PowerShell_profile.ps1" = "$UserHome\Documents\PowerShell\Microsoft.PowerShell_profile.ps1";
    "$DotfilesDir\git\gitconfig.symlink" = "$UserHome\.gitconfig";
}

# 如果找得到 Terminal 路徑，才加入連結清單
if ($TargetTerminalPath) {
    $Links["$DotfilesDir\windows\Terminal\settings.json"] = $TargetTerminalPath
} else {
    Write-Host "⚠️  Windows Terminal not found. Skipping settings link." -ForegroundColor Yellow
}

# 執行連結邏輯 (保持不變)
foreach ($Link in $Links.GetEnumerator()) {
    $Src = $Link.Key
    $Dst = $Link.Value
    $DstDir = Split-Path -Parent $Dst

    if (-not (Test-Path $DstDir)) { New-Item -ItemType Directory -Path $DstDir | Out-Null }

    if (Test-Path $Dst) {
        $IsSymlink = (Get-Item $Dst).LinkType -eq "SymbolicLink"
        if ($IsSymlink) {
            Write-Host "✅ Link exists: $Dst" -ForegroundColor Gray
            continue
        }
        $Backup = "$Dst.bak.$(Get-Date -Format 'yyyyMMddHHmm')"
        Write-Host "⚠️  File exists. Backing up to $Backup" -ForegroundColor DarkGray
        Move-Item $Dst $Backup -Force
    }

    New-Item -ItemType SymbolicLink -Path $Dst -Target $Src | Out-Null
    Write-Host "🔗 Linked: $Dst -> $Src" -ForegroundColor Green
}

# -----------------------------------------------------------------------------
# 4. 全域設定
# -----------------------------------------------------------------------------
git config --global core.editor "code --wait"

Write-Host "🎉 Setup Complete! Please restart PowerShell." -ForegroundColor Cyan
