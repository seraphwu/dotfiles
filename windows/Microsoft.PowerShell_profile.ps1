# ===================================================================
# FILE: windows/Microsoft.PowerShell_profile.ps1
# ===================================================================

# 0. 設定編碼
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# 1. 核心工具整合
if (Get-Command scoop-search -ErrorAction SilentlyContinue) {
    Invoke-Expression (&scoop-search --hook)
}

# 2. 介面美化 (Oh My Posh & Icons)
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    # 優先嘗試載入經典主題
    $ThemePath = "$env:POSH_THEMES_PATH/powerlevel10k_classic.omp.json"
    if (Test-Path $ThemePath) {
        oh-my-posh init pwsh --config $ThemePath | Invoke-Expression
    } else {
        oh-my-posh init pwsh | Invoke-Expression
    }
}
Import-Module -Name Terminal-Icons -ErrorAction SilentlyContinue

# 3. 導航增強
Set-PSReadLineOption -PredictionViewStyle ListView

# Zoxide (修正：強制使用 powershell 參數)
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& zoxide init powershell | Out-String)
}

# FZF (修正：檢查模組是否載入)
if (Get-Command fzf -ErrorAction SilentlyContinue) {
    Import-Module PSFzf -ErrorAction SilentlyContinue
    if (Get-Module PSFzf) {
        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineDirProvider 'Ctrl+f'
    }
}

# 4. Aliases (修正：改用 Function 以支援參數)
if (Get-Command eza -ErrorAction SilentlyContinue) {
    # ls 不帶參數，可以用 Alias
    Set-Alias -Name ls -Value eza
    
    # ll 和 lt 帶有參數，必須用 Function，並加上 $args 以便能接續輸入路徑
    function ll { eza -l -g --icons $args }
    function lt { eza --tree --icons -a $args }
}

# Git Aliases
Import-Module posh-git -ErrorAction SilentlyContinue
function gs { git status }
function gc { git commit $args }
function ga { git add $args }
function gco { git checkout $args }
function gl { git pull }
function gp { git push }
function gd { git diff $args }

# 5. 環境變數
$env:GIT_EDITOR="code --wait"
