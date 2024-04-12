[toc] 

# 命令行@setx环境变量配置@永久配置

## references

- [Setting Windows PowerShell environment variables - Stack Overflow](https://stackoverflow.com/questions/714877/setting-windows-powershell-environment-variables)
- [saving-changes-to-environment-variables/about Environment Variables - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_environment_variables?view=powershell-7.2#saving-changes-to-environment-variables)
- [setx | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/setx)

- On Windows, there are three methods for making `a persistent change` to `an environment variable:` 
  1. setting them in your profile, (仅限从powershell中使用)
  2. using the **SetEnvironmentVariable** method,(此处介绍的方法)
  3. using the System Control Panel.(传统方法)

## 环境变量

- 通常,环境变量可以细分为
  - 系统环境变量
  - 用户环境变量
- 如果您的计算机只是个人使用,那么通常使用**用户环境变量**已经足够了,并且相关配置在使用命令行的时候不需要进入到管理模式就可以执行
- 但是如果您的计算机包含多个用户,并且希望所有用户都能够用一些共同的环境变量配置,则需要配置**系统环境变量**
- 由于系统环境变量更加具体,所以用户环境变量的值会覆盖掉系统环境变量中的同名变量

### 补充

- 在Windows操作系统中，系统环境变量是所有用户共享的环境变量，用户环境变量是每个用户私有的环境变量。具体来说：

  - 系统环境变量：是在Windows操作系统启动时就加载的环境变量，对所有用户和所有进程都可见。可以在控制面板的“系统”窗口中设置系统环境变量，或者在注册表中的“`HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment`”键下设置系统环境变量。
  - 用户环境变量：是每个用户私有的环境变量，只对该用户可见。可以在控制面板的“用户账户”窗口中设置用户环境变量，或者在注册表中的“`HKEY_CURRENT_USER\Environment`”键下设置用户环境变量。

  系统环境变量和用户环境变量都是用来存储系统配置和用户配置的参数信息，例如PATH、TEMP等变量。在编程和系统管理中，常常需要读取和修改这些环境变量的值，以便正确地配置系统和程序。

#### HKLM

- "HKLM"代表的是Windows操作系统注册表中的"HKEY_LOCAL_MACHINE"主键，是一个系统范围内的注册表分支，包含了计算机硬件和系统软件的配置信息。

- 其下包含了众多子项和键值，用于存储系统、硬件和软件的配置信息。

  在"HKLM"下的子项包括：

  - HARDWARE：包含了计算机硬件信息；
  - SAM：包含了Windows安全账户管理器信息；
  - SECURITY：包含了Windows安全信息；
  - SOFTWARE：包含了计算机上已安装的所有软件的配置信息；
  - SYSTEM：包含了Windows操作系统的配置信息。

  "HKLM"是Windows操作系统注册表中的一个重要部分，包含了大量的系统配置信息，因此一般不建议用户随意修改或删除其中的信息。如果需要修改或删除"HKLM"中的信息，建议先备份注册表，以免操作失误导致系统故障。

## 列出或查找环境变量值👺

- 另见他文

### 使用reg命令查看

- 例如:

- ```python
   reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH
  ```

- 在windows上,任何长期有效配置环境变量的方式都需要直接或间接操作注册表

- 只不过有些工具简化了相关流程

## SETX版👺

- 可以在cmd或者powershell中执行setx命令
  - 该命令是windows自带的,可以放便的配置环境变量(用户变量和系统变量)

### set和setx

- `set` 和 `setx` 都是 Windows 系统中用于设置环境变量的命令。

  `set` 命令用于设置当前会话的环境变量。这些变量只在当前命令提示符窗口中有效，当你关闭这个窗口后，这些变量也就失效了。

  示例：假设你需要将 `C:\myfolder` 添加到系统的 Path 环境变量中，你可以使用以下命令：

  ```
  Copy Codeset PATH=%PATH%;C:\myfolder
  ```

  注意，此命令只对当前命令提示符窗口有效，如果你打开新的命令提示符窗口，这个环境变量就不存在了。

  `setx` 命令用于设置永久的环境变量，它会将环境变量写入到用户或者系统的注册表中，因此即使你关闭当前命令提示符窗口，这些环境变量仍然存在。

  示例：要将 `C:\myfolder` 添加到系统的 Path 环境变量中，你可以使用以下命令：

  ```
  Copy Codesetx PATH "%PATH%;C:\myfolder"
  ```

  注意，使用 `setx` 命令设置的环境变量不会立即生效，你必须重新启动命令提示符窗口或者注销并重新登录用户账户才能生效。

### 配置用户级环境变量@local environment

- ```cmd
  PS D:\repos\blogs> setx MACHINE Brand1
  
  SUCCESS: Specified value was saved.
  ```

- 配置当前用户,不需要管理员权限就行

### 配置系统级环境变量@ system environment

- ```cmd
  PS D:\repos\blogs> setx MACHINE "Brand1 Computer" /m
  
  SUCCESS: Specified value was saved.
  ```

  - 该操作需要管理员模式
  - 如果某个名字有空格,使用引号包裹起来

### 引用系统变量中的Path变量

- To set the *MYPATH* environment variable in the local environment to use the search <u>path defined in the *PATH* environment variable</u>, type:

- ```cmd
  PS D:\repos\blogs> setx MYPATH %PATH%
  
  SUCCESS: Specified value was saved.
  ```

### 为环境变量追加新值

- ```cmd
  PS D:\repos\configs\env> setx PYTHONPATH "C:\new_path_demo;$env:PYTHONPATH"
  
  SUCCESS: Specified value was saved.
  ```

- 这个命令有风险!(但如果您要修改的变量本身不长,则可以考虑使用该方法)

#### Note@Warning

- 然而,这个命令似乎不是很适合追加新的值到系统Path变量中,容易遇到字符数超过的问题

  - ```cmd
    PS D:\repos\configs\env> setx /M PATH  "$env:path;value_by_setx"
    
    WARNING: The data being saved is truncated to 1024 characters.
    
    SUCCESS: Specified value was saved.
    ```

  - 这个动作可能导致你的环境变量丢失,因为新的值如果超过1024字节,超过部分就会丢失

- 您可以尝试其他命令行工具,或者使用下面的powershell版本

## powershell版

- 另见它文

## 总结

- 配置新变量和单值变量可以考虑用`setx`方案,但是不适合配置变量值很长的情况,例如不适合用来配置`PATH`变量,因为它的取值通常是包括各种各样的目录,容易因为过长而被截断,造成数据丢失
- powershell版本的更适合用来追加新值到`path`中

