[toc]

## abstract

本文介绍bash的开发环境搭建和针对交互式的体验改进项目.

### Bash IDE 

vscode中的核心的bash插件

这部分包含最核心的功能,包括符号分析,定义跳转,高亮显示,语法检查和规范检查(shellcheck)和格式化(shfmt),变量或函数补全等

[Bash IDE - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=mads-hartmann.bash-ide-vscode)

> 此插件集成了最核心的功能,但是完整功能的可用性依赖于几个外部工具,需要用户自行安装,主要是shellcheck和shfmt.
>
> 其他语法检查和格式插件是可选的(虽然这两个功能在bash IDE这个插件提供了基本功能,但是提供的可配置项以及功能完整度可能不如单独的插件专业,可以按需额外安装shellcheck和shfmt的插件.)



> 此插件在vscode刚启动时可能无法立即工作,需要一些时间,如果过早打开shell文件可能导致该文件的分析无法正常进行
>
> 尤其是目标文件内容复杂的情况,如果卡住无法分析符号等,请关闭该文件后重新打开.

> Visual Studio Code extension utilizing the [Bash Language Server](https://github.com/bash-lsp/bash-language-server) and integrating with [explainshell](https://explainshell.com/), [shellcheck](https://www.shellcheck.net/) and [shfmt](https://github.com/mvdan/sh).
>
> We recommend that you [install shellcheck](https://github.com/koalaman/shellcheck#installing) to enable linting and [install shfmt](https://github.com/mvdan/sh?tab=readme-ov-file#shfmt) to enable formatting.

- shellcheck和shfmt这两个工具(`shellcheck`和`shfmt`)不仅在linux上可用,windows上也可用.
- 这是一个命令行解释工具(在线网站)https://explainshell.com/,也可以部署本地服务集成到Bash IDE([idank/explainshell：将命令行参数与他们的帮助文本匹配](https://github.com/idank/explainshell)),安装条件比前面两个工具略高,这作为一个可选的功能.

#### 异常检查

此插件功能相对复杂,支持的功能比较多,如果环境或配置不当,许多功能无法生效.

如果你发现某些功能无法工作,可以通过vscode的输出(output)窗口找到Bash IDE,看看输出了哪些错误或异常

> 通过顶部菜单栏中的View->Output打开此窗口,然后再右侧的输出来源下拉列表中找到Bash IDE.

例如,当你发现格式化bash代码不生效时,可能在输出中找到如下报告

```bash
[Error - 6:54:24 PM] 10:54:24.718 ERROR ⛔️ Error while formatting: Error: Shfmt: exited with status 2: invalid value "auto" for flag -ln: unknown shell language variant: "auto"
usage: shfmt [flags] [path ...]

```

这表明bash ide插件在关于`shfmt`的配置上有问题(使用了无效的值`auto`,有效值可能跟随shfmt的版本不同而不同,`auto`可能需要较新的shfmt才能支持)

> 运行此命令查询版本和可用的格式化选项.`shfmt -version;shfmt --help 2>&1|grep -- '-ln.*str'`

```bash
   shfmt -version;shfmt --help 2>&1|grep -- '-ln.*str'
(devel)
  -ln str        language variant to parse (bash/posix/mksh/bats, default "bash")
```

在较新版本中,输出可能像如下(支持`auto`选项.)

```bash
$ shfmt -version;shfmt --help 2>&1|grep -- '-ln.*str'
3.12.0
  -ln, --language-dialect str  bash/posix/mksh/bats, default "auto"
```

可以通过如下路径(`bashIde.shfmt.languageDialect`)将auto更改为bash或其他可用的值.

或者将下面的url粘贴到设置页的查找框中

```
vscode://settings/bashIde.shfmt.languageDialect
```



### 代码片段(模板)

另外还有代码片段snippet 类型的插件可以提高编写效率(这类插件不只1个.)

[BashSnippets - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=WaseemAkram.bashnsippets)

> 提供了像`fnd`这样的代码模板

[shellman - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=Remisa.shellman)

下面的插件是大片段补全,包含一些常用需求的标准解决方案,例如判断一个命令是否已经安装/可用(`isCommandInstalled()`)

[sheller - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=guttih.sheller)

此扩展包含用于编写 Bash 脚本的代码片段和函数。它包括菜单、解析选项、文本着色、函数声明、查找和列出文件及目录等诸多代码片段。

### 代码补全

#### ai补全

可以额外配合ai提示补全(预测型补全),尤其是基于大模型的预测补全.

#### 传统补全

根据一些语法和命令的用法选项进行补全提示

但是还有一些高级特性(和命令相关的补全提示)需要linux/macos环境,对于较新版本的windows可以借助wsl获得linux环境.

[Shell 脚本命令补全 - Visual Studio Marketplace --- Shell Script Command Completion - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=tetradresearch.vscode-h2o)这个shell命令补全和提示插件就无法直接在windows下运行.

### 代码规范检查(shellcheck)

在vscode中,Bash IDE插件已经集成了此功能,但是这需要你事先安装shellcheck

如果需要更专业的配置,需要额外安装其他插件做补充

[ShellCheck - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=timonwong.shellcheck)

### 代码格式化排版插件(shfmt)

在vscode中,Bash IDE插件已经集成了此功能,但是这需要你事先安装shfmt

如果不生效,或者需要额外的配置,可以使用其他专门的格式化插件,例如`shell-format-rev`

[shell-format-rev - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=lumirelle.shell-format-rev)

------

### 代码示例提示插件(tldr)

这个部分是可选的增强.下面到插件不仅仅适用于bash脚本编辑,还支持windows cmd(bat)脚本编写中发挥作用,但是tooltip可能和其他一些相似的提示插件相互覆盖,按需使用

[tl;dr pages - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=bmuskalla.vscode-tldr)

### Bash 增强框架

按需使用

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

## 自定义代码片段(snippet)

VS Code 中 Bash 函数文档注释方案

### 一、相关插件推荐

有几个插件可以辅助，但**没有专门针对 Bash 函数文档注释**的成熟插件（不像 JSDoc/Doxygen 那样自动生成）：

**结论：最佳方案是自定义 Snippet**，完全可控且效果很好。

---

### 二、自定义 Snippet

#### 步骤

1. 打开 VS Code
2. `Ctrl+Shift+P` → 输入 `Snippets: Configure Snippets`
3. 选择 **`shellscript.json`**（如果没有就选 `New Global Snippets File`）

#### 基础模板

```json
{
  "Bash Function with Doc": {
    "prefix": "func",
    "body": [
      "######################################",
      "# ${1:Brief description of the function}",
      "#",
      "# Globals:",
      "#   ${2:None}",
      "# Arguments:",
      "#   ${3:None}",
      "# Returns:",
      "#   ${4:0 on success, non-zero on error}",
      "######################################",
      "${5:function_name}() {",
      "  ${0:# function body}",
      "}"
    ],
    "description": "Create a bash function with Google Shell Style Guide doc comment"
  }
}
```

使用效果

输入 `func` + `Tab`，自动展开为：

```bash
######################################
# Brief description of the function
#
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   0 on success, non-zero on error
######################################
function_name() {
  # function body
}
```

然后通过 `Tab` 键依次跳转填写每个字段。

---

#### 更丰富的模板变体

1. 带参数列表的详细模板

```json
{
  "Bash Function Detailed Doc": {
    "prefix": "funcd",
    "body": [
      "######################################",
      "# ${1:Brief description}",
      "#",
      "# Description:",
      "#   ${2:Detailed description of what this function does.}",
      "#",
      "# Globals:",
      "#   ${3:None}",
      "#",
      "# Arguments:",
      "#   \\$1 - ${4:first_param_description}",
      "#   \\$2 - ${5:second_param_description}",
      "#",
      "# Outputs:",
      "#   Writes ${6:output description} to stdout",
      "#",
      "# Returns:",
      "#   ${7:0 on success, non-zero on error}",
      "#",
      "# Example:",
      "#   ${8:function_name \"arg1\" \"arg2\"}",
      "######################################",
      "${9:function_name}() {",
      "  local ${10:param1}=\"\\$1\"",
      "  local ${11:param2}=\"\\$2\"",
      "",
      "  ${0:# function body}",
      "}"
    ],
    "description": "Bash function with detailed documentation"
  }
}
```

**效果：**

```bash
######################################
# Process user data
#
# Description:
#   Reads user data from file and validates format.
#
# Globals:
#   USER_CONFIG
#
# Arguments:
#   $1 - username
#   $2 - config file path
#
# Outputs:
#   Writes processed data to stdout
#
# Returns:
#   0 on success, non-zero on error
#
# Example:
#   process_user "john" "/etc/config"
######################################
process_user() {
  local username="$1"
  local config_path="$2"

  # function body
}
```

#### 仅文档注释模板（给已有函数补文档）

```json
{
  "Bash Doc Comment Only": {
    "prefix": "bdoc",
    "body": [
      "######################################",
      "# ${1:Brief description}",
      "#",
      "# Arguments:",
      "#   \\$1 - ${2:description}",
      "# Returns:",
      "#   ${3:0 on success, non-zero on error}",
      "######################################"
    ],
    "description": "Bash documentation comment block"
  }
}
```

---

### 四、完整 `shellscript.json` 一键复制

```json
{
	"Bash Function Doc": {
		"prefix": "fn_doc",
		"body": [
			"######################################",
			"# ${1:Brief description}",
			"# Description:",
			"#   ${2:Detailed description of what this function does.}",
			"# Globals:",
			"#   ${3:None}",
			"# Arguments:",
			"#   \\$1 - ${4:first_param_description}",
			"#",
			"# Outputs:",
			"#   Writes ${5:output description} to stdout",
			"# Returns:",
			"#   ${6:0 on success, non-zero on error}",
			"# Example:",
			"# ",
			"######################################"
		],
		"description": "Create a bash function with Google Shell Style Guide doc comment"
	},
	"Bash Function Doc Short": {
		"prefix": "fn_doc_short",
		"body": [
			"######################################",
			"# ${1:Brief description}",
			"#",
			"# Arguments:",
			"#   \\$1 - ${2:description}",
			"# Returns:",
			"#   ${3:0 on success, non-zero on error}",
			"######################################"
		],
		"description": "Create a bash function with Google Shell Style Guide doc comment"
	},
	"Bash Function With Detailed Doc (1 Param)": {
		"prefix": "fn_full1",
		"body": [
			"######################################",
			"# ${1:Brief description}",
			"# Description:",
			"#   ${2:Detailed description of what this function does.}",
			"# Globals:",
			"#   ${3:None}",
			"# Arguments:",
			"#   \\$1 - ${4:param_description}",
			"# Outputs:",
			"#   Writes ${5:output description} to stdout",
			"# Returns:",
			"#   ${6:0 on success, non-zero on error}",
			"# Example:",
			"#   ${7:function_name \"arg1\"}",
			"######################################",
			"${8:function_name}() {",
			"  local ${9:param}=\"\\$1\"",
			"",
			"  ${0:# function body}",
			"}"
		]
	},
	"Bash Function With Detailed Doc (2 Param)": {
		"prefix": "fn_full2",
		"body": [
			"######################################",
			"# ${1:Brief description}",
			"# Description:",
			"#   ${2:Detailed description of what this function does.}",
			"# Globals:",
			"#   ${3:None}",
			"# Arguments:",
			"#   \\$1 - ${4:first_param_description}",
			"#   \\$2 - ${5:second_param_description}",
			"# Outputs:",
			"#   Writes ${6:output description} to stdout",
			"# Returns:",
			"#   ${7:0 on success, non-zero on error}",
			"# Example:",
			"#   ${8:function_name \"arg1\" \"arg2\"}",
			"######################################",
			"${9:function_name}() {",
			"  local ${10:param1}=\"\\$1\"",
			"  local ${11:param2}=\"\\$2\"",
			"",
			"  ${0:# function body}",
			"}"
		],
		"description": "Bash function with detailed documentation"
	}
}
```

---

### 使用技巧

打开shellscript文件(.sh后缀的文件一般自动识别)

输入触发词(`fn...`) → Tab 展开 → Tab 跳转填写 → 完成

 **提示**：这套注释风格遵循 [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html#s4.1-function-comments)，是业界最广泛使用的 Bash 文档规范。

## 其他

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



