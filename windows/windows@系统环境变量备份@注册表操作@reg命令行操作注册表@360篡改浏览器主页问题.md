[toc]

# windows@系统环境变量备份@注册表操作@reg命令行操作注册表@360篡改浏览器主页问题.md

##  备份注册表🎈

- 完整的注册表备份可能达到`500MB`
- 打开register editor
  - 命令行里可以输入`regedit.exe`打开
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/569b8de064d74d2991cdddd29d017c81.png)
- 可以局部备份

### 备份环境变量@powershell函数

- ```bash
  function backupEnvs_regeditPrintPath
  {
      param (
          $file="$configs\env\$name_with_ticks"
      )
      # Write-Output $env:envRegedit "`\ncontent has been set to clipborad😊"
      # Set-Clipboard $env:envRegedit
      # regedit.exe
  
      $name_with_ticks = "env_reg_$((gdt).Ticks).reg"
      reg export 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' $file
      Write-Output 'Done!🎈'
      Get-Content $file -Head 5
      
  }
  ```

  - 根据实际情况改变它,主要的语句是`  reg export 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' $file`
  - 其中`$file`是保存备份文件的目录,建议后缀设置为`.reg`
  - 上述脚本中,将保存的文件名加入了`时间戳`后缀为`reg`

### 从注册表文件还原

- 双击您备份的文件,回车还原即可.

## 命令行操作注册表

- 注册表操作是一个危险操作(不恰当的修改容易导致系统崩溃)
  - 因此,当您确实需要编辑注册表的时候,一定要先备份
  - 备份特定注册表内容可以通过命令行进行(读取/备份操作是安全的,危险在于删除和修改)

- [reg commands | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/reg)
  -  Caution:Don't edit the registry directly unless you have no alternative. The registry editor bypasses standard safeguards, allowing settings that can degrade performance, damage your system, or even require you to reinstall Windows. You can safely alter most registry settings by using the programs in Control Panel or Microsoft Management Console (MMC). If you must edit the registry directly, back it up first.
  - 官方建议,编辑注册表应该使用windows提供的GUI程序
  - 但是为了高效配置,熟悉相关操作的用户可以用命令行来配置,便于部署环境

### 查询某个注册表

- ```
  PS C:\repos\blogs> reg add /?
  
  REG ADD KeyName [/v ValueName | /ve] [/t Type] [/s Separator] [/d Data] [/f]
          [/reg:32 | /reg:64]
  
    KeyName  [\\Machine\]FullKey
             Machine  远程机器名 - 忽略默认到当前机器。远程机器上
                      只有 HKLM 和 HKU 可用。
             FullKey  ROOTKEY\SubKey
             ROOTKEY  [ HKLM | HKCU | HKCR | HKU | HKCC ]
             SubKey   所选 ROOTKEY 下注册表项的完整名称。
  
    /v       所选项之下要添加的值名称。
  
    /ve      为注册表项添加空白值名称(默认)。
  
    /t       RegKey 数据类型
             [ REG_SZ    | REG_MULTI_SZ | REG_EXPAND_SZ |
               REG_DWORD | REG_QWORD    | REG_BINARY    | REG_NONE ]
             如果忽略，则采用 REG_SZ。
  
    /s       指定一个在 REG_MULTI_SZ 数据字符串中用作分隔符的字符
             如果忽略，则将 "\0" 用作分隔符。
  
    /d       要分配给添加的注册表 ValueName 的数据。
  
    /f       不用提示就强行覆盖现有注册表项。
  
   /reg:32  指定应该使用 32 位注册表视图访问的注册表项。
  
   /reg:64  指定应该使用 64 位注册表视图访问的注册表项。
  
  例如:
  
    REG ADD \\ABC\HKLM\Software\MyCo
      添加远程机器 ABC 上的一个注册表项 HKLM\Software\MyCo
  
    REG ADD HKLM\Software\MyCo /v Data /t REG_BINARY /d fe340ead
      添加一个值(名称: Data，类型: REG_BINARY，数据: fe340ead)
  
    REG ADD HKLM\Software\MyCo /v MRU /t REG_MULTI_SZ /d fax\0mail
      添加一个值(名称: MRU，类型: REG_MULTI_SZ，数据: fax\0mail\0\0)
  
    REG ADD HKLM\Software\MyCo /v Path /t REG_EXPAND_SZ /d ^%systemroot^%
      添加一个值(名称: Path，类型: REG_EXPAND_SZ，数据: %systemroot%)
  ```

#### 例

- ```
  PS C:\repos\blogs> reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters /v  BasicAuthLevel
  
  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters
      BasicAuthLevel    REG_DWORD    0x2
  ```



### 更新某个key

- 下面这个例子试图修改注册表中指定了限制系统环境变量`Path`的值(value)的的长度(或者说,将限制放宽为32000个字符)

- 首先,您需要使用管理员方式打开`cmd`或者`powershell`

- 如果目标明确,执行类似以下操作的命令

  - ```bash
    PS C:\repos\blogs> reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters /v  BasicAuthLevel /t REG_DWORD /d 2
    值 BasicAuthLevel 已存在，要覆盖吗(Yes/No)? yes
    操作成功完成。
    ```

- 推荐的流程

- 方案1:

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

    

## 360篡改浏览器主页

- 如果您使用360,且不想卸载它,那么当你启动360后,它可能会篡改你的浏览器(比如edge)的主页`start page`为360
- 早期可能是通过修改快捷方式的`target`等属性,但是现在变得更加隐蔽,至少修改了注册表!
- 我们借助[Registry Finder (registry-finder.com)](https://registry-finder.com/)来查找注册表中得`hao.360`相关字段,可以发现4个路径得`start page`被默认修改为`hao.360.com`
- 一个推荐的方式是打开360:功能大全->**主页防护**->解锁所有浏览器->更改主页(比如空白页或者自己喜欢的主页)->一键锁定

### 注册表修改

- 这个方法不是很彻底,在360启动的时候修改将无法进行,而且在360运行起见,打开edge依然会被定向到`hao.360.com`

- 但是如果您已经将360卸载,那么可以这么作

- 用**管理员权限**打开powershell

- ```powershell
  $items=@("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main",
  "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Main",
  "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Main",
  "HKEY_USERS\S-1-5-21-1862010897-3831421347-3551306287-1001\Software\Microsoft\Internet Explorer\Main")
  
  $items|%{reg query $_ /v 'start page'}
  
  
  
  ```

- 上述内容输入powershell回车,如果看到形如:

  - ```bash
    PS C:\Users\cxxu\Desktop> $items|%{reg query $_ /v 'start page'}
    
    HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main
        start page    REG_SZ    https://hao.360.com
    
    
    HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Main
        start page    REG_SZ    https://hao.360.com
    
    
    HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Main
        start page    REG_SZ    https://hao.360.com
    
    
    HKEY_USERS\S-1-5-21-1862010897-3831421347-3551306287-1001\Software\Microsoft\Internet Explorer\Main
        start page    REG_SZ    https://hao.360.com
    ```

  - 这正说明您的计算机浏览器主页被篡改为`hao.360.com`

- 删除这些注册表:

  - ```powershell
    $items|%{reg delete $_ /v 'start page'}
    ```

    - ```
      PS C:\Users\cxxu\Desktop> $items|%{reg delete $_ /v 'start page'}
      Delete the registry value start page (Yes/No)? y
      The operation completed successfully.
      Delete the registry value start page (Yes/No)? y
      The operation completed successfully.
      Delete the registry value start page (Yes/No)? y
      The operation completed successfully.
      Delete the registry value start page (Yes/No)? y
      ```

- 注意,如果采用此方法,此时您再次打开360,主页依然受360控制,除非360已经卸载,才推荐使用该方法

## 例

### 移除edge策略组

- ```bash
  PS C:\Users\cxxu\Desktop> reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge
  Permanently delete the registry key HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge (Yes/No)? yes
  The operation completed successfully.
  ```

- 这里操作的KeyName是`HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge`;前面不要带`Computer`(直接从注册表编辑器中复制的路径是`Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge`,这不被命令行识别)





