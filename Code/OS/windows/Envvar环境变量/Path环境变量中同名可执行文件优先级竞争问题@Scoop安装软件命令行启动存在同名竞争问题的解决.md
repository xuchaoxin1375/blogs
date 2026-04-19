[toc]



## abstract

windows系统中,命令行中能够直接调用的可执行文件(程序)通常配置在Path环境变量下

Path环境的取值决定了在命令行中能够在任何路径下都能直接调用程序(以程序名直接调用)的有哪些

配置Path变量的取值(通常是增加一个目录(文件夹)路径到现有取值中,以`;`隔开),这个操作对于命令行程序用户是经常做的,无论是从命令行方式配置(setx或者powershell中调用`[System.Environment]`下的方法配置环境变量),这里不做配置方法的说明,详情另见它文

本文介绍使用Path变量过程中可能会遇到的问题,以及如何调整环境变量来解决一些冲突问题

本文会结合powershell命令行环境说明一些问题

## 同名程序的竞争问题

windwos系统会将`PathExt`环境变量中配置的文件类型后桌视为可执行程序的后缀,例如最典型的`.exe`,`.bat`等

```powershell
PS> $env:PATHEXT
.LNK;.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC;.CPL
```

这里出现的`.LNK`是我自己加上的,默认通常没有这个后缀在里面

现在看下面这个例子,我使用了windows上的一个基于powershell开发的包管理工具scoop,它可以按照很多常用的命令行工具以及少量的GUI程序

其中有些工具包,比如miniconda3这个包,在安装的时候,会自动安装其依赖的许多压缩/解压程序,比如lz4和zstd,即便我们没有专门安装这两个程序

```powershell
PS> $env:Path -split ';'|sls scoop

C:\ProgramData\scoop\apps\powershell\7.5.1
C:\ProgramData\scoop\shims
C:\ProgramData\scoop\apps\lz4\current
C:\ProgramData\scoop\apps\openjdk21\current\bin
C:\ProgramData\scoop\apps\nvm\current
C:\ProgramData\scoop\apps\nvm\current\nodejs\nodejs
C:\ProgramData\scoop\apps\mingw\current\bin
C:\ProgramData\scoop\apps\miktex\current\texmfs\install\miktex\bin\x64
C:\ProgramData\scoop\apps\dotnet-sdk\current
C:\ProgramData\scoop\apps\miniconda3\current\scripts
C:\ProgramData\scoop\apps\miniconda3\current\Library\bin
C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Scoop Apps
C:\Users\Administrator\scoop\shims
C:\ProgramData\scoop\shims
C:\ProgramData\scoop\apps\lz4\current
C:\ProgramData\scoop\apps\powershell\7.5.1
C:\ProgramData\scoop\apps\nvm\current
C:\ProgramData\scoop\apps\nvm\current\nodejs\nodejs
C:\ProgramData\scoop\apps\mingw\current\bin
C:\ProgramData\scoop\apps\miktex\current\texmfs\install\miktex\bin\x64
C:\ProgramData\scoop\apps\dotnet-sdk\current
C:\ProgramData\scoop\apps\miniconda3\current

```

为了更好的说明问题,我们分别查看用户级别的Path变量和系统级的Path变量

在此之间,先注意两个表达式的取值(常量字符串`'User'`和'`Machine`'的标准代替写法)

```powershell
PS> [System.EnvironmentVariableTarget]::Machine
Machine
PS> [System.EnvironmentVariableTarget]::User
User
```

下面是用户级别的Path变量的取值

```powershell
PS> [System.Environment]::GetEnvironmentVariable('Path',[System.EnvironmentVariableTarget]::User) -split ';'
C:\Users\Administrator\scoop\shims
C:\ProgramData\scoop\shims
C:\ProgramData\scoop\apps\lz4\current
C:\phpstudy_pro\extensions\Nginx1.25.2
C:\ProgramData\scoop\apps\powershell\7.5.1
C:\ProgramData\scoop\apps\nvm\current
C:\ProgramData\scoop\apps\nvm\current\nodejs\nodejs
C:\ProgramData\scoop\apps\mingw\current\bin
C:\ProgramData\scoop\apps\miktex\current\texmfs\install\miktex\bin\x64
C:\ProgramData\scoop\apps\dotnet-sdk\current
C:\ProgramData\scoop\apps\miniconda3\current
C:\Users\Administrator\AppData\Local\Programs\cursor\resources\app\bin
C:\phpstudy_pro\extensions\php\php7.4.3nts\
C:\phpstudy_pro\extensions\MySQL5.7.26\bin
```

下面是系统级别的Path取值

```powershell
PS> [System.Environment]::GetEnvironmentVariable('Path',[System.EnvironmentVariableTarget]::Machine) -split ';'
C:\ProgramData\scoop\shims
C:\ProgramData\scoop\apps\lz4\current
C:\ProgramData\scoop\apps\openjdk21\current\bin
C:\ProgramData\scoop\apps\nvm\current
C:\ProgramData\scoop\apps\nvm\current\nodejs\nodejs
C:\ProgramData\scoop\apps\mingw\current\bin
C:\ProgramData\scoop\apps\miktex\current\texmfs\install\miktex\bin\x64
C:\ProgramData\scoop\apps\dotnet-sdk\current
C:\phpstudy_pro\Extensions\MySQL5.7.26\bin
C:\ProgramData\scoop\apps\miniconda3\current\scripts
C:\ProgramData\scoop\apps\miniconda3\current\Library\bin
C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Scoop Apps
C:\Windows\system32
C:\Windows
C:\Windows\System32\Wbem
C:\Windows\System32\WindowsPowerShell\v1.0\
C:\Windows\System32\OpenSSH\
C:\Program Files\Microsoft VS Code\bin
C:\Program Files\dotnet\
C:\exes
```

其中一个大的包是miniconda3,包含了大量的实用程序,但是往往不是最新版本

```powershell
PS> ls *exe

    Directory: C:\ProgramData\scoop\apps\miniconda3\current\Library\bin

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---            2023/9/5    16:22          23040 acountry.exe
-a---            2023/9/5    16:22          23552 adig.exe
-a---            2023/9/5    16:22          14336 ahost.exe
-a---           2023/10/8    19:17         496128 b2.exe
-a---           2023/10/8    19:17         496128 bjam.exe
-a---           2024/8/21     0:56         241432 bsdcat.exe
-a---           2024/8/21     0:56        1172240 bsdcpio.exe
-a---           2024/8/21     0:56        1201432 bsdtar.exe
...
-a---            2024/5/1     5:22         173840 lz4.exe
-a---            2024/5/1     6:12         478320 lzcat.exe
-a---            2024/5/1     6:12         478320 lzma.exe
-a---            2024/5/1     6:12         315432 lzmadec.exe
-a---            2024/5/1     6:12         328752 lzmainfo.exe
...
-a---            2024/5/1     6:13         478320 xz.exe
-a---            2024/5/1     6:13         478312 xzcat.exe
-a---            2024/5/1     6:13         347904 xzdec.exe
-a---           2024/10/9    23:18         763152 zstd.exe
```

如果这时候你需要安装最新版本的`zstd.exe`或者`lz4.exe`两种先进压缩/解压缩工具,就有可能发生程序版本的竞争问题

例如,我们使用`gcm zstd*`来查询当前环境中有几个名为`zstd`的可直接调用的程序名

```powershell
PS> gcm zstd*

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Application     zstd.exe                                           0.0.0.0    C:\ProgramData\scoop\shims\zstd.exe
Application     zstd.exe                                           0.0.0.0    C:\ProgramData\scoop\apps\miniconda3\current\Library\bin\zstd.exe
# 类似的,查询lz4
PS> gcm lz4*

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Application     lz4.exe                                            0.0.0.0    C:\ProgramData\scoop\shims\lz4.exe
Application     lz4.exe                                            1.9.4.0    C:\ProgramData\scoop\apps\miniconda3\current\Library\bin\lz4.exe
Application     lz4_decompress.exe                                 5.7.26.0   C:\phpstudy_pro\Extensions\MySQL5.7.26\bin\lz4_decompress.exe

```

那么上述这类有多个可调用程序(版本)的顺序(优先级)是如何确定的

windows扫描Path环境变量中的各个目录,从第一个目录开始扫描,这意味着你想优先使用的程序路径应该相对靠前,比如本例中,单独安装的zstd版本(`C:\ProgramData\scoop\shims\zstd.exe`是我优先想要使用的,那么它所在的路径`C:\ProgramData\scoop\shims`在Path中的位置就应该在另一个同名程序所在目录`C:\ProgramData\scoop\apps\miniconda3\current\Library\bin`的前面)

注意到,系统级和用户级中各有一个Path变量,但是并不总是都要配置,请优先调整用户级别的Path,它不需要管理员权限;而系统级中的Path不一定包含你需要配置的路径,如果有,也类似的注意所配置的路径之间的相对顺序

```powershell

#⚡️[Administrator@CXXUDESK][C:\ProgramData\scoop\apps\miniconda3\current\Library\bin][19:06:26][UP:31.22Days]
PS> zstd -V
*** Zstandard CLI (64-bit) v1.5.7, by Yann Collet ***

#⚡️[Administrator@CXXUDESK][C:\ProgramData\scoop\apps\miniconda3\current\Library\bin][19:12:42][UP:31.22Days]
PS> gcm zstd

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Application     zstd.exe                                           0.0.0.0    C:\ProgramData\scoop\shims\zstd.exe
```

