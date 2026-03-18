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



> Visual Studio Code extension utilizing the [Bash Language Server](https://github.com/bash-lsp/bash-language-server) and integrating with [explainshell](https://explainshell.com/), [shellcheck](https://www.shellcheck.net/) and [shfmt](https://github.com/mvdan/sh).
>
> We recommend that you [install shellcheck](https://github.com/koalaman/shellcheck#installing) to enable linting and [install shfmt](https://github.com/mvdan/sh?tab=readme-ov-file#shfmt) to enable formatting.

- shellcheck和shfmt这两个工具(`shellcheck`和`shfmt`)不仅在linux上可用,windows上也可用.
- 这是一个命令行解释工具(在线网站)https://explainshell.com/,也可以部署本地服务集成到Bash IDE([idank/explainshell：将命令行参数与他们的帮助文本匹配](https://github.com/idank/explainshell)),安装条件比前面两个工具略高,这作为一个可选的功能.

### 部分脚本文件的符号分析和大纲(outline)失效

Bash IDE插件在vscode刚启动时可能无法立即工作,需要一些时间,如果过早打开shell文件可能导致该文件的分析无法正常进行;

尤其是目标文件内容复杂的情况,如果卡住无法分析符号等,**请关闭该文件后重新打开**.

#### 插件功能异常检查

Bash IDE插件功能相对复杂,支持的功能比较多,如果环境或配置不当,许多功能无法生效.

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

配置追踪外部`shell`脚本文件的行为

> [ShellCheck：SC1091 – 未跟随：（此处有错误信息）](https://www.shellcheck.net/wiki/SC1091)

当脚本中使用 `source` 或 `.`（点命令）引用了外部文件，但 ShellCheck **无法找到或无法打开**该文件时，就会触发此警告。

```bash
#!/bin/bash

# 引用一个外部配置文件
source /etc/myapp/config.sh       # ← SC1091
. ./lib/utils.sh                  # ← SC1091
source "${DIR}/helpers.sh"        # ← SC1091
```

ShellCheck 是**静态分析**工具，它希望能够：

1. **跟踪（follow）** 被 `source` 的文件
2. 检查被引用文件中定义的**变量和函数**
3. 避免对已在外部文件中定义的变量发出"未使用/未定义"的**误报**

如果 ShellCheck 无法读取被 `source` 的文件，它就无法得知该文件中定义了哪些变量和函数，可能导致后续的**误报**。

最佳处理策略：

1. **首选**：使用 `shellcheck -x` + `source-path` 让 ShellCheck 能找到并分析文件
2. **次选**：用 `# shellcheck source=实际文件路径` 手动指引
3. **兜底**：用 `# shellcheck source=/dev/null` 显式跳过

---

#### 使用 `-x` 选项（推荐）

`-x`（`--external-sources`）选项允许 ShellCheck 跟踪并检查外部 `source` 的文件：

```bash
shellcheck -x myscript.sh
```

这要求被引用的文件在 ShellCheck 运行时能通过相对/绝对路径访问到。

### 使用 `source-path` 指令

在脚本顶部指定搜索路径：

```bash
#!/bin/bash
# shellcheck source-path=SCRIPTDIR
# 告诉 ShellCheck 从脚本所在目录查找 source 文件

source lib/utils.sh

# 搜索多个路径
# shellcheck source-path=SCRIPTDIR
# shellcheck source-path=SCRIPTDIR/lib
# shellcheck source-path=/etc/myapp
```

常用的 `source-path` 值：

| 值          | 含义                              |
| ----------- | --------------------------------- |
| `SCRIPTDIR` | 被检查脚本所在的目录              |
| 绝对路径    | 指定具体目录，如 `/opt/myapp/lib` |
| 相对路径    | 相对于当前工作目录                |



#### vscode中配置`shellcheck`的`-x`参数

可以尝试在vscode中的如下选项中添加shellcheck的参数`-x`(根据插件安装情况配置)

- `bashIde.shellcheckArguments`
- `shellcheck.customArgs`

配置后可能需要重载vscode才会生效

> 生效的特征:对于source的文件如果明确存在,则不再警告追踪问题,并且支持ctrl+鼠标点击跳转到被引用的外部shell文件

### 代码格式化排版插件(shfmt)

在vscode中,Bash IDE插件已经集成了此功能,但是这需要你事先安装shfmt

如果不生效,或者需要额外的配置,可以使用其他专门的格式化插件,例如`shell-format-rev`

[shell-format-rev - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=lumirelle.shell-format-rev)

------

### 代码示例提示插件(tldr)

这个部分是可选的增强.下面到插件不仅仅适用于bash脚本编辑,还支持windows cmd(bat)脚本编写中发挥作用,但是tooltip可能和其他一些相似的提示插件相互覆盖,按需使用

[tl;dr pages - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=bmuskalla.vscode-tldr)

## 有利于静态检查的写法和注意事项

- 使用变量前事先声明或初始化,有助于IDE在后期赋值时对不恰当的值类型做出警告;
- IDE的变量名重命名(重构)功能,对于部分的shell内置命令对变量名的引用和赋值可能无法级联修改;

> 例如`read,mapfile`这类命令将标准输入读取为数组的命令
>
> 又比如`unset "array[n]"`,也要注意`array`变更时带来的影响
>
> ```bash
> mapfile -t var
> ```
>
> 相比于一般的初始化的变量名在使用变量重命名功能时,需要额外的注意;

## Bash 增强框架

按需使用

### bash-completion

[GitHub - scop/bash-completion: Programmable completion functions for bash · GitHub](https://github.com/scop/bash-completion/)

注意，部分系统安装后并不自动启用补全功能,例如ubuntu;需要根据官方文档提供的指导插入激活的shell片段;

1. 现代化的激活方式 (Bash >= 4.2)

文档提供了一段非常严谨的 Shell 代码，按需将其放入 `~/.bashrc`。

```bash
[[ $PS1 &&                                 #  确认是交互式 Shell（防止脚本执行时加载）
  ! ${BASH_COMPLETION_VERSINFO:-} &&        #  确认还没被加载过（避免重复加载浪费资源）
  -f /usr/share/bash-completion/bash_completion ]] && #  确认文件确实存在
    . /usr/share/bash-completion/bash_completion      #  执行加载
```

**重点：** 这种方式比简单的 `source` 更聪明，它通过检查变量 `BASH_COMPLETION_VERSINFO` 来防止“二次加载”，从而提升终端启动速度。

------

2. 自动化加载机制 (`profile.d`)

大多数现代 Linux（如你的 Ubuntu 22.04）使用 `/etc/profile.d/` 目录。

- **原理：** 当你登录时，系统会自动扫描并运行该目录下所有的 `.sh` 脚本。
- **现状：** 如果你通过 `apt install` 安装，通常系统已经自动帮你放了一个 `bash_completion.sh` 在那里，你理论上不需要手动修改 `.bashrc`。
- **失效原因：** 如果你的系统不走这个自动化流程，你就必须回到第 1 步手动在 `.bashrc` 中 `source` 它。

------

上述判断片段和 `/etc/profile.d/bash_completion.sh` 的对比

| 特性               | `/etc/profile.d/bash_completion.sh`          | 这段代码                                        |
| ------------------ | -------------------------------------------- | ----------------------------------------------- |
| **语法**           | POSIX `[ ]` (兼容 sh)                        | Bash `[[ ]]` (仅限 Bash)                        |
| **判断是否 Bash**  | ✅ 显式检查 `${BASH_VERSION-}`                | ❌ 不检查（因为 `[[ ]]` 本身就只在 Bash 中有效） |
| **版本检查**       | ✅ 要求 Bash ≥ 4.2                            | ❌ 无版本检查                                    |
| **progcomp 检查**  | ✅ `shopt -q progcomp`                        | ❌ 不检查                                        |
| **用户自定义配置** | ✅ 先加载 `~/.config/bash_completion`         | ❌ 不处理                                        |
| **防重复加载**     | ✅ `BASH_COMPLETION_VERSINFO`                 | ✅ `BASH_COMPLETION_VERSINFO`                    |
| **加载时机**       | login shell（`/etc/profile` → `profile.d/`） | 每次交互式 shell（`bashrc`）                    |

#### 关闭bash-completion

使用 `shopt -u progcomp`指令关闭;专门解决**“系统全局安装了补全，但个人不想用”**的情况。

逻辑链条如下：

1. **全局脚本运行：** 系统在启动时会执行 `profile.d` 里的脚本来加载补全。
2. **钩子（Hook）检查：** 这个全局脚本在加载前,由于bash-completion的安装文件,bash会看一眼你的个人配置文件
3. **拦截操作：** 如果你在该文件中写入 `shopt -u progcomp`：
   - 全局脚本检测到 `progcomp`（可编程补全）被关掉了。
   - 于是，全局脚本会**停止加载**那些沉重的补全库，从而节省内存和启动时间。
4. **按需恢复：** 如果你只是想在特定时候关闭，可以在 `.bashrc` 里再用 `shopt -s progcomp` 开启，但这通常用于复杂的自定义环境。

如果您的系统不使用 `profile.d` 目录（通常位 `/etc`目录下的一个子目录:`/etc/profile.d` ) （即，不会自动加载其中的 shell 脚本）,你可以尝试自己在`/etc/bashrc`或`~/.bashrc`(具体哪个文件取决于你的系统)文件中用`source`命令导入`bash_completion.sh`脚本.

某些系统**不会**自动 source `/etc/profile.d/` 下的脚本：

- **某些最小化安装的系统**（minimal install）
- **某些 BSD 系统**（如 FreeBSD）
- **自定义的嵌入式 Linux**
- **`/etc/profile` 被用户修改过**，去掉了遍历 `profile.d` 的逻辑
- **非登录 shell**（non-login shell）—— 不会读取 `/etc/profile`

在这些情况下，`bash_completion.sh` 即使放在 `/etc/profile.d/` 下也**不会被自动加载**，bash 补全功能将不可用。

> 对于编译安装的情况,`$sysconfdir` 是编译时（`./configure`）指定的**系统配置目录**变量：
>
> If your system does not use the `profile.d` directory (usually below `/etc`) mechanism (i.e., does not automatically source shell scripts in it), you can source the `$sysconfdir/profile.d/bash_completion.sh` script in `/etc/bashrc` or `~/.bashrc`.

在典型的ubuntu系统上,安装后会产生`/etc/profile.d/bash_completion.sh`,

> ```bash
> $  ls /etc/profile.d/*bash_completion*
> /etc/profile.d/bash_completion.sh
> ```
>
> 

`profile.d` 脚本提供了一个配置文件钩子，可用于在系统范围安装 `bash_completion` 时，阻止为每个用户单独加载该插件。具体操作如下：

1. 使用 `shopt -u progcomp` 关闭可编程补全功能 `$XDG_CONFIG_HOME/bash_completion` （或 `~/.config/bash_completion` 如果未设置 `$XDG_CONFIG_HOME` ）
2. 如果您想将可编程补全用于其他用途，请重新启用它（例如在 `~/.bashrc` 中）。

#### 补全相关脚本

| 属性     | 文件 1                              | 文件 2                                       |
| -------- | ----------------------------------- | -------------------------------------------- |
| **路径** | `/etc/profile.d/bash_completion.sh` | `/usr/share/bash-completion/bash_completion` |
| **角色** | **入口/加载器** (loader)            | **实际补全引擎** (engine)                    |
| **大小** | 很小（十几行）                      | 很大（通常 2000+ 行）                        |

------

#### 问题排查

1. **检查变量：** 在终端输入 `echo $BASH_COMPLETION_VERSINFO`。
   - 如果有输出版本号，说明`bash-completion` **已经加载**了，可能是某个特定命令（如 docker）的补全脚本没装好。
   - 如果为空，说明**没加载**。
2. **手动强制加载：** 将文档中那段 `[[ $PS1 && ... ]]` 代码直接复制到你的 `~/.bashrc` 文件末尾，然后重启终端。

#### 部分命令补全不可用

这说明了一个很关键的点：你的 **基础补全（bash-completion）** 是在工作的，但 **特定命令的补全（Programmable Completion）** 在处理 `git` 时掉链子了。

`ls -` 能补全是因为它是 Bash 最基础的内置规则，而 `git` 补全需要依赖专门的脚本来解析 Git 的子命令。

以下是排查和修复的步骤：

------

1. 核心原因：Git 补全脚本没有“挂载”成功

Bash 补全像是一个插件系统。`ls` 的插件默认加载了，但 `git` 的插件可能在当前 Shell 环境中失效了。

**立即测试：**

在终端输入以下命令，手动加载 Git 补全脚本（路径通常如下）：

```Bash
source /usr/share/bash-completion/completions/git
```

然后再输入 `git che` 按 **Tab**。如果好了，说明就是加载问题。

------

2. 检查环境变量和配置文件

如果手动加载有效，但新开窗口又失效，请检查你的 `~/.bashrc`。里面可能有和补全脚本冲突的设置项

> 可以临时讲`~/.bashrc`重命名(.bak);然后创建一份空的`~/.bashrc`,仅保留bash-completion激活代码片段来观察效果

> **注意：** 修改后记得执行 `source ~/.bashrc` 使其生效。

------

3. 为什么 `ls` 可以但 `git` 不行？

这是因为补全机制分为两个层级：

1. **通用补全 (Common Completion):** 处理路径、文件名、以及像 `ls`、`cd` 这种极其基础的命令。
2. **扩展补全 (Completions):** 位于 `/usr/share/bash-completion/completions/` 目录下。每个复杂命令（如 `git`, `docker`, `kubectl`）都有一个专门的脚本文件。

如果 `git` 补全脚本损坏、丢失，或者因为权限问题没被加载，Bash 就会回退到“文件名补全”模式。这就是为什么它不给你补全 `checkout`，反而去补全 `check.sh` 的原因。

------

4. 检查是否安装了 git-core

在某些精简版系统（如 Docker 容器或轻量版 Ubuntu）中，可能只安装了 `git` 执行文件，没装补全增强包。

- **Ubuntu/Debian:** `sudo apt install bash-completion`
- **RHEL/CentOS:** `sudo yum install bash-completion`

------

5. 一个“暴力”但有效的诊断命令

使用bash内置的`completion`命令(readline 系列)

```Bash
complete -p git
```

- **正常结果：** 应该输出类似 `complete -o bashdefault -o default -o nospace -F __git_wrap__git_main git`。
- **错误结果：** 如果输出 `bash: complete: git: no completion specification found`，说明 Git 的补全定义彻底没加载。



### ohmyzsh类似的bash框架

这些参考oh my zsh设计的框架,效果并不如oh my zsh好,交互式插件例如命令语法高亮是缺失的.

主要是提供prompt美化和常用别名的集成,以及常见命令的补全提示,但是和oh my zsh还有较大差距(可以考虑ble.sh项目提供的补全体验);

总之,下面的项目酌情考虑;

#### Bash-it

[Bash-it/bash-it: A community Bash framework.](https://github.com/Bash-it/bash-it)

- **Bash-it** 是一个社区 Bash 命令和脚本的集合，专为 Bash 而设计。

- 功能非常接近 **Oh My Zsh**：支持**插件（plugins）**、**别名（aliases）**、**命令补全（completions）**、**主题（themes）**。

- 适合希望在 Bash 上获得完整“插件生态”的用户。

- GitHub: `Bash-it`

- 示例安装：

  ```bash
  git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
  ~/.bash_it/install.sh
  ```

#### Oh My Bash

- 专为 Bash 打造的 **Oh My Zsh 移植版本（port）**。

- 虽然结构、插件系统、主题形式都与 **Oh My Zsh** ,但是在交互模式中没有提供高亮,历史命令提示,,命令补全这些方面的支持,有这类需求的请寻找其他方案,比如`bash-completion`和`blesh`。

- GitHub: `ohmybash/oh-my-bash`
   安装示例：

  ```bash
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
  ```

### Blesh / ble.sh



[akinomyoga/ble.sh: Bash Line Editor―a line editor written in pure Bash with syntax highlighting, auto suggestions, vim modes, etc. for Bash interactive sessions.](https://github.com/akinomyoga/ble.sh)

全称 **Bash Line Editor**。

*Bash 行编辑器* ( `ble.sh` [†1](https://github.com/akinomyoga/ble.sh#discl-pronun) ) 是一个用纯 Bash [†2](https://github.com/akinomyoga/ble.sh#discl-pure) 编写的命令行编辑器，它**取代了默认的 GNU Readline**。

- 这是 Bash 用户体验增强中最现代、**功能最强**的项目之一。

  - 但是项目实现比较复杂,对shell的响应速度会造成一定的影响

- 提供类似 Zsh 的：

  - **语法高亮（syntax highlighting）**
  - **智能补全（intelligent completion）**
  - **提示增强（prompt enhancement）**
  - **异步提示更新（async prompt）**

- 不修改你的 Bash 配置框架，只增强 Bash 本身的输入体验。


> - **语法高亮** ：ble.sh 可以像 `fish` 和 `zsh-syntax-highlighting` 一样，高亮显示用户输入的命令行。与 `zsh-syntax-highlighting` 的简单高亮不同， `ble.sh` 会进行语法分析，从而能够正确高亮显示复杂的结构，例如嵌套的命令替换、多个 here 文档等。高亮颜色和样式完全可配置 。
> - **增强完成** ：延长完成时间 通过**语法感知补全** 、带引号的补全、前缀文本中的参数扩展、 **歧义候选词生成**等方式，以及**菜单补全。** 支持使用光标键、 TAB 和 S-TAB 在菜单（候选人列表）中选择候选。该功能**支持自动完成。** 支持类似 `fish` 和 `zsh-autosuggestions` 的自动文本建议功能（Bash 4.0 及更高版本）。该功能**还包含菜单过滤器** 。 将自动筛选候选词的功能集成到菜单补全中（Bash 4.0+）。 还有其他功能，例如： **缩写**和 **缩写** *zsh 缩写*或 `zsh-abbr` 。
> - **Vim 编辑模式** ：增强 `readline` 的 vi 编辑模式，可通过 `set -o vi` 启用。Vim 编辑模式支持多种 vim 模式，例如字符/行/块可视/选择模式、替换模式、命令模式、运算符挂起模式、插入模式和普通模式。Vim 编辑模式支持各种运算符、文本对象、寄存器、键盘宏、标记等。它还提供 `vim-surround` 作为可选组件。
> - 其他有趣的功能包括 **状态行** ， **历史分享** ， **正确的提示** ， **瞬态提示** ， **xterm 标题**等。
>
> 注意：ble.sh 不提供提示符、别名、函数等的具体设置。ble.sh 提供了一个更基础的架构，以便用户可以设置自己的提示符、别名、函数等。当然，ble.sh 可以与其他 Bash 配置（例如 [`bash-it`](https://github.com/Bash-it/bash-it) 和 [`oh-my-bash`](https://github.com/ohmybash/oh-my-bash) 结合使用。

- 安装示例：

  ```bash
  git clone https://github.com/akinomyoga/ble.sh.git
  make -C ble.sh install PREFIX=~/.local
  echo 'source ~/.local/share/blesh/ble.sh' >> ~/.bashrc
  ```

------

## 自定义代码片段(snippet)

VS Code 中 Bash 函数文档注释方案

### 相关插件推荐

有几个插件可以辅助，但**没有专门针对 Bash 函数文档注释**的成熟插件（不像 JSDoc/Doxygen 那样自动生成）：

**结论：最佳方案是自定义 Snippet**，完全可控且效果很好。

---

### 自定义 Snippet

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

### 完整 `shellscript.json` 一键复制

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



