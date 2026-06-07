[toc]



## abstract

lazyvim的相对同类工具而言算是积极,好处是可以及时体验到新特性,但也伴随一些问题,例如在相对老的系统上,可能有兼容性问题,例如某些关键组件版本兼容问题引起的插件构建失败导致功能不全的问题;

通常,相对新的系统,一般都能比较顺利安装.

下面是一个具体的案例.

## 现象

在ubuntu24上正常安装lazyVim,且构建默认插件(包括tree-sitter)都顺利进行.

而在Ubuntu 22.04 安装 LazyVim 时 nvim-treesitter 报 `GLIBC_2.39 not found`(这是从日志中捕获的)

对于构建存在故障的lazyvim安装,启动lazyvim后,会弹出一个重试构建的message窗口,里面可以观察到一些红色的错误信息,这些消息刷的比较快,可以截图观察.

> 这里假设我观察到`nvim-treesitter build`失败(errror)错误.并基于此展开讨论.
>
> 对于`treesitter`错误,查阅资料发现是可以通过`:TSLog`来查看相关日志(但默认显示在message窗格中不变观察和拷贝错误信息.)

### 核心组件说明

**Tree-Sitter 是一个现代的、高性能的增量语法分析器（Incremental Parser）生成工具。**

在 Neovim 和 LazyVim 中，它取代了传统的正则表达式，成为了**代码高亮、代码折叠、文本对象选择以及代码导航**的“幕后大脑”。

1. 极其精准的代码高亮
2. 速度极快（增量解析）
3. 极强的容错性（Robust）

Tree-Sitter 是一个独立于编辑器的开源项目（由 GitHub 开发）。不仅 Neovim 在用，VS Code、Emacs、GitHub 网页版也在用它。这意味着一种语言只要写一次 Tree-Sitter 解析器（Parser），所有编辑器都能享受到完美的语法支持。

在 LazyVim 中，由于默认深度集成了 `nvim-treesitter` 插件，你不仅能享受到丝滑的高亮，还能体验到以下高级功能：

- **增量选中（Incremental Selection）**：按下 `Space + v`（或特定快捷键），你可以按照语法结构一层层扩大选中范围（先选变量名 $\rightarrow$ 再选整行 $\rightarrow$ 再选整个 `if` 块 $\rightarrow$ 再选整个函数）。
- **智能代码折叠（Fold）**：基于语法的折叠，绝对不会把一个函数切成两半。
- **代码结构导航**：结合大纲插件（如 `symbols-outline` 或 `aerial.nvim`），可以清晰地在侧边栏看到当前文件的函数和类列表。

在 LazyVim（以及 Neovim）中，**`:TSUpdate`** 是一个非常核心的指令，它的全称是 **Tree-Sitter Update**。

它的核心作用是：**更新你当前安装的所有编程语言的语法解析器（Parsers）。**

如果你只想更新某一种特定的语言，可以在后面加上名字：

```lua
:TSUpdate python    " 只更新 Python 解析器
:TSUpdate html css  " 同时更新 HTML 和 CSS 解析器
```

为什么要用它？

**Tree-Sitter** 是 Neovim 用来实现高性能、精准代码高亮（以及代码折叠、文本对象选择）的底层引擎。 每种语言（比如 Python, Lua, TypeScript, Go）都需要一个专门的“解析器”来把代码切分成语法树。

当你遇到以下情况时，通常需要运行 `:TSUpdate`：

1. **代码高亮突然乱了或失效了**（比如升级了 Neovim 之后）。
2. **写代码时 Neovim 报错**，提示某个语言的 parser 版本不兼容。
3. **想获得最新的语法支持**（比如某种语言新增了关键字或语法特性）。



### 日志捕获和保存

直接在shell中通过非交互式的方式尝试捕获构建类错误是不可靠的,往往抓不到内容提取为空，是因为 `:messages` 是当前 nvim 会话里的消息；新开一个 headless nvim 不会有刚才 UI 里的消息。

在当前这个 nvim 窗口里直接执行：

```lua
:lua vim.fn.writefile(vim.split(vim.fn.execute("messages"), "\n"), "/tmp/nvim-messages.txt")
```



在 Ubuntu 22.04 上安装 LazyVim 后，`nvim-treesitter` 安装 parser 时大量失败，例如：

```text
[nvim-treesitter/install/javascript] error: Error during "tree-sitter build":
tree-sitter: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.39' not found
```

```
stderr -> tree-sitter: /lib/x86_64-linux-gnu/...
error(install/dtd): Error during "tree-sitter build"
error(install/vimdoc): Error during "tree-sitter build"
error(install/xml): Error during "tree-sitter build"
```



常见失败语言包括：

```text
javascript
python
yaml
markdown
markdown_inline
c
bash
typescript
vim
tsx
```

最后可能还有：

```text
[nvim-treesitter]: Installed 3/27 languages
E471: Argument required
E21: Cannot make changes, 'modifiable' is off
```

## 根因

根因不是 LazyVim 配置错误，而是当前系统中被 Neovim 调用的 `tree-sitter` CLI 是一个预编译二进制，它依赖较新的 `glibc`。

Ubuntu 22.04 默认 glibc 版本是 2.35，而该 `tree-sitter` 二进制需要：

```text
GLIBC_2.39
```

所以在 Ubuntu 22.04 上运行失败。

## 不推荐的做法

不要手动升级或替换系统 glibc：

```bash
/lib/x86_64-linux-gnu/libc.so.6
```

Ubuntu 22.04 的系统组件依赖 glibc 2.35，强行替换 glibc 很容易导致 apt、ssh、shell、桌面环境等系统组件异常。

## 推荐解决方案

使用 `cargo` 在本机从源码编译 `tree-sitter-cli`。

这样编译出来的 `tree-sitter` 会适配当前 Ubuntu 22.04 的系统库，而不是依赖 GLIBC_2.39。

## 处理步骤

### 1. 检查当前 glibc 和 tree-sitter

```bash
ldd --version

which tree-sitter
tree-sitter --version
ldd "$(which tree-sitter)" | head
```

如果看到 `GLIBC_2.39 not found`，说明当前 `tree-sitter` 二进制不兼容。

对于顺利安装的情况:ubuntu24上,可以看到完整的`ldd(GLIBC)`版本和`tree-sitter`版本

```bash
ldd (Ubuntu GLIBC 2.39-0ubuntu8.7) 2.39
Copyright (C) 2024 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Written by Roland McGrath and Ulrich Drepper.
/root/.local/share/nvim/mason/bin/tree-sitter
tree-sitter 0.26.9
        linux-vdso.so.1 (0x00007fff5d1e9000)
        libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x000078e13adb4000)
        libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x000078e139917000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x000078e139600000)
        /lib64/ld-linux-x86-64.so.2 (0x000078e13adef000)

```

对于修复过的ubuntu22上的安装情况

> 这里的glibc版本和上面不同,且tree-sitter是通过本地补齐rust,cargo依赖后编译安装的.

```bash
ldd (Ubuntu GLIBC 2.35-0ubuntu3.13) 2.35
Copyright (C) 2022 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Written by Roland McGrath and Ulrich Drepper.
/root/.cargo/bin/tree-sitter
tree-sitter 0.26.9
        linux-vdso.so.1 (0x00007ffd845ee000)
        libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007ff2498b7000)
        libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007ff2497d0000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007ff2495a7000)
        /lib64/ld-linux-x86-64.so.2 (0x00007ff24a220000)
```



### 2. 删除可能有问题的预编译版本

如果是 npm 安装的：

```bash
npm uninstall -g tree-sitter-cli
```

如果系统里有 apt 安装的版本：

```bash
sudo apt remove tree-sitter-cli tree-sitter 2>/dev/null
```

检查所有路径：

```bash
type -a tree-sitter
```

确保之后不会继续调用旧的、不兼容的版本。

### 3. 补齐 Ubuntu 22.04 编译依赖

```bash
sudo apt update
sudo apt install -y \
  build-essential \
  pkg-config \
  libssl-dev \
  clang \
  git \
  curl
```

这些依赖很关键。缺少它们时，`cargo install tree-sitter-cli` 可能会出现：

```text
error: failed to compile `tree-sitter-cli`
```

或者只显示：

```text
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
```

但真正原因通常在日志上方，比如缺少编译器、openssl、pkg-config、clang 等。

### 4. 安装或更新 Rust

```bash
curl https://sh.rustup.rs -sSf | sh
source "$HOME/.cargo/env"

rustup update stable
rustup default stable

rustc --version
cargo --version
```

### 5. 使用 cargo 编译安装 tree-sitter-cli

推荐使用：

```bash
cargo install --locked tree-sitter-cli
```

如果最新版本编译失败，可以指定小版本，例如：

```bash
cargo install --locked tree-sitter-cli --version 0.26.8
```

或：

```bash
cargo install --locked tree-sitter-cli --version 0.25.10
```

### 6. 确认 tree-sitter 路径

```bash
which tree-sitter
tree-sitter --version
ldd "$(which tree-sitter)" | grep libc
```

理想输出路径应类似：

```text
/home/你的用户名/.cargo/bin/tree-sitter
```

如果不是，把 cargo bin 放到 PATH 前面。

bash：

```bash
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

zsh：

```bash
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

再次确认：

```bash
type -a tree-sitter
which tree-sitter
tree-sitter --version
```

## LazyVim / nvim-treesitter 侧清理与重装

进入 Neovim 后执行：

```vim
:Lazy sync
:TSUpdate
:checkhealth nvim-treesitter
```

如果之前 parser 缓存损坏，可以退出 Neovim 后清理：

```bash
rm -rf ~/.local/share/nvim/site/parser
rm -rf ~/.local/state/nvim
```

必要时也可以清掉 `nvim-treesitter` 插件目录，让 LazyVim 重新拉取：

```bash
rm -rf ~/.local/share/nvim/lazy/nvim-treesitter
```

然后重新打开：

```bash
nvim
```

再执行：

```vim
:Lazy sync
:TSUpdate
```

## 最终结论

Ubuntu 22.04 使用 LazyVim 时，如果 `nvim-treesitter` 编译 parser 报：

```text
GLIBC_2.39 not found
```

应优先判断为：

```text
tree-sitter-cli 预编译二进制与 Ubuntu 22.04 glibc 2.35 不兼容
```

正确修复方式是：

```text
删除不兼容的 tree-sitter-cli
补齐编译依赖
用 cargo 在本机源码编译安装 tree-sitter-cli
确保 ~/.cargo/bin/tree-sitter 优先于旧版本
重新执行 :TSUpdate
```

本次实际处理结果：补齐依赖后，`tree-sitter-cli` 已成功编译并安装，LazyVim 中的 treesitter parser 安装问题应随之解决。