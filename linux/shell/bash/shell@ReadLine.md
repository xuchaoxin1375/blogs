[toc]





## GNU Readline

**GNU Readline** 是一个**命令行编辑库**，提供**交互式文本输入的增强功能**。

> 你在终端里能用的很多"方便操作"，都是 Readline 提供的。
>
> GNU Readline 不是一个命令，而是一个软件库（Library）。

---

## Readline 提供的功能

Readline 负责处理你在终端输入命令时的**交互体验**。如果没有它，你的终端将变得非常难用。它主要提供以下功能：

- **行编辑**：允许你用左右方向键移动光标，用退格键删除字符。
- **命令历史**：允许你用上下键找回之前输入过的命令（其实是它在管理 `~/.bash_history`）。
- **快捷键**：支持类 Emacs（默认）或类 Vi 的快捷键。
  - 例如：`Ctrl + A` 跳到行首，`Ctrl + E` 跳到行尾，`Ctrl + R` 搜索历史。
- **自动补全**：当你按下 `Tab` 键时，背后的逻辑通常由 Readline 配合 Shell 完成。

当你运行一个支持交互的程序时，该程序会“链接”到 Readline 库。

我们可以通过 `ldd` 命令查看到底是谁在使用它：

例如查看bash

```bash
# 查看 bash 是否链接了 readline 库
ldd $(which bash) | grep readline
```

如果输出包含 `libreadline.so.x`，就说明这个程序正依赖它来处理你的输入。

### 1. 行编辑快捷键

```bash
Ctrl + A    # 跳到行首
Ctrl + E    # 跳到行尾
Ctrl + U    # 删除光标前所有内容
Ctrl + K    # 删除光标后所有内容
Ctrl + W    # 删除前一个单词
Ctrl + L    # 清屏
Alt + B     # 后退一个单词
Alt + F     # 前进一个单词
```

### 2. 历史记录

```bash
↑ / ↓       # 浏览历史命令
Ctrl + R    # 反向搜索历史
!!          # 执行上一条命令
!$          # 上一条命令的最后参数
```

### 3. Tab 自动补全

```bash
$ cd /ho[Tab]        # 补全为 /home/
$ cat my\ fi[Tab]    # 补全带空格的文件名，自动加反斜杠
```

---

## 哪些程序使用 Readline？

| 程序                 | 说明              |
| -------------------- | ----------------- |
| **Bash**             | 默认使用 Readline |
| **Python REPL**      | `python` 交互模式 |
| **MySQL/PostgreSQL** | 命令行客户端      |
| **GDB**              | 调试器            |
| **ftp/bc/gnuplot**   | 各种命令行工具    |

---

## 与 read 命令的关系

```bash
# 普通 read：没有编辑功能
read name        # 只能输入，无法用快捷键编辑

# read -e：启用 Readline
read -e name     # 支持 Tab 补全、Ctrl+A、历史记录等
```

### 演示

```bash
# 不用 -e
$ read filepath
# 输入时：不能 Tab 补全，不能 Ctrl+A 跳到行首

# 使用 -e
$ read -e filepath
# 输入时：Tab 可补全文件名，支持所有编辑快捷键
```

---

## 配置文件

既然它不是命令，你怎么控制它呢？答案是修改配置文件 **`~/.inputrc`**。

这是 Readline 的全局配置文件。你可以在这里自定义快捷键，或者开启一些隐藏的高级功能。

```bash
# 可以通过bind -f ~/.inputrc的方式激活或重载配置.


# 切换到 vi 编辑模式（如果你是键盘侠）
# set editing-mode vi

# 1. 基础全局设置
$include /etc/inputrc
set editing-mode emacs
set show-all-if-ambiguous on    # 按一下 Tab 就显示所有补全结果
set completion-ignore-case on   # 补全忽略大小写
set mark-directories on         # 补全目录时自动加上斜杠 /
set visible-stats on            # 补全列表显示文件类型标识（如 * @ /）

# 2. 搜索增强 (历史记录快速搜索)
# 输入命令开头再按上下键，只在匹配的历史中搜索
"\e[A": history-search-backward
"\e[B": history-search-forward

# 3. 颜色与美化 (如果系统支持)
set colored-stats on            # 补全列表显示颜色
set colored-completion-prefix on # 补全时高亮匹配的部分

# 4. 快捷键微调
# Ctrl+Delete 删除光标后的单词
"\e[3;5~": kill-word
# Ctrl+Backspace 删除光标前的单词
"\C-H": backward-kill-word
```

### 验证修改方法

1. **重新打开 Shell**：Readline 通常在 Shell 启动时读取配置。

2. 使用bind命令刷新配置

   ```bash
   bind -f ~/.inputrc
   ```

   

3. **查看当前所有设置**：

   ```bash
   bind -v  # 列出所有 Readline 变量的当前状态
   bind -P  # 列出所有快捷键的绑定状态
   ```

   如果你在 `.inputrc` 中设置了忽略大小写，可以运行 `bind -v | grep completion-ignore-case` 来检查。

## 总结

```
┌─────────────────────────────────────────────┐
│              GNU Readline                   │
├─────────────────────────────────────────────┤
│  • 命令行编辑（快捷键移动/删除）             │
│  • 历史记录（上下浏览、搜索）                │
│  • Tab 自动补全                             │
│  • 可配置（~/.inputrc）                     │
├─────────────────────────────────────────────┤
│  被 Bash、Python、MySQL 等程序使用           │
└─────────────────────────────────────────────┘
```

> 💡 简单说：**Readline = 让命令行输入变得好用的库**