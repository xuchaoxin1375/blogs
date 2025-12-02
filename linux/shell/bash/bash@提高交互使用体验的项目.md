[toc]

## abstract

在 **Bash** 环境下，也有不少类似 **Oh My Zsh** 的可扩展框架（framework）或增强项目，可以显著改善交互体验、补全能力、外观与插件生态。

------

### Bash 增强框架（类似 Oh My Zsh 的 Framework）

#### Bash-it

[Bash-it/bash-it: A community Bash framework.](https://github.com/Bash-it/bash-it)

- 功能非常接近 **Oh My Zsh**：支持**插件（plugins）**、**别名（aliases）**、**自动补全（completions）**、**主题（themes）**。

- 适合希望在 Bash 上获得完整“插件生态”的用户。

- GitHub: `Bash-it`

- 示例安装：

  ```bash
  git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
  ~/.bash_it/install.sh
  ```

#### Oh My Bash

- 专为 Bash 打造的 **Oh My Zsh 移植版本（port）**。

- 结构、插件系统、主题形式都与 **Oh My Zsh** 极为接近。

- 适合想保持与 Oh My Zsh 类似体验但必须使用 Bash 的用户。

- GitHub: `ohmybash/oh-my-bash`
   安装示例：

  ```bash
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
  ```

#### Blesh / ble.sh🎈

[akinomyoga/ble.sh: Bash Line Editor―a line editor written in pure Bash with syntax highlighting, auto suggestions, vim modes, etc. for Bash interactive sessions.](https://github.com/akinomyoga/ble.sh)

- 全称 **Bash Line Editor**。

- 这是 Bash 用户体验增强中最现代、**功能最强**的项目之一。

  - 但是项目实现比较复杂,对shell的响应速度会造成一定的影响

- 提供类似 Zsh 的：

  - **语法高亮（syntax highlighting）**
  - **智能补全（intelligent completion）**
  - **提示增强（prompt enhancement）**
  - **异步提示更新（async prompt）**

- 不修改你的 Bash 配置框架，只增强 Bash 本身的输入体验。

- 安装示例：

  ```bash
  git clone https://github.com/akinomyoga/ble.sh.git
  make -C ble.sh install PREFIX=~/.local
  echo 'source ~/.local/share/blesh/ble.sh' >> ~/.bashrc
  ```

------



### 提示符与主题增强（Prompt Enhancers）

#### Starship

- **跨 Shell（cross-shell）** 的现代提示符系统。

- 极简、极速（Rust 编写），配置使用 **TOML** 文件。

- 支持 Bash/Zsh/Fish/PowerShell。

- 提供可定制的 **segments**，如 Git 状态、执行耗时、环境等。

- 安装（脚本）：

  ```bash
  curl -sS https://starship.rs/install.sh | sh
  echo 'eval "$(starship init bash)"' >> ~/.bashrc
  ```

#### Powerline / Powerline-shell / Powerlevel10k for Bash

- 虽然 Powerlevel10k 主用于 Zsh，但也有轻量版本适用于 Bash（第三方移植）。
- Powerline 提供更经典的 Unicode 箭头风格。

------

### 自动补全与提示增强（Autocompletion / Suggestions）

#### Bash-completion

- 官方补全扩展项目，提供大量程序的补全脚本。

- 在大部分发行版可直接安装：

  ```bash
  sudo pacman -S bash-completion
  ```

- 适合刚切换到 Bash 时大幅提升补全体验。

#### fzf（command-line fuzzy finder）

- 提供模糊搜索（fuzzy search）功能，例如：

  - 搜文件
  - 命令历史
  - Git 文件选择

- 结合 Bash alias/plugin 可极大提升效率。

- 安装：

  ```bash
  sudo pacman -S fzf
  ```

#### fzf-tab (Bash port)

- Zsh 的 famous 选项卡补全增强，在 Bash 有部分移植项目，能提供更友好的补全界面。

#### thefuck

- 智能修复命令错误的工具：

  ```bash
  pip install thefuck
  echo 'eval $(thefuck --alias)' >> ~/.bashrc
  ```

------

### 历史与文件管理体验增强（History & File Tools）

#### zoxide（smarter cd）

- 智能目录跳转工具，比 autojump 更现代。

- 使用频率学习（frecent algorithm）。

- 安装：

  ```bash
  sudo pacman -S zoxide
  echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
  ```

#### autojump

- 传统“智能 cd”。

------

### 推荐使用组合（现代化 Bash 方案）

下面是一个现代 Bash 使用体验组合，尽量接近 Zsh 体验并保持性能：

| 需求                   | 推荐                      | 说明                            |
| ---------------------- | ------------------------- | ------------------------------- |
| 框架（类似 Oh My Zsh） | **Bash-it 或 Oh My Bash** | 提供插件、主题管理              |
| 输入体验增强           | **blesh**                 | 最接近 Zsh 的语法高亮和补全体验 |
| 提示符                 | **Starship**              | 现代、快速、跨 shell            |
| 智能跳转               | **zoxide**                | 比 autojump 更现代              |
| 模糊查找               | **fzf**                   | 搜索文件/历史                   |
| 修错工具               | **thefuck**               | 快速修复拼写错误                |

如果希望尽量简洁，不想安装太多：

- **blesh + starship + fzf + zoxide**
   这是目前 Bash 用户中最现代且最轻量的组合。

