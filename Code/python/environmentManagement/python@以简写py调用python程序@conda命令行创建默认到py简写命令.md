[toc]

在windows系统上,`py` 是 Windows 官方自带的 **Python Launcher for Windows**，默认会随官方 Windows installer 版的 Python 一起安装。

Miniconda/Anaconda 并不会安装这个 launcher,使用scoop安装也没有这个`py.exe`程序

解决方案

可以根据需要来选择：

### 创建python的符号链接到已配置到Path的目录

例如,我的Path环境变量配置了`C:\exes`目录,从而此目录中的可执行文件就可以直接用名字启动

> 但是注意权限和程序的相对工作目录,有些程序依赖于工作目录中的一些组件,单纯的链接到其他目录中去调用可能会报错(组件缺失)

对于conda(miniconda)中自带的python版本(尤其是通过scoop安装的情况下),可以通过创建符号链接为`python.exe`创建简写`py.exe`

当然也可以是别的名字,比如`py1`

例如:`New-Item -ItemType HardLink -Path C:/exes/py1.exe -Target C:\scoop\apps\miniconda3\current\python.exe -Verbose -Force`

```powershell
# [cxxu@CXXUFIREBAT][~\Desktop][23:11:52][UP:0.91Days]
PS> New-Item -ItemType HardLink -Path C:/exes/py1.exe -Target C:\scoop\apps\miniconda3\current\python.exe -Verbose -Force

VERBOSE: Performing the operation "Create Hard Link" on target "Destination: C:\exes\py1.exe".

    Directory: C:\exes

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           2025/6/13     0:54         104264 py1.exe

```

检查是否可用

```powershell
# [cxxu@CXXUFIREBAT][~\Desktop][23:20:37][UP:0.92Days]
PS> py1
Python 3.13.5 | packaged by Anaconda, Inc. | (main, Jun 12 2025, 16:37:03) [MSC v.1929 64 bit (AMD64)] on win32
Type "help", "copyright", "credits" or "license" for more information.
>>> exit()
```

说明我们成功创建了`python.exe`的别名`py1`

### 安装 Windows Python Launcher

如果你确实想要 `py` 命令（比如方便在 Windows 上切换不同 Python 版本）：

1. 去 [Python 官方下载页](https://www.python.org/downloads/windows/) 下载 Windows installer。
2. 在安装时只勾选 “Install launcher for all users” （可以不勾主程序 Python，因为你已经用 miniconda 管理）。
3. 安装完成后，命令行就能用 `py` 调用 python。

这样 `py` 会负责查找系统中不同的 Python 解释器，你可以用：

```powershell
py         # 默认版本
py -3.12   # 指定 3.12
py -3.11   # 指定 3.11
```

### 自己创建别名（适合只想简单用 `py`）

如果你只用 miniconda 里的 python，不在意多版本切换，可以直接给 `py` 做个别名：

- 在 PowerShell 里加 profile：

```powershell
New-Alias py python
```

这样 `py` 就等同于 `python`。
 如果要永久生效，把这一行加到你的 PowerShell profile (`$PROFILE`) 里。

- 在 CMD 下，可以建一个 `py.bat`：
   在某个 PATH 里的目录（比如 `C:\Windows`）新建一个 `py.bat`，内容是：

```bat
@echo off
python %*
```

这样输入 `py` 时实际执行的是 `python`。

### 直接继续用 `python`

在 Windows 上，`py` 只是一个 launcher 的方便工具，本质上和 `python` 没区别。如果你只用一个 conda 环境，其实没必要折腾 `py`。

------

总结表格：

| 方式                 | 适合场景                  | 操作                                |
| -------------------- | ------------------------- | ----------------------------------- |
| 安装官方 py launcher | 需要切换多版本 Python     | 装 Python Installer 并启用 launcher |
| New-Alias / .bat     | 只想让 `py` 等于 `python` | 创建别名或批处理                    |
| 保持现状             | 只用 `python` 就好        | 什么都不用做                        |

