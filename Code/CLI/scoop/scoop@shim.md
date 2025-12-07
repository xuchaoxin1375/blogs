[toc]

## abstract

For terminal applications, Scoop creates *shims*, a kind of command-line shortcuts, inside the `~\scoop\shims` folder, which is accessible in the PATH. 

For graphical applications, Scoop creates program shortcuts in a dedicated Start menu folder, called 'Scoop Apps'. This way, packages are always cleanly uninstalled and you can be sure what tools are currently in your PATH and in your Start menu.
对于终端应用程序，Scoop 会在 `~\scoop\shims` 文件夹中创建 *shim* （一种命令行快捷方式），该文件夹已添加到 PATH 环境变量中。

对于图形应用程序，Scoop 会在名为“`Scoop Apps`”的专用开始菜单文件夹中创建程序快捷方式。这样，软件包始终能够被彻底卸载，并且您可以清楚地了解当前 PATH 环境变量和开始菜单中包含哪些工具。

Scoop 里的 **shim** 是一个**轻量级可执行“代理”**（英文：*shim = lightweight proxy executable*）。

它的作用是： 让你安装的软件，无论真实路径在哪里，都能通过一个统一的命令名在系统中被调用。

换句话说：**Scoop 通过 shim 来“桥接”命令名和程序真实路径。**

下面用中文解释，并附带关键英文词汇标注。

### shim 的作用

| 作用                                  | 说明                                                         |
| ------------------------------------- | ------------------------------------------------------------ |
| 命令映射（command mapping）           | 把例如 `python`、`node` 这种命令映射到真实执行文件。         |
| 路径稳定（stable path）               | Scoop 的应用放在 `~/scoop/apps/...`，版本升级会变动路径，而 shim 路径不变。 |
| 简化 PATH 设置（PATH simplification） | 无需把每个软件的真实目录加入 PATH，统一使用 `~/scoop/shims/`。 |

### 运行流程示例

以你安装 Python 为例：

1. Scoop 安装 Python 到：
    `~/scoop/apps/python/current/python.exe`
2. Scoop 在 `~/scoop/shims/` 目录生成一个 shim：
    `python.exe`
3. 当你执行 `python` 时：
    shim → 自动转发（forward）到真正的 Python 程序。

用类比来理解：
 **shim 就像门房（doorman），负责把访客（命令）带到真正的房间（可执行文件）。**

### shim 的实现方式

Scoop 使用的 shim 其实是由一个小工具 *shimmer* 生成的 tiny executable 或 batch 文件，主要做：

- 读取实际程序路径（real executable path）
- 将参数（arguments）原样传递过去
- 启动真实程序（invoke real executable）

### 为什么需要 shim？

因为 Scoop 的目录结构是“每个版本一个文件夹”，例如：

```
python/
  ├── 3.12.0/
  ├── 3.12.1/
  └── current → 3.12.1/
```

真实路径会随版本变化，但 shim 永远不变，避免 PATH 混乱。

### 示例：查看某个 shim 指向哪里

你可以在 PowerShell 执行：

```powershell
scoop which python
```

它会告诉你 shim 后面真实的执行路径。

例如

```powershell
 scoop which python
C:\scoop\apps\miniconda3\current\python.exe
```

而shims目录中

```powershell
#⚡️[Administrator@CXXUDESK][C:\scoop\shims][11:44:28] PS >
 ls python.*

    Directory: C:\scoop\shims

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           2025/10/4    20:26         136192 python.exe
-a---          2025/10/10    17:41             54 python.shim
```

其中的`python.shim`内容如下

```ini
path = "C:\scoop\apps\miniconda3\current\python.exe"

```



### 示例：查看所有 shim

```powershell
Get-ChildItem ~/scoop/shims
```

## 创建scoop安装的命令行工具的别名

以python为例

```powershell
#⚡️[Administrator@CXXUDESK][C:\scoop\shims][12:12:23] PS >
 ls python.*,py.*

    Directory: C:\scoop\shims

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           2025/10/4    20:26         136192 python.exe
-a---          2025/10/10    17:41             54 python.shim
la---           2025/12/7    12:12              0 py.exe -> C:\scoop\shims\python.exe
la---           2025/12/7    12:12              0 py.shim -> C:\scoop\shims\python.shim
```

scoop 安装的python和普通方法安装的不同

并且scoop会隐藏一些细节,比如我使用miniconda这类环境管理工具安装的python,python可执行程序的真实路径可能位于

```
scoop which python
C:\scoop\apps\miniconda3\current\python.exe
```

这可以由`scoop which python`命令查询出来.

如果你想要为python.exe取一个别名,比如`py`,则可以在shims目录下创建一组名符号链接`py.exe`和`py.shim`,他们分别指向同目录下的`python.exe`和`python.shim`

经过上述操作,可以使用`scoop which py`查看别名命令`py`,其指向和原来的python相同

```powershell
  scoop which py
C:\scoop\apps\miniconda3\current\python.exe
```

