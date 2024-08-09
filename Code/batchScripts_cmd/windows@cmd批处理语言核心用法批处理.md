[toc]





## 创建脚本文件的方法

- 脚本文件是一个文本文件,创建或获取一个脚本文件的方式有许多
  - 自己新建一个文本文件,然后用文本编辑器(比如基础的自带的记事本notepad),打开并编辑这个文本,最后将这个文件改名,尤其是扩展名(后缀)修改为脚本文件后缀名,对于cmd脚本,可以修改为`.cmd`或者`.bat`,如果是powershell脚本,那么后缀为`.ps1`(这里不讨论)
  - 从网络上下载脚本到本地运行,例如github上开源的脚本文件,具有特定的功能

## 创建第一个简单的脚本

让我们从一个简单的例子开始。假设您需要一个脚本来列出当前目录下的所有文件。您可以创建一个名为`list_files.cmd`的文件，并在其中输入以下内容：

```batch
@echo off
dir
pause
```

- `@echo off`：这条命令会关闭命令的回显，即不会显示接下来要执行的命令。
- `dir`：这条命令会列出当前目录下的所有文件和子目录。

保存文件后，在命令行中切换到该文件所在的目录，并运行：

```batch
list_files.cmd
```

您应该能看到当前目录下所有的文件和子目录被列出来了。

## 基础概念

### 变量

CMD脚本支持变量，您可以使用它们来存储和引用数据。变量有两种类型：环境变量和脚本变量。

#### 环境变量

环境变量是在整个系统范围内定义的，可以通过`set`命令查看：

例如

```batch
C:\Users\cxxu\Desktop>set
ALLUSERSPROFILE=C:\ProgramData
APPDATA=C:\Users\cxxu\AppData\Roaming
CommonProgramFiles=C:\Program Files\Common Files
CommonProgramFiles(x86)=C:\Program Files (x86)\Common Files
CommonProgramW6432=C:\Program Files\Common Files
...
```

#### 脚本变量

脚本变量是在脚本内部定义的，只能在脚本执行期间使用。定义变量的方式如下：

```batch
set variable_name=value
```

使用变量的方式如下(加上一对`%`号：

```batch
echo %variable_name%
```

例如：

```batch
set myVar=Hello, World!
echo %myVar%
```

和powershell等其他脚本或变成语言不通,cmd中设置带空格字符串的变量不需要用引号包裹

### 条件判断

CMD脚本支持基本的条件判断结构，可以使用`if`命令来进行逻辑判断。


#### 1. `IF` 语句

`IF` 语句用于判断某个条件是否为真。如果条件为真，则执行相应的命令。

```
IF condition (command)
```

##### 例子：

```cmd
IF %USERNAME%==admin echo Hello Admin
```

#### 2. `IF NOT` 语句

`IF NOT` 用于判断条件是否为假。如果条件为假，则执行相应的命令。

```
IF NOT condition (command)
```

##### 例子：

```cmd
IF NOT %USERNAME%==admin echo You are not an admin
```

#### 3. `IF EXIST` 和 `IF NOT EXIST` 语句

`IF EXIST` 用于判断某个文件或目录是否存在。如果存在，则执行相应的命令。`IF NOT EXIST` 则相反，用于判断文件或目录是否不存在。

```
IF EXIST filename (command)
IF NOT EXIST filename (command)
```

##### 例子：

```cmd
IF EXIST C:\test.txt echo File exists
IF NOT EXIST C:\test.txt echo File does not exist
```

### 高级用法

#### 1. 复杂条件判断

可以使用逻辑运算符（如 `AND` 和 `OR`）来组合多个条件。

##### 例子：

```cmd
IF %USERNAME%==admin IF EXIST C:\test.txt echo Admin and file exists
```

#### 2. 使用变量进行条件判断

可以使用环境变量进行条件判断。

##### 例子：

```cmd
SET var=1
IF %var%==1 echo Variable is 1
```

#### 3. `IF` 语句中的 ELSE

可以在 `IF` 语句中使用 `ELSE` 来处理条件不成立的情况。

##### 例子：

```cmd
IF %USERNAME%==admin (
    echo Hello Admin
) ELSE (
    echo You are not an admin
)
```

### 示例总结

以下是一个综合使用条件判断的示例脚本：

```cmd
@echo off
SET var=2

IF %var%==1 (
    echo Variable is 1
) ELSE IF %var%==2 (
    echo Variable is 2
) ELSE (
    echo Variable is not 1 or 2
)

IF EXIST C:\test.txt (
    echo File exists
) ELSE (
    echo File does not exist
)

IF %USERNAME%==admin (
    echo Hello Admin
) ELSE (
    echo You are not an admin
)
```

这个示例展示了如何使用 `IF` 和 `IF EXIST` 进行条件判断，并结合 `ELSE` 语句处理不同的情况。通过这些条件判断，CMD 脚本可以变得更加灵活和强大。

### 循环结构

CMD脚本支持两种循环结构：`for`循环和`while`循环。

#### `for`循环

`for`循环可以用来遍历一系列的项或执行特定次数的命令。

#### 示例

打印出从1到10的数字：

```batch
@echo off
for /L %%i in (1,1,10) do (
    echo %%i
)
```

#### `while`循环

`while`循环会在满足某个条件时重复执行一组命令。

#### 示例

使用`while`循环来打印数字1到5：

```batch
@echo off
set i=1
:loop
if %i% leq 5 (
    echo %i%
    set /a i+=1
    goto :loop
)
```

## 实战案例

现在我们来编写一个稍微复杂一点的脚本，这个脚本可以帮助我们备份指定文件夹下的所有文件到另一个位置。

### 脚本代码

```batch
@echo off
setlocal enabledelayedexpansion

set "sourceFolder=C:\Users\YourName\Documents"
set "backupFolder=C:\Backup\Documents"

if not exist "!backupFolder!" mkdir "!backupFolder!"

echo Backing up files from !sourceFolder! to !backupFolder!...

xcopy "!sourceFolder!\*" "!backupFolder!" /s /e /y

echo Backup complete.
pause
```

### 解释

- `setlocal enabledelayedexpansion`：启用延迟变量扩展，允许在循环中使用变量。
- `set "sourceFolder=C:\Users\YourName\Documents"`：设置源文件夹。
- `set "backupFolder=C:\Backup\Documents"`：设置备份文件夹。
- `if not exist "!backupFolder!" mkdir "!backupFolder!"`：如果备份文件夹不存在，则创建它。
- `xcopy "!sourceFolder!\*" "!backupFolder!" /s /e /y`：复制文件夹及其内容到备份文件夹，覆盖已存在的文件。
- `pause`：暂停脚本，等待用户按任意键退出。

## 总结

通过这篇文章，您已经学习了CMD脚本的基础知识，包括如何创建简单的脚本、使用变量、条件判断和循环结构。掌握了这些基础之后，您可以尝试编写更复杂的脚本来解决实际问题。CMD脚本虽然简单，但在自动化日常任务方面却非常实用。







### 2. 基础命令
以下是一些常用的基础命令，它们构成了批处理文件的基本操作。

- **echo**: 显示消息或打开/关闭命令回显。
  ```batch
  echo Hello, World!
  ```
  *解释*: `echo` 命令用于在控制台输出文本。如果关闭回显（`@echo off`），批处理文件运行时就不会显示命令本身。

- **pause**: 暂停批处理文件的执行，并显示“Press any key to continue...”提示。
  ```batch
  pause
  ```
  *解释*: `pause` 命令在等待用户按下任意键后才会继续执行后续命令。

- **cls**: 清除屏幕上的内容。
  ```batch
  cls
  ```
  *解释*: `cls` 命令用于清屏，使控制台窗口变得干净。

- **rem**: 添加注释。
  ```batch
  rem This is a comment
  ```
  *解释*: `rem` 命令用于在批处理文件中添加注释，注释内容不会被执行。

### 3. 变量与参数
批处理文件中，变量和参数用于存储和传递信息。

- **定义变量**: 使用 `set` 命令。
  ```batch
  set name=John
  echo %name%
  ```
  *解释*: `set` 命令定义一个变量并赋值，使用 `%变量名%` 访问变量值。

- **读取参数**: 使用 `%1`、`%2` 等访问传递给批处理文件的参数。
  ```batch
  @echo off
  echo First parameter: %1
  echo Second parameter: %2
  ```
  *解释*: 运行批处理文件时传入的参数可以用 `%1`、`%2` 等访问，第一个参数是 `%1`，第二个是 `%2`，以此类推。

### 4. 流程控制
批处理文件支持条件语句和循环等基本的流程控制结构。

- **if 语句**:
  ```batch
  @echo off
  set /p answer=Are you sure? (yes/no): 
  if "%answer%"=="yes" (
      echo You answered yes.
  ) else (
      echo You answered no.
  )
  ```
  *解释*: `if` 语句根据条件执行不同的代码块。`set /p` 命令用于提示用户输入并将输入值赋给变量。

- **for 循环**:
  ```batch
  @echo off
  for %%i in (1 2 3) do (
      echo Loop iteration %%i
  )
  ```
  *解释*: `for` 循环遍历指定的集合，每次迭代执行括号内的命令。`%%i` 是循环变量。

### 5. 实用示例
通过实用的例子帮助新手理解批处理文件的实际应用。

#### 5.1 批量重命名文件
```batch
@echo off
setlocal enabledelayedexpansion
set /p prefix=Enter the prefix: 
set count=1
for %%f in (*.txt) do (
    ren "%%f" "!prefix!_!count!.txt"
    set /a count+=1
)
endlocal
```
*解释*: 该脚本重命名当前目录下的所有 `.txt` 文件，加上用户输入的前缀和编号。`setlocal enabledelayedexpansion` 允许在循环中使用 `!变量名!` 动态引用变量。

#### 5.2 备份文件夹
```batch
@echo off
set /p source=Enter the source folder: 
set /p destination=Enter the destination folder: 
xcopy "%source%" "%destination%" /s /e /h /i /y
```
*解释*: 该脚本使用 `xcopy` 命令递归地复制源文件夹及其子文件夹到目标文件夹。`/s /e /h /i /y` 是 `xcopy` 命令的选项，用于控制复制行为。

#### 5.3 计算文件行数
```batch
@echo off
setlocal enabledelayedexpansion
set /p filename=Enter the file name: 
set lines=0
for /f "delims=" %%i in (%filename%) do (
    set /a lines+=1
)
echo Total lines: %lines%
endlocal
```
*解释*: 该脚本计算指定文件中的行数。`for /f` 读取文件的每一行，并使用 `set /a` 增加行数计数器。

### 6. 进阶内容
介绍一些进阶内容，如错误处理、调试技巧等。

- **错误处理**:
  ```batch
  @echo off
  xcopy "%source%" "%destination%" /s /e /h /i /y
  if %errorlevel% neq 0 (
      echo An error occurred.
  )
  ```
  *解释*: `errorlevel` 是一个系统变量，表示上一个命令的退出状态码。`if %errorlevel% neq 0` 检查 `xcopy` 命令是否执行成功。

- **调试技巧**:
  ```batch
  @echo off
  setlocal enabledelayedexpansion
  set "var=hello"
  echo Value of var: !var!
  endlocal
  ```
  *解释*: `setlocal enabledelayedexpansion` 允许在脚本中使用 `!变量名!` 进行延迟变量扩展，便于调试变量值。

### 7. 结语
批处理文件在自动化任务和系统管理中非常有用。通过实践和深入学习，您可以编写出功能强大的脚本，提高工作效率。

---

### 总结表格

以下表格总结了批处理文件中的核心内容：

| 内容类别   | 命令/示例                                       | 解释                                   |
| ---------- | ----------------------------------------------- | -------------------------------------- |
| 基础命令   | `echo`、`pause`、`cls`、`rem`                   | 显示信息、暂停执行、清屏、添加注释     |
| 变量与参数 | `set name=John`、`echo %name%`、`%1`            | 定义和使用变量，读取传入参数           |
| 流程控制   | `if "%answer%"=="yes"`、`for %%i in ()`         | 条件语句和循环结构                     |
| 实用示例   | 批量重命名文件、备份文件夹、计算行数            | 实际应用案例，展示批处理文件的强大功能 |
| 进阶内容   | `errorlevel`、`setlocal enabledelayedexpansion` | 错误处理和调试技巧                     |

