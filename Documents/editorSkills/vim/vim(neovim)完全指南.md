[toc]

# Neovim 完整学习指南



## 1. 引言与历史背景

### 什么是 Vim/Neovim

Vim（Vi IMproved）是一款高度可配置的文本编辑器，诞生于 1991 年，由 Bram Moolenaar 基于更早的 vi 编辑器（1976 年）开发而成。Neovim 是 Vim 的现代化重构版本，始于 2014 年，它保持了与 Vim 的高度兼容性，同时引入了更现代的架构和特性。

### 为什么选择 Neovim

Neovim 相比传统 Vim 具有若干显著优势。首先是内置 Lua 支持，Lua 是一种轻量级脚本语言，比 Vimscript 更快、更易读、生态更丰富。其次是更好的异步架构，插件可以在后台运行而不阻塞编辑器。Neovim 还内置了 LSP（Language Server Protocol）客户端和 Tree-sitter 解析器，前者提供智能补全、诊断、重构等 IDE 级功能，后者提供更准确的语法高亮和代码分析。此外，Neovim 拥有活跃的社区和现代化的插件生态。

### 核心设计哲学

Vim 的设计哲学建立在几个核心原则之上。第一是模态编辑，不同模式专注不同任务，减少手指移动。第二是组合性，简单命令可以组合成复杂操作。第三是可重复性，通过 `.` 命令重复上一次编辑。第四是可定制性，几乎一切都可以重新映射和配置。

------

## 2. 安装与基础配置

### 安装 Neovim

在不同操作系统上安装 Neovim 的方法略有不同。macOS 用户可以通过 Homebrew 安装：

```bash
brew install neovim
```

Ubuntu/Debian 用户可以使用 apt：

```bash
sudo apt update
sudo apt install neovim
```

如果需要最新版本，可以添加 PPA：

```bash
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim
```

Arch Linux 用户使用 pacman：

```bash
sudo pacman -S neovim
```

Windows 用户可以通过 winget、scoop 或 chocolatey 安装：

```powershell
winget install Neovim.Neovim
# 或
scoop install neovim
# 或
choco install neovim
```

安装完成后，在终端输入 `nvim` 即可启动 Neovim。

### 配置文件位置

Neovim 的配置文件位置遵循 XDG 规范。在 Linux 和 macOS 上，主配置文件位于 `~/.config/nvim/init.lua`（Lua 配置）或 `~/.config/nvim/init.vim`（传统 Vimscript 配置）。在 Windows 上，配置文件位于 `~/AppData/Local/nvim/init.lua`。

推荐的目录结构如下：

```
~/.config/nvim/
├── init.lua              # 主入口文件
├── lua/
│   ├── config/           # 基础配置
│   │   ├── options.lua   # 编辑器选项
│   │   ├── keymaps.lua   # 快捷键映射
│   │   └── autocmds.lua  # 自动命令
│   └── plugins/          # 插件配置
│       ├── lsp.lua
│       ├── telescope.lua
│       └── ...
└── lazy-lock.json        # 插件版本锁定文件
```

### 基础选项设置

以下是一个推荐的基础配置，保存为 `~/.config/nvim/lua/config/options.lua`：

```lua
-- 行号设置
vim.opt.number = true         -- 显示行号
vim.opt.relativenumber = true -- 相对行号，方便跳转

-- 缩进设置
vim.opt.tabstop = 4           -- Tab 显示为 4 个空格宽度
vim.opt.shiftwidth = 4        -- 自动缩进使用 4 个空格
vim.opt.expandtab = true      -- 将 Tab 转换为空格
vim.opt.smartindent = true    -- 智能缩进

-- 搜索设置
vim.opt.ignorecase = true     -- 搜索时忽略大小写
vim.opt.smartcase = true      -- 如果包含大写字母则区分大小写
vim.opt.hlsearch = true       -- 高亮搜索结果
vim.opt.incsearch = true      -- 增量搜索

-- 外观设置
vim.opt.termguicolors = true  -- 启用真彩色
vim.opt.signcolumn = "yes"    -- 始终显示符号列
vim.opt.cursorline = true     -- 高亮当前行
vim.opt.scrolloff = 8         -- 光标距离顶部/底部保持 8 行
vim.opt.sidescrolloff = 8     -- 水平滚动时保持 8 列

-- 行为设置
vim.opt.mouse = "a"           -- 启用鼠标支持
vim.opt.clipboard = "unnamedplus" -- 使用系统剪贴板
vim.opt.undofile = true       -- 持久化撤销历史
vim.opt.swapfile = false      -- 禁用交换文件
vim.opt.updatetime = 250      -- 更快的更新时间
vim.opt.timeoutlen = 300      -- 快捷键等待时间

-- 分割窗口设置
vim.opt.splitright = true     -- 垂直分割时新窗口在右边
vim.opt.splitbelow = true     -- 水平分割时新窗口在下边

-- 显示不可见字符
vim.opt.list = true
vim.opt.listchars = {
    tab = "→ ",
    trail = "·",
    extends = "»",
    precedes = "«",
}
```

在 `init.lua` 中引入这个配置：

```lua
require("config.options")
```

------

## 3. 核心概念：模态编辑

### 什么是模态编辑

模态编辑是 Vim 最独特也最强大的特性。与大多数编辑器不同，Vim 有多种"模式"，每种模式下按键有不同的含义。这种设计使得你可以用最少的按键完成最多的操作，因为同一个按键在不同模式下可以执行不同的功能。

初学者常常困惑于为什么按 `j` 不是输入字母 j，而是向下移动光标。这正是因为 Vim 默认处于普通模式，而非插入模式。

### 主要模式详解

**普通模式（Normal Mode）** 是 Vim 的默认模式，也是你停留时间最长的模式。在这个模式下，按键用于导航、编辑命令和操作符。按 `Esc` 或 `Ctrl+[` 可以从任何模式回到普通模式。这是 Vim 的"休息位置"，你应该养成完成编辑后立即返回普通模式的习惯。

**插入模式（Insert Mode）** 用于实际输入文本，行为类似普通编辑器。进入方式有多种：`i` 在光标前插入，`a` 在光标后插入，`I` 在行首插入，`A` 在行尾插入，`o` 在下方新开一行，`O` 在上方新开一行。按 `Esc` 返回普通模式。

**可视模式（Visual Mode）** 用于选择文本区域，然后对选中区域执行操作。`v` 进入字符可视模式，`V` 进入行可视模式，`Ctrl+v` 进入块可视模式。选择完成后可以执行操作，如 `d` 删除、`y` 复制、`c` 修改等。

**命令行模式（Command-line Mode）** 用于执行 Ex 命令。按 `:` 进入，输入命令后按回车执行。常见命令包括 `:w` 保存、`:q` 退出、`:wq` 保存并退出、`:e filename` 打开文件。

**替换模式（Replace Mode）** 用于覆盖式输入，按 `R` 进入。每输入一个字符会替换光标下的字符，而非插入。

### 模式切换流程图

```
                    ┌─────────────────┐
                    │   普通模式      │
                    │  (Normal Mode)  │
                    └────────┬────────┘
                             │
         ┌───────────────────┼───────────────────┐
         │                   │                   │
         ▼                   ▼                   ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│   插入模式      │ │   可视模式      │ │  命令行模式     │
│ i, a, o, I, A, O│ │   v, V, Ctrl+v  │ │    :, /, ?      │
└────────┬────────┘ └────────┬────────┘ └────────┬────────┘
         │                   │                   │
         └───────────────────┴───────────────────┘
                             │
                           Esc
                             │
                             ▼
                    ┌─────────────────┐
                    │   普通模式      │
                    └─────────────────┘
```

### 为什么模态编辑更高效

模态编辑的效率来源于几个方面。首先，在普通模式下，整个键盘都是快捷键，无需按 Ctrl 或 Alt 组合键。其次，双手始终保持在键盘主区，不需要频繁移动去按方向键或鼠标。第三，命令可以组合和重复，例如 `d3w` 表示删除 3 个单词。最后，编辑操作被分解为离散的、可重复的单元。

------

## 4. 移动与导航

### 基础移动

Vim 使用 `h`、`j`、`k`、`l` 作为基本方向键，分别对应左、下、上、右。这四个键位于键盘主行，手指无需离开打字位置。这个设计可以追溯到 Bill Joy 使用的 ADM-3A 终端，其键盘上这四个键确实标有箭头。

```
       k
       ↑
   h ← · → l
       ↓
       j
```

所有移动命令都可以加数字前缀。例如 `5j` 向下移动 5 行，`10l` 向右移动 10 个字符。

### 单词级移动

单词移动是日常编辑中最常用的导航方式。`w` 移动到下一个单词开头，`b` 移动到前一个单词开头，`e` 移动到当前/下一个单词结尾，`ge` 移动到前一个单词结尾。

Vim 区分"word"和"WORD"。小写命令（w, b, e）识别的单词以标点符号分隔，而大写命令（W, B, E）识别的单词只以空白分隔。例如对于 `hello-world`，`w` 会停在 `-` 和 `w` 处，而 `W` 会将其视为一个整体。

```
示例文本：hello-world foo_bar baz

使用 w 移动：hello -> - -> world -> foo -> _ -> bar -> baz
使用 W 移动：hello-world -> foo_bar -> baz
```

### 行内移动

`0` 移动到行首（第一列），`^` 移动到行首非空白字符，`$` 移动到行尾，`g_` 移动到行尾非空白字符。

`f{char}` 向前查找字符并移动到该字符，`F{char}` 向后查找。`t{char}` 向前查找并移动到该字符之前（till），`T{char}` 向后查找并移动到该字符之后。`;` 重复上次 f/t 查找，`,` 反向重复。

```
示例：The quick brown fox jumps over the lazy dog
光标在 T，执行 fx 后光标移动到 fox 的 x
执行 ; 再次查找，移动到 lazy 之后没有 x，保持原位
执行 Fo 向后查找，移动到 brown 的 o
```

### 垂直移动

`gg` 跳转到文件开头，`G` 跳转到文件末尾。`{number}G` 或 `:{number}` 跳转到指定行号。`{` 跳转到上一个空行，`}` 跳转到下一个空行，这对于在段落间移动很有用。

`Ctrl+d` 向下滚动半屏，`Ctrl+u` 向上滚动半屏。`Ctrl+f` 向下滚动一整屏，`Ctrl+b` 向上滚动一整屏。`zz` 将当前行居中显示，`zt` 将当前行移到屏幕顶部，`zb` 将当前行移到屏幕底部。

### 语义级移动

`%` 在匹配的括号间跳转，支持 `()`、`[]`、`{}`。这在编程时非常有用，可以快速找到配对的括号。

`[[` 跳转到上一个函数/代码块开头，`]]` 跳转到下一个函数/代码块开头。`[]` 跳转到上一个代码块结尾，`][` 跳转到下一个代码块结尾。

`gd` 跳转到局部定义，`gD` 跳转到全局定义。配合 LSP 使用时，这些命令会更加智能。

### 标记与跳转

标记（marks）允许你在文件中设置书签并快速跳回。`m{a-z}` 设置局部标记（只在当前缓冲区有效），`m{A-Z}` 设置全局标记（跨文件有效）。` `{mark}` 跳转到标记的精确位置，`'{mark}` 跳转到标记所在行的行首。

一些特殊标记自动设置：```` 跳转到上次跳转前的位置，``.` 跳转到上次修改的位置，``^` 跳转到上次插入的位置，``[` 和 ``]` 跳转到上次修改或复制的文本的开头/结尾。

`:marks` 命令可以查看所有标记。

### 跳转列表

Vim 维护一个跳转列表，记录你的跳转历史。`Ctrl+o` 回到上一个跳转位置，`Ctrl+i` 前进到下一个跳转位置。`:jumps` 查看跳转列表。

------

## 5. 编辑操作

### 操作符-动作范式

Vim 编辑的核心是"操作符 + 动作"的组合模式。操作符定义要做什么，动作定义对什么范围做。这种组合创造了极大的灵活性。

```
[数字] + 操作符 + [数字] + 动作
```

主要操作符包括：`d` 删除（delete）、`c` 修改（change，删除并进入插入模式）、`y` 复制（yank）、`>` 增加缩进、`<` 减少缩进、`=` 自动格式化缩进、`gU` 转换为大写、`gu` 转换为小写。

### 删除操作

`x` 删除光标下的字符，`X` 删除光标前的字符。`dd` 删除整行，`D` 删除到行尾（等同于 `d$`）。

操作符 + 动作的组合示例：`dw` 删除到下一个单词开头，`de` 删除到当前单词结尾，`db` 删除到前一个单词开头，`d$` 删除到行尾，`d0` 删除到行首，`dG` 删除到文件末尾，`dgg` 删除到文件开头，`d%` 删除到匹配的括号。

配合数字：`3dd` 删除 3 行，`d5w` 删除 5 个单词，`2dj` 删除当前行和下面 2 行（共 3 行）。

### 修改操作

`c` 操作符与 `d` 类似，但删除后会进入插入模式。`cc` 修改整行，`C` 修改到行尾。`cw` 修改到单词结尾，`c$` 修改到行尾。`s` 删除字符并进入插入模式（substitute），`S` 删除整行并进入插入模式。

### 复制与粘贴

`y` 是复制操作符（yank）。`yy` 复制整行，`Y` 也是复制整行（注意这与 `D`、`C` 的逻辑不一致，可以重新映射）。`yw` 复制到单词结尾，`y$` 复制到行尾。

`p` 在光标后粘贴，`P` 在光标前粘贴。如果复制的是整行，`p` 粘贴到下一行，`P` 粘贴到上一行。

### 撤销与重做

`u` 撤销上一次操作，`Ctrl+r` 重做。`U` 撤销当前行的所有修改（这是一个独立的撤销项）。

Vim 维护一个撤销树而非简单的撤销栈。即使你撤销后进行了新的编辑，之前的历史也不会丢失。`:undolist` 可以查看撤销历史，`g-` 和 `g+` 可以在撤销树的不同分支间移动。

### 重复操作

`.` 是 Vim 最强大的命令之一，它重复上一次的编辑操作。这里的"编辑操作"是指从进入插入模式到返回普通模式之间的所有改变，或者一个完整的操作符+动作命令。

```
示例：需要在多行末尾添加分号
1. 移动到第一行行尾：A
2. 输入分号并返回普通模式：;<Esc>
3. 移动到下一行：j
4. 重复操作：.
5. 继续 j. j. j. ...
```

这种"做一次，重复多次"的模式是 Vim 效率的核心。

### 合并与拆分行

`J` 将下一行合并到当前行，中间用空格连接。`gJ` 合并但不添加空格。

在普通模式下没有专门的拆分行命令，但可以用 `r<Enter>` 将当前字符替换为换行符，或者 `i<Enter><Esc>` 在光标处插入换行。

------

## 6. 文本对象与动作

### 什么是文本对象

文本对象是 Vim 最精妙的概念之一。它允许你以语义单位（单词、句子、段落、括号内容等）而非物理位置来选择和操作文本。文本对象只能与操作符一起使用，不能单独作为移动命令。

文本对象的语法是 `a` 或 `i` 加上对象类型。`a` 表示"a/an"（包含周围的空白或定界符），`i` 表示"inner"（不包含周围的空白或定界符）。

### 常用文本对象

**单词对象**：`iw` 是内部单词（不含周围空白），`aw` 是一个单词（含后面的空白）。`iW` 和 `aW` 是以空白分隔的 WORD。

```
示例：Hello, world!
光标在 world 的 o 上
diw 删除 world，结果：Hello, !
daw 删除 world 和前面的空格，结果：Hello,!
```

**句子和段落**：`is` 是内部句子，`as` 是一个句子。`ip` 是内部段落，`ap` 是一个段落（含后面的空行）。

**括号/引号对象**：

- `i(` 或 `ib`：括号内部内容
- `a(` 或 `ab`：包含括号本身
- `i[`：方括号内部
- `i{` 或 `iB`：花括号内部
- `i<`：尖括号内部
- `i"`：双引号内部
- `i'`：单引号内部
- `i``：反引号内部

```
示例：function(arg1, arg2)
光标在括号内任意位置
di( 删除括号内容，结果：function()
da( 删除包括括号，结果：function
ci( 修改括号内容，删除 arg1, arg2 并进入插入模式
```

**标签对象**（HTML/XML）：`it` 是标签内部内容，`at` 是包含标签本身。

```
示例：<div>Hello World</div>
dit 删除 Hello World
dat 删除整个 <div>Hello World</div>
```

### 实际应用示例

假设你正在编辑代码，光标在某个位置：

```python
def calculate(x, y, z):
    result = (x + y) * z
    return result
```

一些操作示例：

- 光标在 `calculate` 上，`ciw` 可以修改函数名
- 光标在参数列表括号内，`ci(` 可以修改所有参数
- 光标在 `(x + y)` 内，`da(` 删除整个括号表达式
- 光标在 `result` 上，`yiw` 复制这个变量名

### 自定义文本对象

通过插件可以添加更多文本对象。例如 `vim-textobj-user` 和相关插件可以添加：

- `ii`/`ai`：缩进级别
- `if`/`af`：函数
- `ic`/`ac`：注释
- `ie`/`ae`：整个文件

------

## 7. 可视模式

### 三种可视模式

**字符可视模式**：按 `v` 进入，可以选择任意范围的字符。选择范围从进入可视模式的位置到当前光标位置。

**行可视模式**：按 `V` 进入，以整行为单位选择。无论光标在行内何处，都会选中整行。

**块可视模式**：按 `Ctrl+v` 进入，可以选择矩形区域。这在处理列数据或批量编辑时非常有用。

### 可视模式下的操作

选择文本后，可以执行各种操作：`d` 删除选中内容、`y` 复制选中内容、`c` 修改选中内容、`>` 增加缩进、`<` 减少缩进、`=` 自动格式化缩进、`~` 切换大小写、`U` 转为大写、`u` 转为小写、`J` 合并为一行、`:` 对选中行执行命令。

### 块可视模式详解

块可视模式是 Vim 的独特功能，允许进行列编辑。

**在多行同时插入文本**：

```
原始文本：
line1
line2
line3

操作步骤：
1. Ctrl+v 进入块可视模式
2. jj 向下选择 3 行
3. I 进入插入模式
4. 输入 prefix_
5. Esc

结果：
prefix_line1
prefix_line2
prefix_line3
```

**在多行末尾添加文本**：

```
1. Ctrl+v 选择多行
2. $ 扩展到每行末尾
3. A 在末尾追加
4. 输入内容
5. Esc
```

**删除列**：

```
原始文本（列对齐的数据）：
001 apple  red
002 banana yellow
003 grape  purple

使用 Ctrl+v 选择第一列的数字，按 d 删除
```

### 技巧与最佳实践

`gv` 重新选择上次选择的区域。`o` 在可视模式下切换光标到选区的另一端，这在调整选区时很有用。

可视模式结合文本对象：在普通模式下 `vaw` 选中一个单词，`vi{` 选中花括号内容。

虽然可视模式直观，但在可能的情况下，操作符+动作或操作符+文本对象通常更高效，因为不需要先选择再操作。例如 `daw` 比 `vaw` 然后 `d` 更快。

------

## 8. 寄存器与宏

### 理解寄存器

寄存器是 Vim 的"剪贴板"，但远比普通剪贴板强大。Vim 有多种类型的寄存器，可以存储不同的内容。

**无名寄存器 `""`**：默认寄存器，`d`、`c`、`y`、`x`、`s` 等操作的内容自动存入这里。

**命名寄存器 `"a` 到 `"z`**：用户可以显式使用的 26 个寄存器。使用小写字母会覆盖内容，使用大写字母会追加内容。

```
"ayy  - 复制当前行到寄存器 a
"Ayy  - 追加当前行到寄存器 a
"ap   - 从寄存器 a 粘贴
```

**数字寄存器 `"0` 到 `"9`**：`"0` 存储最近一次复制的内容，`"1` 到 `"9` 存储最近 9 次删除的内容（删除行或大块文本）。

**特殊寄存器**：

- `"+`：系统剪贴板
- `"*`：主选择（Linux）或剪贴板（Windows/Mac）
- `"_`：黑洞寄存器，写入的内容会消失
- `"/`：最近的搜索模式
- `":`：最近执行的命令
- `".`：最近插入的文本
- `"%`：当前文件名
- `"#`：上一个编辑的文件名
- `"=`：表达式寄存器

### 寄存器的使用

查看所有寄存器内容：`:registers` 或 `:reg`

在普通模式下使用寄存器：

```
"ayy   - 复制行到寄存器 a
"ap    - 从寄存器 a 粘贴
"+y    - 复制到系统剪贴板
"+p    - 从系统剪贴板粘贴
"_dd   - 删除行但不影响任何寄存器
```

在插入模式下粘贴寄存器内容：`Ctrl+r` 然后按寄存器名称。例如 `Ctrl+r 0` 粘贴最近复制的内容，`Ctrl+r +` 粘贴系统剪贴板。

### 宏：录制与回放

宏允许录制一系列按键操作，然后重复执行。这是 Vim 自动化的基础。

**录制宏**：

```
q{寄存器}  - 开始录制到指定寄存器
... 执行操作 ...
q          - 停止录制
```

**回放宏**：

```
@{寄存器}  - 执行一次
@@         - 重复上次执行的宏
{数字}@{寄存器} - 执行多次
```

### 宏的实际示例

**示例 1：将多行转换为列表项**

原始文本：

```
Apple
Banana
Cherry
```

目标：

```
- Apple
- Banana
- Cherry
```

操作步骤：

```
qa       - 开始录制到寄存器 a
I- <Esc> - 在行首插入 "- "
j        - 移动到下一行
q        - 停止录制
2@a      - 对剩余两行执行
```

**示例 2：批量修改代码**

假设需要将所有 `var` 改为 `let`：

```
qa       - 开始录制
/var<Enter> - 搜索 var
ciwlet<Esc> - 修改为 let
n        - 跳转到下一个
q        - 停止录制
100@a    - 执行 100 次（多了也无妨）
```

### 宏的高级技巧

**递归宏**：宏可以调用自身。先清空寄存器 `qaq`，然后录制时在最后调用自己 `@a`。当没有更多匹配时，宏会自动停止。

**编辑宏**：宏存储在寄存器中，可以粘贴出来编辑。`"ap` 粘贴寄存器 a 的内容，编辑后 `"ay$` 重新复制回去。

**并行执行**：`:5,20 normal @a` 在第 5-20 行执行宏。

------

## 9. 搜索与替换

### 基础搜索

`/pattern` 向前搜索，`?pattern` 向后搜索。`n` 跳转到下一个匹配，`N` 跳转到上一个匹配。`*` 搜索光标下的单词（向前），`#` 搜索光标下的单词（向后）。

搜索支持正则表达式。一些常用的元字符：`.` 匹配任意单个字符，`*` 匹配前一个字符零次或多次，`\+` 匹配前一个字符一次或多次，`\?` 匹配前一个字符零次或一次，`^` 行首，`$` 行尾，`\<` 单词开头，`\>` 单词结尾，`[]` 字符类，`\|` 或。

```
/\<word\>  - 精确匹配单词 word
/^func     - 匹配行首的 func
/;$        - 匹配行尾的分号
/[0-9]\+   - 匹配一个或多个数字
```

### 搜索选项

`:set hlsearch` 启用搜索高亮，`:noh` 或 `:nohlsearch` 临时关闭高亮。`:set incsearch` 启用增量搜索，边输入边跳转。`:set ignorecase` 搜索忽略大小写。`:set smartcase` 如果模式包含大写字母则区分大小写。

在搜索模式中，`\c` 强制忽略大小写，`\C` 强制区分大小写。例如 `/\cword` 会匹配 Word、WORD、word 等。

### 替换命令

基本语法：

```
:[range]s/{pattern}/{replacement}/[flags]
```

**范围指定**：

- 无范围：只作用于当前行
- `%`：整个文件
- `1,10`：第 1 到第 10 行
- `.,$`：当前行到文件末尾
- `'<,'>`：可视模式选择的范围（自动填充）

**标志**：

- `g`：替换行内所有匹配（否则只替换第一个）
- `c`：每次替换前确认
- `i`：忽略大小写
- `n`：只计数不替换

**实际示例**：

```vim
:s/foo/bar/           " 当前行第一个 foo 替换为 bar
:s/foo/bar/g          " 当前行所有 foo 替换为 bar
:%s/foo/bar/g         " 全文替换
:%s/foo/bar/gc        " 全文替换，每次确认
:10,20s/foo/bar/g     " 第 10-20 行替换
```

### 替换中的特殊字符

在替换部分（replacement）中：

- `&` 或 `\0`：整个匹配的内容
- `\1` 到 `\9`：捕获组
- `\r`：换行符
- `\t`：制表符
- `\u`：下一个字符大写
- `\l`：下一个字符小写
- `\U`：之后的字符全大写（直到 `\E`）
- `\L`：之后的字符全小写（直到 `\E`）

```vim
" 交换两个单词
:%s/\(foo\)\(bar\)/\2\1/g

" 将匹配内容首字母大写
:%s/\<\(.\)\(\w*\)\>/\u\1\2/g

" 在每行末尾添加分号
:%s/$/;/

" 删除行尾空白
:%s/\s\+$//

" 将 snake_case 转换为 camelCase
:%s/_\([a-z]\)/\u\1/g
```

### 全局命令

`:g` 命令对匹配的行执行操作：

```vim
:g/pattern/command

" 删除所有空行
:g/^$/d

" 删除所有包含 DEBUG 的行
:g/DEBUG/d

" 删除所有不包含 pattern 的行
:v/pattern/d
" 或
:g!/pattern/d

" 将所有匹配的行复制到文件末尾
:g/TODO/t$

" 对所有函数定义执行正常模式命令
:g/^function/normal @a
```

------

## 10. 窗口、标签页与缓冲区

### 核心概念

理解 Vim 的缓冲区、窗口、标签页的关系至关重要：

**缓冲区（Buffer）** 是文件在内存中的表示。每个打开的文件对应一个缓冲区。缓冲区可能在屏幕上可见，也可能隐藏在后台。

**窗口（Window）** 是查看缓冲区的视口。一个窗口显示一个缓冲区，但同一个缓冲区可以在多个窗口中显示。

**标签页（Tab）** 是窗口的集合。每个标签页可以有自己的窗口布局。

形象地说：缓冲区是文件内容，窗口是观察文件的"眼睛"，标签页是工作空间布局。

```
┌──────────────────────────────────────────────────┐
│ Tab 1                 │ Tab 2                    │ <- 标签页
├───────────────────────┴──────────────────────────┤
│ ┌──────────────────────┬───────────────────────┐ │
│ │ Window 1             │ Window 2              │ │ <- 窗口
│ │ (Buffer: file1.txt)  │ (Buffer: file2.py)    │ │
│ │                      │                       │ │
│ │                      │                       │ │
│ └──────────────────────┴───────────────────────┘ │
│                                                  │
│ Hidden buffers: file3.js, file4.md               │ <- 隐藏缓冲区
└──────────────────────────────────────────────────┘
```

### 缓冲区操作

```vim
:e filename     " 编辑文件（创建新缓冲区）
:ls 或 :buffers " 列出所有缓冲区
:b{n}           " 切换到第 n 个缓冲区
:bn             " 下一个缓冲区
:bp             " 上一个缓冲区
:b filename     " 切换到指定文件的缓冲区（支持部分匹配和 Tab 补全）
:bd             " 关闭当前缓冲区
:bd {n}         " 关闭第 n 个缓冲区
:%bd            " 关闭所有缓冲区
:bufdo {cmd}    " 对所有缓冲区执行命令
```

缓冲区状态（在 `:ls` 中显示）：

- `a`：活动（当前窗口显示）
- `h`：隐藏
- `+`：已修改
- `-`：不可修改
- `=`：只读

### 窗口操作

**分割窗口**：

```vim
:sp [filename]  或 Ctrl+w s    " 水平分割
:vsp [filename] 或 Ctrl+w v    " 垂直分割
:new            " 水平分割并创建新文件
:vnew           " 垂直分割并创建新文件
```

**窗口导航**：

```vim
Ctrl+w h    " 移动到左边窗口
Ctrl+w j    " 移动到下边窗口
Ctrl+w k    " 移动到上边窗口
Ctrl+w l    " 移动到右边窗口
Ctrl+w w    " 循环切换窗口
Ctrl+w p    " 切换到上一个窗口
```

**窗口调整**：

```vim
Ctrl+w =    " 使所有窗口等大小
Ctrl+w _    " 最大化当前窗口高度
Ctrl+w |    " 最大化当前窗口宽度
Ctrl+w +    " 增加高度
Ctrl+w -    " 减少高度
Ctrl+w >    " 增加宽度
Ctrl+w <    " 减少宽度
{n}Ctrl+w _ " 设置高度为 n 行
```

**窗口移动**：

```vim
Ctrl+w H    " 将窗口移动到最左边
Ctrl+w J    " 将窗口移动到最下边
Ctrl+w K    " 将窗口移动到最上边
Ctrl+w L    " 将窗口移动到最右边
Ctrl+w r    " 旋转窗口
Ctrl+w x    " 交换当前窗口和下一个窗口
```

**关闭窗口**：

```vim
:q 或 Ctrl+w q   " 关闭当前窗口
:close 或 Ctrl+w c " 关闭当前窗口（最后一个除外）
:only 或 Ctrl+w o  " 只保留当前窗口
```

### 标签页操作

```vim
:tabnew [filename]  " 新建标签页
:tabedit filename   " 在新标签页打开文件
:tabc               " 关闭当前标签页
:tabo               " 关闭其他标签页
gt                  " 下一个标签页
gT                  " 上一个标签页
{n}gt               " 转到第 n 个标签页
:tabm {n}           " 将当前标签页移动到位置 n
:tabs               " 列出所有标签页
:tabdo {cmd}        " 对所有标签页执行命令
```

### 推荐工作流

很多 Vim 用户发现，大量使用标签页并不是最佳实践。更好的方式是：

1. **缓冲区为主**：使用缓冲区管理打开的文件，借助 Telescope 或 fzf 快速切换
2. **窗口用于并列查看**：需要同时查看多个文件时使用窗口分割
3. **标签页用于不同任务**：例如一个标签页用于开发，另一个用于调试

------

## 11. 配置文件详解

### 完整的基础配置

以下是一个功能完整的 Neovim 配置，适合作为学习起点：

**`~/.config/nvim/init.lua`**：

```lua
-- 引入模块化配置
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")  -- 插件管理器
```

**`~/.config/nvim/lua/config/options.lua`**：

```lua
local opt = vim.opt

-- 行号
opt.number = true
opt.relativenumber = true

-- 缩进
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- 搜索
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- 外观
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.cursorline = true
opt.colorcolumn = "80"
opt.scrolloff = 8
opt.sidescrolloff = 8

-- 行为
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.updatetime = 250
opt.timeoutlen = 300

-- 分割
opt.splitright = true
opt.splitbelow = true

-- 补全
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 10

-- 折叠
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99
opt.foldenable = true

-- 其他
opt.wrap = false
opt.linebreak = true
opt.showmode = false  -- 使用 lualine 显示模式
opt.conceallevel = 0
opt.fileencoding = "utf-8"
opt.virtualedit = "block"
opt.inccommand = "split"  -- 实时预览替换结果

-- 空白字符显示
opt.list = true
opt.listchars = {
    tab = "» ",
    trail = "·",
    extends = "→",
    precedes = "←",
    nbsp = "␣",
}

-- 填充字符
opt.fillchars = {
    eob = " ",
    fold = " ",
    foldopen = "",
    foldsep = " ",
    foldclose = "",
}
```

**`~/.config/nvim/lua/config/keymaps.lua`**：

```lua
-- Leader 键设置
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- 更好的窗口导航
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- 调整窗口大小
map("n", "<C-Up>", ":resize +2<CR>", opts)
map("n", "<C-Down>", ":resize -2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- 缓冲区导航
map("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- 保持光标居中
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- 更好的粘贴
map("v", "p", '"_dP', opts)  -- 粘贴后不覆盖寄存器

-- 移动选中的行
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- 缩进后保持选中
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- 快速保存和退出
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
map("n", "<leader>Q", ":qa<CR>", { desc = "Quit all" })

-- 清除搜索高亮
map("n", "<Esc>", ":nohlsearch<CR>", opts)

-- 更好的 J（合并行时保持光标位置）
map("n", "J", "mzJ`z", opts)

-- 快速添加空行
map("n", "<leader>o", "o<Esc>", { desc = "Add blank line below" })
map("n", "<leader>O", "O<Esc>", { desc = "Add blank line above" })

-- 全选
map("n", "<C-a>", "ggVG", { desc = "Select all" })

-- 在行首行尾快速移动
map("n", "H", "^", opts)
map("n", "L", "$", opts)
map("v", "H", "^", opts)
map("v", "L", "g_", opts)

-- 插入模式下的快捷键
map("i", "jk", "<Esc>", opts)  -- 快速退出插入模式
map("i", "<C-h>", "<Left>", opts)
map("i", "<C-l>", "<Right>", opts)

-- 命令行模式
map("c", "<C-a>", "<Home>", opts)
map("c", "<C-e>", "<End>", opts)

-- 诊断导航（LSP）
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- 终端模式
map("t", "<Esc>", "<C-\\><C-n>", opts)
map("t", "<C-h>", "<C-\\><C-n><C-w>h", opts)
map("t", "<C-j>", "<C-\\><C-n><C-w>j", opts)
map("t", "<C-k>", "<C-\\><C-n><C-w>k", opts)
map("t", "<C-l>", "<C-\\><C-n><C-w>l", opts)
```

**`~/.config/nvim/lua/config/autocmds.lua`**：

```lua
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- 高亮复制内容
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
    group = "YankHighlight",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
    end,
})

-- 记住上次编辑位置
augroup("RestoreCursor", { clear = true })
autocmd("BufReadPost", {
    group = "RestoreCursor",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line_count = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

-- 自动调整窗口大小
augroup("ResizeWindows", { clear = true })
autocmd("VimResized", {
    group = "ResizeWindows",
    command = "wincmd =",
})

-- 关闭某些文件类型的行号
augroup("DisableLineNumbers", { clear = true })
autocmd("FileType", {
    group = "DisableLineNumbers",
    pattern = { "help", "man", "qf", "TelescopePrompt" },
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    end,
})

-- 特定文件类型设置
augroup("FileTypeSettings", { clear = true })
autocmd("FileType", {
    group = "FileTypeSettings",
    pattern = { "lua", "yaml", "json" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
    end,
})

autocmd("FileType", {
    group = "FileTypeSettings",
    pattern = { "markdown", "text" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- 保存时自动删除行尾空白
augroup("TrimWhitespace", { clear = true })
autocmd("BufWritePre", {
    group = "TrimWhitespace",
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- 进入终端时自动进入插入模式
augroup("TerminalInsert", { clear = true })
autocmd("TermOpen", {
    group = "TerminalInsert",
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.cmd("startinsert")
    end,
})
```

------

## 12. 插件生态系统

### 插件管理器：lazy.nvim

lazy.nvim 是目前最推荐的 Neovim 插件管理器，特点是懒加载、快速启动、现代化的界面。

**`~/.config/nvim/lua/config/lazy.lua`**：

```lua
-- 自动安装 lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- 插件配置
require("lazy").setup({
    -- 导入 plugins 目录下的所有插件配置
    spec = {
        { import = "plugins" },
    },
    defaults = {
        lazy = true,  -- 默认懒加载
    },
    install = {
        colorscheme = { "catppuccin", "tokyonight", "habamax" },
    },
    checker = {
        enabled = true,  -- 自动检查更新
        notify = false,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
```

### 必备插件配置

**颜色主题 - `~/.config/nvim/lua/plugins/colorscheme.lua`**：

```lua
return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                transparent_background = false,
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    telescope = true,
                    treesitter = true,
                    which_key = true,
                    mason = true,
                    native_lsp = {
                        enabled = true,
                    },
                },
            })
            vim.cmd.colorscheme("catppuccin")
        end,
    },
}
```

**模糊搜索 - `~/.config/nvim/lua/plugins/telescope.lua`**：

```lua
return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
        },
        cmd = "Telescope",
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
            { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
            { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
            { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy find in buffer" },
        },
        config = function()
            local telescope = require("telescope")
            telescope.setup({
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = " ",
                    path_display = { "truncate" },
                    file_ignore_patterns = {
                        "node_modules",
                        ".git/",
                        "*.pyc",
                        "__pycache__",
                    },
                    mappings = {
                        i = {
                            ["<C-j>"] = "move_selection_next",
                            ["<C-k>"] = "move_selection_previous",
                            ["<C-q>"] = "send_to_qflist",
                        },
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                    },
                },
            })
            telescope.load_extension("fzf")
        end,
    },
}
```

**语法高亮增强 - `~/.config/nvim/lua/plugins/treesitter.lua`**：

```lua
return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "lua", "vim", "vimdoc", "query",
                    "python", "javascript", "typescript", "tsx",
                    "rust", "go", "c", "cpp",
                    "html", "css", "json", "yaml", "toml",
                    "markdown", "markdown_inline",
                    "bash", "regex",
                },
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        scope_incremental = false,
                        node_decremental = "<bs>",
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]c"] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[c"] = "@class.outer",
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>a"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["<leader>A"] = "@parameter.inner",
                        },
                    },
                },
            })
        end,
    },
}
```

**文件树 - `~/.config/nvim/lua/plugins/neo-tree.lua`**：

```lua
return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        cmd = "Neotree",
        keys = {
            { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
            { "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Reveal in file explorer" },
        },
        config = function()
            require("neo-tree").setup({
                close_if_last_window = true,
                window = {
                    width = 35,
                    mappings = {
                        ["<space>"] = "none",
                    },
                },
                filesystem = {
                    follow_current_file = { enabled = true },
                    use_libuv_file_watcher = true,
                    filtered_items = {
                        hide_dotfiles = false,
                        hide_gitignored = false,
                    },
                },
            })
        end,
    },
}
```

**状态栏 - `~/.config/nvim/lua/plugins/lualine.lua`**：

```lua
return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "catppuccin",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { { "filename", path = 1 } },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },
}
```

**快捷键提示 - `~/.config/nvim/lua/plugins/which-key.lua`**：

```lua
return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            local wk = require("which-key")
            wk.setup({
                plugins = {
                    spelling = { enabled = true },
                },
                win = {
                    border = "rounded",
                },
            })
            wk.add({
                { "<leader>f", group = "Find/File" },
                { "<leader>g", group = "Git" },
                { "<leader>l", group = "LSP" },
                { "<leader>b", group = "Buffer" },
                { "<leader>t", group = "Toggle" },
            })
        end,
    },
}
```

**Git 集成 - `~/.config/nvim/lua/plugins/gitsigns.lua`**：

```lua
return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "│" },
                    change = { text = "│" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                },
                current_line_blame = true,
                current_line_blame_opts = {
                    delay = 500,
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns
                    local map = function(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map("n", "]h", gs.next_hunk, { desc = "Next hunk" })
                    map("n", "[h", gs.prev_hunk, { desc = "Previous hunk" })

                    -- Actions
                    map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
                    map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
                    map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
                    map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
                    map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
                    map("n", "<leader>gb", function()
                        gs.blame_line({ full = true })
                    end, { desc = "Blame line" })
                    map("n", "<leader>gd", gs.diffthis, { desc = "Diff this" })
                end,
            })
        end,
    },
}
```

------

## 13. LSP 与现代开发

### 什么是 LSP

Language Server Protocol（语言服务器协议）是一个标准化的协议，用于编辑器和语言服务器之间的通信。语言服务器提供诸如自动补全、定义跳转、重构、诊断等功能。

在 LSP 出现之前，每个编辑器都需要为每种语言单独实现这些功能。LSP 将这种 M×N 的问题简化为 M+N：语言只需实现一个 LSP 服务器，编辑器只需实现一个 LSP 客户端。

### 配置 LSP

**`~/.config/nvim/lua/plugins/lsp.lua`**：

```lua
return {
    -- LSP 配置
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            { "folke/neodev.nvim", config = true },  -- Neovim Lua API 支持
        },
        config = function()
            -- 配置诊断显示
            vim.diagnostic.config({
                virtual_text = {
                    prefix = "●",
                    source = "if_many",
                },
                float = {
                    source = "always",
                    border = "rounded",
                },
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
            })

            -- 诊断符号
            local signs = {
                Error = " ",
                Warn = " ",
                Hint = " ",
                Info = " ",
            }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end

            -- LSP 附加时的键位映射
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf }
                    local map = vim.keymap.set

                    -- 导航
                    map("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Go to definition" })
                    map("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
                    map("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "References" })
                    map("n", "gi", vim.lsp.buf.implementation, { buffer = ev.buf, desc = "Implementation" })
                    map("n", "gt", vim.lsp.buf.type_definition, { buffer = ev.buf, desc = "Type definition" })

                    -- 信息
                    map("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover info" })
                    map("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Signature help" })
                    map("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Signature help" })

                    -- 操作
                    map("n", "<leader>lr", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename" })
                    map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code action" })
                    map("n", "<leader>lf", function()
                        vim.lsp.buf.format({ async = true })
                    end, { buffer = ev.buf, desc = "Format" })

                    -- 工作区
                    map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, { buffer = ev.buf, desc = "Add workspace folder" })
                    map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, { buffer = ev.buf, desc = "Remove workspace folder" })
                    map("n", "<leader>lwl", function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, { buffer = ev.buf, desc = "List workspace folders" })
                end,
            })
        end,
    },

    -- Mason: LSP/DAP/Linter/Formatter 管理器
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup({
                ui = {
                    border = "rounded",
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },

    -- Mason 与 lspconfig 桥接
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",        -- Lua
                    "pyright",       -- Python
                    "ts_ls",         -- TypeScript/JavaScript
                    "rust_analyzer", -- Rust
                    "gopls",         -- Go
                    "clangd",        -- C/C++
                    "html",          -- HTML
                    "cssls",         -- CSS
                    "jsonls",        -- JSON
                    "yamlls",        -- YAML
                },
                automatic_installation = true,
            })

            local lspconfig = require("lspconfig")
            local capabilities = vim.lsp.protocol.make_client_capabilities()

            -- 如果使用 nvim-cmp，需要扩展 capabilities
            local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            if ok then
                capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
            end

            -- 通用 LSP 设置
            local default_setup = function(server)
                lspconfig[server].setup({
                    capabilities = capabilities,
                })
            end

            require("mason-lspconfig").setup_handlers({
                default_setup,

                -- Lua 特殊配置
                ["lua_ls"] = function()
                    lspconfig.lua_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "LuaJIT" },
                                workspace = {
                                    checkThirdParty = false,
                                    library = vim.api.nvim_get_runtime_file("", true),
                                },
                                completion = {
                                    callSnippet = "Replace",
                                },
                                diagnostics = {
                                    globals = { "vim" },
                                },
                            },
                        },
                    })
                end,

                -- Python 特殊配置
                ["pyright"] = function()
                    lspconfig.pyright.setup({
                        capabilities = capabilities,
                        settings = {
                            python = {
                                analysis = {
                                    typeCheckingMode = "basic",
                                    autoSearchPaths = true,
                                    useLibraryCodeForTypes = true,
                                },
                            },
                        },
                    })
                end,
            })
        end,
    },
}
```

### 自动补全

**`~/.config/nvim/lua/plugins/cmp.lua`**：

```lua
return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",      -- LSP 补全源
            "hrsh7th/cmp-buffer",        -- 缓冲区补全
            "hrsh7th/cmp-path",          -- 路径补全
            "hrsh7th/cmp-cmdline",       -- 命令行补全
            "saadparwaiz1/cmp_luasnip",  -- 代码片段补全
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                build = "make install_jsregexp",
                dependencies = {
                    "rafamadriz/friendly-snippets",  -- 预定义代码片段
                },
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end,
            },
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                }, {
                    { name = "buffer" },
                }),
                formatting = {
                    format = function(entry, vim_item)
                        -- 显示来源
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snippet]",
                            buffer = "[Buffer]",
                            path = "[Path]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
            })

            -- 命令行补全
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })

            -- 搜索补全
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })
        end,
    },
}
```

### 格式化与 Linting

**`~/.config/nvim/lua/plugins/formatting.lua`**：

```lua
return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>lf",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    lua = { "stylua" },
                    python = { "black", "isort" },
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                    javascriptreact = { "prettier" },
                    typescriptreact = { "prettier" },
                    json = { "prettier" },
                    yaml = { "prettier" },
                    markdown = { "prettier" },
                    html = { "prettier" },
                    css = { "prettier" },
                    go = { "gofmt" },
                    rust = { "rustfmt" },
                    sh = { "shfmt" },
                },
                format_on_save = {
                    timeout_ms = 500,
                    lsp_fallback = true,
                },
            })
        end,
    },

    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")
            lint.linters_by_ft = {
                python = { "ruff" },
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                lua = { "luacheck" },
                sh = { "shellcheck" },
            }

            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                group = vim.api.nvim_create_augroup("lint", { clear = true }),
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
}
```

------

## 14. 高级技巧与工作流

### 快速编辑技巧

**使用 `.` 的艺术**：`.` 命令重复上一次的修改。关键是设计可重复的操作。

```
场景：将所有 const 改为 let
方法一（低效）：
:%s/const/let/g

方法二（可控且可重复）：
1. /const<CR>  搜索 const
2. cgn         修改下一个匹配
3. let<Esc>    输入新内容
4. .           重复修改下一个
5. n           跳过一个
6. .           继续修改
```

`cgn` 是一个强大的组合：`c` 是修改，`gn` 是"下一个搜索匹配"。这样 `.` 就会修改下一个匹配，`n` 可以跳过。

**多光标替代方案**：虽然 Vim 没有原生多光标，但有更强大的替代方案。

使用宏：

```
qa          开始录制
0f:w        移动到冒号后的单词
ciwvalue    修改为 "value"
jq          下一行并结束录制
99@a        执行 99 次
```

使用块可视模式批量修改：

```
Ctrl+v      进入块可视模式
jjjj        选择多行
I           在选区前插入
内容<Esc>   输入并退出
```

### 文本操作技巧

**快速括号操作**（使用 mini.surround 或 vim-surround 插件）：

```
ys{motion}{char}   添加包围符号
ds{char}           删除包围符号
cs{old}{new}       修改包围符号

例如：
ysiw"       给单词添加双引号：word -> "word"
ds"         删除双引号："word" -> word
cs"'        双引号改单引号："word" -> 'word'
yss)        给整行添加括号
```

**快速注释**（使用 Comment.nvim 或类似插件）：

```
gcc         注释/取消注释当前行
gc{motion}  注释/取消注释选区
gcap        注释整个段落
```

### 高效搜索与导航

**全局搜索与导航**：

```
:vim /pattern/ **/*.py    在所有 Python 文件中搜索
:copen                    打开 quickfix 列表
:cn                       下一个结果
:cp                       上一个结果

使用 Telescope:
<leader>fg                live_grep
<leader>fw                grep 当前单词
```

**使用 marks 进行位置记忆**：

```
ma          设置标记 a
'a          跳转到标记 a 所在行
`a          跳转到标记 a 的精确位置
:marks      查看所有标记
```

### 项目工作流

**会话管理**：

可以使用 `auto-session` 或类似插件自动保存和恢复会话，包括打开的文件、窗口布局、光标位置等。

```lua
-- 使用 persistence.nvim
{
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
        require("persistence").setup()
        vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end)
        vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end)
        vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end)
    end,
}
```

**项目导航**：

使用 Telescope 项目插件或 project.nvim 快速切换项目：

```
<leader>fp    打开项目列表
```

### 调试工作流

使用 nvim-dap 进行调试：

```lua
-- 基本调试键位
<leader>db    设置断点
<leader>dc    继续执行
<leader>di    步入
<leader>do    步出
<leader>dr    运行到光标
<leader>du    打开 UI
```

### 终端集成

Neovim 内置终端：

```
:terminal           打开终端
:sp | terminal      在分割窗口打开终端
<C-\><C-n>          终端模式下返回普通模式
```

使用 toggleterm.nvim 获得更好的体验：

```lua
{
    "akinsho/toggleterm.nvim",
    keys = {
        { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
    },
    config = function()
        require("toggleterm").setup({
            size = 15,
            open_mapping = [[<C-\>]],
            direction = "horizontal",
        })
    end,
}
```

------

## 15. 最佳实践与学习路径

### 渐进式学习路径

**第一阶段：生存（1-2 周）**

目标是能够完成基本编辑任务，不需要退出 Vim 就能完成工作。

核心技能：

- 理解模态编辑的概念
- 掌握 `h`、`j`、`k`、`l` 移动
- 使用 `i`、`a`、`o` 进入插入模式
- 使用 `Esc` 返回普通模式
- 使用 `:w` 保存、`:q` 退出
- 使用 `dd` 删除行、`yy` 复制行、`p` 粘贴
- 使用 `u` 撤销

练习建议：每天强制使用 Vim 至少 30 分钟进行实际工作。运行 `vimtutor` 完成官方教程。

**第二阶段：效率提升（2-4 周）**

目标是开始感受到 Vim 的效率优势。

核心技能：

- 单词移动：`w`、`b`、`e`
- 行内移动：`0`、`^`、`$`、`f`、`t`
- 操作符 + 动作：`dw`、`cw`、`d$`、`c$`
- 文本对象：`diw`、`ci"`、`da(`
- 搜索：`/pattern`、`n`、`N`、`*`
- 使用 `.` 重复操作

练习建议：每次使用方向键时问自己"有没有更好的方式"。开始记录常用操作，尝试找到更快的方法。

**第三阶段：熟练运用（1-2 月）**

目标是 Vim 操作变得自然流畅。

核心技能：

- 可视模式：`v`、`V`、`Ctrl+v`
- 寄存器基础：`"ayy`、`"ap`
- 宏录制与回放：`qa`、`@a`
- 替换命令：`:%s/old/new/g`
- 窗口分割：`Ctrl+w` 系列
- 配置基础快捷键

练习建议：配置自己的 `init.lua`。尝试使用宏自动化重复任务。

**第四阶段：高级进阶（2-3 月）**

目标是掌握 Vim 的高级特性，配置现代化开发环境。

核心技能：

- 配置 LSP 和自动补全
- 使用 Telescope 进行项目导航
- Tree-sitter 语法高亮和代码分析
- Git 集成
- 调试配置
- 自定义复杂工作流

练习建议：阅读其他人的配置文件获取灵感。为特定任务编写自己的键位映射。

**第五阶段：精通（持续）**

目标是将 Vim 变成自己的工具，而非适应工具。

持续学习：

- 编写 Lua 函数和插件
- 优化启动时间和性能
- 探索新插件和工作流
- 帮助社区中的其他人

### 常见错误与避免方法

**错误一：试图一次学会所有东西**

正确方法是渐进式学习，每周专注于 2-3 个新概念。先用简单的方法完成工作，然后逐步优化。

**错误二：过早过度配置**

正确方法是从最小配置开始。只有当确实需要某个功能时才添加插件。理解每个配置选项的作用。

**错误三：不使用原生功能**

正确方法是在添加插件前，先尝试用原生 Vim 功能解决问题。很多时候原生方案更简洁高效。

**错误四：不利用重复**

正确方法是设计可重复的操作。使用 `.` 命令、宏和 `:g` 命令自动化重复任务。

**错误五：不记忆常用操作**

正确方法是创建个人速查表。定期复习不熟悉的命令。

### 实用资源

**官方资源**：

- `:help` 命令是最权威的文档
- `vimtutor` 是最好的入门教程
- `:help user-manual` 完整用户手册

**在线资源**：

- Neovim 官网：neovim.io
- Vim Adventures：游戏化学习 Vim 移动
- Practical Vim（书籍）：Drew Neil 的经典著作
- ThePrimeagen 的 Vim 教程：YouTube 上的优质内容

**社区**：

- r/neovim：Reddit 社区
- Neovim 官方 Discord
- GitHub 上的 awesome-neovim 列表

### 键位映射建议

**Leader 键**：推荐使用空格键作为 Leader，因为它是键盘上最容易按到的键。

**常用操作应该最容易触发**：

```lua
-- 保存文件应该很快
vim.keymap.set("n", "<leader>w", ":w<CR>")

-- 快速访问配置
vim.keymap.set("n", "<leader>vc", ":e $MYVIMRC<CR>")
```

**避免与系统/插件快捷键冲突**：保留 `Ctrl+c`、`Ctrl+v`、`Ctrl+z` 等常见系统快捷键的预期行为，或者明确地重新定义它们。

**使用助记符**：`<leader>f` 开头的用于查找（find），`<leader>g` 用于 git，`<leader>l` 用于 LSP。

### 性能优化

**减少启动时间**：使用 `lazy.nvim` 的懒加载功能。禁用不需要的内置插件。使用 `:Lazy profile` 分析启动时间。

**平滑的编辑体验**：保持插件数量适中。定期更新插件。使用 Tree-sitter 而非正则表达式高亮。

------

## 结语

Vim 和 Neovim 的学习曲线确实陡峭，但投入的时间会获得丰厚的回报。模态编辑一旦内化，就会成为思考和操作代码的自然方式。重要的是保持耐心，循序渐进，每天都比昨天进步一点点。

记住 Vim 社区的一句格言："Vim 不是目的，而是手段。"它是帮助你更高效地完成工作的工具。根据自己的需求定制它，让它成为你手指的延伸。祝你在 Vim 的道路上旅途愉快。