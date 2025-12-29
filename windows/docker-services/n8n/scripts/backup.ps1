# 設定備份路徑 (建議指向 OneDrive)
$BackupRoot = "$env:USERPROFILE\OneDrive\Backups\n8n"
$Timestamp = Get-Date -Format "yyyyMMdd-HHmm"
$TargetDir = "$BackupRoot\$Timestamp"

# 建立備份資料夾
if (-not (Test-Path $TargetDir)) {
    New-Item -Path $TargetDir -ItemType Directory | Out-Null
}

Write-Host "🚀 Starting n8n & MySQL backup..." -ForegroundColor Cyan

# 1. 匯出 MySQL 資料庫 (SQL Dump)
# 注意：容器名稱通常是 資料夾名-服務名-1，若不同請用 docker ps 確認
$ContainerMySQL = "n8n-mysql-1"
$MySQLUser = "root" 
# 這裡假設您執行腳本時知道密碼，或是在 .env 裡讀取，為簡化這邊先手動或寫死，
# 更進階做法是解析 .env 檔
$MySQLPass = "change_me_root" 

Write-Host "📦 Exporting Database..." -ForegroundColor Yellow
docker exec $ContainerMySQL /usr/bin/mysqldump -u $MySQLUser -p$MySQLPass --all-databases > "$TargetDir\mysql_dump.sql"

# 2. 匯出 n8n Workflows (JSON)
Write-Host "📦 Exporting Workflows..." -ForegroundColor Yellow
$ContainerN8N = "n8n-n8n-1"
# 使用 n8n CLI 匯出
docker exec $ContainerN8N n8n export:workflow --all --output=/tmp/workflows.json
docker cp "$ContainerN8N`:/tmp/workflows.json" "$TargetDir\workflows.json"

# 3. 匯出 n8n Credentials (加密過的，需配合 master key)
# 建議直接備份整個 .n8n 資料夾最保險，但 CLI 匯出較輕量
Write-Host "📦 Exporting Credentials..." -ForegroundColor Yellow
docker exec $ContainerN8N n8n export:credentials --all --output=/tmp/credentials.json
docker cp "$ContainerN8N`:/tmp/credentials.json" "$TargetDir\credentials.json"

# 4. 複製 .env 設定檔 (重要！還原需要它)
Copy-Item "..\.env" "$TargetDir\env_backup.txt"

Write-Host "✅ Backup Complete! Saved to: $TargetDir" -ForegroundColor Green