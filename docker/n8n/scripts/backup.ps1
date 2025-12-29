# 取得腳本所在的目錄 (docker\n8n\scripts)
$ScriptDir = $PSScriptRoot
# 推導專案根目錄 (docker\n8n)
$ProjectDir = Split-Path -Parent $ScriptDir

# 設定備份路徑 (建議指向 OneDrive)
$BackupRoot = "$env:USERPROFILE\OneDrive\Backups\n8n"
$Timestamp = Get-Date -Format "yyyyMMdd-HHmm"
$TargetDir = "$BackupRoot\$Timestamp"

# 建立備份資料夾
if (-not (Test-Path $TargetDir)) {
    New-Item -Path $TargetDir -ItemType Directory | Out-Null
}

Write-Host "🚀 Starting n8n & MySQL backup..." -ForegroundColor Cyan

# 1. 匯出 MySQL 資料庫
# 既然您保留了預設名稱，這裡使用 -1 是正確的
$ContainerMySQL = "n8n-mysql-1"

# 讀取 .env 密碼邏輯
$EnvFile = "$ProjectDir\.env"
$MySQLPass = "root_password" # 預設值

if (Test-Path $EnvFile) {
    $EnvContent = Get-Content $EnvFile
    foreach ($Line in $EnvContent) {
        if ($Line -match "^MYSQL_ROOT_PASSWORD=(.*)") {
            # [修正] 增加 .Trim('"') 去除可能存在的引號，避免密碼錯誤
            $MySQLPass = $matches[1].Trim('"').Trim("'")
            break
        }
    }
} else {
    Write-Host "⚠️ Warning: .env file not found. Using default password." -ForegroundColor Yellow
}

Write-Host "📦 Exporting Database..." -ForegroundColor Yellow
# 注意：密碼緊接在 -p 後面不能有空格
docker exec $ContainerMySQL /usr/bin/mysqldump -u root -p$MySQLPass --all-databases > "$TargetDir\mysql_dump.sql"

# 2. 匯出 n8n Workflows
Write-Host "📦 Exporting Workflows..." -ForegroundColor Yellow
$ContainerN8N = "n8n-n8n-1"
docker exec $ContainerN8N n8n export:workflow --all --output=/tmp/workflows.json
docker cp "$ContainerN8N`:/tmp/workflows.json" "$TargetDir\workflows.json"

# 3. 匯出 n8n Credentials
Write-Host "📦 Exporting Credentials..." -ForegroundColor Yellow
docker exec $ContainerN8N n8n export:credentials --all --output=/tmp/credentials.json
docker cp "$ContainerN8N`:/tmp/credentials.json" "$TargetDir\credentials.json"

# 4. 複製 .env 設定檔
if (Test-Path $EnvFile) {
    Copy-Item $EnvFile "$TargetDir\env_backup.txt"
    Write-Host "📄 .env file backed up." -ForegroundColor Gray
}

Write-Host "✅ Backup Complete! Saved to: $TargetDir" -ForegroundColor Green