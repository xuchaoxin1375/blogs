[toc]

## abstract



- windows@系统环境变量备份@注册表操作
- reg命令行操作注册表
- 360篡改浏览器主页问题.md

##  备份注册表🎈

- 完整的注册表备份可能达到`500MB`
- 打开register editor
  - 命令行里可以输入`regedit.exe`打开
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/569b8de064d74d2991cdddd29d017c81.png)
- 可以局部备份

## 备份环境变量



##  方法1：方便导入回去的备份方法：

You can use RegEdit to export the following two keys:

```HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment```

`HKEY_CURRENT_USER\Environment`



##  方法2：便于人类阅读的形式

在任意windows终端(cmd或者powershell中执行以下任意一个方案,查看所有环境变量)

```powershell
#如果是在一个已有的cmd窗口中执行set命令,输出的可能不仅仅是环境变量,可能还包含自定义的临时变量
cmd /c set
```

```powershell
powershell -c ls Env:\
```

可以分别将上述输出重定向到指定文件中作为备份(但是这种格式的备份比价笼统,不便于区分用户环境变量和系统环境变量)



## 使用命令行或脚本方式导出

有两类方式备份环境变量

### 注册表reg 导出

利用`reg export`备份,通过双击导出的`.reg`文件来导入环境变量

#### 导出

仅演示系统级环境变量的导出

- ```bash
  function Backup-EnvsRegistry
  {
      <# 
      .SYNOPSIS
      备份环境变量
      .DESCRIPTION
      通过导出相关注册表的方式来备份系统环境变量
      用户环境变量也可以类似的备份,但是用户的注册表是区分用户的而且用户id并不直观,例如
          Computer\HKEY_USERS\S-1-5-21-1150093504-2233723087-916622917-1001\Environment
          这个用户id在我试验的时候对应的是cxxu这个用户名
          如果确实有需要,可以在注册表regedit.exe中搜索用户环境变量独有的关键词(可以打开系统环境变量界面或者使用命令行查看当前用户设置的的环境变量,例如执行:[System.Environment]::GetEnvironmentVariables('User')
          )
      而系统级别的环境变量会相对好识别,HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
      也可以用命令行 [System.Environment]::GetEnvironmentVariables('Machine')查看
      #>
      param (
          $Dir=''
      )
      # Write-Verbose $env:envRegedit "`\ncontent has been set to clipborad😊"
      # Set-Clipboard $env:envRegedit
      # regedit.exe
      # 备份文件名字带有时间戳，方便我们辨别不同的备份时期（虽然我们有git备份天然具有时间属性信息，但是文件名上带有时间会更加直观）
      Update-PwshEnvIfNotYet -Mode Vars
      $fileName = "env_reg_$(Get-DateTimeNumber).reg"
      if($Dir -eq ''){
  
          $file = "$configs\env\$fileName"
      }else{
          $file="$Dir\$fileName"
      }
      
      reg export 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' $file
      Write-Verbose 'Done!🎈'
      Get-Content $file -Head 5
      
  }
  ```
  

#### 从注册表文件导入

- 双击您备份的文件,回车还原即可.



### 使用.Net API备份和导入👺

- 下面的两个函数无法直接调用,但是包含了关键逻辑
- 可以通过仓库获取内部调用但是未列出的函数
  - [modulesByCxxu/backup/backup.psm1 · xuchaoxin1375/scripts - Gitee.com](https://gitee.com/xuchaoxin1375/scripts/blob/main/modulesByCxxu/backup/backup.psm1)
  - [modulesByCxxu/deploy/deploy.psm1 · xuchaoxin1375/scripts - Gitee.com](https://gitee.com/xuchaoxin1375/scripts/blob/main/modulesByCxxu/deploy/deploy.psm1)

- 下载上述模块直接使用相关函数

#### 环境变量CSV文件

```powershell

function Backup-EnvsByPwsh
{
    [CmdletBinding()]
    param(
        # 备份用户环境变量和系统环境变量选项,使用All表示都备份
        [validateset('User', 'Machine', 'All')]$Scope = 'All',
        # 将备份的环境变量文件保存到指定目录下
        $Directory = ''

    )
    <# 
    .SYNOPSIS
    备份用户环境变量和系统环境变量
    #>
    # 检查powershell 环境变量
    Update-PwshEnvIfNotYet
    
    # 配置环境变量文件保存目录目录
    if (!$Directory)
    {
        $Directory = "$configs\env"
    }
    function getEnvs
    {
        param (
            #直接访问外部函数的参数不够灵活
            $Scope 
            # $Directory
        )
        $EnvVars = [System.Environment]::GetEnvironmentVariables($Scope)
        $EnvVars = $EnvVars.GetEnumerator() | Select-Object Name, Value
        # 设置备份的数据文件名字的格式
        $EnvVarsPath = "$Directory\${Scope}@$(Get-Date -Format 'yyyy-MM-dd--HH-mm-ss').csv"
        Write-Host "Files will be saved in : $EnvVarsPath"
        # 将数据保存成csv格式的文件中
        $EnvVars | Export-Csv $EnvVarsPath
        # 查看保存结果
        # Write-Verbose $EnvVars
        if ($VerbosePreference)
        {
            # Write-Host $EnvVars
            $EnvVars
        }
    }
    # 备份环境变量
    if ($Scope -eq 'All')
    {

        getEnvs -Scope 'User'
        getEnvs -Scope 'Machine'
    }
    else
    {
        # 单次调用
        getEnvs -Scope $Scope
    }
    
}
```

#### 从CSV文件导入环境变量@清空或覆盖现有环境变量

如果您使用上面的`Backup-EnvsByPwsh`备份环境变量,那么可以使用以下函数进行导入

```powershell

function Deploy-EnvsByPwsh
{
    <# 
    .SYNOPSIS
    将Backup-EnvsByPwsh备份的环境变量导入到系统环境变量中
    .DESCRIPTION
    .EXAMPLE
    #查看试验素材
    PS[BAT:76%][MEM:41.92% (13.29/31.70)GB][20:55:58]
    # [C:\repos\configs\env]
    ls *csv

            Directory: C:\repos\configs\env


    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    -a---         2024/4/20     20:36           1289 󰈛  system202404203647.csv
    -a---         2024/4/20     20:36            890 󰈛  user202404203647.csv
    -a---         2024/4/20     20:51             30 󰈛  userDemo.csv
    #导入到系统中持久化
    PS[BAT:76%][MEM:41.65% (13.20/31.70)GB][20:51:52]
    # [C:\repos\configs\env]
    deploy-EnvsByPwsh -SourceFile .\userDemo.csv -Scope 'User'
    .EXAMPLE
    PS[BAT:76%][MEM:42.02% (13.32/31.70)GB][20:54:01]
    # [~]
    deploy-EnvsByPwsh -SourceFile C:\repos\configs\env\user202404203647.csv -Scope 'User'
    .EXAMPLE
    PS[BAT:76%][MEM:42.19% (13.38/31.70)GB][20:54:50]
    # [~]
    deploy-EnvsByPwsh -SourceFile C:\repos\configs\env\system202404203647.csv -Scope 'Machine'
    #>
    param (
        # 指定要导入的备份文件
        $SourceFile,
        # 写入到用户环境变量还是系统环境变量
        [parameter(Mandatory = $true)]
        [ValidateSet('User', 'Machine')]$Scope,
        # 是否清除环境变量(由Scope指定的作用于)
        [switch]$Clear,
        # 使用指定的备份文件覆盖现有的的环境变量(如果已经存在相应的环境变量)
        [switch]$Replace
    )
    # 从备份文件中读取数据
    $items = Import-Csv $SourceFile 
    # 将读取的数据(是一个可迭代容器)遍历

    # 如果用户使用了-Clear参数,则清除原来的系统环境变量(这是一个高度危险的操作,执行前请做好备份)
    if ($Clear)
    {
        Backup-EnvsByPwsh -Scope $Scope -Directory $home/desktop #用户清空前默认备份一份存放到桌面
        Clear-EnvVar -Scope $Scope
    }
    foreach ($item in $items)
    {
        
        # 采用增量模式来导入环境变量在通常情况下是比较合适的
        $exist = Get-EnvVar -Key $item.Name -Scope $Scope
        if (!$exist)
        {

            Add-EnvVar -EnvVar $item.Name -NewValue $item.Value -Scope $Scope
            # Write-Verbose
            Write-Host "$($item.Name):$($item.Value) was added." -ForegroundColor Blue
        }
        else
        {
            Write-Verbose "$($item.Name) already exists: $($item.Name):$($exist.value)"
            if ($Replace)
            {
                Set-EnvVar -EnvVar $item.Name -NewValue $item.Value -Scope $Scope
            }
        }
    }
    
}
```

