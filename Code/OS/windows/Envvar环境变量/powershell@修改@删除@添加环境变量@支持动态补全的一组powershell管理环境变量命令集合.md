[toc]



## powershell操作环境变量

- 包括对环境变量做增加/删除/替换和取值规范化功能,并且为这些命令适配了在动态补全功能,包括参数补全和返回值属性补全(部分必要的命令支持)
- 所作修改长期有效,重启仍然有效
- 关于查看环境变量,[另见它文](https://blog.csdn.net/xuchaoxin1375/article/details/121435951)

### 安全声明

- 环境变量是重要的,因此操作前建议备份环境变量
- 详情另见它文

### 范围说明

- 以下函数支持用户级别和系统级别的更改
- 默认更改用户级别,系统级别的更改需要以管理员方式运行shell才行
- 总的来说,这些函数调用简单有效,能够自动更新当前powershell中的环境变量

## 环境变量管理模块函数或命令行安装👺

- 一键部署

  ```powershell
  irm 'https://gitee.com/xuchaoxin1375/scripts/raw/main/PS/Deploy/Deploy-CxxuPsModules.ps1'|iex
  ```

  - 上述命令尝试为你在线安装相关命令,获取最新版本的相关命令
  - 此命令行为你部署本主题模块和其他一些实用工具命令[scripts: 实用脚本集合,以powershell模块为主(针对powershell 7开发) 支持一键部署,改善windows下的shell实用体验 (gitee.com)](https://gitee.com/xuchaoxin1375/scripts)

- 下面的讨论基于此开源模块仓库

- 您也可以查看相应的仓库,对应的脚本代码,进行针对性手动安装

### 关于环境变量操作模块的特性

- 移除环境变量取值中存在的多余的分号
- 对于该系列命令提供了相对完善的命令行特性
  - 支持变量名补全和预览,并且支持指定范围(Scope)下调整对应的补全列表
  - 提供变量名后选值预览功能(对于多值环境变量,默认预览前5个，您可以修改相应的`Limit`阈值,注意值过大的话可能会导致补全提示(Tooltip)显示问题,全屏终端来使用补全功能最佳)
  - 返回值类型极其属性补全支持,配合管道符比如`|select-object `筛选属性,支持的命令有`Get-EnvVar`,`Get-EnvList`等

### 动态补全功能展示👺

#### 补全操作说明

powershell(7+)会话下编写命令行时,比如`Get-envvar `过程中,按下Tab键进行动态补全

```powershell
PS🌙[BAT:73%][MEM:25.82% (8.19/31.71)GB][Win 11 Pro@24H2:10.0.26100.1742][23:51:28]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.154>][~\Desktop]
PS> Get-EnvVar -Scope User -EnvVar Path
POSH_INSTALLER          POSH_THEMES_PATH        powershell_updatecheck
Path                    PSModulePath

Index Value
----- -----
    1 C:\repos\scripts
    2 C:\Users\cxxu\scoop\apps\vscode\current\bin
    3 C:\Users\cxxu\scoop\apps\openjdk21\current\bin
    4 C:\Users\cxxu\scoop\apps\gsudo\current
    5 C:\Users\cxxu\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Scoop Apps
---[5/8]---                                                                           
```

其中

```powershell
POSH_INSTALLER          POSH_THEMES_PATH        powershell_updatecheck
Path                    PSModulePath
```

是后选补全的部分,提示有这些环境变量和给定(正在输入的`Path`相匹配或相关)

当通过上下左右箭头选中合适的候选值,可以查看改候选值的预览取值,比如`Path`的值预览部分为

```powershell
Index Value
----- -----
    1 C:\repos\scripts
    2 C:\Users\cxxu\scoop\apps\vscode\current\bin
    3 C:\Users\cxxu\scoop\apps\openjdk21\current\bin
    4 C:\Users\cxxu\scoop\apps\gsudo\current
    5 C:\Users\cxxu\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Scoop Apps
---[5/8]---   
```

预览其中的前5个值,总共有8个值(`---[5/8]---   `)(在当前用户专属的环境变量下)



## FAQ

### 环境变量名字太长删不掉

- 部分情况可能将环境变量值作为环境变量名设置成了系统环境变量,可能造成删不掉的局面
  - 例如,`C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Scoop Apps`本来是个path值,但是操作失误设置为了变量名
- 可以借助powertoys的环境变量功能来删除!
- 或者从注册表中相关表项删除它
