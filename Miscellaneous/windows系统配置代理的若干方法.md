[toc]



## abstract

### 相关参考

- [在 Windows 中使用代理服务器 - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/在-windows-中使用代理服务器-03096c53-0554-4ffe-b6ab-8b1deee8dae1)
- [为信息保护配置设备代理和 Internet 连接设置 | Microsoft Learn](https://learn.microsoft.com/zh-cn/purview/device-onboarding-configure-proxy)
- [使用 环境变量配置代理 - .NET |Microsoft 学习](https://learn.microsoft.com/en-us/dotnet/azure/sdk/configure-proxy?tabs=cmd#configure-using-environment-variables)
- [代理服务器与隧道 - HTTP | MDN](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Guides/Proxy_servers_and_tunneling)
- PAC
  - [代理自动配置文件（PAC）文件 - HTTP | MDN](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Guides/Proxy_servers_and_tunneling/Proxy_Auto-Configuration_PAC_file)
  - [代理自动配置 (PAC) 文件 - HTTP | MDN - MDN 文档](https://mdn.org.cn/en-US/docs/Web/HTTP/Proxy_servers_and_tunneling/Proxy_Auto-Configuration_PAC_file)
- [Windows10系统设置代理教程 - 文档中心 - 快代理](https://help.kuaidaili.com/using/win10/)

在 Windows 系统上设置代理的方法有多种，适用于不同场景（如系统全局代理、特定应用代理、命令行工具代理等）。

以下是常见的几种设置代理的方式：

---

### 1. 通过系统设置（图形界面）设置全局代理(适合较新系统)
适用于 Windows 10/11 系统，设置后对大多数系统应用（如浏览器、Windows Store 等）生效。

**步骤：**
1. 打开 **设置（Settings）** → **网络和 Internet** → **代理**。
2. 在 **手动设置代理** 部分：
   - 开启 **使用代理服务器**。
   - 输入 **地址**（如 `127.0.0.1`）和 **端口**（如 `7890`）。
   - 如需绕过本地地址，可在 **不使用代理服务器的地址** 中添加（如 `<local>` 或 `localhost;127.0.0.1`）。
3. 点击 **保存**。

> 注意：此设置仅对**使用系统代理的应用生效**，部分软件（如 Chrome、Edge）默认遵循系统代理，而其他如 Firefox 需单独设置。

---

### 2. 通过 Internet 属性面板设置代理(兼容老系统)
适用于较旧版本 Windows 或需要兼容 IE 的场景。

对于win10以前的系统也支持,可以在命令行中输入`inetcpl.cpl`来快速打开此控制面板(Internet属性)设置入口

**步骤：**

1. 打开 **控制面板** → **Internet 选项**。
2. 切换到 **连接** 选项卡 → 点击 **局域网设置**。
3. 勾选 **为 LAN 使用代理服务器**，填写地址和端口。
4. 可设置 **例外**（即不走代理的地址）。
5. 点击 **确定** 保存。

> 此设置与系统设置中的代理是同步的，修改一处会同步到另一处。

---



### 3. 通过命令行设置系统代理（netsh）🎈

适用于脚本自动化设置。

> 注意权限问题,修改winhttp代理需要管理权限,建议启动一个管理员权限方式启动的shell窗口进行操作🎈

权限不足导致错误

```powershell
PS> netsh winhttp reset proxy
写入代理服务器设置时出错。(5) 拒绝访问。
```

命令`netsh`是windows系统自带,并且cmd,powershell上都可以直接运行

```cmd
netsh winhttp set

下列指令有效:

此上下文中的命令:
set proxy      - 配置 WinHTTP 代理服务器设置。
set tracing    - 使用 netsh trace start scenario=InternetClient。
```



```cmd
用法:  set proxy [proxy-server=]<server name> [bypass-list=]<hosts list>

参数:

  标记              值
  proxy-server  -  http 和/或 https 协议使用的代理服务器
  bypass-list   -  绕过代理服务器访问的站点列表
                   (使用 "<local>" 绕过所有短名称主机)

示例:

  set proxy myproxy
  set proxy myproxy:80 "<local>;bar"
  set proxy proxy-server="http=myproxy;https=sproxy:88" bypass-list="*.foo.com"
```



```cmd
# 设置 HTTP 代理
$p="http://localhost:10808"
netsh winhttp set proxy proxy-server="http=$p;https=$p" bypass-list="localhost;127.*"

# 重置为直接连接（取消代理）
netsh winhttp reset proxy
```

> 注意：`netsh winhttp` 设置的是 WinHTTP 代理，主要用于系统服务和部分命令行工具（如 PowerShell 的 `Invoke-WebRequest`），**不等于系统全局代理**。
>
> 例如,配置完上述代理,powershell中的`iwr`命令可以走此代理(当然此命令自己也有指定代理的选项`-proxy`),但是`curl.exe`却不走此代理,如果希望curl.exe这类程序走代理,可以使用代理环境变量来指定或者直接使用curl的`--proxy`参数指定代理即可

---

实操如下

```powershell
$p="http://localhost:7890"
netsh winhttp set proxy proxy-server="http=$p;https=$p" bypass-list="localhost;127.*"
```



```powershell
#⚡️[cxxu@CXXUFIREBAT][~\Desktop][17:45:12][UP:0.68Days]
PS> $p="http://localhost:10808"

#⚡️[cxxu@CXXUFIREBAT][~\Desktop][17:45:15][UP:0.68Days]
PS> netsh winhttp set proxy proxy-server="http=$p;https=$p" bypass-list="localhost;127.*"

当前的 WinHTTP 代理服务器设置:

    代理服务器:  http=http://localhost:10808;https=http://localhost:10808
    绕过列表     :  localhost;127.*

```

```powershell
PS> Invoke-WebRequest google.com |select StatusCode

StatusCode
----------
       200
```



### 4. 设置环境变量（适用于命令行工具和部分应用）

| 环境变量                     | 目的                                                         |
| :--------------------------- | :----------------------------------------------------------- |
| `HTTP_PROXY`或`http_proxy`   | 用于 HTTP 请求的代理服务器。                                 |
| `HTTPS_PROXY`或`https_proxy` | 用于 HTTPS 请求的代理服务器。                                |
| `ALL_PROXY`或`all_proxy`     | 用于 HTTP 和 HTTPS 请求的代理服务器。                        |
| `NO_PROXY`或`no_proxy`       | 要从代理中排除的以逗号分隔的主机名列表。                     |
| `GATEWAY_INTERFACE`          | 指示应用程序在通用网关接口 （CGI） 环境中运行。示例值：`CGI/1.1` |

要深入了解如何处理这些环境变量，请参阅[代码](https://github.com/Azure/azure-sdk-for-net/blob/9aa3b3a44f81bc0be5a4fc86607e0150ba9815d5/sdk/core/Azure.Core/src/Pipeline/Internal/HttpEnvironmentProxy.cs#L31)。请注意以下行为：

- 上表中的每个环境变量（除了 ）也可以定义为小写。小写形式优先于大写形式。`GATEWAY_INTERFACE`
- 如果 和 都未定义，则使用。`http_proxy``GATEWAY_INTERFACE``HTTP_PROXY`
- `ALL_PROXY`仅当 HTTP 或 HTTPS 代理未定义时才考虑。
- 特定于协议的环境变量优先于 .`ALL_PROXY`

代理服务器 URL 采用 的形式，其中组合是可选的。要获取代理服务器的 IP 地址或主机名、端口和凭据，请咨询您的网络管理员。`http[s]://[username:password@]<ip_address_or_hostname>:<port>/``username:password`

许多命令行工具（如 curl、git、npm、Python requests 等）会读取环境变量。

临时设置（当前终端会话有效）：
```cmd
set HTTP_PROXY=http://127.0.0.1:7890
set HTTPS_PROXY=http://127.0.0.1:7890
set NO_PROXY=localhost,127.0.0.1,.example.com
```

**永久设置：**
1. 右键 **此电脑** → **属性** → **高级系统设置** → **环境变量**。
2. 在 **用户变量** 或 **系统变量** 中添加：
   - `HTTP_PROXY` = `http://127.0.0.1:7890`
   - `HTTPS_PROXY` = `http://127.0.0.1:7890`
   - `NO_PROXY` = `localhost,127.0.0.1,.example.com`

> 注意：部分工具（如 Git）可能需要单独配置，不完全依赖环境变量。

---

### 5. 为特定应用或者命令单独设置代理
- **浏览器（如 Chrome、Edge）**：通常继承系统代理，也可通过启动参数指定：
  
  ```cmd
  chrome.exe --proxy-server="127.0.0.1:7890"
  ```
- **Firefox**：需在 **设置 → 网络设置 → 手动代理配置** 中单独设置。
- **Git**：
  ```bash
  git config --global http.proxy http://127.0.0.1:7890
  git config --global https.proxy http://127.0.0.1:7890
  ```
- **npm**：
  ```bash
  npm config set proxy http://127.0.0.1:7890
  npm config set https-proxy http://127.0.0.1:7890
  ```

---

- curl和powershell中的网络请求相关命令一般支持proxy设置

#### 关于应用单独设置代理的优先级问题

通常,如果应用程序本身支持配置代理(比如命令行程序支持`-proxy`这里参数或者支持配置文件中写入proxy字段值),这类方案配置的代理优先级比系统默认或者笼统配置到代理(比如环境变量或者系统代理)的优先级要高,尤其是git这类程序最为典型,配置文件中如果配置了不可用代理,会导致依赖或调用了git的程序无法从网络中执行操作

因此当你发现系统代理明明修改成功,但是部分程序运行过程中就是报一些不存在或者不可用的代理错误就应当注意应用级的代理配置覆盖了系统代理配置

例如git或则调用了git的程序或脚本,比如scoop

```powershell
PS> scoop install firefox
Updating Scoop...
fatal: unable to access 'https://github.com/ScoopInstaller/Scoop/': Failed to connect to 127.0.0.1 port 1081 after 2058 ms: Could not connect to server
Remove-Item: C:\scoop\apps\scoop\current\libexec\scoop-update.ps1:88
Line |
  88 |              Remove-Item $newdir -Force -Recurse
     |              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     | Cannot find path 'C:\scoop\apps\scoop\new' because it does not exist.
Scoop download failed. If this appears several times, try removing SCOOP_REPO by 'scoop config rm SCOOP_REPO'
Couldn't find manifest for 'firefox'.
```

分析错误,这是应为scoop的仓库(scoop_repo)拉取失败,并且指向了一个不可用代理,可能是git配置(.gitconfig)从另一台机器迁移过来没有根据当前机器的情况修改导致的错误

### 6. **使用 PAC（代理自动配置）脚本**

适用于复杂网络环境，自动判断是否使用代理。

**设置方法：**
1. 在系统代理设置中选择 **自动检测设置** 或 **使用设置脚本**。
2. 填写 PAC 文件 URL（如 `http://example.com/proxy.pac`）。

PAC 文件是一个 JavaScript 脚本，通过 `FindProxyForURL(url, host)` 函数返回代理规则。

---

### 7. **通过注册表设置系统代理（高级）**
适用于批量部署或脚本配置。

效果和从gui进入控制面板或系统设置中的代理设置修改效果是一样的

关键注册表路径：
```
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings
```

常用键值：
- `ProxyEnable` (DWORD): 1 表示启用，0 表示禁用
- `ProxyServer` (REG_SZ): `127.0.0.1:7890`
- `ProxyOverride` (REG_SZ): `<local>;example.com`

#### 查看现有相关值

可以在执行修改前后查看/验证修改是否正确

```powershell
# [cxxu@CXXUFIREBAT][~\Desktop][19:30:23][UP:0.76Days]
PS> Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"

CertificateRevocation    : 1
DisableCachingOfSSLPages : 0
IE5_UA_Backup_Flag       : 5.0
PrivacyAdvanced          : 1
SecureProtocols          : 2048
User Agent               : Mozilla/4.0 (compatible; MSIE
                            8.0; Win32)
ZonesSecurityUpgrade     : {178, 193, 155, 245…}
EnableNegotiate          : 1
ProxyEnable              : 1
MigrateProxy             : 1
WarnonZoneCrossing       : 0
LockDatabase             : 133932520891614138
SecureProtocolsUpdated   : 1
ProxyServer              : 127.0.0.1:10808
ProxyOverride            : <local>;localhost;127.*;10.*;
                           172.16.*;172.17.*;172.18.*;17
                           2.19.*;172.20.*;172.21.*;172.
                           22.*;172.23.*;172.24.*;172.25
                           .*;172.26.*;172.27.*;172.28.*
                           ;172.29.*;172.30.*;172.31.*;1
                           92.168.*
PSPath                   : Microsoft.PowerShell.Core\Reg
                           istry::HKEY_CURRENT_USER\Soft
                           ware\Microsoft\Windows\Curren
                           tVersion\Internet Settings
PSParentPath             : Microsoft.PowerShell.Core\Reg
                           istry::HKEY_CURRENT_USER\Soft
                           ware\Microsoft\Windows\Curren
                           tVersion
PSChildName              : Internet Settings
PSDrive                  : HKCU
PSProvider               : Microsoft.PowerShell.Core\Reg
                           istry


```

或者更有针对性的

```powershell

PS> Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"|select proxyEnable,proxyServer,ProxyOverride |fl

ProxyEnable   : 1
ProxyServer   : 127.0.0.1:10808
ProxyOverride : <local>;localhost;127.*;10.*;172.16.*;172.17.*;172.18.*;172.19.*;172
                .20.*;172.21.*;172.22.*;172.23.*;172.24.*;172.25.*;172.26.*;172.27.*
                ;172.28.*;172.29.*;172.30.*;172.31.*;192.168.*
```

或者,可以将注册表路径赋值给变量,然后引用

```powershell
$InternetProxyRegPath="HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"

Get-ItemProperty -Path $InternetProxyRegPath |select proxyEnable,proxyServer,ProxyOverride |fl

```

#### 修改

可通过 或 PowerShell 修改：

```powershell
$InternetProxyRegPath="HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
Set-ItemProperty -Path $InternetProxyRegPath -Name ProxyEnable -Value 1
Set-ItemProperty -Path $InternetProxyRegPath -Name ProxyServer -Value "127.0.0.1:7890"

```



或者`.reg` 文件修改

### 注意事项：

- 系统代理设置对 **UWP 应用**（如 Microsoft Store）可能无效，需额外配置。
- 某些安全软件或企业策略可能锁定代理设置。
- 重启应用或系统后，部分设置可能需要重新加载。

---

