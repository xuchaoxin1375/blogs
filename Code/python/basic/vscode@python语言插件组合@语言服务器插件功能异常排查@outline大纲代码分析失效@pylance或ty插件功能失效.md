[toc]

## abstract

vscode中python基础插件和增强插件:

- [Python - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-python.python)
  - 支持 Python 语言，并提供 IntelliSense (Pylance)、调试 (Python Debugger)、代码检查、格式化、重构、单元测试等扩展访问点。
  - 本插件是许多其他python插件的基础(依赖项)

- [Pylance - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance)
  - VS Code 中高性能、功能丰富的 Python 语言服务器;安装时可能不依赖于上述的基础python插件,可以独立安装;
- [ty - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=astral-sh.ty)
  - 除了pylance,较新的`ty`是一个用 Rust 编写的、速度极快的 Python 类型检查器和语言服务器。

其他

Python 扩展提供可插拔的访问点，用于扩展各种功能领域，从而进一步提升您的 Python 开发体验。这些扩展都是可选的，具体取决于您的项目配置和偏好。

下面这些插件依赖于python基础插件:

- [Python formatters Python 格式化程序](https://code.visualstudio.com/docs/python/formatting#_choose-a-formatter)
- [Python linters Python 代码检查器](https://code.visualstudio.com/docs/python/linting#_choose-a-linter)

社区提供的ruff方案兼顾python程序的格式化和代码检查,且性能好,是一个不错的选择;

- [Ruff - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=charliermarsh.ruff)

  此插件需要ruff程序提供支持.(powered by **astral**)

### astral系列产品

Astral致力于为 Python 生态系统构建高性能开发者工具。

- [Astral Docs](https://docs.astral.sh/)

最著名的作品包括 Python 包管理器 [uv](https://github.com/astral-sh/uv)，以及代码检查和格式化工具 [Ruff](https://github.com/astral-sh/ruff)。

- [Ruff](https://docs.astral.sh/ruff/)

### python插件功能异常排查

不恰当的项目目录(工作区)配置会导致python插件提供的部分甚至主要功能失效;

除了**系统级和用户级配置**,在vscode在工作区(项目根目录)中针对python的配置`.vscode/settings.json`文件中通常有3个配置项:

```json
{
    "python.languageServer": "Default",
    "python.analysis.diagnosticsSource": "Pylance",
    "python.analysis.languageServerMode": "default"
}
```

这些配置项在vscode的设置中都可以找到(python插件+pylance插件)

其中最为重要的是`python language server`;

如果语言服务器运行异常,那么许多基础功能,例如符号分析和跳转都无法工作;

可以通过vscode的`OUTPUT`选项卡中的`python`相关的下拉选项中查看插件的日志输出;

> `Output: Focus on Output View`

下面是一些语言服务器插件输出的日志示例

#### ty

```log
2026-04-23 17:05:19.384 [info] Name: ty
2026-04-23 17:05:19.384 [info] Module: ty
2026-04-23 17:05:19.384 [info] Python extension loading
2026-04-23 17:05:19.384 [info] Waiting for interpreter from python extension.
2026-04-23 17:05:22.216 [info] Python extension loaded
2026-04-23 17:05:22.268 [info] Using interpreter: c:\scoop\apps\miniforge\25.11.0-1\python.exe
2026-04-23 17:05:22.316 [info] Initialization options: {}
2026-04-23 17:05:22.379 [info] Using the ty binary: c:\scoop\apps\miniforge\25.11.0-1\Scripts\ty.exe
2026-04-23 17:05:22.382 [info] Found executable at c:\scoop\apps\miniforge\25.11.0-1\Scripts\ty.exe
2026-04-23 17:05:22.382 [info] Server run command: c:\scoop\apps\miniforge\25.11.0-1\Scripts\ty.exe server
2026-04-23 17:05:22.383 [info] Server: Start requested.
2026-04-23 17:05:22.407 [info] ty server version: 0.0.32 (4d1e1fc57 2026-04-20)
```



```log
2026-04-23 16:59:06.723737600  INFO Version: 0.0.32 (4d1e1fc57 2026-04-20)
2026-04-23 16:59:06.764138700  INFO Defaulting to python-platform `win32`
2026-04-23 16:59:06.765158200  INFO Python version: Python 3.12, platform: win32
2026-04-23 16:59:13.035895900  INFO Indexed 100 file(s) in 0.016s
2026-04-23 16:59:15.425918000  INFO Checking file `c:\Users\Administrator\Desktop\woo_df\woosqlitedb.py` took more than 100ms (457.1503ms)

```



#### pylance

日志输出示例:

```log

2026-04-23 11:50:39.231 [info] Client: Pylance client (2026.2.1) started with python extension (2026.4.0)
2026-04-23 11:50:39.957 [info] (6952): Server root directory: file:///c%3A/Users/Administrator/.vscode/extensions/ms-python.vscode-pylance-2026.2.1/dist
2026-04-23 11:50:40.047 [info] (6952): Pylance language server 2026.2.1 (pyright version 1.1.408, commit 138238b4) starting
2026-04-23 11:50:40.055 [info] (6952): Starting service instance "woo_df" for workspace "c:\Users\Administrator\Desktop\woo_df"
2026-04-23 11:50:40.937 [info] (6952): Loading background bundle file:///c%3A/Users/Administrator/.vscode/extensions/ms-python.vscode-pylance-2026.2.1/dist/copilot-background.bundle.js into file:///c%3A/Users/Administrator/Desktop/woo_df...
2026-04-23 11:50:41.023 [info] (6952): Starting Mcp server id:52946 ...
2026-04-23 11:50:41.048 [info] (6952): FG(woo_df): Loading configuration file at c:\Users\Administrator\Desktop\woo_df\pyrightconfig.json
2026-04-23 11:50:41.049 [error] (6952): FG(woo_df): Config file "c:\Users\Administrator\Desktop\woo_df\pyrightconfig.json" could not be parsed. Verify that format is correct.
2026-04-23 11:50:41.061 [info] (6952): FG(woo_df): Setting environmentName for service "woo_df": "3.12.12 (base conda)"
2026-04-23 11:50:41.061 [info] (6952): FG(woo_df): Setting pythonPath for service "woo_df": "C:\scoop\apps\miniforge\25.11.0-1\python.exe"
2026-04-23 11:50:41.062 [info] (6952): FG(woo_df): No include entries specified; assuming c:\Users\Administrator\Desktop\woo_df
2026-04-23 11:50:41.062 [info] (6952): FG(woo_df): Auto-excluding **/node_modules
2026-04-23 11:50:41.063 [info] (6952): FG(woo_df): Auto-excluding **/__pycache__
2026-04-23 11:50:41.063 [info] (6952): FG(woo_df): Auto-excluding **/.*
2026-04-23 11:50:41.125 [info] (6952): FG(woo_df): Assuming Python version 3.12.12.final.0
2026-04-23 11:50:41.248 [info] (6952): [Editable Installs] Starting dynamic pth file resolution for Python: C:\scoop\apps\miniforge\25.11.0-1\python.exe
2026-04-23 11:50:41.257 [info] (6952): [Editable Installs] No sandbox available for Python C:\scoop\apps\miniforge\25.11.0-1\python.exe. Dynamic pth file resolution requires Python 3.13 or later.
2026-04-23 11:50:41.338 [info] (6952): FG(woo_df): Found 74 source files
2026-04-23 11:50:41.353 [info] (6952): Settings have not changed. Skipping update.
2026-04-23 11:50:41.696 [info] (6952): PQ(woo_df): Priority queue background worker(2) root directory: file:///c%3A/Users/Administrator/.vscode/extensions/ms-python.vscode-pylance-2026.2.1/dist
2026-04-23 11:50:41.696 [info] (6952): PQ(woo_df): Priority queue background worker(2) started
2026-04-23 11:50:41.833 [info] (6952): FG(woo_df): IDX(woo_df): Indexer background runner(3) root directory: file:///c%3A/Users/Administrator/.vscode/extensions/ms-python.vscode-pylance-2026.2.1/dist (index)
2026-04-23 11:50:41.834 [info] (6952): FG(woo_df): IDX(woo_df): Indexing(3) started
2026-04-23 11:50:43.271 [info] (6952): FG(woo_df): IDX(woo_df): scanned(3) 635 files over 1 exec env
2026-04-23 11:50:43.607 [info] (6952): FG(woo_df): IDX(woo_df): indexed(3) 635 files over 1 exec env
2026-04-23 11:50:43.710 [info] (6952): FG(woo_df): IDX(woo_df): Indexing finished(3).

```

语言服务器插件会跳过一些通常不适合检索的目录,例如`node_modules`,`__pycache__`以及`.`开头的(通常被视为隐藏文件)

### pylance报多余而不该有的错

- 重载窗口,pylance可以重新扫描新模块
- 配置extra路径
  - `python.analysis.extraPaths`
    - Used to specify extra search paths for import resolution. This replaces the old `python.autoComplete.extraPaths` setting.
    - Default value: empty array



