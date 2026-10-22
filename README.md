# Seraph Wu's Dotfiles

這份 Dotfiles 採用 **Monorepo** 架構，同時管理 **macOS** 與 **Windows** 的開發環境配置，並包含容器化的服務設定。
Modified from [Amo Wu does dotfiles](https://github.com/amowu/dotfiles) & [Holman's dotfiles](https://github.com/holman/dotfiles).

## 🚀 Overview

- **Cross-Platform**: 單一 Repo 同步管理雙平台設定。
- **Infrastructure as Code**:
  - **macOS**: 使用 `Brewfile` (核心) 與 `Brewfile.fonts` (字體) 管理軟體，`script/install` 自動化部署。
  - **Windows**: 使用 `scoopfile.json` 管理軟體，`windows/install.ps1` 自動化部署。
- **Security First**:
  - **SSH Strategy**: 採用 Bitwarden 管理私鑰，配合 `ssh-agent` 實現免密碼連線。
  - **Bitwarden**: 透過 Scoop/Brew 優先安裝，作為環境建置的基石。
- **Shell Customization**:
  - **Zsh (Mac)**: Powerlevel10k, Autosuggestions, Syntax-highlighting.
  - **PowerShell (Win)**: Oh My Posh, Terminal-Icons, Zoxide, PSFzf, Eza.
- **Self-Hosted Services**:
  - **Docker**: 內建 n8n + MySQL 的 Docker Compose 設定，支援跨平台運行與備份。

---

## 📂 Repository Structure

```text
/dotfiles
  ├── .gitattributes      # [Core] 強制定義換行規則 (LF/CRLF 防護)
  ├── .gitconfig          # [Win] Git 入口 (include git/gitconfig.shared + Windows 專屬設定)
  ├── git/
  │   ├── gitconfig.shared   # [Shared] 跨平台共用的 Git 設定
  │   └── gitconfig.symlink  # [Mac] Git 入口 (include gitconfig.shared + macOS 專屬設定)
  ├── ssh/config          # [Shared] SSH 設定 (GitHub 雙帳號：github.com / github-meijiasha)
  ├── docker/             # [Shared] 跨平台 Docker 服務 (n8n, MySQL)
  │   └── n8n/
  │       ├── scripts/    # 備份腳本 ([Win]backup.ps1 / [Mac]backup.sh)
  │       └── ...
  ├── windows/            # [Win] Windows 專屬設定
  │   ├── install.ps1     # [Win] 自動安裝腳本 (含 Docker/Scoop)
  │   └── scoopfile.json  # [Win] 軟體清單
  ├── script/             # [Mac] 安裝腳本
  │   ├── bootstrap       # [Mac] 初始化與 Symlink
  │   └── install         # [Mac] 軟體安裝 (Brewfile + Fonts)
  ├── zsh/                # [Mac] Zsh 設定
  ├── Brewfile            # [Mac] 核心軟體清單
  ├── Brewfile.fonts      # [Mac] 字體清單 (獨立安裝)
  └── ...
```

---

## 🛠 Installation

由於本 Repo 使用 SSH 進行 Clone，且依賴 **Bitwarden** 管理金鑰，請務必遵守以下順序：

### 🟢 Step 0: Pre-installation (Bitwarden & Keys)

在拉取此 Repo 之前，請先安裝套件管理器與 Bitwarden，並還原 SSH 金鑰。

**Windows (PowerShell):**
```powershell
# 1. 安裝 Scoop
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser; irm get.scoop.sh | iex
# 1.1 Admin 安裝 Scoop
# source from: https://github.com/ScoopInstaller/Install?utm_source=copilot.com#for-admin
iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
# 2. 安裝 Bitwarden
scoop bucket add extras; scoop install bitwarden
# 3. 登入 Bitwarden，取出 SSH Key 並放入 $env:USERPROFILE\.ssh\
# 4. 啟動 SSH Agent
Set-Service ssh-agent -StartupType Automatic; Start-Service ssh-agent; ssh-add $env:USERPROFILE\.ssh\id_ed25519
```

**macOS (Terminal):**
```bash
# 1. 安裝 Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# 2. 安裝 Bitwarden
brew install --cask bitwarden
# 3. 登入 Bitwarden，取出 SSH Key 並放入 ~/.ssh/，執行 chmod 600
# 4. 加入 Agent
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

---

### 🪟 Windows Setup (Main)

**Prerequisites:**
- Windows 10 / 11
- **必須以系統管理員身分執行 PowerShell**

**Steps:**

1.  Clone repo:
    ```powershell
    cd $env:USERPROFILE
    git clone git@github.com:seraphwu/dotfiles.git .dotfiles
    ```

2.  Run installer:
    ```powershell
    cd .dotfiles\windows
    .\install.ps1
    ```

**腳本功能：**
- **系統層**: 透過 Winget 自動檢查並安裝 **Docker Desktop** (需重啟生效)。
- **工具層**: 還原 Scoop 所有 CLI 工具 (`git`, `oh-my-posh`, `eza`, `zoxide`...)。
- **設定層**: 自動備份舊 Profile，建立 Symlink 將設定檔指向此 Repo (包含 `.ssh/config`)。

---

### 🍎 macOS Setup (Main)

**Prerequisites:**
- macOS recent versions.
- Xcode Command Line Tools: `xcode-select --install`

**Steps:**

1.  Clone repo:
    ```bash
    git clone git@github.com:seraphwu/dotfiles.git ~/.dotfiles
    ```

2.  Run bootstrap (初始化環境與連結):
    ```bash
    cd ~/.dotfiles
    ./script/bootstrap
    ```

3.  Run install (安裝軟體):
    ```bash
    ./script/install
    ```

**腳本功能：**
- **Bootstrap**: 建立 Symlinks (包含 `.ssh/config`)，設定 macOS Defaults。
- **Install**:
  1.  執行 `Brewfile` 安裝核心軟體。
  2.  執行 `Brewfile.fonts` 安裝字體。

---

## 🐳 Docker Services (n8n)

本 Repo 包含 n8n + MySQL 的完整架構，設定檔位於 `docker/n8n/`。

### 啟動服務

```bash
cd ~/.dotfiles/docker/n8n  # (Windows: cd .dotfiles\docker\n8n)
cp .env.example .env       # 初次需建立設定檔並填入密碼
docker-compose up -d
```

### 資料備份 (Backup)

- **Windows**: 執行 `.\scripts\backup.ps1` (備份至 OneDrive)。
- **macOS**: 執行 `./scripts/backup.sh` (備份至 iCloud/OneDrive)。
- **備份內容**: SQL Dump, Workflows, Credentials, .env。

---

## ⚙️ Management

### Windows

- **新增軟體**: `scoop install <app>`
- **更新清單**: 執行 `scoop export > ~/.dotfiles/windows/scoopfile.json` 並 Commit。
- **修改設定**: 直接編輯 `~/.dotfiles/windows/Microsoft.PowerShell_profile.ps1`。

### macOS

- **新增軟體**: `brew install <app>`
- **更新清單**: 手動維護 `Brewfile` (核心) 或 `Brewfile.fonts` (字體)。
- **修改設定**: 直接編輯 `~/.dotfiles/zsh/zshrc.symlink` 等檔案。

### Backup / Restore (Mac Only)

使用 [Mackup](https://github.com/lra/mackup) 備份應用程式設定 (如 VS Code, SSH keys 等) 到雲端硬碟。

```bash
mackup backup  # 備份
mackup restore # 還原
```

---

## ❤️ Thanks

I forked [Amo Wu](https://github.com/amowu/dotfiles)'s dotfiles, which is forked from [Zach Holman](http://github.com/holman)'s excellent [dotfiles](http://github.com/holman/dotfiles).
