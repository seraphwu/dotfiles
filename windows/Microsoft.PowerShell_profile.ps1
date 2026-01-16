# ===================================================================
# FILE: windows/Microsoft.PowerShell_profile.ps1
# 說明：整合 Mac 習慣 (p10k 風格) 與 Windows 工具的設定檔
# ===================================================================

# 0. 設定編碼 (避免 Nerd Fonts 圖示亂碼 / 強制 UTF-8 輸出，確保圖示顏色正確)
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# -------------------------------------------------------------------
# 1. 核心工具整合
# -------------------------------------------------------------------
# Scoop Search 整合
if (Get-Command scoop-search -ErrorAction SilentlyContinue) {
    Invoke-Expression (&scoop-search --hook)
}

# -------------------------------------------------------------------
# 2. 介面美化 (Oh My Posh & Icons)
# -------------------------------------------------------------------
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    # 設定自訂主題路徑 (對應您的 Mac p10k 設定)
    $CustomTheme = "$env:USERPROFILE\.dotfiles\windows\my-p10k.omp.json"
    
    if (Test-Path $CustomTheme) {
        # 如果找到自訂主題，就使用它
        oh-my-posh init pwsh --config $CustomTheme | Invoke-Expression
    } else {
        # 備案：如果找不到，使用官方預設
        oh-my-posh init pwsh | Invoke-Expression
    }
}

# 載入檔案圖示
Import-Module -Name Terminal-Icons -ErrorAction SilentlyContinue

# -------------------------------------------------------------------
# 3. 導航與體驗增強
# -------------------------------------------------------------------
# PSReadLine: 設定選單式自動補全 (ListView)
# PSReadLine 設定：讓選字選單跟 iTerm2 的自動完成感覺更像
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -Colors @{
    # 讓預測文字變成淡灰色，類似 iTerm2 的 autosuggestions
    "ListPrediction" = "#657B83"
}


# Zoxide: 取代 cd 的智慧導航
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    # 修正：強制使用 powershell 參數，避免舊版 pwsh 錯誤
    Invoke-Expression (& zoxide init powershell | Out-String)
}

# FZF: 模糊搜尋 (Ctrl+T, Ctrl+R)
if (Get-Command fzf -ErrorAction SilentlyContinue) {
    # 嘗試載入 PSFzf 模組
    Import-Module PSFzf -ErrorAction SilentlyContinue
    
    # 只有當模組成功載入後，才執行設定，避免報錯
    if (Get-Module PSFzf) {
        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineDirProvider 'Ctrl+f'
    }
}

# -------------------------------------------------------------------
# 4. Aliases (移植 Mac 的使用習慣)
# -------------------------------------------------------------------

# 檔案列表 (使用 eza 取代 ls)
if (Get-Command eza -ErrorAction SilentlyContinue) {
    # ls 不帶參數，可以用 Alias
    Set-Alias -Name ls -Value eza
    
    # ll 和 lt 帶有參數，必須用 Function 處理 (PowerShell Alias 不支援參數)
    function ll { eza -l -g --icons $args }
    function lt { eza --tree --icons -a $args }
}

# Git 常用指令 (讓 Windows 跟 Mac 手感一樣)
# 需先載入 posh-git 取得狀態支援
Import-Module posh-git -ErrorAction SilentlyContinue

function gs { git status }
function gc { git commit $args }
function ga { git add $args }
function gco { git checkout $args }
function gl { git pull }
function gp { git push }
function gd { git diff $args }

# 快速編輯與重載 Profile
function code-profile { code $PROFILE }
function reload-profile { . $PROFILE }

# -------------------------------------------------------------------
# 5. 環境變數
# -------------------------------------------------------------------
# 讓 git 使用 VS Code 作為編輯器
$env:GIT_EDITOR="code --wait"

# -------------------------------------------------------------------
# 6. yazi 
# 作者：裘乡
# 链接：https://juejin.cn/post/7458292920564187171
# 来源：稀土掘金
# 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
# -------------------------------------------------------------------

function y {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath ([System.IO.Path]::GetFullPath($cwd))
    }
    Remove-Item -Path $tmp
}