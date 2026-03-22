[toc]

## abstract

------



`conda` 是一个**通用包管理器**，而 `venv` 只是一个**环境管理工具**。

- **Python 版本管理**：`conda` 可以轻松安装不同版本的 Python（如 `conda create -n py38 python=3.8`），而 `venv` 只能基于你系统中**已经安装好**的 Python 版本创建环境。
- **非 Python 依赖**：如果你的项目涉及深度学习（CUDA/cuDNN）或科学计算（C++ 编译库），`conda` 能直接帮你装好这些非 Python 库，而 `venv` 无能为力。
- **包含关系**：`conda` 的功能是 `venv` 的超集。在数据科学、机器学习领域，`conda` 几乎是行业标准。

------

### venv

[venv --- 虚拟环境的创建 — Python 3文档](https://docs.python.org/zh-cn/3.14/library/venv.html)

尽管 `conda` 很强大，但在以下三种情况，`venv` 更有优势：

- **轻量化与速度**：`venv` 创建环境的速度极快，且占用磁盘空间非常小。对于简单的 Web 开发或脚本编写，`venv` 更清爽。
- **生产环境部署**：许多云服务器或 Docker 镜像为了保持镜像体积最小化，通常不安装巨大的 `conda`，而是直接使用 Python 自带的 `venv`。
- **IDE 默认支持**：虽然现在的 IDE（如 VS Code, PyCharm）对两者支持都很好，但 `venv` 与 Python 生态系统的标准（如 PEP 405）结合得更紧密。

获取venv帮助(如果系统不自带,则需要手动安装)

```bash
python3 -m venv -h

usage: venv [-h] [--system-site-packages] [--symlinks | --copies] [--clear] [--upgrade] [--without-pip] [--prompt PROMPT] [--upgrade-deps] ENV_DIR [ENV_DIR ...]

Creates virtual Python environments in one or more target directories.
...
```



------

### conda和venv两者的核心操作对比

你会发现，两者的逻辑其实非常相似。如果你掌握了 `conda`，学习 `venv` 只需要 2 分钟：

| **功能**     | **Conda 命令**                           | **venv 命令 (标准库)**                  |
| ------------ | ---------------------------------------- | --------------------------------------- |
| **创建环境** | `conda create -n myenv`                  | `python -m venv myenv`                  |
| **激活环境** | `conda activate myenv`                   | `source myenv/bin/activate` (Mac/Linux) |
| **安装包**   | `conda install pkg` 或 `pip install pkg` | `pip install pkg`                       |
| **退出环境** | `conda deactivate`                       | `deactivate`                            |

### venv简单用例

以ubuntu24版本为例(自带python3.12)

> ` cat /etc/os-release`或`hostnamectl`可以查询到自己的系统版本

```bash

PRETTY_NAME="Ubuntu 24.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.3 LTS (Noble Numbat)"
VERSION_CODENAME=noble
```

#### 安装`venv`

```bash
#( 01/20/26@ 5:08PM )( root@s3 ):~
   apt install python3.12-venv
```

#### 新建venv

假设指定环境目录为`~/.venv`并安装pandas包

```bash

#( 01/20/26@ 5:09PM )( root@s3 ):~
   python3 -m venv .venv
```

#### 激活venv

```bash

# 启动venv目录(一般是.venv/bin/这类的路径下的activate命令)
#( 01/20/26@ 5:09PM )( root@s3 ):~
   source .venv/bin/activate

```

#### 环境检查

激活 `venv` 后，检查当前环境名的方法主要取决于你是想**肉眼观察**、**通过命令查询**，还是在**脚本代码中判断**。

以下是几种最有效的方法：

1. 使用环境变量命令 (最可靠)

如果你想通过命令确认，最直接的方式是检查 `VIRTUAL_ENV` 变量。这个变量记录了当前激活环境的**绝对路径**。

2. 观察 Shell 提示符 (最直观)

默认情况下，激活脚本会修改你的终端提示符（`PS1`）。

- 你会看到命令行开头多了个圆括号，里面就是环境名： `(.venv) user@machine:~/project$`
- **注意**：如果你使用了自定义主题（如 Oh My Zsh 或 Powerlevel10k），环境名可能会以小图标的形式出现在右侧或上方。

------

在此环境被激活后,shell的提示符(prompt)可能会多出一个前缀

```bash
(base) #( 03/22/26@10:03AM )( cxxu@CxxuDesk ):~
   source ./.venv1/bin/activate
```

如果在conda中叠加使用`venv`,就可能出现多重前缀(一般不这么嵌套使用)

```bash
(base) #( 03/22/26@10:03AM )( cxxu@CxxuDesk ):~
   source ./.venv1/bin/activate
((.venv1) ) (base) #( 03/22/26@10:03AM )( cxxu@CxxuDesk ):~
```



### 使用已激活的venv环境

此时,在此环境中安装某个包(比如pandas)

```bash
   
(.venv) #( 01/20/26@ 5:09PM )( root@s3 ):~
   pip install pandas
Collecting pandas
...
Successfully installed numpy-2.4.1 pandas-2.3.3 python-dateutil-2.9.0.post0 pytz-2025.2 six-1.17.0 tzdata-2025.3
```

### 多个venv环境

管理多个 `venv` 时，最核心的原则是：**保持环境与项目代码的分离，同时确保环境的可重建性**。

####  目录结构：推荐“项目内置”模式

虽然你可以把所有虚拟环境集中放在一个文件夹里（类似 Conda），但在 Python 社区，最推荐的做法是将虚拟环境放在**项目根目录下**。

以下是针对开发者和生产环境的推荐用法：

```bash
my_project1/
├── .venv/       <--- 虚拟环境文件夹（建议以点开头，保持隐藏）
├── src/
├── tests/
├── .gitignore   <--- 必须在这里忽略 .venv/
└── requirements.txt
```

多个venv环境应该放在不同项目的根目录下(而不应该放同一个根目录下)

类似的,第二个`venv`目录放在第二个项目根目录中,例如`my_project2`下的`.venv`

- **编辑器自动识别**：VS Code 和 PyCharm 会自动扫描项目下的 `.venv` 并建议将其作为解释器。
- **路径清晰**：你永远不会搞混哪个环境属于哪个项目。
- **易于清理**：删除项目文件夹时，环境也随之删除，不会留下系统垃圾。

### git版本控制管理：`.gitignore`

**千万不要将 `.venv` 文件夹上传到 Git！** 虚拟环境包含大量硬编码的绝对路径，换台机器就失效了。

在项目根目录创建 `.gitignore` 文件。

写入一行：`.venv/`。

共享项目时，只共享 `requirements.txt`。

### 移除venv

移除 `venv` 虚拟环境的操作非常简单，因为它不像 Conda 那样需要复杂的卸载命令。`venv` 本质上就是一个包含 Python 解释器和库文件的**普通文件夹**。

以下是标准步骤：

1. 退出环境（如果已激活）

如果你的终端提示符前还显示着 `(.venv)`，请先运行：`deactivate`命令

> 在环境被激活时,激活脚本(例如~/.venv/bin/activate)会向当前shell注册`deactivate`命令(函数),方便用户取消激活当前环境

这一步会恢复你的系统环境变量（特别是 `PATH`），防止后续操作出现残留。

直接删除你创建虚拟环境时指定的那个文件夹（通常命名为 `.venv`、`venv` 或 `env`）。

> 一步到位的命令:`deactivate && rm -rf <your_venv_dir_path>` 

总结与对比

| **工具**  | **移除命令**                   | **原理**                     |
| --------- | ------------------------------ | ---------------------------- |
| **venv**  | `rm -rf <dir>`                 | 物理删除文件夹即可           |
| **Conda** | `conda remove -n <name> --all` | 需要通过管理工具修改中央索引 |

## uv,conda,venv

### 1. 三方核心对比表

| **特性**            | **venv (标准库)**  | **Conda (传统强者)**       | **uv (新晋神器)**              |
| ------------------- | ------------------ | -------------------------- | ------------------------------ |
| **速度**            | 快 (轻量)          | **慢** (解析依赖耗时久)    | **极快** (比 pip 快 10-100 倍) |
| **Python 版本管理** | ❌ 无法安装 Python  | ✅ 自由安装各版本           | ✅ 自动下载/管理 Python         |
| **非 Python 依赖**  | ❌ 不支持 (如 CUDA) | ✅ 强项 (二进制包管理)      | ❌ 不直接支持                   |
| **磁盘占用**        | 小                 | **巨大** (重复包多)        | **极小** (全局内容寻址缓存)    |
| **上手难度**        | 极低               | 中                         | 低 (命令直观)                  |
| **适用场景**        | 简单脚本、轻量容器 | 深度学习、科学计算、多语言 | **现代项目、通用开发、CI/CD**  |

------

### 2. 为什么 `uv` 正在取代 `conda` 和 `venv` 的部分领地？

`uv` 的出现是为了解决 `pip` 慢、`venv` 功能弱、`conda` 太重的问题：

- **全能选手**：`uv` 既能像 `conda` 一样管理不同的 Python 版本（`uv python install 3.12`），也能像 `venv` 一样创建虚拟环境（`uv venv`）。
- **性能怪兽**：它通过 Rust 实现，并利用了“硬链接”技术。如果你在两个环境里都装了同样的 Numpy，`uv` 只会在磁盘里存一份，而 `conda` 通常会存两份。
- **一键运行**：`uv run` 可以直接运行一个脚本并自动处理环境。比如 `uv run --with requests myscript.py`，你甚至不需要手动创建环境。

------

### 3. 你该如何选择？（决策指南）

现在你的工具箱里有三个工具，建议这样分配：

#### **情况 A：继续使用 Conda**

- **科研/深度学习**：需要安装 `pytorch` + `cuda` + `cudnn` 这种复杂的非 Python 库。
- **多语言项目**：项目里混杂了 R、C++ 等非 Python 依赖。
- **习惯稳定**：公司或团队已有成熟的 `conda` 工作流。

#### **情况 B：全面转向 uv**

- **纯 Python 项目**：Web 开发、自动化脚本、数据分析（纯 Python 库）。
- **追求效率**：受够了 `conda install` 漫长的等待。
- **现代工作流**：你需要类似 `Poetry` 的 `lock` 文件来保证环境 100% 可复现，但又想要极速体验。

#### **情况 C：只用 venv**

- **极其受限的环境**：如老旧的内网服务器，不允许安装第三方二进制工具。
- **极简主义**：只需要临时跑个 10 行代码的脚本。

------

### 💡 现在的学习建议

1. **Conda**：保留它，作为处理“硬骨头”（如大型 AI 框架）的底牌。
2. **uv**：**强烈建议立即尝试**。它是目前的行业趋势。你只需要记住 `uv init`、`uv add` 和 `uv run` 就能覆盖 90% 的开发需求。
3. **venv**：知道它存在即可，无需深钻。

