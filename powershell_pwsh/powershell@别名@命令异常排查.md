[toc]

- powershell 的cmdlet名字大多比较长,如果使用别名的话可以提高效率

- 由于powershell 不区分大小写,所以默认在搜索相关命令的时候不区分大小写


##  get-alias

### 查询别名的全名

- 默认情况下,该命令根据别名来查找命令(函数)的原名(Definition)

- ```cmd
  PS D:\repos\scripts> help gal
  
  NAME
      Get-Alias
  
  SYNOPSIS
      Gets the aliases for the current session.
      
      
  DESCRIPTION
      The `Get-Alias` cmdlet gets the aliases in the current session. This includes built-in aliases, aliases that you
      have set or imported, and aliases that you have added to your PowerShell profile.
  
      By default, `Get-Alias` takes an alias and returns the command name. When you use the Definition parameter,
      `Get-Alias` takes a command name and returns its aliases.
  
  
  ```

### 查询全名的别名

- `-Definitoin`

- ```cmd
  PARAMETERS
      -Definition <System.String[]>
          Gets the aliases for the specified item. Enter the name of a cmdlet, function, script, file, or executable
          file.
  
          This parameter is called Definition , because it searches for the item name in the Definition property of the
          alias object.
  
          Required?                    false
          Position?                    named
          Default value                None
          Accept pipeline input?       False
          Accept wildcard characters?  true
  ```

- 例:` Get-Alias -Definition Get-ChildItem`

  - ```cmd
    PS D:\repos\scripts> gal -Definition Get-ChildItem
    
    CommandType     Name                                               Version    Source
    -----------     ----                                               -------    ------
    Alias           dir -> Get-ChildItem
    Alias           gci -> Get-ChildItem
    Alias           ls -> Get-ChildItem
    ```

    

  - ```
        ------------- Example 3: Get aliases for a cmdlet -------------
    
        Get-Alias -Definition Get-ChildItem
    
        This command gets the aliases for the `Get-ChildItem` cmdlet.
    
        By default, the `Get-Alias` cmdlet gets the item name when you know the alias. The Definition parameter gets the
        alias when you know the item name.
    ```

### 小结

- `help get-alias`
- `help get-alias -examples`
- `help gal -examples`
- get-alias 支持双向查询别名
- `get -Name`根据别名查询原命令
- `get -Definition`根据原命令查询别名配置情况get-alias(gal)返回的对象分析

```ps1
PS D:\repos\learnPwsh> gal|gm


   TypeName: System.Management.Automation.AliasInfo     

Name                MemberType     Definition
----                ----------     ----------
Equals              Method         bool Equals(System.…
GetHashCode         Method         int GetHashCode()    
GetType             Method         type GetType()       
ResolveParameter    Method         System.Management.A… 
ToString            Method         string ToString()    
...
Source              Property       string Source {get;} 
Version             Property       version Version {ge… 
Visibility          Property       System.Management.A… 
DisplayName         ScriptProperty System.Object Displ… 
HelpUri             ScriptProperty System.Object HelpU… 
ResolvedCommandName ScriptProperty System.Object Resol… 
```

## 获取alias相关的命令的别名
`Get-Alias -Definition *alias*`
```powershell
CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Alias           epal -> Export-Alias
Alias           gal -> Get-Alias
Alias           ipal -> Import-Alias
Alias           nal -> New-Alias
Alias           sal -> Set-Alias
Alias           setAlias -> Set-Alias
```
看到`get-Alias`配置了别名`gal`
所以之后我们直到可以用gal来代替`get-alias`
好,现在我们利用已经获得的知识去查询经常使用的命令的别名配置情况
例如`select-object`,`where-object`,`sort-object`
##  根据原命令名查找可能存在的别名
`-Definition`参数
```powershell
PS C:\Users\cxxu\Desktop\tes> gal -Definition where*

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Alias           ? -> Where-Object
Alias           where -> Where-Object


PS C:\Users\cxxu\Desktop\tes> gal -Definition *select*

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Alias           select -> Select-Object
Alias           sls -> Select-String

PS C:\Users\cxxu\Desktop\tes> gal -Definition *sort*

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Alias           sort -> Sort-Object

PS C:\Users\cxxu\Desktop\tes> gal -Definition *member*

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Alias           gm -> Get-Member

```
现用查询到的别名,来做一个信息(列)筛选
```powershell
PS C:\Users\cxxu\Desktop\tes> gal -Definition *alias* | select DisplayName|Format-Table

DisplayName
-----------
epal -> Export-Alias
gal -> Get-Alias
ipal -> Import-Alias
nal -> New-Alias
sal -> Set-Alias
setAlias -> Set-Alias
```
这里可以提一下获取对象(真实(完整)属性)的若干方法

## 获取对象属性@函数的若干方法

- 获取对象完整的属性和对象方法

```powershell

PS C:\Users\cxxu\Desktop\tes> gal -Definition *alias*|select -First 1|select *

HelpUri             : https://go.microsoft.com/fwlink/?LinkID=2096597
ResolvedCommandName : Export-Alias
DisplayName         : epal -> Export-Alias
ReferencedCommand   : Export-Alias
ResolvedCommand     : Export-Alias
Definition          : Export-Alias
Options             : ReadOnly
Description         :
OutputType          : {System.Management.Automation.AliasInfo}
Name                : epal
CommandType         : Alias
Source              :
Version             :
Visibility          : Public
ModuleName          :
Module              :
RemotingCapability  : PowerShell
Parameters          : {[Path, System.Management.Automation.ParameterMetadata],
                      [LiteralPath, System.Management.Automation.ParameterMetadata],
                      [Name, System.Management.Automation.ParameterMetadata], [PassThru,
                      System.Management.Automation.ParameterMetadata]…}
ParameterSets       :

```
- 这中方法的一个好处,可以看到属性以及相应的取值的实例,帮助您更好的把握属性的含义.
- 当然,还不清楚某些相像的属性的区别,可以利用`get-member`(gm)这样做

```powershell
PS C:\Users\cxxu\Desktop\tes> gal -Definition *member*|gm


   TypeName: System.Management.Automation.AliasInfo

Name                MemberType     Definition
----                ----------     ----------
Equals              Method         bool Equals(System.Object obj)
GetHashCode         Method         int GetHashCode()
GetType             Method         type GetType()
ResolveParameter    Method         System.Management.Automation.ParameterMetadata Resolve…
ToString            Method         string ToString()
CommandType         Property       System.Management.Automation.CommandTypes CommandType …
Definition          Property       string Definition {get;}
Description         Property       string Description {get;set;}
Module              Property       psmoduleinfo Module {get;}
ModuleName          Property       string ModuleName {get;}
....(我节约篇幅,做了删节)
DisplayName         ScriptProperty System.Object DisplayName {get=if ($this.Name.IndexOf(…
HelpUri             ScriptProperty System.Object HelpUri {get=$oldProgressPreference = $P…
ResolvedCommandName ScriptProperty System.Object ResolvedCommandName {get=$this.ResolvedC…

```

- 这包含了属性/方法的解释


## 查询函数@命令/别名@gcm

- ```cmd
  PS D:\> gcm *env*
  
  CommandType     Name                                               Version    Source
  -----------     ----                                               -------    ------
  Alias           etenv -> Enter-CondaEnvironment                    0.0        Conda
  Alias           exenv -> Exit-CondaEnvironment                     0.0        Conda
  Alias           genv -> Get-CondaEnvironment                       0.0        Conda
  Function        add-env                                            0.0        functionsByCxxu
  Function        backupEnvs_regeditPrintPath                        0.0        functionsByCxxu
  Function        cxxuAli_update_alias_envs_vimrc                    0.0        functionsByCxxu
  Function        Django_env_Home                                    0.0        functionsByCxxu
  Function        Enter-CondaEnvironment                             0.0        Conda
  Function        envAll                                             0.0        functionsByCxxu
  Function        envInPath                                          0.0        functionsByCxxu
  Function        EnvironmentRequireTips                             0.0        functionsByCxxu
  ```

  

- 还可以进行排序或过滤或分组

  - ```bash
    PS D:\> gcm *env*|where CommandType -eq Alias
    
    CommandType     Name                                               Version    Source
    -----------     ----                                               -------    ------
    Alias           etenv -> Enter-CondaEnvironment                    0.0        Conda
    Alias           exenv -> Exit-CondaEnvironment                     0.0        Conda
    Alias           genv -> Get-CondaEnvironment                       0.0        Conda
    ```

  - ```
    PS C:\Users\cxxu> gcm *env*|where CommandType -like fun*
    
    CommandType     Name                                               Version    Source
    -----------     ----                                               -------    ------
    Function        add-env                                            0.0        functionsByCxxu
    Function        backupEnvs_regeditPrintPath                        0.0        functionsByCxxu
    Function        cxxuAli_update_alias_envs_vimrc                    0.0        functionsByCxxu
    Function        Django_env_Home                                    0.0        functionsByCxxu
    Function        Enter-CondaEnvironment                             0.0        Conda
    Function        envAll                                             0.0        functionsByCxxu
    ```

    

- 例:按命令来源排序

  - ```bash
    PS C:\Users\cxxu> gcm *git*|sort Source
    
    CommandType     Name                                               Version    Source
    -----------     ----                                               -------    ------
    Alias           gitBash -> git-cmd.exe                             0.0        Aliases
    Alias           gitCmdShell -> git-cmd.exe                         0.0        Aliases
    Application     UevTemplateConfigItemGenerator.exe                 0.0.0.0    C:\WINDOWS\system32\UevTemplateConfigIte…
    Application     git.exe                                            2.34.1.1   D:\exes\PortableGit\bin\git.exe
    Application     git-bash.exe                                       2.34.1.1   D:\exes\portableGit\git-bash.exe
    Application     git-cmd.exe                                        2.34.1.1   D:\exes\portableGit\git-cmd.exe
    Function        checkGitReports                                    0.0        functionsByCxxu
    Function        git_proxy_set                                      0.0        functionsByCxxu
    Function        git_initial_email_name                             0.0        functionsByCxxu
    ```

    

- 筛选后排序

  ```cmd
  PS C:\Users\cxxu> gcm *git*|where {$_.Name -Like "*git*"}|sort CommandType
  
  CommandType     Name                                               Version    Source
  -----------     ----                                               -------    ------
  Alias           gitBash -> git-cmd.exe                             0.0        Aliases
  Alias           gitCmdShell -> git-cmd.exe                         0.0        Aliases
  Function        git_proxy_set                                      0.0        functionsByCxxu
  Function        git_initial_email_name                             0.0        functionsByCxxu
  Function        git_clone_shallow                                  0.0        functionsByCxxu
  ```

##  只查询别名
- 那么可以直接使用`gal`,更加专注别名类型(`Alias`),而不会牵扯到函数

## 命令异常排查

- 例:

  - 由于我修改了系统环境变量,使得原来工作良好的别名变得不可用

  ```cmd
  PS D:\repos\scripts> softxor
  softxor: The module '%pdfTools%' could not be loaded. For more information, run 'Import-Module %pdfTools%'.
  ```

  - 这个错误提示不太具体,尝试以下命令

- 使用`help <command>`或`gcm <command>|fl`查询情况

  - ```cmd
    PS D:\repos\scripts> help softxor
    
    Name          : softxor
    Category      : Alias
    Synopsis      : %pdfTools%\softxor_cracked\softx
    Component     :
    Role          :
    Functionality :
    
    PS D:\repos\scripts> gcm softxor|fl
    
    DisplayName       : softxor -> %pdfTools%\softxor_cracked\softx
    CommandType       : Alias
    Definition        : %pdfTools%\softxor_cracked\softx
    ReferencedCommand :
    ResolvedCommand   :
    
    
    ```

    - 根据描述可知(Category/CommandType),因该是Alias(别名)出现了问题
    - 于是我打开powershell配置文件修改了相关的错误
      - 原来是该软件所在家目录环境变量被删除,而别名的路径引用了这个环境变量
      - 现在可以考虑将变量添加回去,或者直接创建一个不依赖于系统变量的别名,比如用绝对路径或者参考linux中bash配置文件的做法,单独创建一个存储别名的文件来同一管理环境变量或别名的导入操作





