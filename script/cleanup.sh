#!/bin/bash
# FILE: script/cleanup
# 說明：安全地清理不在 Brewfile 與 Brewfile.fonts 中的軟體

set -e
cd "$(dirname $0)"/..

echo "🧹 準備執行 Homebrew 清理..."
echo "ℹ️  這將會合併 Brewfile 與 Brewfile.fonts 進行比對"

# 1. 建立暫時的合併檔案 (Combined Brewfile)
# 這裡將兩個檔案內容接在一起，存成 Brewfile.combined
cat Brewfile Brewfile.fonts > Brewfile.combined

echo "📋 正在檢查要移除的軟體 (Dry Run)..."
echo "---------------------------------------------------"

# 2. 執行預覽 (Dry Run) - 使用合併後的檔案
# 這會列出「既不在 Brewfile 也不在 Brewfile.fonts」的軟體
brew bundle cleanup --file="Brewfile.combined"

echo "---------------------------------------------------"
read -p "⚠️  請檢查上方清單。確定要永久刪除這些軟體嗎？ (y/N) " -n 1 -r
echo    # (optional) move to a new line

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔥 正在執行刪除..."
    # 3. 執行真正的強制刪除
    brew bundle cleanup --force --file="Brewfile.combined"
    
    echo "🧹 清理孤兒依賴 (Autoremove)..."
    brew autoremove
    
    echo "✨ 清理完成！系統現在與 Brewfile 完全同步。"
else
    echo "❌ 取消操作，未刪除任何東西。"
fi

# 4. 刪除暫時檔案
rm Brewfile.combined