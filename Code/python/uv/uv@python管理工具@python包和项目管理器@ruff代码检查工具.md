[toc]



## abstract

一个用 Rust 编写的、速度极快的 Python 包和项目管理器。

- [GitHub - astral-sh/uv：一个用 Rust 编写的、速度极快的 Python 包和项目管理器。 --- GitHub - astral-sh/uv: An extremely fast Python package and project manager, written in Rust.](https://github.com/astral-sh/uv)
- [配置文件 | uv 中文文档](https://uv.doczh.com/configuration/files/)

## 安装

uv的安装方法非常丰富

- [uv installation](https://docs.astral.sh/uv/getting-started/installation/#installation-methods)

本文主要讨论windows上的安装和使用

### pip方案安装

如果你已经安装了python,并且pip可用的话,那么可以直接通过`pip install uv`来安装uv

之后就可以使用uv管理python,但是这种方案的uv安装目录相对于纯净安装来说不是很标准(默认)

### linux

```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
downloading uv 0.9.21 x86_64-unknown-linux-gnu
no checksums to verify
installing to /root/.local/bin
  uv
  uvx
everything's installed!

To add $HOME/.local/bin to your PATH, either restart your shell or run:

    source $HOME/.local/bin/env (sh, bash, zsh)
    source $HOME/.local/bin/env.fish (fish)
```

根据提示设置环境变量`PATH`,例如bash/zsh

```bash
source $HOME/.local/bin/env
```

其中,`env`是一个shell脚本,是一个`case`语句

```bash
#( 01/02/26@11:53AM )( root@s3 ):~/.local/bin
   cat env
#!/bin/sh
# add binaries to PATH if they aren't added yet
# affix colons on either side of $PATH to simplify matching
case ":${PATH}:" in
    *:"$HOME/.local/bin":*)
        ;;
    *)
        # Prepending path in case a system-installed binary needs to be overridden
        export PATH="$HOME/.local/bin:$PATH"
        ;;
esac
```



### scoop方案安装(windows)

```bash
scoop install uv
```

安装python

```cmd
uv python install
```

这可能会提示

```bash
warning: `C:\Users\cxxu\.local\bin` is not on your PATH. To use installed Python executables, run `$env:PATH = "C:\Users\cxxu\.local\bin;$env:PATH"` or `uv python update-shell`.
```

这表明你`uv`安装python的路径`~/.local/bin`没有被添加到`Path`环境变量中

快速解决的办法是运行`uv python update-shell`,此命令会为你修改环境变量

> 注意,上述命令的效果和cmd中执行`setx`命令类似但有不同

```bash
# 以下命令会导致系统级PATH变量的内容一起添加到用户级的PATH变量中,导致出现多余内容
SETX PATH "%userprofile%\.local\bin;%PATH%"
```

> 推测`uv`应该是通过修改系统的注册表中对应的`Path`来实现对应的修改,从而保持了原用户`PATH`的值不被展开解释也不会引入系统级的`PATH`变量值.

## 检查安装

### python可执行文件

经过上述操作,在uv默认安装目录下存在`pythonx.xx.exe`可执行文件,

> uv 默认只安装***带版本号的***可执行文件。强制要求输入版本号更加严谨和安全,并且多个不同的python版本也可以从名字上的版本号区分出来.
>
> 要安装 `python` 和 `python3` 可执行文件，请添加实验性的 `--default` 选项

```bash
# [cxxu@CXXUFIREBAT][~\.local\bin][10:58:38] PS >
 ls

    Directory: C:\Users\cxxu\.local\bin

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---            2026/1/2    10:14          39424 python3.14.exe
```

 通过如下命令安装省略版本号的可执行python.exe

```cmd
uv python install --default
```

### shell中uv命令补全提示设置

[shell-autocompletion|Installation | uv](https://docs.astral.sh/uv/getting-started/installation/#shell-autocompletion)

### 指定python版本运行脚本

uv 允许在每次脚本调用时请求任意 Python 版本，例如：

```bash
# Use a specific Python version
uv run --python 3.10 example.py
```



## 使用uv的说明指南

包括如何运行python脚本(无额外依赖或有额外依赖),构建python项目等

- [guides | uv](https://docs.astral.sh/uv/guides/)

## 脚本集和uv

假设我的脚本目录为`C:/repos/scripts/python`(许多脚本需要安装依赖)
创建为uv项目后,有哪些执行脚本的方案?

在 `uv` 的体系下，正确做法取决于你的脚本是“**单文件脚本**”还是“**属于某个大项目的模块**”。

### 方案一：最推荐做法（单文件脚本模式）

如果你目录下的脚本（如 `data_process.py`）是相对独立的，**不需要**将其创建为 `uv` 项目，而是利用 `uv` 的“无感环境”功能。

**正确步骤：**

1. **在脚本头部添加 Shebang 和依赖声明：**

   shebang语句是linux可用,但是windows不识别,但是依赖声明( [内联脚本元数据](https://packaging.python.org/en/latest/specifications/inline-script-metadata/#inline-script-metadata))是可以识别的

   ```python
   #!/usr/bin/env -S uv run --script
   # /// script
   # dependencies = [
   #   "pandas",
   # ]
   # ///
   import pandas as pd
   # ... 你的代码
   ```

2. 在任意位置执行：

   无论你在哪个目录下，直接输入脚本的全路径即可运行`uv run <script-path>`

   ```bash
   uv run C:\repos\scripts\python\example.py
   ```

   **优点：** `uv` 会自动处理依赖，你完全不需要关心虚拟环境在哪里，也不需要执行 `source venv/activate`。

------

### 方案二：项目模式（把脚本作为项目工具）

如果你已经在 `C:/repos/scripts/python` 执行了 `uv init`，将其变成了一个完整的项目。

**错误做法：** 在家目录直接运行 `python /path/to/script.py`。这会导致 `ImportError`，因为此时 Python 用的是全局环境，没加载项目的依赖。

**正确做法：** 使用 `--project` 参数明确指定项目路径。



```bash
uv run --project C:/repos/scripts/python /C/repos/scripts/python/your_script.py
```

更优雅的做法（创建别名/链接）：

如果你经常在家目录运行这些脚本，可以在你的 .bashrc 或 .zshrc 中给这些常用的脚本起别名：

Bash

```
alias my-tool='uv run --project C:/repos/scripts/python /C/repos/scripts/python/main.py'
```

------

### 方案三：工具模式（uv tool）—— 针对功能性脚本

如果你写的脚本是一个“工具”（比如一个用来处理 Excel 的小工具），你可以利用 `uv` 将其安装到系统路径中。

1. 在项目目录下配置好 `pyproject.toml` 的 `[project.scripts]` 部分。

2. 执行安装：

   Bash

   ```
   uv tool install C:/repos/scripts/python --editable
   ```

3. **结果：** `uv` 会在你的家目录（或系统 PATH 下）创建一个可执行文件。以后你在**任何目录下**直接输入脚本名（例如 `my-excel-tool`）就能运行，它会自动关联回那个目录的环境。

------

### 总结建议

1. **如果脚本多且杂：** 用 **方案一**。给每个 `.py` 文件头加上那几行 `/// script` 声明。这是 `uv` 最精髓的用法，彻底摆脱目录限制。
2. **如果是大型项目：** 用 **方案二**，配合 `uv run --project`。
3. **如果是一个常用的命令：** 用 **方案三**。

特别提示（Windows 用户）：

由于 Windows 不支持 Shebang 直接解析，如果你在 Windows CMD/PowerShell 下运行，最顺手的方式依然是：

uv run C:/repos/scripts/python/your_script.py

（uv 会自动检查该文件头部是否有 /// script 声明并自动准备环境）。



## uv tool命令安装命令行工具

`uv tool install` 是专门用来安装**命令行工具**（CLI Tools）的，比如 `black`、`ruff`、`yt-dlp` 等。这些包在安装后会向系统提供一个可以直接执行的命令。

## ruff

- [Ruff - Astral 文档](https://docs.astral.ac.cn/ruff/)

安装ruff(使用uv安装)

```bash
uv tool install ruff
```



```powershell
# [cxxu@CXXUFIREBAT][~\.local\bin][22:03:50] PS >
 ls

    Directory: C:\Users\cxxu\.local\bin

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
la---            2026/1/2    11:18              0 py.exe -> C:\Users\cxxu\.local\bin
                                                  \python.exe
-a---            2026/1/2    11:00          39424 python.exe
-a---            2026/1/2    10:14          39424 python3.14.exe
-a---            2026/1/2    11:00          39424 python3.exe
-a---            2026/1/2    13:09       40560128 ruff.exe
```

