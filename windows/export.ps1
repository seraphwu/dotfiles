<#
.SYNOPSIS
    Smart Scoop Export (Visualized)
    自動分離核心軟體與字體庫，保持 Dotfiles 整潔。
#>

$ErrorActionPreference = "Stop"
$DotfilesDir = $PSScriptRoot
$MainFile    = "$DotfilesDir\scoopfile.json"
$FontsFile   = "$DotfilesDir\scoopfile.fonts.json"

# ── 分類規則（集中管理）──────────────────────────────
$FontSource     = 'nerd-fonts'
$FontExceptions = @('Maple-Mono-NF-CN')   # 雖屬 nerd-fonts，但 PowerShell 需要，歸入 Core

# ── 工具函式 ─────────────────────────────────────────

function Write-Typewriter {
    param([string]$Text, [ConsoleColor]$Color = 'White', [int]$Delay = 18)
    $Text.ToCharArray() | ForEach-Object {
        Write-Host $_ -NoNewline -ForegroundColor $Color
        Start-Sleep -Milliseconds $Delay
    }
    Write-Host ""
}

function Invoke-WithSpinner {
    param([scriptblock]$ScriptBlock, [string]$Message, [ConsoleColor]$Color = 'Yellow')
    $frames  = @('⠋','⠙','⠹','⠸','⠼','⠴','⠦','⠧','⠇','⠏')
    $job     = Start-Job -ScriptBlock $ScriptBlock
    $i       = 0
    while ($job.State -eq 'Running') {
        $frame = $frames[$i % $frames.Length]
        Write-Host "`r  $frame $Message" -NoNewline -ForegroundColor $Color
        Start-Sleep -Milliseconds 80
        $i++
    }
    Write-Host "`r  ✔ $Message" -ForegroundColor $Color
    return (Receive-Job $job -Wait -AutoRemoveJob)
}

# ── Banner ───────────────────────────────────────────
Write-Host ""
Write-Typewriter "   ____                 ___       "        Magenta 8
Write-Typewriter "  / __/___ __ _  ___   / _/___  __ _"     Magenta 8
Write-Typewriter " _\ \ / _//  ' \/ _ \ / _// _ \/  ' \"    Magenta 8
Write-Typewriter "/___//_/ /_/_/_/\___//_/  \___/_/_/_/"     Magenta 8
Write-Host ""
Write-Typewriter "   :: Scoop Smart Export ::" Cyan 22
Write-Host ""

Write-Host "🚀 開始執行智慧清單匯出..." -ForegroundColor Cyan
Write-Host ""

# ── 1. 讀取並解析（Spinner 等待）────────────────────
try {
    $RawJson    = Invoke-WithSpinner -Message "正在讀取 Scoop 安裝狀態..." -ScriptBlock { scoop export }
    $ExportData = $RawJson | ConvertFrom-Json
    Write-Host "   -> 共讀取到 $($ExportData.apps.Count) 個應用程式" -ForegroundColor Gray
} catch {
    Write-Error "❌ 無法取得或解析 scoop export：$($_.Exception.Message)"
    exit 1
}

Write-Host ""

# ── 2. 邏輯分離 ──────────────────────────────────────
# 規則：nerd-fonts 來源且不在例外清單內 → Fonts；其餘 → Core
$CoreApps = $ExportData.apps | Where-Object {
    $_.Source -ne $FontSource -or $_.Name -in $FontExceptions
}
$FontApps = $ExportData.apps | Where-Object {
    $_.Source -eq $FontSource -and $_.Name -notin $FontExceptions
}

# ── 3. 分離 Buckets ──────────────────────────────────
$CoreBuckets = $ExportData.buckets
$FontBuckets = $ExportData.buckets | Where-Object { $_.Name -eq $FontSource }

# ── 4. 建構 JSON ─────────────────────────────────────
$CoreJsonData  = @{ buckets = $CoreBuckets; apps = $CoreApps }
$FontsJsonData = @{ buckets = $FontBuckets; apps = $FontApps }

# ── 5. 寫入檔案 ──────────────────────────────────────
Write-Host "  ✔ 正在寫入主清單 (Core Apps)..." -ForegroundColor Green
$CoreJsonData | ConvertTo-Json -Depth 10 | Out-File -FilePath $MainFile -Encoding utf8
Write-Host "   -> $MainFile" -ForegroundColor Gray

Write-Host "  ✔ 正在寫入字體清單 (Fonts)..." -ForegroundColor Green
$FontsJsonData | ConvertTo-Json -Depth 10 | Out-File -FilePath $FontsFile -Encoding utf8
Write-Host "   -> $FontsFile" -ForegroundColor Gray

# ── 6. 統計報告 ──────────────────────────────────────
Write-Host ""
Write-Typewriter "✅ 匯出作業完成！" Cyan 20
Write-Host "----------------------------------------" -ForegroundColor Gray
Write-Host "   📦 核心軟體數 : $($CoreApps.Count)"  -ForegroundColor Green
Write-Host "   🎨 額外字體數 : $($FontApps.Count)"  -ForegroundColor Magenta
Write-Host "   📄 Core 路徑  : $MainFile"            -ForegroundColor Gray
Write-Host "   📄 Font 路徑  : $FontsFile"           -ForegroundColor Gray
Write-Host "----------------------------------------" -ForegroundColor Gray
Write-Host ""
Write-Host "👉 現在您可以執行 git commit 來保存變更了。" -ForegroundColor Yellow
Write-Host ""