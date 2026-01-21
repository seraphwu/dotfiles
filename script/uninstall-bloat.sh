#!/bin/bash
# FILE: script/uninstall-bloat.sh
# 說明：針對 Intel Mac 移除在 Brewfile 中被移動到 M-Series 區塊的軟體

echo "🚀 開始清理 Intel Mac 上不需要的重型軟體..."

# 定義要移除的 Cask 清單 (這些是你在 Brewfile 中移動到 arm? 判斷式內的)
CASKS_TO_REMOVE=(
    "yabai"
    "skhd"
    "dockdoor"
    "topnotch"
    "monitorcontrol"
    "ollama"
    "upscayl"
    "comfyui"
    "docker"
    "arc"
    "brave-browser"
    "microsoft-edge"
    "figma"
    "framer"
    "gimp"
    "inkscape"
    "scribus"
    "synfigstudio"
    "couleurs"
    "pika"
    "obs"
    "openshot-video-editor"
    "shotcut"
    "cap"
    "quickrecorder"
    "macwhisper"
    "discord"
    "slack"
    "telegram"
    "franz"
    "rocket"
    "steam"
    "battle-net"
    "openemu@experimental"
    "spotify"
    "adobe-acrobat-reader"
    "pronotes"
    "anytype"
    "heptabase"
    "wave"
)

# 1. 移除 Casks
for cask in "${CASKS_TO_REMOVE[@]}"; do
    if brew list --cask "$cask" &>/dev/null; then
        echo "🗑️  正在移除 Cask: $cask ..."
        # 使用 --zap 可以連同設定檔一起移除，最乾淨，但需輸入密碼
        # 如果不想刪設定檔，拿掉 --zap 即可
        brew uninstall --cask --zap "$cask" || echo "⚠️  移除 $cask 失敗，跳過。"
    else
        echo "✅ $cask 未安裝，跳過。"
    fi
done

# 2. 移除 Formulae (CLI 工具)
# 你的清單中主要只有這兩個是 Formula
FORMULAE_TO_REMOVE=(
    "yabai"
    "skhd"
    "ollama"
)

for formula in "${FORMULAE_TO_REMOVE[@]}"; do
    if brew list --formula "$formula" &>/dev/null; then
        echo "🗑️  正在移除 Formula: $formula ..."
        brew uninstall "$formula" || echo "⚠️  移除 $formula 失敗，跳過。"
    fi
done

echo ""
echo "🎉 清理完成！你的 Intel Mac 現在應該輕盈多了。"
echo "💡 建議執行 'brew bundle cleanup' 來檢查是否還有漏網之魚。"