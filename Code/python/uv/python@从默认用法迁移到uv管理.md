[toc]

## abstract

从传统的“全局 Python + pip”模式转向 **uv** 是一个非常明智的决定。`uv` 不仅速度极快，而且能彻底解决依赖冲突和环境变量污染的问题。

以下是迁移到 `uv` 管理架构的建议步骤：

------

## 1. 环境清理：卸载全局依赖（可选但推荐）

在切换到 `uv` 之前，建议先清理过去散落在全局环境中的 pip 包。

- **导出清单（以防万一）：** `pip freeze > old_global_packages.txt`
- **清理建议：** 尽量只保留 Python 解释器本身，不要通过 `sudo pip install` 或全局 `pip install` 安装库。

------

## 2. 移除或简化 PYTHONPATH

**这是最关键的一步。** 传统的 `PYTHONPATH` 往往会导致库的版本冲突，因为 Python 会强制从这些路径加载模块。

- **现状：** 以前你可能在 `.bashrc` 或 `.zshrc` 中写了 `export PYTHONPATH=$PYTHONPATH:/your/script/path`。
- **uv 的做法：** `uv` 倾向于**项目自包含**。如果你有公共模块，建议将其打包成一个本地库，或者使用 `uv` 的 Workspace 功能，而不是依赖全局路径。

> **建议：** 先注释掉 Shell 配置文件中的 `PYTHONPATH` 定义，让 `uv` 完全接管模块查找路径。

------

## 3. 将单文件脚本升级为 "Self-contained" 脚本

你之前提到的 `#!/usr/bin/env -S uv run --script` 正是为此设计的。

**迁移操作：**

1. 在脚本头部添加 **PEP 723** 格式的元数据块。
2. 指定脚本所需的依赖。

**示例：**



```Python
#!/usr/bin/env -S uv run --script
# /// script
# dependencies = [
#   "requests>=2.31.0",
#   "pandas",
# ]
# ///

import requests
import pandas as pd
# 你的业务逻辑代码...
```

这样做之后，你只需运行 `./your_script.py`，`uv` 就会自动创建临时环境并安装依赖。

------

## 4. 替换全局工具（uv tool）

如果你以前用 `pip install` 安装了一些像 `black`、`flake8` 或 `yt-dlp` 之类的**命令行工具**，请改用 `uv tool`。

- **安装工具：** `uv tool install yt-dlp`
- **原理：** `uv` 会为每个工具创建一个完全隔离的虚拟环境，并把可执行文件链接到 `/home/user/.local/bin`。这不会污染你的全局 Python 环境。

------

## 5. 项目级管理：从 pip 到 uv project

如果你有复杂的项目目录，而不仅仅是单文件脚本：

1. **初始化：** 进入项目目录执行 `uv init`。
2. **迁移依赖：** 如果已有 `requirements.txt`，运行 `uv add -r requirements.txt`。
3. **运行：** 使用 `uv run main.py` 代替原来的 `python main.py`。

------

## 6. 管理不同的 Python 版本

`uv` 可以完美替代 `pyenv`。你不再需要手动下载安装 Python：

- **列出可用版本：** `uv python list`
- **安装特定版本：** `uv python install 3.12`
- **项目指定版本：** `uv python pin 3.11`

------

## 总结迁移工作流

| **过去的操作**                | **uv 的推荐方式**                        |
| ----------------------------- | ---------------------------------------- |
| `pip install requests` (全局) | 在脚本中添加 `# /// script` 声明         |
| `export PYTHONPATH=...`       | 使用 `uv add --editable` 或 Workspace    |
| `pip install black` (工具)    | `uv tool install black`                  |
| 手动创建 `venv`               | `uv run` 自动处理，或 `uv venv` 手动创建 |

