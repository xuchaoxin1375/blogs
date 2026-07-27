[toc]

# Windows 批处理（BAT）完整指南

批处理（Batch Processing）是 Windows 系统中一种强大的自动化脚本技术。通过编写 `.bat` 或 `.cmd` 文件，你可以将一系列命令组合起来，实现任务自动化、系统管理、文件处理等多种功能。

------

## 第一章：基础概念与环境

### 1.1 什么是批处理

批处理是一种脚本语言，运行在 Windows 的命令行解释器（cmd.exe）中。它的本质是将你在命令提示符中手动输入的命令，按顺序写入一个文本文件中，然后一次性执行。这种"批量处理"的方式就是"批处理"名称的由来。

批处理文件的扩展名通常是 `.bat`（源自早期 DOS 时代）或 `.cmd`（Windows NT 及之后引入）。两者在现代 Windows 中几乎没有功能差异，但 `.cmd` 文件在某些错误处理行为上略有不同。

### 1.2 为什么学习批处理

尽管 PowerShell 已成为 Windows 的现代化脚本工具，批处理仍然有其独特价值。它不需要任何额外安装，在任何 Windows 系统上都能直接运行。对于简单的自动化任务、传统系统维护、以及需要最大兼容性的场景，批处理仍是首选。此外，理解批处理也有助于你阅读和维护大量遗留的自动化脚本。

### 1.3 开发环境准备

你只需要一个文本编辑器和 Windows 系统即可开始。推荐使用 Visual Studio Code 并安装 "Batch Runner" 或类似扩展，可以获得语法高亮和便捷的运行功能。当然，Windows 自带的记事本也完全可以胜任。

创建你的第一个批处理文件非常简单：新建一个文本文件，将扩展名改为 `.bat`，然后双击运行或在命令提示符中执行。

### 1.4 运行方式

批处理文件有多种运行方式。最直接的方式是双击文件图标，系统会打开一个命令提示符窗口执行脚本。你也可以在已打开的命令提示符中输入文件路径来运行。如果需要以管理员权限运行，可以右键点击文件选择"以管理员身份运行"。

在命令提示符中运行时，可以使用 `call` 命令调用另一个批处理文件并返回继续执行，或直接输入文件名（此时不会返回原脚本继续执行）。

### 1.5 脚本文件的编码细节

中文windows系统需要注意以下内容:

- 编写cmd脚本文件时,应该确保换行风格为CRLF,虽然windows平台上此风格是默认的,但是有些编辑器可以指定LF风格,或者在其他平台编写的cmd脚本,需要小心这一点
- 如果包含中文,中文系统用户要注意,通常保存为gbk编码格式,防止打印的中文乱码!

下面这段批处理代码片段检查windows上是否有可用的python命令(检查`--version`参数的可用性)

```cmd
@echo off
python --version >nul 2>&1

echo "Checking Python environment...(环境检查...)
echo "脚本文件编码风格检查:CRLF回车换行风格脚本文件 + GBK编码(中文windows系统默认编码)"

@REM Check if python command is available, if not, prompt user to install python
if errorlevel 1 (
    echo.
    echo Error: Python command not found!
    echo Please confirm that you have installed Python and added it to the system PATH environment variable.
    echo Please visit https://www.python.org/downloads/ to download and install Python.
    echo.
    pause
    exit /b 1
) else (
    echo Python environment check passed, starting the program...

)

@REM pause
```



------

## 第二章：基本语法与结构

### 2.1 注释

注释是代码中不被执行的说明文字，用于解释代码的目的和逻辑。

```batch
@echo off
REM 这是一行注释，REM 是 REMark 的缩写
:: 这也是注释，使用双冒号的方式更简洁

REM 下面的命令会显示当前目录
dir
```

`REM` 是正式的注释命令，而 `::` 实际上是一个无效的标签名，被巧妙地用作注释。两者在大多数情况下等效，但在复杂的代码块（如 `for` 循环内部）中，建议使用 `REM` 以避免潜在问题。

### 2.2 回显控制

`echo` 命令用于在屏幕上显示信息。默认情况下，批处理会显示每一条正在执行的命令，这称为"回显"。

```batch
@echo off
REM @符号表示不显示这一行命令本身
REM echo off 关闭后续所有命令的回显

echo 欢迎使用批处理脚本
echo.
echo 上面的 echo. 会输出一个空行

echo on
REM 重新开启回显
dir
echo off
```

`@` 符号放在任何命令前面，可以阻止该行命令本身被显示。`@echo off` 是几乎所有批处理脚本的标准开头，它既关闭了回显，又不显示这条命令本身。

### 2.3 暂停与退出

```batch
@echo off
echo 脚本执行中...
pause
REM pause 命令会显示"请按任意键继续..."并等待用户输入

echo 即将退出
exit /b 0
REM exit /b 退出当前批处理但不关闭命令提示符窗口
REM 后面的数字是返回码，0 通常表示成功
```

`pause` 在调试脚本时非常有用，它可以让窗口停留，便于你查看输出结果。`exit /b` 中的 `/b` 参数很重要，没有它的话会直接关闭整个命令提示符窗口。

### 2.4 标题与颜色

```batch
@echo off
title 我的自动化脚本
REM 设置命令提示符窗口的标题

color 0A
REM 设置颜色：0 是黑色背景，A 是亮绿色前景
REM 颜色代码：0=黑 1=蓝 2=绿 3=青 4=红 5=紫 6=黄 7=白
REM 8-F 是对应颜色的亮色版本

echo 这是绿色文字
pause
color
REM 不带参数的 color 命令恢复默认颜色
```

------

## 第三章：变量系统

### 3.1 环境变量

环境变量是存储在系统中的命名值，批处理可以读取和修改它们。使用 `%变量名%` 的语法来引用变量的值。

```batch
@echo off
REM 显示一些常用的系统环境变量
echo 用户名：%USERNAME%
echo 计算机名：%COMPUTERNAME%
echo 用户主目录：%USERPROFILE%
echo 临时文件夹：%TEMP%
echo 系统目录：%SYSTEMROOT%
echo 当前目录：%CD%
echo 当前日期：%DATE%
echo 当前时间：%TIME%
echo 随机数（0-32767）：%RANDOM%
```

这些变量由系统预先定义，无需你创建即可使用。

### 3.2 自定义变量

使用 `set` 命令创建和修改变量。

```batch
@echo off
REM 创建变量（等号两边不能有空格）
set name=张三
set age=25

echo 姓名：%name%
echo 年龄：%age%

REM 变量值包含空格时不需要引号
set greeting=你好 世界
echo %greeting%

REM 但如果值的开头或结尾有空格需要注意
set "message=  前后有空格  "
echo [%message%]

REM 使用引号包围整个赋值语句是更安全的做法
set "path_backup=%PATH%"
```

等号两边绝对不能有空格，这是批处理中最常见的错误之一。`set name = 张三` 会创建一个名为 `name ` 的变量，其值为 ` 张三`。

### 3.3 数值运算

默认情况下，变量的值被视为字符串。要进行数学运算，需要使用 `set /a` 命令。

```batch
@echo off
set /a num1=10
set /a num2=3

set /a sum=num1+num2
set /a diff=num1-num2
set /a product=num1*num2
set /a quotient=num1/num2
set /a remainder=num1%%num2

echo %num1% + %num2% = %sum%
echo %num1% - %num2% = %diff%
echo %num1% * %num2% = %product%
echo %num1% / %num2% = %quotient%（整数除法）
echo %num1% %% %num2% = %remainder%（取余）

REM 注意：在批处理中，% 需要写成 %% 才能表示百分号本身

REM 复合运算
set /a "result=(num1+num2)*2"
echo 复合运算结果：%result%

REM 自增自减
set /a counter=0
set /a counter+=1
echo 计数器：%counter%

REM 位运算
set /a "bitwiseAnd=12&10"
set /a "bitwiseOr=12|10"
set /a "bitwiseXor=12^10"
echo 12 AND 10 = %bitwiseAnd%
echo 12 OR 10 = %bitwiseOr%
echo 12 XOR 10 = %bitwiseXor%
```

### 3.4 用户输入

使用 `set /p` 命令可以接收用户输入并存储到变量中。

```batch
@echo off
set /p username=请输入您的用户名：
set /p password=请输入密码：

echo.
echo 您输入的用户名是：%username%
echo 您输入的密码是：%password%

REM 带默认值的输入
set "choice=Y"
set /p choice=是否继续？(Y/N) [%choice%]：
echo 您的选择：%choice%
```

### 3.5 延迟变量扩展

这是批处理中一个重要但容易困惑的概念。正常情况下，变量的值在整个命令行被读取时就已经确定了。这在某些情况下会导致问题。

```batch
@echo off
set count=0

REM 问题演示：这个循环不会正确工作
for %%i in (1 2 3 4 5) do (
    set /a count+=1
    echo 当前计数：%count%
)
echo 最终计数：%count%
```

运行上面的代码，你会发现循环内的 `%count%` 始终显示 0，但最终计数却是 5。这是因为整个 `for` 语句在执行前，`%count%` 就已经被替换成了它当时的值（0）。

解决方案是启用延迟变量扩展，使用 `!变量名!` 语法：

```batch
@echo off
setlocal enabledelayedexpansion

set count=0

for %%i in (1 2 3 4 5) do (
    set /a count+=1
    echo 当前计数：!count!
)
echo 最终计数：%count%

endlocal
```

`setlocal enabledelayedexpansion` 开启延迟扩展模式，此后使用 `!变量名!` 可以获取变量的实时值，而非预先替换的值。`endlocal` 结束这个本地环境。

### 3.6 变量作用域

```batch
@echo off
set globalVar=我是全局变量

setlocal
set localVar=我是局部变量
echo 局部环境内：%globalVar%，%localVar%
endlocal

echo 局部环境外：%globalVar%，%localVar%
REM localVar 在 endlocal 后不再存在
```

`setlocal` 和 `endlocal` 创建一个局部环境，在其中对环境变量的修改不会影响到外部。这对于编写不干扰系统环境的脚本非常重要。

------

## 第四章：字符串处理

### 4.1 字符串截取

批处理提供了强大的字符串截取功能，使用 `%变量名:~起始位置,长度%` 语法。

```batch
@echo off
set str=Hello World

REM 从位置0开始取5个字符
echo %str:~0,5%
REM 输出：Hello

REM 从位置6开始取到末尾
echo %str:~6%
REM 输出：World

REM 取最后5个字符（负数从末尾计算）
echo %str:~-5%
REM 输出：World

REM 去掉最后3个字符
echo %str:~0,-3%
REM 输出：Hello Wo

REM 取倒数第5个到倒数第2个
echo %str:~-5,-2%
REM 输出：Wor
```

位置从 0 开始计算。负数表示从字符串末尾向前计算。

### 4.2 字符串替换

使用 `%变量名:原字符串=新字符串%` 语法进行替换。

```batch
@echo off
set str=Hello World World

REM 替换所有匹配项
echo %str:World=Universe%
REM 输出：Hello Universe Universe

REM 删除指定字符串（替换为空）
echo %str:World=%
REM 输出：Hello

REM 替换空格为下划线
set filename=my document file.txt
echo %filename: =_%
REM 输出：my_document_file.txt
```

### 4.3 字符串长度计算

批处理没有直接获取字符串长度的命令，但可以通过循环实现。

```batch
@echo off
setlocal enabledelayedexpansion

set "str=Hello World"
set len=0

:loop
if not "!str:~%len%,1!"=="" (
    set /a len+=1
    goto loop
)

echo 字符串 "%str%" 的长度是：%len%
```

这段代码通过逐个检查字符是否为空来计算长度。当 `!str:~%len%,1!` 返回空字符串时，说明已经到达字符串末尾。

------

## 第五章：流程控制

### 5.1 条件判断：if 语句

`if` 是批处理中最重要的条件判断命令。

```batch
@echo off
set /a num=10

REM 基本比较（字符串比较）
if "%num%"=="10" echo num 等于 10

REM 数值比较使用专门的比较运算符
REM EQU（等于）NEQ（不等于）LSS（小于）LEQ（小于等于）GTR（大于）GEQ（大于等于）
if %num% EQU 10 echo num 等于 10（数值比较）
if %num% GTR 5 echo num 大于 5
if %num% LEQ 15 echo num 小于等于 15

REM 否定条件
if not %num% EQU 20 echo num 不等于 20

REM 多条件（使用括号）
if %num% GEQ 5 (
    if %num% LEQ 15 (
        echo num 在 5 到 15 之间
    )
)

REM 带 else 的条件
if %num% GTR 100 (
    echo num 是个大数
) else (
    echo num 是个小数
)
```

### 5.2 文件和目录判断

```batch
@echo off

REM 检查文件是否存在
if exist "C:\Windows\notepad.exe" (
    echo 记事本程序存在
) else (
    echo 找不到记事本程序
)

REM 检查目录是否存在
if exist "C:\Windows\" (
    echo Windows 目录存在
)

REM 检查文件不存在
if not exist "C:\不存在的文件.txt" (
    echo 文件不存在
)

REM 检查变量是否已定义
set myVar=hello
if defined myVar echo myVar 已定义
if not defined undefinedVar echo undefinedVar 未定义
```

### 5.3 错误码判断

每个命令执行后都会设置一个错误码（ERRORLEVEL），通常 0 表示成功，非 0 表示失败。

```batch
@echo off

REM 执行一个命令
ping localhost -n 1 >nul

REM 检查错误码
if %ERRORLEVEL% EQU 0 (
    echo ping 成功
) else (
    echo ping 失败
)

REM 更简洁的写法
ping localhost -n 1 >nul && echo 成功 || echo 失败

REM && 表示前一个命令成功时执行
REM || 表示前一个命令失败时执行
```

### 5.4 跳转：goto 语句

`goto` 命令可以跳转到脚本中的指定标签位置。标签以冒号开头。

```batch
@echo off

set /p choice=请输入选项 (1/2/3)：

if "%choice%"=="1" goto option1
if "%choice%"=="2" goto option2
if "%choice%"=="3" goto option3
goto invalid

:option1
echo 您选择了选项 1
goto end

:option2
echo 您选择了选项 2
goto end

:option3
echo 您选择了选项 3
goto end

:invalid
echo 无效的选项

:end
echo 程序结束
pause
```

`goto :eof` 是一个特殊用法，它跳转到文件末尾，相当于结束脚本执行。

### 5.5 循环：for 语句

`for` 是批处理中功能最强大也最复杂的命令。

**遍历列表：**

```batch
@echo off
REM 遍历明确的值列表
for %%i in (苹果 香蕉 橙子 葡萄) do (
    echo 水果：%%i
)

REM 注意：在批处理文件中使用 %%，在命令行直接输入时使用 %
```

**遍历文件：**

```batch
@echo off
REM 遍历当前目录的所有 txt 文件
for %%f in (*.txt) do (
    echo 找到文件：%%f
)

REM 遍历指定目录
for %%f in (C:\Users\*.log) do (
    echo 日志文件：%%f
)
```

**数值循环：**

```batch
@echo off
REM for /l 用于数值循环：起始值,步长,结束值
for /l %%i in (1,1,10) do (
    echo 数字：%%i
)

REM 倒序循环
for /l %%i in (10,-1,1) do (
    echo 倒计时：%%i
)

REM 步长为2
for /l %%i in (0,2,10) do (
    echo 偶数：%%i
)
```

**遍历目录：**

```batch
@echo off
REM /d 开关用于遍历目录
for /d %%d in (C:\*) do (
    echo 目录：%%d
)

REM /r 开关用于递归遍历（包括子目录）
for /r C:\Users %%f in (*.txt) do (
    echo 找到：%%f
)
```

**解析文件内容：**

```batch
@echo off
REM /f 开关用于解析文件内容或命令输出

REM 逐行读取文件
for /f "tokens=*" %%line in (data.txt) do (
    echo %%line
)

REM 解析带分隔符的数据
REM tokens=1,2,3 表示取第1、2、3个字段
REM delims=, 表示以逗号为分隔符
for /f "tokens=1,2,3 delims=," %%a in (data.csv) do (
    echo 姓名：%%a，年龄：%%b，城市：%%c
)

REM 执行命令并处理输出
for /f "tokens=*" %%line in ('dir /b') do (
    echo 条目：%%line
)

REM usebackq 允许使用反引号执行命令，双引号引用文件名
for /f "usebackq tokens=*" %%line in (`ipconfig`) do (
    echo %%line
)
```

### 5.6 选择菜单：choice 命令

`choice` 命令提供了一种用户友好的选择界面。

```batch
@echo off
echo ================================
echo         主菜单
echo ================================
echo   1. 查看系统信息
echo   2. 查看网络配置
echo   3. 查看磁盘空间
echo   4. 退出
echo ================================

choice /c 1234 /n /m "请选择操作 [1-4]："

if %ERRORLEVEL% EQU 1 goto sysinfo
if %ERRORLEVEL% EQU 2 goto netinfo
if %ERRORLEVEL% EQU 3 goto diskinfo
if %ERRORLEVEL% EQU 4 goto quit

:sysinfo
systeminfo | findstr /c:"OS Name" /c:"System Type"
pause
goto :eof

:netinfo
ipconfig
pause
goto :eof

:diskinfo
wmic logicaldisk get caption,freespace,size
pause
goto :eof

:quit
echo 再见！
```

`choice /c 1234` 指定有效的按键选项，`/n` 隐藏选项列表，`/m` 指定提示消息。用户按键后，ERRORLEVEL 会被设置为对应选项的序号（从1开始）。

------

## 第六章：文件与目录操作

### 6.1 目录操作

```batch
@echo off

REM 显示当前目录
echo 当前目录：%CD%

REM 切换目录
cd C:\Users
echo 切换后：%CD%

REM 切换到上级目录
cd ..

REM 切换盘符（需要 /d 参数）
cd /d D:\Projects

REM 创建目录
mkdir NewFolder
md "带空格的文件夹"

REM 创建多级目录（自动创建父目录）
mkdir Parent\Child\GrandChild

REM 删除空目录
rmdir EmptyFolder
rd EmptyFolder

REM 删除非空目录（/s 递归删除，/q 安静模式不询问）
rmdir /s /q "要删除的目录"

REM 列出目录内容
dir
dir /b          REM 简洁格式
dir /s          REM 包含子目录
dir /a:d        REM 只显示目录
dir /a:h        REM 显示隐藏文件
dir /o:n        REM 按名称排序
dir /o:-s       REM 按大小倒序排序
```

### 6.2 文件操作

```batch
@echo off

REM 复制文件
copy source.txt destination.txt
copy source.txt D:\Backup\
copy *.txt D:\Backup\

REM 复制目录（使用 xcopy 或 robocopy）
xcopy SourceDir DestDir /e /i /h
REM /e 包括空目录，/i 如果目标不存在则创建，/h 包含隐藏文件

REM robocopy 是更现代更强大的工具
robocopy SourceDir DestDir /e /mir
REM /e 包括空目录，/mir 镜像模式（删除目标中源没有的文件）

REM 移动文件
move oldname.txt newname.txt
move file.txt D:\NewLocation\
move *.log D:\Logs\

REM 删除文件
del file.txt
del *.tmp
del /q *.bak        REM 安静模式不询问
del /f *.txt        REM 强制删除只读文件
del /s *.log        REM 递归删除子目录中的匹配文件

REM 重命名
ren oldname.txt newname.txt
rename "old file.txt" "new file.txt"

REM 显示文件内容
type file.txt

REM 创建空文件
type nul > newfile.txt
echo. > newfile.txt

REM 追加内容到文件
echo 这是追加的内容 >> file.txt
```

### 6.3 文件属性

```batch
@echo off

REM 查看文件属性
attrib file.txt

REM 设置只读属性
attrib +r file.txt

REM 移除只读属性
attrib -r file.txt

REM 设置隐藏属性
attrib +h file.txt

REM 属性说明：
REM R = 只读
REM H = 隐藏
REM S = 系统
REM A = 存档

REM 递归设置属性
attrib +r *.txt /s
```

### 6.4 文件路径处理

批处理提供了丰富的路径参数修饰符，用于提取路径的各个部分。

```batch
@echo off

REM 假设有一个完整路径
set filepath=C:\Users\John\Documents\report.txt

REM 使用 for 循环来演示各种修饰符
for %%f in ("%filepath%") do (
    echo 完整路径：%%f
    echo 驱动器：%%~df
    echo 路径（不含文件名）：%%~pf
    echo 文件名（不含扩展名）：%%~nf
    echo 扩展名：%%~xf
    echo 文件名+扩展名：%%~nxf
    echo 驱动器+路径：%%~dpf
    echo 短文件名格式：%%~sf
    echo 文件属性：%%~af
    echo 文件日期时间：%%~tf
    echo 文件大小：%%~zf
)
```

这些修饰符也可以用于脚本参数（%0, %1 等）：

```batch
@echo off
echo 脚本完整路径：%~f0
echo 脚本所在目录：%~dp0
echo 脚本名称：%~n0
```

------

## 第七章：输入输出与重定向

### 7.1 标准流

每个命令都有三个标准流：标准输入（stdin，编号0）、标准输出（stdout，编号1）、标准错误（stderr，编号2）。

```batch
@echo off

REM 重定向标准输出到文件（覆盖）
dir > output.txt

REM 重定向标准输出到文件（追加）
echo 追加的内容 >> output.txt

REM 重定向标准错误到文件
dir nonexistent 2> error.txt

REM 同时重定向标准输出和标准错误
dir 1> output.txt 2> error.txt

REM 将标准错误重定向到标准输出（合并）
dir 2>&1 > all_output.txt

REM 丢弃输出（重定向到 nul）
ping localhost > nul 2>&1
```

### 7.2 管道

管道符 `|` 将一个命令的输出传递给另一个命令作为输入。

```batch
@echo off

REM 列出目录内容并筛选
dir | findstr "txt"

REM 统计文件数量
dir /b | find /c /v ""

REM 排序输出
type names.txt | sort

REM 显示前10行
type largefile.txt | more

REM 链式管道
dir /b | findstr "log" | sort
```

### 7.3 findstr 命令

`findstr` 是批处理中的文本搜索工具，支持正则表达式。

```batch
@echo off

REM 简单搜索
findstr "error" log.txt

REM 忽略大小写
findstr /i "error" log.txt

REM 搜索多个字符串
findstr "error warning" log.txt

REM 使用正则表达式
findstr /r "^Error.*failed$" log.txt

REM 在多个文件中搜索
findstr "pattern" *.txt

REM 递归搜索
findstr /s "pattern" *.log

REM 显示行号
findstr /n "pattern" file.txt

REM 反向匹配（不包含模式的行）
findstr /v "debug" log.txt
```

------

## 第八章：函数与子程序

### 8.1 call 命令与标签

批处理通过 `call` 命令和标签来实现类似函数的功能。

```batch
@echo off

echo 主程序开始
call :sayHello 张三
call :sayHello 李四
call :add 10 20
echo 主程序结束
pause
goto :eof

:sayHello
echo 你好，%~1！
goto :eof

:add
set /a result=%~1+%~2
echo %~1 + %~2 = %result%
goto :eof
```

`%~1` 和 `%~2` 是传递给子程序的参数。波浪号 `~` 用于移除参数周围的引号。

### 8.2 返回值

批处理的"函数"可以通过变量或 ERRORLEVEL 返回值。

```batch
@echo off
setlocal enabledelayedexpansion

call :multiply 6 7 product
echo 6 x 7 = %product%

call :divide 20 3 quotient remainder
echo 20 / 3 = %quotient% 余 %remainder%

pause
goto :eof

:multiply
set /a %~3=%~1*%~2
goto :eof

:divide
set /a %~3=%~1/%~2
set /a %~4=%~1%%%~2
goto :eof
```

### 8.3 调用外部批处理

```batch
@echo off

REM 调用另一个批处理文件并返回继续执行
call another_script.bat
echo 已从 another_script.bat 返回

REM 带参数调用
call process_data.bat input.txt output.txt

REM 如果不使用 call，当前脚本会终止，不会返回
REM 直接写 another_script.bat 就不会返回
```

### 8.4 模块化示例

创建一个可复用的工具库：

**utils.bat（工具库）：**

```batch
@echo off
REM 这是一个工具库，不应直接运行
goto :eof

:log
echo [%DATE% %TIME%] %~1
echo [%DATE% %TIME%] %~1 >> log.txt
goto :eof

:confirm
set /p answer=%~1 (Y/N)：
if /i "%answer%"=="Y" exit /b 0
if /i "%answer%"=="y" exit /b 0
exit /b 1

:fileExists
if exist "%~1" exit /b 0
exit /b 1
```

**main.bat（主程序）：**

```batch
@echo off

call utils.bat :log "程序启动"

call utils.bat :confirm "是否继续"
if %ERRORLEVEL% EQU 0 (
    echo 用户选择继续
) else (
    echo 用户选择取消
    goto :eof
)

call utils.bat :fileExists "important.dat"
if %ERRORLEVEL% EQU 0 (
    call utils.bat :log "文件存在，开始处理"
) else (
    call utils.bat :log "文件不存在"
)
```

------

## 第九章：错误处理与调试

### 9.1 错误检测

```batch
@echo off

REM 检查命令是否成功
copy source.txt dest.txt
if %ERRORLEVEL% NEQ 0 (
    echo 复制失败！
    exit /b 1
)

REM 使用 && 和 || 运算符
copy source.txt dest.txt && echo 复制成功 || echo 复制失败

REM 连续命令的错误检查
copy file1.txt backup\ && (
    copy file2.txt backup\ && (
        echo 所有文件复制成功
    ) || (
        echo file2 复制失败
    )
) || (
    echo file1 复制失败
)
```

### 9.2 错误处理模式

```batch
@echo off
setlocal

set errorCount=0

call :safeOperation "copy file1.txt backup\"
call :safeOperation "copy file2.txt backup\"
call :safeOperation "copy file3.txt backup\"

if %errorCount% GTR 0 (
    echo 警告：有 %errorCount% 个操作失败
)

goto :eof

:safeOperation
echo 执行：%~1
%~1
if %ERRORLEVEL% NEQ 0 (
    echo 错误：%~1 失败
    set /a errorCount+=1
)
goto :eof
```

### 9.3 调试技术

```batch
@echo off

REM 开启命令回显来调试
REM @echo on

REM 显示变量值
set myVar=hello
echo DEBUG: myVar=%myVar%

REM 暂停在特定位置
echo DEBUG: 即将执行关键操作
pause

REM 记录到日志文件
echo [%DATE% %TIME%] 脚本启动 >> debug.log
echo [%DATE% %TIME%] 变量 myVar=%myVar% >> debug.log

REM 使用 verify 命令检查扩展是否正确
verify >nul
echo ERRORLEVEL after verify: %ERRORLEVEL%

REM 条件性调试输出
set DEBUG=1
if defined DEBUG echo DEBUG: 当前处于调试模式
```

### 9.4 try-catch 模式

虽然批处理没有真正的异常处理，但可以模拟：

```batch
@echo off
setlocal

call :try
goto :eof

:try
echo 尝试执行操作...
copy nonexistent.txt dest.txt 2>nul
if %ERRORLEVEL% NEQ 0 call :catch "文件复制失败"
echo 继续执行...
goto :eof

:catch
echo 捕获错误：%~1
echo 执行恢复操作...
goto :eof
```

------

## 第十章：实用技巧与高级特性

### 10.1 参数处理

```batch
@echo off

REM 脚本参数：%0 是脚本自身，%1-%9 是传入的参数
echo 脚本名：%0
echo 第一个参数：%1
echo 第二个参数：%2
echo 所有参数：%*

REM 参数修饰符
echo 参数（去除引号）：%~1
echo 参数（完整路径）：%~f1
echo 参数（只取文件名）：%~n1

REM 检查参数是否提供
if "%~1"=="" (
    echo 用法：%~n0 ^<参数1^> [参数2]
    exit /b 1
)

REM 处理超过9个参数：使用 shift 命令
:loop
if "%~1"=="" goto :done
echo 处理参数：%~1
shift
goto :loop

:done
echo 所有参数处理完毕
```

### 10.2 临时文件处理

```batch
@echo off
setlocal

REM 创建唯一的临时文件名
set "tempfile=%TEMP%\myapp_%RANDOM%.tmp"

REM 写入临时文件
echo 临时数据 > "%tempfile%"

REM 使用临时文件
type "%tempfile%"

REM 清理临时文件
del "%tempfile%" 2>nul

REM 确保退出时清理（使用标签）
goto :main

:cleanup
if exist "%tempfile%" del "%tempfile%"
goto :eof

:main
REM 主程序逻辑
echo 程序执行中...
call :cleanup
```

### 10.3 日期时间处理

```batch
@echo off
setlocal

REM 获取当前日期和时间
echo 当前日期：%DATE%
echo 当前时间：%TIME%

REM 格式化日期（注意：格式因系统区域设置而异）
REM 假设格式为 YYYY/MM/DD
for /f "tokens=1-3 delims=/" %%a in ("%DATE%") do (
    set year=%%a
    set month=%%b
    set day=%%c
)
echo 年：%year%，月：%month%，日：%day%

REM 创建带时间戳的备份文件名
set timestamp=%DATE:/=-%_%TIME::=-%
set timestamp=%timestamp: =0%
set timestamp=%timestamp:,=.%
echo 时间戳：%timestamp%

REM 使用 wmic 获取标准格式日期时间（更可靠）
for /f %%i in ('wmic os get localdatetime ^| findstr [0-9]') do set dt=%%i
set YYYY=%dt:~0,4%
set MM=%dt:~4,2%
set DD=%dt:~6,2%
set HH=%dt:~8,2%
set Min=%dt:~10,2%
set Sec=%dt:~12,2%
echo 标准格式：%YYYY%-%MM%-%DD% %HH%:%Min%:%Sec%
```

### 10.4 注册表操作

```batch
@echo off

REM 查询注册表值
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion" /v ProductName

REM 添加注册表项
reg add "HKCU\Software\MyApp" /v Setting1 /t REG_SZ /d "Value1" /f

REM 修改注册表值
reg add "HKCU\Software\MyApp" /v Setting1 /t REG_SZ /d "NewValue" /f

REM 删除注册表值
reg delete "HKCU\Software\MyApp" /v Setting1 /f

REM 删除注册表项
reg delete "HKCU\Software\MyApp" /f

REM 导出注册表
reg export "HKCU\Software\MyApp" backup.reg

REM 导入注册表
reg import backup.reg
```

### 10.5 网络操作

```batch
@echo off

REM 测试网络连接
ping -n 1 www.example.com >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo 网络连接正常
) else (
    echo 网络不可用
)

REM 下载文件（使用 curl，Windows 10 及以上内置）
curl -o downloaded.txt https://example.com/file.txt

REM 使用 certutil 下载（较老系统）
certutil -urlcache -split -f "https://example.com/file.txt" downloaded.txt

REM 使用 PowerShell 下载（兼容性更好）
powershell -Command "Invoke-WebRequest -Uri 'https://example.com/file.txt' -OutFile 'downloaded.txt'"

REM 查看网络配置
ipconfig /all

REM 刷新 DNS
ipconfig /flushdns

REM 查看端口占用
netstat -ano | findstr :80
```

### 10.6 服务管理

```batch
@echo off

REM 查看服务状态
sc query "服务名"

REM 启动服务
net start "服务名"

REM 停止服务
net stop "服务名"

REM 设置服务启动类型
sc config "服务名" start= auto
sc config "服务名" start= demand
sc config "服务名" start= disabled

REM 创建服务
sc create "MyService" binpath= "C:\path\to\service.exe"

REM 删除服务
sc delete "MyService"
```

### 10.7 计划任务

```batch
@echo off

REM 创建计划任务
schtasks /create /tn "MyTask" /tr "C:\Scripts\backup.bat" /sc daily /st 09:00

REM 运行计划任务
schtasks /run /tn "MyTask"

REM 查看任务状态
schtasks /query /tn "MyTask"

REM 修改任务
schtasks /change /tn "MyTask" /st 10:00

REM 删除任务
schtasks /delete /tn "MyTask" /f
```

------

## 第十一章：完整项目示例

### 11.1 自动备份脚本

```batch
@echo off
setlocal enabledelayedexpansion

REM ==========================================
REM 自动备份脚本
REM 功能：备份指定目录到备份位置，保留最近N个备份
REM ==========================================

REM 配置
set "SOURCE=C:\ImportantData"
set "BACKUP_ROOT=D:\Backups"
set "MAX_BACKUPS=7"
set "LOG_FILE=%BACKUP_ROOT%\backup.log"

REM 检查源目录是否存在
if not exist "%SOURCE%" (
    echo 错误：源目录不存在 - %SOURCE%
    exit /b 1
)

REM 创建备份根目录
if not exist "%BACKUP_ROOT%" mkdir "%BACKUP_ROOT%"

REM 生成时间戳
for /f %%i in ('wmic os get localdatetime ^| findstr [0-9]') do set dt=%%i
set "TIMESTAMP=%dt:~0,8%_%dt:~8,6%"
set "BACKUP_DIR=%BACKUP_ROOT%\backup_%TIMESTAMP%"

REM 记录日志
call :log "=========================================="
call :log "备份开始：%DATE% %TIME%"
call :log "源目录：%SOURCE%"
call :log "目标目录：%BACKUP_DIR%"

REM 执行备份
call :log "正在复制文件..."
robocopy "%SOURCE%" "%BACKUP_DIR%" /e /r:3 /w:5 /np /ndl /nfl
set COPY_RESULT=%ERRORLEVEL%

if %COPY_RESULT% LSS 8 (
    call :log "备份成功完成"
) else (
    call :log "备份过程中出现错误，错误码：%COPY_RESULT%"
)

REM 清理旧备份
call :log "正在清理旧备份..."
set count=0
for /f "delims=" %%d in ('dir /b /ad /o-n "%BACKUP_ROOT%\backup_*" 2^>nul') do (
    set /a count+=1
    if !count! GTR %MAX_BACKUPS% (
        call :log "删除旧备份：%%d"
        rmdir /s /q "%BACKUP_ROOT%\%%d"
    )
)

call :log "备份任务完成"
call :log "==========================================
"

exit /b 0

:log
echo %~1
echo [%DATE% %TIME%] %~1 >> "%LOG_FILE%"
goto :eof
```

### 11.2 系统信息收集脚本

```batch
@echo off
setlocal enabledelayedexpansion

REM ==========================================
REM 系统信息收集脚本
REM 生成详细的系统报告
REM ==========================================

set "REPORT_FILE=%USERPROFILE%\Desktop\SystemReport_%COMPUTERNAME%.txt"

echo 正在收集系统信息，请稍候...

(
    echo ==========================================
    echo 系统信息报告
    echo 生成时间：%DATE% %TIME%
    echo 计算机名：%COMPUTERNAME%
    echo ==========================================
    echo.
    
    echo [操作系统信息]
    echo ------------------------------------------
    systeminfo | findstr /c:"OS Name" /c:"OS Version" /c:"System Type" /c:"Total Physical Memory"
    echo.
    
    echo [处理器信息]
    echo ------------------------------------------
    wmic cpu get name,numberofcores,maxclockspeed /format:list
    echo.
    
    echo [内存信息]
    echo ------------------------------------------
    wmic memorychip get capacity,manufacturer,speed /format:list
    echo.
    
    echo [磁盘信息]
    echo ------------------------------------------
    wmic logicaldisk get caption,description,filesystem,freespace,size /format:table
    echo.
    
    echo [网络配置]
    echo ------------------------------------------
    ipconfig /all
    echo.
    
    echo [已安装程序（部分）]
    echo ------------------------------------------
    wmic product get name,version 2^>nul | findstr /v "^$"
    echo.
    
    echo [启动项]
    echo ------------------------------------------
    wmic startup get caption,command
    echo.
    
    echo [运行中的服务]
    echo ------------------------------------------
    sc query state= running | findstr "SERVICE_NAME DISPLAY_NAME"
    echo.
    
    echo ==========================================
    echo 报告结束
    echo ==========================================
) > "%REPORT_FILE%"

echo 报告已保存到：%REPORT_FILE%
notepad "%REPORT_FILE%"
```

### 11.3 批量文件重命名工具

```batch
@echo off
setlocal enabledelayedexpansion

REM ==========================================
REM 批量文件重命名工具
REM ==========================================

:menu
cls
echo ==========================================
echo         批量文件重命名工具
echo ==========================================
echo.
echo   1. 添加前缀
echo   2. 添加后缀（扩展名前）
echo   3. 替换文本
echo   4. 添加序号
echo   5. 转换大小写
echo   6. 退出
echo.
echo ==========================================

choice /c 123456 /n /m "请选择操作 [1-6]："

if %ERRORLEVEL% EQU 1 goto addPrefix
if %ERRORLEVEL% EQU 2 goto addSuffix
if %ERRORLEVEL% EQU 3 goto replaceText
if %ERRORLEVEL% EQU 4 goto addNumber
if %ERRORLEVEL% EQU 5 goto changeCase
if %ERRORLEVEL% EQU 6 goto :eof

:addPrefix
set /p "folder=请输入目录路径："
set /p "pattern=请输入文件模式（如 *.txt）："
set /p "prefix=请输入前缀："

for %%f in ("%folder%\%pattern%") do (
    set "filename=%%~nxf"
    ren "%%f" "%prefix%!filename!"
    echo 重命名：%%~nxf -^> %prefix%!filename!
)
pause
goto menu

:addSuffix
set /p "folder=请输入目录路径："
set /p "pattern=请输入文件模式（如 *.txt）："
set /p "suffix=请输入后缀："

for %%f in ("%folder%\%pattern%") do (
    set "name=%%~nf"
    set "ext=%%~xf"
    ren "%%f" "!name!%suffix%!ext!"
    echo 重命名：%%~nxf -^> !name!%suffix%!ext!
)
pause
goto menu

:replaceText
set /p "folder=请输入目录路径："
set /p "pattern=请输入文件模式（如 *.txt）："
set /p "oldtext=请输入要替换的文本："
set /p "newtext=请输入替换后的文本："

for %%f in ("%folder%\%pattern%") do (
    set "filename=%%~nxf"
    set "newname=!filename:%oldtext%=%newtext%!"
    if not "!filename!"=="!newname!" (
        ren "%%f" "!newname!"
        echo 重命名：!filename! -^> !newname!
    )
)
pause
goto menu

:addNumber
set /p "folder=请输入目录路径："
set /p "pattern=请输入文件模式（如 *.jpg）："
set /p "basename=请输入基础名称："
set "counter=1"

for %%f in ("%folder%\%pattern%") do (
    set "ext=%%~xf"
    set "num=00!counter!"
    set "num=!num:~-3!"
    ren "%%f" "%basename%_!num!!ext!"
    echo 重命名：%%~nxf -^> %basename%_!num!!ext!
    set /a counter+=1
)
pause
goto menu

:changeCase
set /p "folder=请输入目录路径："
set /p "pattern=请输入文件模式（如 *.*）："
echo 1. 转换为小写
echo 2. 转换为大写
choice /c 12 /n /m "请选择 [1-2]："
set caseChoice=%ERRORLEVEL%

for %%f in ("%folder%\%pattern%") do (
    set "filename=%%~nxf"
    if !caseChoice! EQU 1 (
        for %%c in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
            set "filename=!filename:%%c=%%c!"
        )
    ) else (
        REM 大写转换需要更复杂的处理，这里简化处理
        echo 大写转换功能开发中...
    )
    echo 处理：%%~nxf
)
pause
goto menu
```

### 11.4 开发环境快速切换工具

```batch
@echo off
setlocal enabledelayedexpansion

REM ==========================================
REM 开发环境切换工具
REM 快速切换不同版本的开发工具
REM ==========================================

:menu
cls
echo ==========================================
echo       开发环境切换工具
echo ==========================================
echo.
echo   当前 JAVA_HOME: %JAVA_HOME%
echo   当前 Python: 
python --version 2>nul || echo 未安装
echo.
echo ==========================================
echo   1. 切换 Java 版本
echo   2. 切换 Node.js 版本
echo   3. 切换 Python 版本
echo   4. 查看当前环境
echo   5. 打开新的命令行窗口
echo   6. 退出
echo ==========================================

choice /c 123456 /n /m "请选择操作 [1-6]："

if %ERRORLEVEL% EQU 1 goto switchJava
if %ERRORLEVEL% EQU 2 goto switchNode
if %ERRORLEVEL% EQU 3 goto switchPython
if %ERRORLEVEL% EQU 4 goto showEnv
if %ERRORLEVEL% EQU 5 goto newWindow
if %ERRORLEVEL% EQU 6 goto :eof

:switchJava
cls
echo 可用的 Java 版本：
echo   1. Java 8  (C:\Program Files\Java\jdk1.8.0)
echo   2. Java 11 (C:\Program Files\Java\jdk-11)
echo   3. Java 17 (C:\Program Files\Java\jdk-17)
echo   4. Java 21 (C:\Program Files\Java\jdk-21)
echo   5. 返回主菜单

choice /c 12345 /n /m "请选择 Java 版本 [1-5]："

if %ERRORLEVEL% EQU 1 set "JAVA_HOME=C:\Program Files\Java\jdk1.8.0"
if %ERRORLEVEL% EQU 2 set "JAVA_HOME=C:\Program Files\Java\jdk-11"
if %ERRORLEVEL% EQU 3 set "JAVA_HOME=C:\Program Files\Java\jdk-17"
if %ERRORLEVEL% EQU 4 set "JAVA_HOME=C:\Program Files\Java\jdk-21"
if %ERRORLEVEL% EQU 5 goto menu

if %ERRORLEVEL% LSS 5 (
    setx JAVA_HOME "%JAVA_HOME%" >nul
    set "PATH=%JAVA_HOME%\bin;%PATH%"
    echo.
    echo Java 已切换到：%JAVA_HOME%
    java -version
    pause
)
goto menu

:switchNode
cls
echo 使用 nvm 切换 Node.js 版本...
echo 可用版本：
nvm list
echo.
set /p "nodeVer=请输入要切换的版本："
nvm use %nodeVer%
pause
goto menu

:switchPython
cls
echo 可用的 Python 版本：
where python
echo.
echo 请使用 py 启动器选择版本：
echo   py -2 script.py  (Python 2)
echo   py -3 script.py  (Python 3)
echo   py -3.10 script.py  (特定版本)
pause
goto menu

:showEnv
cls
echo ==========================================
echo 当前开发环境配置
echo ==========================================
echo.
echo [Java]
echo JAVA_HOME: %JAVA_HOME%
java -version 2>&1
echo.
echo [Node.js]
node --version 2>nul || echo 未安装
npm --version 2>nul && echo NPM 已安装
echo.
echo [Python]
python --version 2>nul || echo 未安装
pip --version 2>nul && echo PIP 已安装
echo.
echo [Git]
git --version 2>nul || echo 未安装
echo.
pause
goto menu

:newWindow
start cmd /k "echo 新的开发环境窗口 && echo JAVA_HOME=%JAVA_HOME%"
goto menu
```

------

## 第十二章：最佳实践与注意事项

### 12.1 编码规范

良好的编码规范能让你的脚本更易读、易维护。脚本开头应包含说明注释，描述脚本的用途、作者、创建日期和修改历史。变量命名要有意义，避免使用单个字母（循环变量除外）。使用一致的缩进，推荐使用4个空格。将可配置的参数放在脚本开头，便于修改。复杂的逻辑应该封装成子程序，每个子程序只做一件事。

### 12.2 安全性考虑

永远不要在脚本中硬编码密码或敏感信息。如果需要处理用户输入，要验证输入的合法性。使用 `"%variable%"` 而非 `%variable%` 来防止空值或特殊字符导致的问题。在删除文件或目录之前，先确认路径正确，最好先用 `echo` 输出要执行的命令进行检查。运行涉及系统修改的脚本前，先在测试环境验证。

### 12.3 性能优化

减少不必要的命令调用，特别是在循环中。使用 `>nul 2>&1` 来丢弃不需要的输出，避免屏幕刷新开销。对于大量文件操作，优先使用 `robocopy` 而非 `copy`。在循环中处理变量时，启用延迟变量扩展而非嵌套调用。避免在循环中重复读取相同的文件或执行相同的命令，可以将结果存储在变量中。

### 12.4 与 PowerShell 的互操作

现代 Windows 管理中，批处理和 PowerShell 经常需要协同工作。

```batch
@echo off
REM 在批处理中调用 PowerShell 命令
powershell -Command "Get-Process | Where-Object {$_.CPU -gt 100}"

REM 调用 PowerShell 脚本
powershell -ExecutionPolicy Bypass -File "script.ps1"

REM 获取 PowerShell 命令的输出
for /f "delims=" %%i in ('powershell -Command "(Get-Date).ToString('yyyy-MM-dd')"') do set today=%%i
echo 今天是：%today%

REM 传递参数给 PowerShell
set name=World
powershell -Command "Write-Host 'Hello, %name%!'"
```

### 12.5 常见陷阱

变量赋值时等号两边不能有空格，这是最常见的错误。在 `for` 循环和 `if` 语句的括号内使用变量时，需要延迟变量扩展。`%` 符号在批处理中有特殊含义，要表示百分号本身需要写成 `%%`。文件路径中包含空格时，必须用引号包围。`goto :eof` 中的冒号不能省略。比较字符串时，建议两边都加引号以处理空值情况。`if` 语句的括号必须紧跟在条件后面，不能换行。

------

## 结语

批处理虽然是一门古老的脚本语言，但它在 Windows 系统管理和自动化领域仍然发挥着重要作用。通过本指南的学习，你应该已经掌握了从基础到高级的批处理技术。继续实践和探索，你会发现批处理能够帮助你完成许多日常任务，显著提高工作效率。

当批处理的功能不足以满足需求时，可以考虑学习 PowerShell，它提供了更强大的编程能力和更丰富的系统管理功能。但对于简单任务和需要最大兼容性的场景，批处理仍然是可靠的选择。