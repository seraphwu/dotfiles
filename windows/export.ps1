<#
.SYNOPSIS
    Smart Scoop Export (Visualized)
    自動分離核心軟體與字體庫，保持 Dotfiles 整潔。
#>

$ErrorActionPreference = "Stop"
$DotfilesDir = $PSScriptRoot
$MainFile = "$DotfilesDir\scoopfile.json"
$FontsFile = "$DotfilesDir\scoopfile.fonts.json"

# ASCII Banner
Write-Host "
   ____                 ___       
  / __/___ __ _  ___   / _/___  __ _
 _\ \ / _//  ' \/ _ \ / _// _ \/  ' \
/___//_/ /_/_/_/\___//_/  \___/_/_/_/
                                     
   :: Scoop Smart Export ::
" -ForegroundColor Magenta

Write-Host "🚀 開始執行智慧清單匯出..." -ForegroundColor Cyan

# 1. 讀取狀態
Write-Host "📊 正在讀取目前的 Scoop 安裝狀態..." -ForegroundColor Yellow
$RawJson = scoop export | Out-String

try {
    $ExportData = $RawJson | ConvertFrom-Json
} catch {
    Write-Error "❌ 解析失敗：請檢查 'scoop export' 是否能正常執行。"
}

# 2. 邏輯分離
# 規則：Nerdfonts 來源且非 Maple 字體，歸類為 Fonts，其餘為 Core
$CoreApps = $ExportData.apps | Where-Object { 
    $_.Source -ne 'nerd-fonts' -or $_.Name -eq 'Maple-Mono-NF-CN' 
}

$FontApps = $ExportData.apps | Where-Object { 
    $_.Source -eq 'nerd-fonts' -and $_.Name -ne 'Maple-Mono-NF-CN' 
}

# 3. 分離 Buckets
$CoreBuckets = $ExportData.buckets
$FontBuckets = $ExportData.buckets | Where-Object { $_.Name -eq 'nerd-fonts' }

# 4. 建構 JSON
$CoreJsonData = @{ buckets = $CoreBuckets; apps = $CoreApps }
$FontsJsonData = @{ buckets = $FontBuckets; apps = $FontApps }

# 5. 寫入檔案
Write-Host "💾 正在寫入主清單 (Core Apps)..." -ForegroundColor Green
$CoreJsonData | ConvertTo-Json -Depth 10 | Out-File -FilePath $MainFile -Encoding utf8
Write-Host "   -> 已儲存至: scoopfile.json" -ForegroundColor Gray

Write-Host "💾 正在寫入字體清單 (Extra Fonts)..." -ForegroundColor Green
$FontsJsonData | ConvertTo-Json -Depth 10 | Out-File -FilePath $FontsFile -Encoding utf8
Write-Host "   -> 已儲存至: scoopfile.fonts.json" -ForegroundColor Gray

# 6. 統計報告
Write-Host "`n✅ 匯出作業完成！" -ForegroundColor Cyan
Write-Host "----------------------------------------" -ForegroundColor Gray
Write-Host "   📦 核心軟體數 : $($CoreApps.Count)" -ForegroundColor Green
Write-Host "   🎨 額外字體數 : $($FontApps.Count)" -ForegroundColor Magenta
Write-Host "----------------------------------------" -ForegroundColor Gray
Write-Host "👉 現在您可以執行 git commit 來保存變更了。" -ForegroundColor Yellow