[toc]



## 进阶用法

- 例如利用aria2进行多线程下载,创建bucket等问题

### 认识@使用@创建bucket

- [Buckets · ScoopInstaller/Scoop Wiki (github.com)](https://github.com/ScoopInstaller/Scoop/wiki/Buckets)

### 资深用户的记录和教程👺

- [Scoop 国内源加速：Windows 命令行包管理工具 Scoop 的安装、使用与软件源定制 - 志文工作室 (lzw.me)](https://lzw.me/a/scoop.html/comment-page-1)

- [教程_Scoop:超好用的Windows包管理器 - 边缘坐标 - 博客园 (cnblogs.com)](https://www.cnblogs.com/Edge-coordinates/p/15130184.html)

- [scoop中使用aria2加速下载 - 姬雨晨 - 博客园 (cnblogs.com)](https://www.cnblogs.com/jiyuchen1/p/18241199)

- [【好软推荐】Scoop - Windows快速软件安装指南 - 老船长SleepyOcean - 博客园 (cnblogs.com)](https://www.cnblogs.com/sleepyocean/p/17017084.html)



## scoop仓库被污染@更新问题@修复scoop更新git unstash问题👺

- 如果你无意中对scoop目录下的某些git仓库做了修改，那么可能导致更新失败
- 当你在 PowerShell 中运行 `scoop update` 命令时，出现了以下警告：`WARN  Uncommitted changes detected. Update aborted.` 这是 Scoop 检测到 Scoop 本身的 Git 仓库中有未提交的更改，从而阻止更新操作。

```powershell
error: cannot pull with rebase: You have unstaged changes.
error: Please commit or stash them.
```

### 原因分析

Scoop 使用 Git 来管理它的自身和软件包的版本。当 Scoop 的本地仓库中有未提交的更改时，它不会允许执行更新操作，以防止这些更改被覆盖或引发冲突。

### 解决方法

通常我们通过丢弃更改来恢复更新

**丢弃未提交的更改**：如果你不需要这些更改，或你确定这些更改是不必要的，你可以丢弃它们。

在 PowerShell 中执行以下命令来重置 Scoop 的bucket仓库：

```powershell
cd ~\scoop\apps\scoop\current
git reset --hard
# git clean -df # 清除未保存的更改

#其他buckets依次修复
cd $home/scoop/buckets
ls -Directory |%{cd $_;git reset --hard head}

```

如果是自定安装路径:

假设scoop安装目录记为`$scoop_home`,则用`$buckets="$scoop_home/buckets"`作为buckets目录路径的代表

```powershell
$buckets="$scoop_home/buckets"
ls $buckets  -Directory  |%{echo $_.name ;cd $_.FullName;git status};
# 回到buckets目录
cd $buckets
#end
```



```powershell
cd $env:scoop\scoop\current
git reset --hard
# git clean -df # 清除未保存的更改

#其他buckets依次修复
cd $env:scoop/buckets
ls -Directory |%{cd $_;git reset --hard head}

```

然后再尝试运行 `scoop update`



Note:**保存和提交更改**：如果你不想要彻底放弃修改，可以创建分支保存，然后切换会原分支回溯拉取更新

如果buckets被意外更改,也可以类似的方式放弃更改然后重新拉取更新

分别检查各个bucket内`git status`的返回值(可以用脚本批量检查),找到后执行`reset`

假设我这里main bucket被污染,执行reset





## scoop家目录不可以轻易移动或复制

- scoop使用了符号链接来区分并指定不同软件的当前版本,每个apps下的软件目录中都存在一个`current`符号,指向当前使用的版本

- 如果你打算通过复制scoop家目录来备份,那么复制后的scoop目录中的current指向可能会失效(变为空文件夹`current`而不再是一个有效符号)

- 可以尝试以下方式修复(先进入到scoop家目录(这里进入全局安装的scoop家目录下的apps目录))

  ```powershell
  #⚡️[cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\ProgramData\scoop\apps]
  PS> 
  $items = Get-ChildItem C:\ProgramData\scoop\apps 
  $items | ForEach-Object { Write-Host $_ -NoNewline ; New-Item -ItemType SymbolicLink -Path $_/current -Target $_/*.* -Force }
  ```

  - 部分目录可能需要手动创建符号

- 其他方法参考下面的`scoop reset`

## 安装多个版本的同名软件👺

- 例如安装python3的不同版本,openjdk的不同版本,powershell7的不同版本

### 预备工作

- 注意

  - 在安装第二个版本或其他版本前,请关闭相关进程,否则可能会失败,例如安装另一个版本的powershell7
  - 对于全局安装可能需要管理员权限窗口启动powershell(v5)来操作(安装或切换新版本)

- 对于powershell7比较特殊点,因为scoop一般运行在powershell上,并且很可能是powershell7(pwsh)

  - 如果要安装两个powershell 7,建议你先关闭所有powershell7窗口,然后打开winodws powershell(v5.1)

  - 在powershell(v5.1)中执行安装第二个版本的powershell7

  - 例如我当前用的是scoop安装的powershell 7.4.5,可以打开windows powershell 安装powershell 7.2.4

    ```powershell
    (base) PS C:\Users\cxxu> scoop install powershell@7.2.4 -g
    WARN  Given version (7.2.4) does not match manifest (7.4.5)
    WARN  Attempting to generate manifest for 'powershell' (7.2.4)
    Autoupdating powershell
    Searching hash for PowerShell-7.2.4-win-x86.zip in https://github.com/PowerShell/PowerShell/releases/tag/v7.2.4/
    Found: 56e9a7a0b2617181bfbd7ae1318215a43360bba578ecef872beb0a7da1a2ad08 using Extract Mode
    Searching hash for PowerShell-7.2.4-win-x64.zip in https://github.com/PowerShell/PowerShell/releases/tag/v7.2.4/
    Found: edcd6b626ee983c2eb8dbc3cc7bc222263b60bcf1dda4f02c53018528d09bb14 using Extract Mode
    Searching hash for PowerShell-7.2.4-win-arm64.zip in https://github.com/PowerShell/PowerShell/releases/tag/v7.2.4/
    Found: 750317b603c379a289f2e51dde9adba66dfe2759032aaee1f02c5342fc67df9d using Extract Mode
    Writing updated powershell manifest
    WARN  Scoop uses 'aria2c' for multi-connection downloads.
    WARN  Should it cause issues, run 'scoop config aria2-enabled false' to disable it.
    WARN  To disable this warning, run 'scoop config aria2-warning-enabled false'.
    Installing 'powershell' (7.2.4) [64bit] from 'C:\Users\cxxu\scoop\workspace\powershell.json'
    Loading PowerShell-7.2.4-win-x64.zip from cache.
    Checking hash of PowerShell-7.2.4-win-x64.zip ... ok.
    Extracting PowerShell-7.2.4-win-x64.zip ... done.
    Linking C:\ProgramData\scoop\apps\powershell\current => C:\ProgramData\scoop\apps\powershell\7.2.4
    Creating shim for 'pwsh'.
    Creating shortcut for PowerShell (pwsh.exe)
    'powershell' (7.2.4) was installed successfully!
    ```

### 版本检查

例如powershell 7的两个子版本共存,并且current会自动重定向到最后安装的一个版本

```powershell
PS🌙[BAT:71%][MEM:31.15% (9.88/31.71)GB][20:23:42]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\ProgramData\scoop\apps\powershell]
PS> ls

        Directory: C:\ProgramData\scoop\apps\powershell


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d----          2024/9/2     20:17                  7.2.4
d----          2024/9/2     17:40                  7.4.5
l-r--          2024/9/2     20:17                  current 󰁕 C:\ProgramData\scoop\apps\powershell\7.2.4
```

### 切换版本

- 查看下一节

## scoop app版本切换和current当前版本指向符号重置👺

- 使用`scoop reset <app>`可以重置scoop app,也会重新创建current符号

  ```powershell
  PS>  scoop reset -h
  Usage: scoop reset <app>
  
  Used to resolve conflicts in favor of a particular app. For example,
  if you've installed 'python' and 'python27', you can use 'scoop reset' to switch between
  using one or the other.
  
  You can use '*' in place of <app> or `-a`/`--all` switch to reset all apps.
  ```

  - 文档表明,`scoop reset`可以切换指定软件的当前使用版本(更新app下的current符号)
  - 如果使用`scoop reset *`会更新或创建(如果没有的话)app下的current符号
  - 那么reset会有其他副作用吗?
    - 我在powershell的两个版本目录中分别放置了一个文件,然后用`scoop reset`执行切换版本操作,两个文件并没有被删除,所以reset应该是比较安全的命令,不会破坏你的修改

- ```
  (base) PS C:\Users\cxxu> ps pwsh|kill
  (base) PS C:\Users\cxxu> scoop reset powershell@7.4.5
  Resetting powershell (7.4.5).
  Linking C:\ProgramData\scoop\apps\powershell\current => C:\ProgramData\scoop\apps\powershell\7.4.5
  Creating shim for 'pwsh'.
  Creating shortcut for PowerShell (pwsh.exe)
  (base) PS C:\Users\cxxu> pwsh
  PowerShell 7.4.5
  ```


### scoop多版本安装的局限性

- scoop在理想情况下可以安装一个软件的多个版本
- 但是scoop本身没有对多版本做专门的设计,也就是到底能不能多版本要看软件变换(安装方式)变换大不大
- 并且软件有哪些可用的历史版本也难以直接从scoop直接推出
- 相关讨论链接:[[Feature\] scoop info [app] 可以支持查看软件的所有版本（Can support viewing all versions of the software） · Issue #5105 · ScoopInstaller/Scoop (github.com)](https://github.com/ScoopInstaller/Scoop/issues/5105)

## scoop代理配置和git代理

scoop依赖于git.

scoop本身可以通过`scoop config proxy proxy_url`配置代理.假设这里proxy_url为`http://localhost:port1`

但前提是不和git的配置中代理相关选项冲突,例如端口冲突:

```conf
[http "https://github.com"]
	proxy = socks5://127.0.0.1:port2
```

如果`port1`和`port2`不一致,尤其是`port2`不可用时,就容易出错,例如:

```powershell
Updating Scoop...
fatal: unable to access 'https://github.com/ScoopInstaller/Scoop/': Failed to connect to github.com port 443 via 127.0.0.1 after 2117 ms: Could not connect to server
```



## 扩展

- scoop总得来说是不错的,但是软件更新较慢是一个缺点
  - 对于Github上的软件,更新可能滞后几个小时,比如powershell
  - 如果是冷门或者国际上不流行的软件,那么可能滞后几个月
- 虽然版本稍微老一点问题不但,但是它弹窗就不太舒服
- 我们可以考虑用`Winget`来获取交新版本的软件(如果winget找得到的话),winget默认是很慢的,建议换源