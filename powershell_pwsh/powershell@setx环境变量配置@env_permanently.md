[toc] 

# powershell@setx环境变量配置@env_permanently

## references

- [Setting Windows PowerShell environment variables - Stack Overflow](https://stackoverflow.com/questions/714877/setting-windows-powershell-environment-variables)
- [saving-changes-to-environment-variables/about Environment Variables - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_environment_variables?view=powershell-7.2#saving-changes-to-environment-variables)
- [setx | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/setx)

- On Windows, there are three methods for making `a persistent change` to `an environment variable:` 
  1. setting them in your profile, (仅限从powershell中使用)
  2. using the **SetEnvironmentVariable** method,(此处介绍的方法)
  3. using the System Control Panel.(传统方法)

## SETX版

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

### 操作效果

- ![](https://img-blog.csdnimg.cn/img_convert/b59482b62b0fa722cfe9085eae37c66c.png)

### powershell函数代码

- 可以将两个函数一同写入到powershell配置文件$profile中.(这里不讨论此基础问题)

#### 检测当前执行环境是否具有管理员权限(administrator privilege)

```powershell
function isAdministratorPrivilege
{
    if (!([Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544'))
    {

        Write-Output '😊current powershell run without administrator privilege!;请手动打开管理模式的terminal.'
        return
    }
}
```



```powershell
function envAdder
{
    <# 
    .synopsis
    add a value to a specified environment variable
    often, the most  useful variable is `Path`;
    and the most often operation is add value to the Path 
    ;
    if the target value is no exist yet, then the function will try to create the corresponding variable for you!
    本函数既可以为已有的环境变量添加新值,也可以增加一对全新啊的变量=值对;
    但此时这里会前置一个分号(不影响使用),如果有需要清除,可以稍微加一个判断在函数里来完善逻辑
    .example
    envAdder -target_env path -new_value tester1112
    #>
    param(
        $target_env = 'path',
        $new_value,
        $scope_opt = 'Machine'
    )
    # 检测当前是具有管理员权限,如果没有,要求用户使用管理员方式打开,(随之抛出一个错误!)
    isAdministratorPrivilege
    #精心调试过
    $updated_value = "$(Invoke-Expression("`$env:$target_env"));" + "$new_value"
    # $update_value -split ';'#可以用来分行查看结果
    # Write-Output $updated_value
    [Environment]::SetEnvironmentVariable( $target_env, $updated_value, $scope_opt)
}
```

### 使用注意:

- 操作完成后,需要在全新的终端中才可以使用命令行看到效果
  - 当然,您可以通过临时添加的方式让环境立刻生效(下次启动就能够载入刚才永久修改/添加的值了)
- 如果使用GUI,则执行成功后就可以查看啦

## 总结

- 配置新变量和单值变量可以考虑用`setx`方案
- powershell版本的更适合用来追加新值到`path`中

