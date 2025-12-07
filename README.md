# Seraph Wu's Dotfiles

這份 Dotfiles 採用 **Monorepo** 架構，同時管理 **macOS** 與 **Windows** 的開發環境配置。
Modified from [Amo Wu does dotfiles](https://github.com/amowu/dotfiles) & [Holman's dotfiles](https://github.com/holman/dotfiles).

## 🚀 Overview

*   **Cross-Platform**: 單一 Repo 同步管理雙平台設定。
*   **Infrastructure as Code**:
    *   **macOS**: 使用 `Brewfile` 管理軟體，`script/bootstrap` 自動化部署。
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
  │   ├── install.ps1     # [Win] 自動安裝腳本
  │   └── scoopfile.json  # [Win] 軟體清單
  ├── script/             # [Mac] Bootstrap 安裝腳本
  ├── zsh/                # [Mac] Zsh 設定
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
*   安裝 **Scoop** 及必要 Buckets (Extras, Nerd-Fonts)。
*   安裝核心工具：`git`, `oh-my-posh`, `eza`, `zoxide`, `fzf` 等。
*   自動備份舊的 PowerShell Profile。
*   建立 **Symlink** 將設定檔指向此 Repo。

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

2.  Run bootstrap:
    ```bash
    cd ~/.dotfiles
    ./script/bootstrap
    ```

**腳本功能：**
*   安裝 **Homebrew**。
*   安裝 **Oh My Zsh** 及所有 Plugins。
*   建立 **Symlinks** (連結 `*.symlink` 檔案到 Home 目錄)。
*   執行 `Brewfile` 安裝應用程式。

#### 🔌 Zsh Plugins (Manual Setup)

若需手動安裝或重灌個別 Plugin，可參考以下指令。
建議維持指令獨立執行，方便除錯與選擇性安裝；但在單一 Plugin 的安裝步驟中（如切換目錄後下載），會使用 `&&` 確保執行順序正確。

**zsh-autosuggestions**
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

**powerlevel10k**
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

**zsh-syntax-highlighting**
```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

**zsh-wakatime**
```bash
git clone https://github.com/wbingli/zsh-wakatime.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-wakatime
```

**zsh-bat**
```bash
git clone https://github.com/fdellwing/zsh-bat.git $ZSH_CUSTOM/plugins/zsh-bat
```

**zsh-256color**
```bash
cd $ZSH_CUSTOM/plugins && git clone https://github.com/chrissicool/zsh-256color
```

---

## ⚙️ Management

### Windows
*   **新增軟體**: `scoop install <app>`
*   **更新清單**: 執行 `scoop export > ~/.dotfiles/windows/scoopfile.json` 並 Commit。
*   **修改設定**: 直接編輯 `~/.dotfiles/windows/Microsoft.PowerShell_profile.ps1`。

### macOS
*   **新增軟體**: `brew install <app>`
*   **更新清單**: `brew bundle dump --describe --force --file="~/brewfile"` (或手動維護 Repo 中的 Brewfile)。
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
