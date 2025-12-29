#!/bin/bash

# ==========================================
# Mac/Linux Backup Script for n8n & MySQL
# ==========================================

# 1. 設定備份路徑 (預設使用 iCloud Drive，您可修改為 OneDrive 路徑)
# iCloud Drive 路徑通常包含空格，需小心處理
BACKUP_ROOT="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Backups/n8n"
TIMESTAMP=$(date +%Y%m%d-%H%M)
TARGET_DIR="$BACKUP_ROOT/$TIMESTAMP"

# 2. 定位專案路徑 (自動抓取腳本所在目錄的上一層)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$PROJECT_DIR/.env"

# 建立備份目錄
mkdir -p "$TARGET_DIR"

echo "🚀 Starting n8n & MySQL backup (Mac)..."
echo "📂 Project Dir: $PROJECT_DIR"
echo "📂 Backup Dir:  $TARGET_DIR"

# 3. 讀取密碼 (簡易解析 .env)
# 預設值
MYSQL_PASS="root_password" 
if [ -f "$ENV_FILE" ]; then
    # 嘗試抓取 MYSQL_ROOT_PASSWORD
    READ_PASS=$(grep "^MYSQL_ROOT_PASSWORD=" "$ENV_FILE" | cut -d '=' -f2)
    if [ ! -z "$READ_PASS" ]; then
        MYSQL_PASS=$READ_PASS
    fi
else
    echo "⚠️  Warning: .env file not found. Using default password logic."
fi

# 4. 匯出資料庫 (MySQL Dump)
echo "📦 Exporting Database..."
# 在 Mac 上，docker exec 指令與 Linux 相同
docker exec n8n-mysql-1 /usr/bin/mysqldump -u root -p"$MYSQL_PASS" --all-databases > "$TARGET_DIR/mysql_dump.sql"

# 5. 匯出 n8n Workflows & Credentials
echo "📦 Exporting Workflows..."
docker exec n8n-n8n-1 n8n export:workflow --all --output=/tmp/workflows.json
docker cp n8n-n8n-1:/tmp/workflows.json "$TARGET_DIR/workflows.json"

echo "📦 Exporting Credentials..."
docker exec n8n-n8n-1 n8n export:credentials --all --output=/tmp/credentials.json
docker cp n8n-n8n-1:/tmp/credentials.json "$TARGET_DIR/credentials.json"

# 6. 備份設定檔
if [ -f "$ENV_FILE" ]; then
    cp "$ENV_FILE" "$TARGET_DIR/env_backup.txt"
    echo "📄 .env file backed up."
fi

echo "✅ Backup Complete!"