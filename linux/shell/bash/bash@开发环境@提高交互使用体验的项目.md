[toc]

## abstract

在 **Bash** 环境下，也有不少类似 **Oh My Zsh** 的可扩展框架（framework）或增强项目，可以显著改善交互体验、补全能力、外观与插件生态。

### bash开发工具

[Bash IDE - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=mads-hartmann.bash-ide-vscode)

> 此插件集成了最核心的功能,但是完整功能的可用性依赖于几个外部工具,需要用户自行安装,主要是shellcheck和shfmt.(其他语法检查和格式插件就可以不用单独安装了.)
>
> 此插件在vscode刚启动时可能无法立即工作,需要一些时间,如果过早打开shell文件可能导致该文件的分析无法正常进行
>
> 尤其是目标文件内容复杂的情况,如果卡住无法分析符号等,请关闭该文件后重新打开.

Visual Studio Code extension utilizing the [Bash Language Server](https://github.com/bash-lsp/bash-language-server/blob/HEAD/bash-lsp) and integrating with [explainshell](https://explainshell.com/), [shellcheck](https://www.shellcheck.net/) and [shfmt](https://github.com/mvdan/sh).

- We recommend that you [install shellcheck](https://github.com/koalaman/shellcheck#installing) to enable linting and [install shfmt](https://github.com/mvdan/sh?tab=readme-ov-file#shfmt) to enable formatting.这两个工具(`shellcheck`和`shfmt`)不仅在linux上可用,windows上也可用.
- 这是一个命令行解释工具(在线网站)https://explainshell.com/,也可以部署本地服务集成到Bash IDE([idank/explainshell：将命令行参数与他们的帮助文本匹配](https://github.com/idank/explainshell)),安装条件比前面两个工具略高,这作为一个可选的功能.

另外还有代码片段snippet 类型的插件可以提高编写效率(这类插件不只1个.)

[shellman - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=Remisa.shellman)

还可以额外配合ai提示补全

> 这一套组合下windows下也能有较好的bash脚本开发体验

但是还有一些高级特性(和命令相关的补全提示)需要linux/macos环境,对于较新版本的windows可以借助wsl获得linux环境.

[Shell 脚本命令补全 - Visual Studio Marketplace --- Shell Script Command Completion - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=tetradresearch.vscode-h2o)这个shell命令补全和提示插件就无法直接在windows下运行.

### 代码格式化排版插件

在vscode中,Bash IDE插件已经集成了此功能,但是这需要你事先安装shfmt

如果不生效,或者需要额外的配置,可以使用其他专门的格式化插件,例如`shell-forma`

[marketplace.visualstudio.com/items?itemName=lumirelle.shell-format-rev](https://marketplace.visualstudio.com/items?itemName=lumirelle.shell-format-rev)

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

