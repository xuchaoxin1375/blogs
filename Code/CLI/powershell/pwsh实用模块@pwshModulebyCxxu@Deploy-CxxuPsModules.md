[toc]



## 开源脚本模块项目

[scripts: 实用脚本集合,以powershell模块为主(针对powershell 7开发) 支持一键部署,改善windows下的shell实用体验](https://gitee.com/xuchaoxin1375/scripts)

### 一键部署

```powershell
irm 'https://gitee.com/xuchaoxin1375/scripts/raw/main/PS/Deploy/Deploy-CxxuPsModules.ps1'|iex

```



### 部署细节

[PwshModuleByCxxu.md · xuchaoxin1375/scripts - Gitee.com](https://gitee.com/xuchaoxin1375/scripts/blob/main/PwshModuleByCxxu.md)

将本地pwsh模块配置为自动加载模块

### 配置环境变量👺

如果您的电脑只有一个用户的话,那么使用用户级别的变量配置就足够了

#### 临时启用模块

假设你克隆了本项目,并且希望在正式修改环境变量(永久化)之前就能够使用本模块集中的模块,那么可以简单执行形如一下的语句(这种方法是临时生效,如果你打开新的powershell或者调用`pwsh`创建新shell进程,就会失效)

```powershell
$p="C:\repos\scripts\PS" #这里修改为您下载的模块所在目录,这里的取值作为示范
$env:PSModulePath=";$p"
#add-EnvVar -EnvVar PsModulePath -NewValue $p -Verbose #这里$p上上面定义的
```

- 然后,您可以(临时地)执行`Deploy-EnvsByPwsh`这类方法,将您之前使用`backup-EnvsByPwsh`备份的环境变量导入到当前系统中

- 这种方法非常适合于双系统用户,并且使用过模块中提供的环境变量备份函数,如果是初次使用本项目的用户,这种方法不是很有用

- 事实上,如果你配置正确,那么这时候已经可以调用模块中的相关函数了,例如,您可以执行`init`看看shell会返回什么内容

- 其次,可以追加执行

  ```powershell
  add-EnvVar -EnvVar PsModulePath -NewValue $p -Verbose #这里$p上上面定义的
  ```

为当前用户实现持久化配置

#### 演示

```powershell
PS C:\Windows\system32> pwsh
PowerShell 7.5.0
PS C:\Windows\System32> $p="C:\repos\scripts\PS" #这里修改为您下载的模块所在目录,这里的取值作为示范
>> $env:PSModulePath=";$p"
>> add-EnvVar -EnvVar PsModulePath -NewValue $p -Verbose #这里$p上上面定义的
VERBOSE: RawValue of [PsModulePath]:

Index Value
----- -----
    1


VERBOSE: Performing the operation "Get Unique Value" on target "PsModulePath".

EnvVar       From To
------       ---- --
PsModulePath      C:\repos\scripts\PS


VERBOSE: Performing the operation "Add-EnvVar" on target "CXXUFIREBAT11,Scope=User".
PS C:\Windows\System32> p
Loading new pwsh environment...
initing...
VERBOSE: confrim pwsh extension functions
Environment Loading time: 1606.8136 ms
```

