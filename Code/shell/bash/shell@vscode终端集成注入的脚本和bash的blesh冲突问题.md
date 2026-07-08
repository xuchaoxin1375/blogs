[toc]

```shell
$ echo $BLE_VERSION
0.4.0-devel4+b99cadb
$ echo $BLE_ATTACHED 

```

我通过vscode的远程编程链接到某个linux系统上,发现ble.sh不正常:
`$BLE_ATTACHED` 为空,而直接通过ssh链接到bash则是正常的.
这可能是为什么?

最可能原因：**VS Code Remote 的集成终端不是普通 SSH 登录 shell，它会注入自己的 bash shell integration，并参与/改写 `PROMPT_COMMAND`；而 ble.sh 如果没有显式 `ble-attach`，也会依赖 `PROMPT_COMMAND` 来自动 attach。** 结果就是：ble.sh 被 source 了，所以 `$BLE_VERSION` 有值；但 attach 钩子丢了，所以 `$BLE_ATTACHED` 为空。

- ble.sh 维护者也明确提到：自动 attach 可能因为其他配置覆盖 `PROMPT_COMMAND` 而失败，推荐用“开头 source，结尾 ble-attach”的更稳写法。
- VS Code 官方文档也说明它会默认自动注入 shell integration，且 bash 的 `$PROMPT_COMMAND` 形式会影响 integration 工作。([GitHub](https://github.com/akinomyoga/ble.sh/discussions/254))

推荐把 `~/.bashrc` 改成这种结构：

```bash
# ~/.bashrc 顶部附近
case $- in
  *i*) ;;
  *) return ;;
esac

# ble.sh：只加载，不自动 attach
[[ ${BLE_VERSION-} ]] || source ~/.local/share/blesh/ble.sh --attach=none

# 你的其他配置：
# nvm / sdkman / conda / starship / oh-my-posh / aliases / PATH / PS1 / PROMPT_COMMAND 等
# ...

# ~/.bashrc 最后
[[ ${BLE_VERSION-} && ! ${BLE_ATTACHED-} ]] && ble-attach
```

旧版写法里 `--attach=none` 也可能写成 `--noattach`，你的版本是 `0.4.0-devel4`，优先用 `--attach=none`。

如果这样还不行，可以临时关掉 VS Code 的 terminal shell integration 验证：

```json
"terminal.integrated.shellIntegration.enabled": false
```

VS Code 文档说明这个自动注入可以用该设置关闭。([Visual Studio Code](https://code.visualstudio.com/docs/terminal/shell-integration))

另外检查 `.bashrc` 里是否有这类条件，它们在 VS Code 终端和普通 SSH 下表现会不同：

```bash
[[ -n "$VSCODE_SHELL_INTEGRATION" ]] && return
[[ "$TERM_PROGRAM" == "vscode" ]] && return
[[ -z "$SSH_TTY" ]] && return
```

这些如果出现在 `ble-attach` 之前，也会导致 VS Code 里只加载了 ble.sh，但没有执行到最后的 attach。

**对你这种配置：我倾向于不值得默认开启。**

VS Code shell integration 本身是有价值的，但它主要服务于 VS Code 终端 UI，而不是 shell 编辑体验。它能让 VS Code 更准确知道命令边界、退出码、当前目录，从而实现命令装饰、命令导航、sticky scroll、Quick Fix、Run Recent Command、Go to Recent Directory、正确解析当前目录下的文件链接等功能。VS Code 官方文档也说明，它通过注入参数或环境变量自动激活，并且复杂 shell 配置下可能不适合自动注入，推荐改用手动安装。([Visual Studio Code](https://code.visualstudio.com/docs/terminal/shell-integration))

但你已经在用 **ble.sh**，而且已经实测 VS Code 自动 shell integration 会导致 `ble-attach` 失败。那取舍就很明确：

| 场景                                                         | 建议                               |
| ------------------------------------------------------------ | ---------------------------------- |
| 你主要依赖 ble.sh 的补全、历史搜索、编辑体验                 | **关掉 VS Code shell integration** |
| 你经常用 VS Code 终端的命令跳转、命令状态图标、Recent Command、Quick Fix | 可以尝试保留                       |
| 你希望 shell 行为和普通 SSH / 本地终端尽量一致               | **关掉**                           |
| 你写 `.bashrc` 很复杂，有 ble.sh、starship、conda、nvm、PROMPT_COMMAND 等 | **关掉或手动接入**                 |

我的建议是：**保持**

```json
"terminal.integrated.shellIntegration.enabled": false
```

尤其是在 Remote SSH + bash + ble.sh 这个组合里。ble.sh 改善的是每天每次敲命令的核心交互；VS Code shell integration 改善的是 VS Code 对终端输出的“理解”。对重度 shell 用户来说，前者通常更重要。

你可以之后尝试“手动安装”VS Code shell integration，而不是自动注入。官方给 bash 的手动方式是：

```bash
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path bash)"
```

并且官方也说手动安装时推荐把 `terminal.integrated.shellIntegration.enabled` 设为 `false`。([Visual Studio Code](https://code.visualstudio.com/docs/terminal/shell-integration))

但在你的情况下，我会先不加这句。先保证：

```bash
source ~/.local/share/blesh/ble.sh --attach=none

# 其他初始化
# ...

ble-attach
```

稳定工作。只有当你确实怀念 VS Code 的命令装饰、命令跳转、Recent Command、Go to Recent Directory 时，再试手动接入，并仔细测试 `BLE_ATTACHED`、补全、历史、光标移动是否都正常。

一句话：**普通用户值得开；你这种 ble.sh 重度配置，不值得为了它牺牲 shell 稳定性。**

这些都是 **VS Code 终端在“看懂 shell 里发生了什么”之后提供的 UI 功能**。它不是 bash/zsh 自带的能力，而是 VS Code 通过 shell integration 得知“哪里是 prompt、哪里是命令、命令何时开始/结束、退出码是多少、当前目录是什么”之后做出来的增强。VS Code 文档把这些归为 terminal shell integration 功能。([Visual Studio Code](https://code.visualstudio.com/docs/terminal/shell-integration))

### 命令装饰 Command Decorations

就是终端左侧的小圆点、小叉号等标记。

比如你运行：

```bash
npm test
```

如果成功，左边可能有成功标记；如果失败，左边可能有失败标记。点击这个标记，还可能出现复制输出、重新运行命令等操作。VS Code 文档说明它会利用命令退出码来显示成功/失败装饰，并可在滚动条 overview ruler 上显示对应标记。([Visual Studio Code](https://code.visualstudio.com/docs/terminal/shell-integration))

直观理解：**给每条命令加一个“状态徽章”。**

------

### 命令跳转 Command Navigation

这是在终端输出很多时，用快捷键在“上一条命令 / 下一条命令”之间跳。

默认一般是：

```text
Ctrl+Up / Ctrl+Down
```

macOS 是：

```text
Cmd+Up / Cmd+Down
```

它不是普通地滚动一行，而是跳到上一条/下一条 shell 命令的位置。文档说 shell integration 检测到的命令位置会用于 command navigation，从而更可靠地在命令之间导航，并且配合 Shift 可以选择该命令的输出。([Visual Studio Code](https://code.visualstudio.com/docs/terminal/shell-integration))

直观理解：**像在编辑器里跳函数一样，在终端里跳命令块。**

------

### Run Recent Command

这是 VS Code 版的“最近命令列表”。

你可以打开一个 Quick Pick，然后看到最近运行过的命令，搜索并重新运行。它有点像 shell 里的：

```bash
Ctrl+R
```

但区别是它是 VS Code UI 提供的，可以来自当前 session、之前 session、shell history file 等来源。默认快捷键是：

```text
Ctrl+Alt+R
```

VS Code 文档说明它会从当前会话、之前会话以及通用 shell history 文件里汇总历史命令，并支持过滤、pin、Alt 只写入不执行等行为。([Visual Studio Code](https://code.visualstudio.com/docs/terminal/shell-integration))

直观理解：**VS Code 自带的命令历史搜索面板。**

------

### Go to Recent Directory

这是 VS Code 版的“最近目录跳转”。

比如你之前进过：

```bash
~/projects/foo
/var/log/nginx
/mnt/c/work/bar
```

它会记住这些目录。你打开命令后，搜索 `foo` 或 `nginx`，VS Code 可以帮你执行：

```bash
cd ~/projects/foo
```

默认快捷键文档写的是：

```text
Ctrl+G
```

Windows/Linux 下是 `Ctrl+G`，macOS 是 `Cmd+G`。按住 Alt 时，可以只把 `cd ...` 写入终端但不执行。([Visual Studio Code](https://code.visualstudio.com/docs/terminal/shell-integration))

直观理解：**VS Code 版的 zoxide/autojump，但更轻量，只记 VS Code 终端里去过的目录。**

------

### 还有一个隐形但很有用的功能：当前目录识别

shell integration 会告诉 VS Code 当前终端所在目录。这样你在终端里看到：

```text
package.json
src/index.ts
```

点击这些文件名时，VS Code 更可能打开**当前目录下正确的那个文件**，而不是在整个 workspace 里搜索一堆同名文件。官方文档也特别提到，启用 shell integration 后，VS Code 知道当前目录，因此能更准确解析终端里的文件链接。([Visual Studio Code](https://code.visualstudio.com/docs/terminal/shell-integration))

------

所以总结一下：

| 功能                   | 实际用途                            | 对你是否重要                       |
| ---------------------- | ----------------------------------- | ---------------------------------- |
| 命令装饰               | 看命令成功/失败，复制输出，重跑命令 | 中等                               |
| 命令跳转               | 在大量终端输出中按命令块跳转        | 有时有用                           |
| Run Recent Command     | VS Code UI 里的历史命令搜索         | 如果你已用 ble.sh/Ctrl-r，价值变低 |
| Go to Recent Directory | 快速 cd 到最近目录                  | 如果你用 zoxide，价值变低          |
| 当前目录识别           | 终端文件链接更准确                  | 有用，但不是刚需                   |

对你来说，因为 **ble.sh 已经提供更强的行编辑、历史搜索、补全体验**，VS Code shell integration 的这些功能属于“锦上添花”。如果它会破坏 `ble-attach`，我会继续关掉它。