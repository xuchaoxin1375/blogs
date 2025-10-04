[toc]

## abstract

安装scoop的自定义与高级方案,适合有代理的国内用户参考,否则,一般的网络环境很难顺利安装scoop,或者安装上但是后续使用体验也不好

无代理用户可以参考国内镜像(主要是加速从github上下载资源的镜像)版本的scoop,但是这里方案稳定性不是很好,有条件的话用代理比较高效,体验更佳

文档

[ScoopInstaller/Install: 📥 Next-generation Scoop (un)installer](https://github.com/ScoopInstaller/Install?tab=readme-ov-file#advanced-installation)

## 高级安装@自定义安装@指定安装位置🎈

- 默认情况下会安装到当前用户家目录下


可以自定义安装位置,而且又有两种方案来指定安装目录

1. 下载安装脚本,然后手动运行命令行指定相关参数
2. 通过指定环境变量预设scoop的安装目录,然后再运行和默认安装类似的一键安装命令

### 指定脚本参数的方案

以国内魔改版为例,兼容原版安装方法和参数

```powershell
irm scoop.201704.xyz -outfile 'install.ps1'
.\install.ps1 -ScoopDir 'C:\Scoop' # -ScoopGlobalDir 'C:\ScoopGlobal'
```

自定义安装需要先下载安装脚本文件到本地,做必要的修改或者指定必要的参数,实现自定义安装

- 上述指定非默认路径后,会在配置文件中增加字段`root_path`,如果共存多个版本scoop就要注意了

  - 相关默认值

    ```powershel
    root_path: $Env:UserProfile\scoop
          Path to Scoop root directory.
    
    global_path: $Env:ProgramData\scoop
          Path to Scoop root directory for global apps.
    ```

    

- 此外还可以通过环境变量来更改默认安装路径

  

## 文档原文

### 自定义安装目录 Advanced Installation



If you want to have an advanced installation, you can download the installer and manually execute it with parameters.

```
irm get.scoop.sh -outfile 'install.ps1'
```



To see all configurable parameters of the installer.

```
.\install.ps1 -?
```

```powershell
PS> gcm .\install.ps1 -Syntax
.\install.ps1 (alias) -> C:\Users\cxxu\Desktop\install.ps1

.\install.ps1 [[-ScoopDir] <string>] [[-ScoopGlobalDir] <string>] [[-ScoopCacheDir] <string>] [[-Proxy] <uri>] [[-ProxyCredential] <pscredential>] [-NoProxy] [-ProxyUseDefaultCredentials] [-RunAsAdmin]
```

For example, you could install scoop to a custom directory, configure scoop to install global programs to a custom directory, and bypass system proxy during installation.

```cmd
.\install.ps1 -ScoopDir 'D:\Applications\Scoop' -ScoopGlobalDir 'F:\GlobalScoopApps' -NoProxy
```



Or you can use the legacy method to configure custom directory by setting Environment Variables. (**Not Recommended**)

需要管理员权限

```powershell
$env:SCOOP='C:\Applications\Scoop'
$env:SCOOP_GLOBAL='C:\GlobalScoopApps'
[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', $env:SCOOP_GLOBAL, 'Machine')
irm get.scoop.sh | iex
```

### 为管理员安装(For admin)

Installation under the administrator console has been disabled by default for security considerations. If you know what you are doing and want to install Scoop as administrator. Please download the installer and manually execute it with the `-RunAsAdmin` parameter in an elevated console. Here is the example:
出于安全考虑，默认情况下已禁用管理员控制台下的安装。如果您知道自己在做什么并想以管理员身份安装 Scoop。请下载安装程序，并在提升的控制台中使用 `-RunAsAdmin` 参数手动执行它。

下面是示例：

```powershell
irm get.scoop.sh -outfile 'install.ps1'
.\install.ps1 -RunAsAdmin [-OtherParameters ...]

```

或者不关心参数其他参数,直接为管理员安装

```bash
# I don't care about other parameters and want a one-line command
iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
```

否则,在管理员命令行窗口下,如果没有使用`-RunAsAdmin`会报错

```powershell
#⚡️[cxxu@CXXUFIREBAT][~\Desktop][11:00:02][UP:0.4Days]
PS> .\install.ps1 -ScoopDir C:/scoop -ScoopGlobalDir C:/scoopGlobal -Proxy http://localhost:10808
Initializing...
Running the installer as administrator is disabled by default, see https://github.com/ScoopInstaller/Install#for-admin for details.
Abort.
```

下面是实际操作以及要注意的地方

### 下载脚本

官方文档的简单命令行过内网络可能跑不成功或者很卡

如果本地网络不行需要走代理的时候,对于`irm`建议使用`-proxy`参数指定可用代理(如果有的话)

或者使用curl.exe命令下载也可以

```powershell
# [cxxu@CXXUFIREBAT][~\Desktop][10:33:13][UP:0.38Days]
PS> irm get.scoop.sh -outfile 'install.ps1' -Proxy http://localhost:10808 -Verbose
VERBOSE: Requested HTTP/1.1 GET with 0-byte payload
VERBOSE: Received HTTP/1.1 response of content type text/plain of unknown size
VERBOSE: File Name: install.ps1

# [cxxu@CXXUFIREBAT][~\Desktop][10:33:23][UP:0.38Days]
PS> ls .\install.ps1

    Directory: C:\Users\cxxu\Desktop

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           2025/10/4    10:33          26066 install.ps1
```

使用curl下载,建议带上`-L`参数

```powershell
curl get.scoop.sh -L
```

类似的,网络不行可以设置代理

```bash
curl -L get.scoop.sh -v --proxy http://localhost:10808 -o ./install.ps1
```

然后检查文件是否成功下载

### 安装操作

如果是普通用户安装,将`-RunAsAdmin`选项删除即可

```bash
.\install.ps1 -RunAsAdmin -ScoopDir C:\scoop -ScoopGlobalDir C:\scoopGlobal -Proxy http://localhost:10808
```

综合示例:为管理员使用指定代理安装到指定目录

> 指定代理后可能会提示github中仓库无法访问,scoop会尝试备用方案

```powershell
PS> .\install.ps1 -RunAsAdmin -ScoopDir C:\scoop -ScoopGlobalDir C:\scoopGlobal -Proxy http://localhost:10808
Initializing...
Downloading...
fatal: unable to access 'https://github.com/ScoopInstaller/Scoop.git/': Failed to connect to 127.0.0.1 port 1081 after 2051 ms: Could not connect to server
WARNING: Cloning failed. Falling back to downloading zip files.
Extracting...
Creating shim...
Adding C:\scoop\shims to your path.
Scoop was installed successfully!
Type 'scoop help' for instructions.
```

## 代理配置

为了后续使用scoop安装软件顺畅,通常依赖于可靠的代理网络,相关配置

```powershell
proxy: [username:password@]host:port
      By default, Scoop will use the proxy settings from Internet Options, but with anonymous authentication.

      * To use the credentials for the current logged-in user, use 'currentuser' in place of username:password
      * To use the system proxy settings configured in Internet Options, use 'default' in place of host:port
      * An empty or unset value for proxy is equivalent to 'default' (with no username or password)
      * To bypass the system proxy and connect directly, use 'none' (with no username or password)
```

| 配置值                          | 示例                         | 含义                                                         |
| ------------------------------- | ---------------------------- | ------------------------------------------------------------ |
| `[username:password@]host:port` | `user:pass@127.0.0.1:7890`   | 使用指定代理，支持认证信息                                   |
| `currentuser@host:port`         | `currentuser@127.0.0.1:7890` | 使用 Windows 当前登录用户的凭据去认证代理                    |
| `default`                       | `scoop config proxy default` | 使用系统“Internet 选项”里配置的代理（WinINET/IE 代理设置），匿名方式 |
| 空值（unset）                   | `scoop config rm proxy`      | 等价于 `default`，仍然读取系统代理                           |
| `none`                          | `scoop config proxy none`    | 不使用代理，直接连接                                         |

例如,配置使用代理`localhost:10808`(不需要指定协议)

```powershell
scoop config proxy localhost:10808
```

```powershell
PS> scoop config

root_path    : C:\scoop
global_path  : C:\scoopGlobal
last_update  : 2025/10/4 20:38:03
scoop_repo   : https://github.com/ScoopInstaller/Scoop
scoop_branch : master
proxy        : localhost:10808
```

