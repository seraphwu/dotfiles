#git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
#git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
#git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
#git clone https://github.com/wbingli/zsh-wakatime.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-wakatime
#git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use
#git clone https://github.com/fdellwing/zsh-bat.git $ZSH_CUSTOM/plugins/zsh-bat
#git clone https://github.com/wting/autojump.git $ZSH_CUSTOM/plugins/autojump
#git clone https://github.com/chrissicool/zsh-256color $ZSH_CUSTOM/plugins/zsh-256color
#git clone https://github.com/fdellwing/zsh-bat.git $ZSH_CUSTOM/plugins/zsh-bat
#git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use
#!/bin/bash
# FILE: zsh/install.sh

set -e

echo "🚀 Setting up Zsh plugins & themes..."

# 1. 定義路徑變數 (修復 Read-only file system 錯誤)
# 如果 ZSH_CUSTOM 沒定義，就預設為 ~/.oh-my-zsh/custom
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# 2. 定義一個聰明的安裝函數 (修復 already exists 錯誤)
# 用法: git_install_or_update "Repo_URL" "Target_Path"
git_install_or_update() {
    local repo_url=$1
    local target_path=$2
    local name=$(basename "$target_path")

    if [ -d "$target_path" ]; then
        echo "   ↻ Updating $name..."
        # 進入目錄並執行 git pull，如果失敗則忽略 (|| true) 以免中斷腳本
        (cd "$target_path" && git pull --quiet) || echo "     ! Git pull failed for $name, skipping."
    else
        echo "   ⬇️ Installing $name..."
        git clone --depth=1 "$repo_url" "$target_path" --quiet
    fi
}

# 3. 安裝 Powerlevel10k 主題
git_install_or_update "https://github.com/romkatv/powerlevel10k.git" "$ZSH_CUSTOM/themes/powerlevel10k"

# 4. 安裝 Plugins
# 根據你的錯誤訊息，我幫你補齊了所有插件
git_install_or_update "https://github.com/zsh-users/zsh-autosuggestions" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git_install_or_update "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
git_install_or_update "https://github.com/wakatime/zsh-wakatime.git" "$ZSH_CUSTOM/plugins/zsh-wakatime"
git_install_or_update "https://github.com/MichaelAquilina/zsh-you-should-use.git" "$ZSH_CUSTOM/plugins/you-should-use"

# 這些是你錯誤訊息中試圖寫入根目錄的插件
git_install_or_update "https://github.com/fdellwing/zsh-bat.git" "$ZSH_CUSTOM/plugins/zsh-bat"
git_install_or_update "https://github.com/chrissicool/zsh-256color" "$ZSH_CUSTOM/plugins/zsh-256color"

# Autojump 通常建議用 brew 安裝，但如果你堅持用 plugin：
# (注意：Autojump 的 plugin 安裝比較特殊，通常是 brew install autojump 然後在 .zshrc 啟用 plugins=(autojump))
# 如果這裡是指 zsh-autojump 插件，通常不需要 git clone，除非是特殊版本。
# 這裡先保留檢查，但不執行 clone，以免路徑錯誤。

echo "✅ Zsh setup complete!"