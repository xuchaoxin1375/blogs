[toc]

## abstract

在国内环境下，`uv` 的默认下载速度可能确实不理想。由于 `uv` 是为了性能设计的，它**故意不读取** `pip` 的全局配置文件（如 `pip.conf`），所以你需要专门为 `uv` 配置国内镜像源。

以下是三种最有效的方法：

------

## 1. 全局配置

[Configuration files | uv](https://docs.astral.sh/uv/concepts/configuration-files/)

你可以创建一个全局配置文件，让所有的 `uv` 命令（包括 `uv add`、`uv run`、`uv tool`）默认都使用国内源。

**配置文件路径：**

- **Linux / macOS:** `~/.config/uv/uv.toml`
- **Windows:** `%APPDATA%\uv\uv.toml`

**操作步骤：**

ustc源:

**当前项目配置**：修改项目根目录下的 `uv.toml` 

```toml
[[index]]
url = "https://mirrors.ustc.edu.cn/pypi/simple"
default = true
```

或 `pyproject.toml`：

```toml
[[tool.uv.index]]
url = "https://mirrors.ustc.edu.cn/pypi/simple"
default = true
```

**全局配置**：修改全局配置文件 `~/.config/uv/uv.toml`（Linux/macOS）或 `%AppData%\uv\uv.toml`（Windows），内容同上。

1. 如果目录不存在，先创建它：`mkdir -p ~/.config/uv`(linux/macos)或`mkdir $env:appdata/uv `(windows powershell)
2. 编辑或创建 `uv.toml` 文件

或者tuna

```TOML
[[index]]
url = "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"
default = true
```

> **注意：** 在全局 `uv.toml` 中，层级是直接从 `[[index]]` 开始的，不需要写 `[tool.uv]`。

------

## 2. 使用环境变量（临时加速或系统级配置）

如果你不想修改配置文件，或者想在 CI/CD 环境中使用，可以设置环境变量。

在你的 `.bashrc` 或 `.zshrc` 中添加：



```bash
export UV_INDEX_URL=https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple
```

设置后执行 `source ~/.bashrc` 即可生效。

------

## 3. 项目级配置

如果你只想让某个特定项目使用特定的镜像源，可以在该项目的 `pyproject.toml` 中添加：

```TOML
[[tool.uv.index]]
url = "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"
default = true
```

------



## 4. 解决 Python 解释器下载慢的问题

`uv` 除了下载包，还会自动下载 Python 解释器。如果这部分也慢，可以设置 Python 下载镜像。

目前国内尚无完美的 `uv` Python 解释器全量镜像，但你可以通过环境变量强制 `uv` 使用特定的安装源（如果该源支持）：

```bash
# 这种方式目前主要依赖于网络环境，建议开启代理或手动预安装 Python
uv python install 3.12
```

------

## 验证是否生效

配置完成后，你可以运行以下命令观察输出的 URL：

```bash
uv add requests --verbose
```

在输出的日志中，你应该能看到正在从 `mirrors.tuna.tsinghua.edu.cn` 获取数据，而不是 `pypi.org`。

## 常用国内镜像源地址

| **机构**                   | **镜像地址**                                           |
| -------------------------- | ------------------------------------------------------ |
| **中国科学技术大学**(USTC) | `https://mirrors.ustc.edu.cn/pypi/web/simple`          |
| **清华大学 (TUNA)**        | `https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple` |
| **阿里云**                 | `https://mirrors.aliyun.com/pypi/simple/`              |
| **腾讯云**                 | `https://mirrors.cloud.tencent.com/pypi/simple/`       |

------

