<#
.SYNOPSIS
    從含 Wi-Fi 與帳號密碼的 autounattend.xml 產生可公開的版本
    (WifiMode=Interactive、安裝時手動建立帳號)。
.DESCRIPTION
    來源 windows\autounattend.xml 只放在 Ventoy 隨身碟與本機 (已加入 .gitignore)；
    輸出 windows\setup\autounattend.xml 才會進 repo。任何一步找不到預期內容就中止。
#>
param(
    [string]$Source = (Join-Path $PSScriptRoot '..\autounattend.xml'),
    [string]$Destination = (Join-Path $PSScriptRoot 'autounattend.xml')
)

$ErrorActionPreference = 'Stop'
$raw = [IO.File]::ReadAllText((Resolve-Path $Source))

function Remove-Required {
    param([string]$Text, [string]$Pattern, [string]$What)
    $re = [regex]::new($Pattern, 'Singleline')
    if (-not $re.IsMatch($Text)) { throw "找不到要移除的內容：$What" }
    return $re.Replace($Text, '', 1)
}

# 1. 產生器網址：WifiMode 改為 Interactive，移除 Wifi 名稱/驗證/密碼參數
if ($raw -notmatch 'WifiMode=Unattended') { throw '來源不是 WifiMode=Unattended，請確認來源檔' }
$raw = $raw -replace 'WifiMode=Unattended', 'WifiMode=Interactive'
$raw = [regex]::Replace($raw, '&(?:amp;)?Wifi(?!Mode)[A-Za-z]+=[^&\s]*', '')

# 2. 內嵌的 Wifi.xml (含 SSID 與密碼)
$raw = Remove-Required $raw '[ \t]*<File path="C:\\Windows\\Setup\\Scripts\\Wifi\.xml">.*?</File>\r?\n' 'Wifi.xml'

# 3. FirstLogon：首次登入時連 Wi-Fi 的區塊 ([custom-wifi-begin] ~ [custom-wifi-end])
$raw = Remove-Required $raw '\t\{\r?\n\t\t# \[custom-wifi-begin\].*?# \[custom-wifi-end\]\r?\n\t\};\r?\n' 'FirstLogon Wi-Fi 區塊'

# 4. oobeSystem：自動建立的帳號與自動登入 (含密碼)；公開版改回安裝時手動建立帳號
$raw = Remove-Required $raw '[ \t]*<UserAccounts>.*?</UserAccounts>\r?\n' 'UserAccounts'
$raw = Remove-Required $raw '[ \t]*<AutoLogon>.*?</AutoLogon>\r?\n' 'AutoLogon'

# 5. 確認沒有殘留
foreach ($p in 'WifiName=', 'WifiPassword=', 'WifiAuthentication=', 'keyMaterial', 'WLANProfile', 'netsh.exe wlan', 'custom-wifi', '<UserAccounts>', '<AutoLogon>', '<Password>') {
    if ($raw.Contains($p)) { throw "輸出仍含有 '$p'，已中止" }
}
$doc = New-Object System.Xml.XmlDocument
$doc.LoadXml($raw)

[IO.File]::WriteAllText($Destination, $raw, [Text.UTF8Encoding]::new($false))
Write-Host "已產生：$Destination" -ForegroundColor Green
