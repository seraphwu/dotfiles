<#
.SYNOPSIS
    Windows Dotfiles Installer (Fix FZF & Zoxide)
#>

$DotfilesDir = Split-Path -Parent $PSScriptRoot
$UserHome = $env:USERPROFILE

Write-Host "🚀 Starting Windows Setup..." -ForegroundColor Cyan

# 1. 安裝 Scoop
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Scoop..." -ForegroundColor Yellow
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    irm get.scoop.sh | iex
}

# 2. 安裝必要 Buckets & Apps
scoop bucket add extras
scoop bucket add nerd-fonts
scoop bucket add java

$Apps = @("git", "sudo", "oh-my-posh", "terminal-icons", "posh-git", "zoxide", "fzf", "eza", "scoop-search", "jq", "fd", "bat")
Write-Host "📦 Installing Core Tools..." -ForegroundColor Yellow
foreach ($App in $Apps) { scoop install $App }

# 補裝 PowerShell Gallery 模組 (Scoop 沒包的)
Write-Host "📦 Installing PowerShell Modules..." -ForegroundColor Yellow
if (-not (Get-Module -ListAvailable PSFzf)) {
    Install-Module PSFzf -Scope CurrentUser -Force -AllowClobber
}

# 匯入軟體清單
$ScoopFile = "$PSScriptRoot\scoopfile.json"
if (Test-Path $ScoopFile) { scoop import $ScoopFile }

# 3. 建立連結 (Symlinks)
$Links = @{
    "$DotfilesDir\windows\Microsoft.PowerShell_profile.ps1" = "$UserHome\Documents\PowerShell\Microsoft.PowerShell_profile.ps1";
    "$DotfilesDir\git\gitconfig.symlink" = "$UserHome\.gitconfig"; 
}

foreach ($Link in $Links.GetEnumerator()) {
    $Src = $Link.Key
    $Dst = $Link.Value
    $DstDir = Split-Path -Parent $Dst

    if (-not (Test-Path $DstDir)) { New-Item -ItemType Directory -Path $DstDir | Out-Null }

    if (Test-Path $Dst) {
        # 檢查是否已經是正確的 Symlink，是的話就跳過
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

Write-Host "🎉 Setup Complete! Please restart PowerShell." -ForegroundColor Cyan
