[toc]



## scoop 更新指定软件包

在直接更新失败的情况下,有以下两类思路解决

```bash
PS C:\Users\cxxu> scoop install powershell -g
WARN  'powershell' (7.4.6) is already installed.
Use 'scoop update powershell --global' to install a new version.
```



### 指定安装来源

使用scoop更新软件时,如果遇到版本好明明存在更新的,但是就是提示你已经时最新的,这可能时因为你下载安装的软件的bucket不被及时更新维护导致的,而新版本出现在其他bucket中,你默认更新就可能更新了,需要指定bucket来源更新

如果来源bucket已经丢失或移除或忘记,可以考虑重新指定一个bucket来源安装最新版,如果引发冲突,但是有非得更新,则考虑移除掉旧版本,重新安装

### 手动指定版本号安装

假设我要更新powershell版本,但之前安装的powershell的bucket被移除了,现在通过查询得到版本信息如下(例子)

```bash

PS C:\Users\cxxu> scoop-search powershell
'main' bucket:
    powershell-beautifier (1.2.5)
    powershell-yaml (0.4.12)

'spc' bucket:
    PowerShell-Install (7.5.0)                                                                                  
    PowerShell-Portable (7.5.0)                                                                              
    PowerShellUniversal-Install (5.2.2)
    clojure (1.12.0.1501) --> includes 'powershell.exe'
    powershell (7.5.0)
    powershell-beautifier (1.2.5)
    powershell-preview (7.6.0-preview.2)
    powershell-yaml (0.4.12)
    psmodule-7Zip4Powershell (2.7.0)
    psmodule-PowerShellAI (0.9.7)
```

而我当前的版本假设是`powershell@7.4.6`;那如何更新到指定版本?

```powershell
scoop install powershell@7.5.0 -g
```

环境准备

实际上更新powershell(v7)需要关闭正在运行的pwsh进程

```
powershell.exe #进入windows powershell.exe(v5),防止pwsh.exe进程占用
ps pwsh|kill #杀死潜在的pwsh进程
scoop update powershell -g #用scoop进行更新

```

