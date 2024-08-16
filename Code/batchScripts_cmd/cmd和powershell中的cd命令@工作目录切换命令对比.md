[toc]

## abstract

[cd | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/cd)

[Set-Location (Microsoft.PowerShell.Management) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.management/set-location?view=powershell-7.4)

在 PowerShell 中，`cd` 命令和传统的命令提示符 (CMD) 中的 `cd` 命令在功能上非常相似，但也有一些关键的差异和增强功能。



### 1. **基本用法**
在两种环境中，`cd` 命令都用于显示当前目录或更改当前工作目录。

#### CMD 

- `cd` 用于更改目录或显示当前目录。
- 支持 `/D` 参数，用于在更改目录的同时切换驱动器。

- 文档

  - ```cmd
    D:\exes> cd /?
    显示当前目录名或改变当前目录。
    
    CHDIR [/D] [drive:][path]
    CHDIR [..]
    CD [/D] [drive:][path]
    CD [..]
    
      ..   指定要改成父目录。
    
    键入 CD drive: 显示指定驱动器中的当前目录。
    不带参数只键入 CD，则显示当前驱动器和目录。
    
    使用 /D 开关，除了改变驱动器的当前目录之外，
    还可改变当前驱动器。
    
    如果命令扩展被启用，CHDIR 会如下改变:
    
    当前的目录字符串会被转换成使用磁盘名上的大小写。所以，
    如果磁盘上的大小写如此，CD C:\TEMP 会将当前目录设为
    C:\Temp。
    
    CHDIR 命令不把空格当作分隔符，因此有可能将目录名改为一个
    带有空格但不带有引号的子目录名。例如:
    
         cd \winnt\profiles\username\programs\start menu
    
    与下列相同:
    
         cd "\winnt\profiles\username\programs\start menu"
    
    在扩展停用的情况下，你必须键入以上命令。
    ```

    

  示例：
  ```cmd
  cd C:\Windows
  cd /D D:\Projects
  ```

#### PowerShell

- `cd` 是 `Set-Location` cmdlet 的别名，用于更改目录。
- 没有 `/D` 参数，因为 PowerShell 自动处理驱动器切换。

示例：
```powershell
cd C:\Windows
cd D:\Projects
```

### 2. **驱动器切换**

- **CMD**:
  - 使用 `/D` 参数来同时切换驱动器和更改目录。
  - 如果不使用 `/D` 参数，则只能更改当前驱动器的目录。
  
  示例：
  ```cmd
  cd /D D:\Projects  # 切换到 D: 驱动器并更改目录
  ```

- **PowerShell**:
  - 无需额外参数，`cd` 自动处理驱动器切换。当你输入一个完整路径时（包括驱动器号），PowerShell 自动切换到相应驱动器。
  
  示例：
  ```powershell
  cd D:\Projects  # 直接切换到 D: 驱动器并更改目录
  ```

### 3. **路径处理**

- **CMD**:
  - 需要显式处理带有空格的路径，通常需要用引号包裹路径。
  - 命令扩展启用时，`cd` 命令可以处理不带引号的空格路径。
  
  示例：
  ```cmd
  cd "C:\Program Files"
  ```

- **PowerShell**:
  - PowerShell 默认可以处理带空格的路径，使用引号或不使用引号都可以。
  
  示例：
  ```powershell
  cd C:\Program Files
  cd "C:\Program Files"
  ```

### 4. **目录切换的增强功能**

- **PowerShell**:
  - PowerShell 支持更多类型的“位置”或“驱动器”，例如注册表 (`HKLM:`)、证书存储 (`Cert:`)、环境变量 (`Env:`) 等。这些位置在 `cd` 操作中与文件系统目录同样对待。
  - 你可以使用 `cd` 命令切换到这些非文件系统的位置。
  
  示例：
  ```powershell
  cd HKLM:\Software  # 切换到注册表中的位置
  cd Env:            # 切换到环境变量驱动器
  ```

- **CMD**:
  - CMD 只支持文件系统路径的目录切换，无法直接导航到其他类型的位置。

### 5. 返回上一个目录@返回父目录

注意返回上一个目录和返回父母路不一样

- **CMD**:
  - 不支持放回上一个目录的功能

- **PowerShell**:
  - PowerShell 提供 `cd -` 功能，可以快速返回上一个访问的目录。
  
  示例：
  ```powershell
  cd C:\Windows
  cd D:\Projects
  cd -  # 返回到 C:\Windows
  ```

- 返回父目录,两种shell都可以通过`cd ..`实现

### 6. **别名和扩展支持**

- **CMD**:
  - `cd` 和 `chdir` 是等效的命令。
  - 支持命令扩展来处理大小写转换和路径中的空格。
  
- **PowerShell**:
  - `cd` 是 `Set-Location` 的别名。
  - PowerShell 提供强大的管道和脚本支持，可以轻松将 `cd` 命令嵌入到更复杂的命令和脚本中。

## 总结👺

| 功能               | CMD `cd`                 | PowerShell `cd`                 |
| ------------------ | ------------------------ | ------------------------------- |
| **驱动器切换**     | 需要 `/D` 参数           | 自动处理                        |
| **路径处理**       | 需要引号包裹空格路径     | 自动处理空格路径                |
| **非文件系统路径** | 不支持                   | 支持 (注册表、证书、环境变量等) |
| **返回上一个目录** | 不支持                   | `cd -` 可返回上一个目录         |
| **命令扩展**       | 支持处理大小写和空格路径 | 自动处理，支持复杂脚本          |

PowerShell 的 `cd` 命令比 CMD 的 `cd` 命令更强大和灵活，尤其是在处理不同类型的驱动器、路径自动化、以及脚本集成方面。

## 补充

- `cmd`上的`cd`切换目录不是那么好用,可以大致`cd /d`和powershell的`cd`等价(仅限于文件系统上跳转目录时,后者强大和灵活得多)

- cmd的`/d`选项出了改变**驱动器的当前目录**之外，还可改变**当前驱动器**。例如要从C盘的某个路径切换到D盘的某个路径,就需要`/d`,否则当前工作目录无法跨驱动器改变

- `cmd`的`cd` 的`/d`选项必须跟在`cd`命令后面,也就是说`cd <path> /d`这种语句会报错,必须形如`cd /d <path>`(开关`/d`不能随意摆放)

- 我们举一个例子来说明

  ```cmd
  #当前目录为D:\exe,我执行cd C:\users,此时cmd的当前目录不会跳转到C盘的C:\users,因为没有用/d选项
  #但是这条命令没有作用,首先cmd记住了,你要C盘上标记了路径C:\users,这可以通过执行cd C:来查看C盘上的哪个路径被标记了
  D:\exes>cd C:\users
  
  D:\exes>cd C:
  C:\Users
  #通过cd /d来跳转盘符,这里跳转到C:盘,但是可以发现,路径切换到了C:\users,而不是C:\的根目录,因为之前我们通过cd C:\users命令做了标记,所以下次跳转C:盘时会跳转到标记的目录,而不是根目录
  #注意,cd /d C:\结尾如果带上`\`那么会覆盖前面的标记,目录将会切换到C:\(根目录)
  D:\exes>cd /d C:
  
  C:\Users>
  ```

  