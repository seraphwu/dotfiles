# Seraph Wu's Dotfiles

這份 Dotfiles 採用 **Monorepo** 架構，同時管理 **macOS** 與 **Windows** 的開發環境配置。
Modified from [Amo Wu does dotfiles](https://github.com/amowu/dotfiles) & [Holman's dotfiles](https://github.com/holman/dotfiles).

## 🚀 Overview

*   **Cross-Platform**: 單一 Repo 同步管理雙平台設定。
*   **Infrastructure as Code**:
    *   **macOS**: 使用 `Brewfile` 管理軟體，`script/install` 自動化部署。
    *   **Windows**: 使用 `scoopfile.json` 管理軟體，`windows/install.ps1` 自動化部署。
*   **Shell Customization**:
    *   **Zsh (Mac)**: Powerlevel10k, Autosuggestions, Syntax-highlighting.
    *   **PowerShell (Win)**: Oh My Posh, Terminal-Icons, Zoxide, PSFzf, Eza.

---

## 📂 Repository Structure

```text
/dotfiles
  ├── .gitattributes      # [Core] 強制定義換行規則 (防止 Windows 損壞 Mac 腳本)
  ├── .gitconfig          # [Shared] 跨平台共用的 Git 設定
  ├── macos/              # [Mac] macOS 專屬設定與腳本
  ├── windows/            # [Win] Windows 專屬設定 (Scoop, PowerShell)
  │   ├── install.ps1     # [Win] 自動安裝腳本 (含 Docker)
  │   ├── scoopfile.json  # [Win] 軟體清單
  │   └── docker-services # [Win] Docker 服務設定 (n8n, MySQL)
  ├── script/             # [Mac] 安裝腳本
  │   ├── bootstrap       # [Mac] 初始化腳本
  │   └── install         # [Mac] 軟體安裝腳本 (Brewfile + Fonts)
  ├── zsh/                # [Mac] Zsh 設定
  ├── Brewfile            # [Mac] 核心軟體清單
  ├── Brewfile.fonts      # [Mac] 字體清單 (獨立安裝)
  └── ...
```

---

## 🛠 Installation

### 🪟 Windows Setup

**Prerequisites:**
*   Windows 10 / 11
*   PowerShell 5.1 or 7+ (建議使用 Windows Terminal)
*   **必須以系統管理員身分執行**

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
*   **系統層**: 透過 Winget 自動檢查並安裝 **Docker Desktop**。
*   **工具層**: 安裝 **Scoop** 及必要 Buckets，還原所有 CLI 工具 (`git`, `oh-my-posh`, `eza`...)。
*   **設定層**: 自動備份舊 Profile，建立 Symlink 指向此 Repo。

> ⚠️ **注意**: 若腳本安裝了 Docker Desktop，可能需要**重新啟動電腦**以啟用 WSL 2 後端。

---

### 🍎 macOS Setup

**Prerequisites:**
*   macOS recent versions.
*   Xcode Command Line Tools: `xcode-select --install`

**Steps:**

1.  Clone repo:
    ```bash
    git clone git@github.com:seraphwu/dotfiles.git ~/.dotfiles
    ```

2.  Run bootstrap (初始化):
    ```bash
    cd ~/.dotfiles
    ./script/bootstrap
    ```

3.  Run install (安裝軟體):
    ```bash
    ./script/install
    ```

**腳本功能：**
*   **Bootstrap**: 安裝 Homebrew, Oh My Zsh, 建立 Symlinks。
*   **Install**:
    1.  執行 `Brewfile` 安裝核心軟體。
    2.  執行 `Brewfile.fonts` 安裝字體 (失敗會自動略過，不影響核心安裝)。
    3.  執行其他子模組安裝 (如 Yabai)。

---

## ⚙️ Management

### Windows
*   **新增軟體**: `scoop install <app>`
*   **更新清單**: 執行 `scoop export > ~/.dotfiles/windows/scoopfile.json` 並 Commit。
*   **修改設定**: 直接編輯 `~/.dotfiles/windows/Microsoft.PowerShell_profile.ps1`。
*   **Docker 服務**: 設定檔位於 `windows/docker-services/`。

### macOS
*   **新增軟體**: `brew install <app>`
*   **更新清單**: 手動維護 `Brewfile` (核心) 或 `Brewfile.fonts` (字體)。
*   **修改設定**: 直接編輯 `~/.dotfiles/zsh/zshrc.symlink` 等檔案。

### Backup / Restore (Mac Only)
使用 [Mackup](https://github.com/lra/mackup) 備份應用程式設定 (如 VS Code, SSH keys 等不適合放入 public repo 的資料) 到雲端硬碟。

```bash
mackup backup  # 備份
mackup restore # 還原
```

---

## ❤️ Thanks

I forked [Amo Wu](https://github.com/amowu/dotfiles)'s dotfiles, which is forked from [Zach Holman](http://github.com/holman)'s excellent [dotfiles](http://github.com/holman/dotfiles).
