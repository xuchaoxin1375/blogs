[toc] 

# powershell_edit_env_permanently 利用powershell来永久修改环境变量

## references

- [Setting Windows PowerShell environment variables - Stack Overflow](https://stackoverflow.com/questions/714877/setting-windows-powershell-environment-variables)
- [saving-changes-to-environment-variables/about Environment Variables - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_environment_variables?view=powershell-7.2#saving-changes-to-environment-variables)

> - On Windows, there are three methods for making `a persistent change` to `an environment variable:` 
>   - setting them in your profile, (仅限从powershell中使用)
>   - using the **SetEnvironmentVariable** method, (此处介绍的方法)
>   - using the System Control Panel.(传统方法)

### 操作效果

![](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220427195501743.png)

### powershell函数代码

> 可以将两个函数一同写入到powershell配置文件$profile中.(这里不讨论次基础问题)

#### 检测当前执行环境是否具有管理员权限(administrator privilege)

```powershell
function isAdministratorPrivilege
{
    if (!([Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544'))
    {

        Write-Output '🤣😂😊current powershell run without administrator privilege!;请手动打开管理模式的terminal.'
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

