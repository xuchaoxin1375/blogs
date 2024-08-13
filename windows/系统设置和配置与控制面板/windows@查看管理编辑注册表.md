[toc]





## 命令行操作注册表

- 注册表操作是一个危险操作(不恰当的修改容易导致系统崩溃)
  - 因此,当您确实需要编辑注册表的时候,一定要先备份
  - 备份特定注册表内容可以通过命令行进行(读取/备份操作是安全的,危险在于删除和修改)

- [reg commands | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/reg)
  -  Caution:Don't edit the registry directly unless you have no alternative. The registry editor bypasses standard safeguards, allowing settings that can degrade performance, damage your system, or even require you to reinstall Windows. You can safely alter most registry settings by using the programs in Control Panel or Microsoft Management Console (MMC). If you must edit the registry directly, back it up first.
  -  官方建议,编辑注册表应该使用windows提供的GUI程序
  -  但是为了高效配置,熟悉相关操作的用户可以用命令行来配置,便于部署环境



## 更新某个key👺

- 下面这个例子试图修改注册表中指定了限制系统环境变量`Path`的值(value)的的长度(或者说,将限制放宽为32000个字符)




### 推荐的流程

#### 方案1:

- ```bash
  #检查特定的key是否存在以及原来的值是多少:
  PS C:\Users\cxxu\Desktop> reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled
  
  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem
      LongPathsEnabled    REG_DWORD    0x0
     
  #确定无误后,开始修改
  #修改的第一步是删除掉该条目(但是这不是必须的!)
  PS C:\Users\cxxu\Desktop> reg delete HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled
  Delete the registry value LongPathsEnabled (Yes/No)? yes
  The operation completed successfully.
  
  #开始设置新的值
  PS C:\Users\cxxu\Desktop> reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled /t REG_DWORD /d 1
  The operation completed successfully.
  
  #再次查询该条目,确认修改后的值
  PS C:\Users\cxxu\Desktop> reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled
  
  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem
      LongPathsEnabled    REG_DWORD    0x1
  
  PS C:\Users\cxxu\Desktop>
  ```

#### 方案2:

- 另一种操作思路(覆盖)

  - ```bash
    #查询
    PS C:\Users\cxxu\Desktop> reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled
    
    HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem
        LongPathsEnabled    REG_DWORD    0x1
        
    #尝试直接使用reg add覆盖已有的值
    PS C:\Users\cxxu\Desktop> reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled /t REG_DWORD /d 0
    Value LongPathsEnabled exists, overwrite(Yes/No)? y
    The operation completed successfully.
    
    #再次查询修改结果
    PS C:\Users\cxxu\Desktop> reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled
    
    HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem
        LongPathsEnabled    REG_DWORD    0x0
    
    ```

### 允许http链接映射为磁盘驱动器

- 下面的操作将是的windows能够将http链接映射为驱动器

- 首先,您需要使用管理员方式打开`cmd`或者`powershell`

- 如果目标明确,执行类似以下操作的命令

  - `reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters /v  BasicAuthLevel /t REG_DWORD /d 2`

  - ```bash
    PS C:\repos\blogs> reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters /v  BasicAuthLevel /t REG_DWORD /d 2
    
    值 BasicAuthLevel 已存在，要覆盖吗(Yes/No)? yes
    操作成功完成。
    ```

