[toc]

#  netsh 命令

- netsh 是一个针对网络配置shell
##  refs
- [Network Shell (Netsh) | Microsoft Docs](https://docs.microsoft.com/zh-cn/windows-server/networking/technologies/netsh/netsh)
- [netsh commands | How does netsh work? [+examples] - IONOS](https://www.ionos.com/digitalguide/server/tools/netsh/)
- [Manage WiFi connection in Windows 10 with PowerShell | 4sysops](https://4sysops.com/archives/manage-wifi-connection-in-windows-10-with-powershell/)
- [How to disable WiFi using CMD or Powershell in Windows 10 (thewindowsclub.com)](https://www.thewindowsclub.com/disable-wifi-using-cmd-or-powershell)
- [windows - How do I display a list of Wi-Fi connections using netsh - Super User](https://superuser.com/questions/991457/how-do-i-display-a-list-of-wi-fi-connections-using-netsh)

##  获取netsh帮助
```ps1

PS D:\repos\scripts> netsh help

The following commands are available:

Commands in this context:
?              - Displays a list of commands.
add            - Adds a configuration entry to a list of entries.
advfirewall    - Changes to the `netsh advfirewall' context.
branchcache    - Changes to the `netsh branchcache' context.
...
winhttp        - Changes to the `netsh winhttp' context.
winsock        - Changes to the `netsh winsock' context.
wlan           - Changes to the `netsh wlan' context.

The following sub-contexts are available:
 advfirewall branchcache bridge dhcpclient dnsclient firewall http interface ipsec lan mbn namespace netio p2p ras rpc trace wcn wfp winhttp winsock wlan

To view help for a command, type the command, followed by a space, and then
 type ?.
```

##  对比Cisco packet tracer CLI
####  相同点(类似)
- netsh 模式和cisco packet tracer 中的CLI的操作有些类似
- 比如基于上下文提供不同的可用命令
- 获取帮助的方式
####  不同
- netsh 似乎不支持命令补齐
	- netsh 但是还是可以在不发生歧义的情况,只输入单词的前几个字符

##  使用netsh 
- ```bash
  PS C:\Users\cxxu\Desktop> netsh
  netsh>?
  
  The following commands are available:
  
  Commands in this context:
  ..             - Goes up one context level.
  ?              - Displays a list of commands.
  abort          - Discards changes made while in offline mode.
  add            - Adds a configuration entry to a list of entries.
  advfirewall    - Changes to the `netsh advfirewall' context.
  alias          - Adds an alias.
  branchcache    - Changes to the `netsh branchcache' context.
  bridge         - Changes to the `netsh bridge' context.
  bye            - Exits the program.
  ...
  The following sub-contexts are available:
   advfirewall branchcache bridge dhcpclient dnsclient firewall http interface ipsec lan mbn namespace netio nlm p2p ras rpc trace wcn wfp winhttp winsock wlan
  
  To view help for a command, type the command, followed by a space, and then
   type ?.
  ```

  


### netsh wlan

- 进入`wlan` 模式(配置环境context)
- ```bash
  
  netsh>wlan
  netsh wlan>?
  
  The following commands are available:
  
  Commands inherited from the netsh context:
  ..             - Goes up one context level.
  abort          - Discards changes made while in offline mode.
  add            - Adds a configuration entry to a list of entries.
  advfirewall    - Changes to the `netsh advfirewall' context.
  alias          - Adds an alias.
  ...
  Commands in this context:
  ?              - Displays a list of commands.
  add            - Adds a configuration entry to a table.
  connect        - Connects to a wireless network.
  ...
  start          - Start hosted network.
  stop           - Stop hosted network.
  
  To view help for a command, type the command, followed by a space, and then
   type ?.
  
  ```

  

### show(展示当前命令的可有命令)

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/37b15faa439e463d92d0d0dcab819c67.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

##  检查/扫描当前wifi信号🎈

### How can I display the other wireless connections?

#### 不适合用来扫描可用信号的命令

- command `netsh wlan show profiles` through command prompt shows list of all the all Wi-Fi available at that time to which my computer can connect.

The above command shows only those connections which have **profiles**.

- They are connections you have previously connected to and have saved configurations.
- It will always show your **current** connection (if you are using wireless).
- These connections may not be available from your current location.

#### 正确命令:netsh wlan show networks

- To list all **available** connections you need to use a different `netsh` command:

```
netsh wlan show networks
```

- These connections are available at your current location.
- You must be disconnected from all wireless networks before running this command.

- Example output (names have been obscured):


```
f:\test>netsh wlan show networks

Interface name : Wireless Network Connection
There are 22 networks currently visible.

SSID 1 : SKYXXXXX
    Network type            : Infrastructure
    Authentication          : WPA2-Personal
    Encryption              : CCMP

SSID 2 : SKYXXXXX
    Network type            : Infrastructure
    Authentication          : WPA2-Personal
    Encryption              : CCMP

SSID 3 : XXXXX
    Network type            : Infrastructure
    Authentication          : WPA2-Personal
    Encryption              : CCMP

SSID 4 : BTOpenzoneXXX
    Network type            : Infrastructure
    Authentication          : Open
    Encryption              : None

...
```

### How can I display the other wireless connections?

> command `netsh wlan show profiles` through command prompt shows list of all the all Wi-Fi available at that time to which my computer can connect.

The above command shows only those connections which have **profiles**.

- They are connections you have previously connected to and have saved configurations.
- It will always show your **current** connection (if you are using wireless).
- These connections may not be available from your current location.

To list all **available** connections you need to use a different `netsh` command:

```
netsh wlan show networks
```

- These connections are available at your current location.
- You must be disconnected from all wireless networks before running this command.

### 输出wifi列表🎈

- 可能会出现乱码(中文字符)

- 不是实时的,新的信号刚刚进入,可能要等待5s左右才可以扫描到

  - 总之，这种方法并不可靠！

- 必须断开所有wifi后再执行该命令,否则只返回当前已连接的wifi

- ```powershell
  function wifi_list
  {
      Write-Output 'list the current wifi signals...'
      Write-Output 'if there is only one item returned,please disconnect current wifi!🎈'
      netsh wlan show networks
  }
  ```

  

- Example output (names have been obscured):


```bash
f:\test>netsh wlan show networks

Interface name : Wireless Network Connection
There are 22 networks currently visible.

SSID 1 : SKYXXXXX
    Network type            : Infrastructure
    Authentication          : WPA2-Personal
    Encryption              : CCMP

SSID 2 : SKYXXXXX
    Network type            : Infrastructure
    Authentication          : WPA2-Personal
    Encryption              : CCMP

SSID 3 : XXXXX
    Network type            : Infrastructure
    Authentication          : WPA2-Personal
    Encryption              : CCMP

SSID 4 : BTOpenzoneXXX
    Network type            : Infrastructure
    Authentication          : Open
    Encryption              : None

...
```



### 检查/过滤指定wifi是否存在

```bash
PS D:\repos\scripts> wifi_list|sls "11T"

SSID 8 : Redmi Note 11T Pro4
```

### 深度刷新/重检查周围wifi列表🎈

- 🎈🎈🎈使用管理员方式代开cmd/powershell
- 原理是重启网卡

  - 先禁用WLAN网卡

  - 再启用网卡

- ```bash
  netsh interface set interface name="wLAN" admin=disable
  ```

  

  - 根据具体情况,也可能是`netsh interface set interface name="wi-fi" admin=disable`
  - 可以通过:`netsh wlan show interfaces`

    - ```bash
      PS C:\Users\cxxu\Desktop> netsh wlan show interfaces|sls Name
      
          Name                   : Wi-Fi
      ```
    - 常见的Name取值为:

      - `wi-fi`(无线路由器)
      - `wlan`(比如手机热点)
      - 下面的脚本已经为你处理好了,所以不需要你自己查看了

    - 检查无线网卡信息获取Name字段的值来获取
    - 大小写应该不区分

#### 强力刷新当前wifi

```powershell

function isAdministratorPrivilege
{
    if (!([Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544'))
    {
        # Write-Output '🎈🎈🎈🎈🎈🎈🎈🎈🎈warning!🎈🎈🎈🎈🎈🎈🎈🎈🎈🎈🎈🎈🎈🎈'
        # Write-Output '🤣current powershell run without administrator privilege!;请手动打开管理模式的terminal.'
        return $false
    }
    # Write-Output '😁current environment is @administrator privilege!'
    #write 会影响返回值!
    return $true
}

function wifiList_forceByDisconnect_SudoFirst
{
    <# 
    .synopsis
    务必使用管理员权限运行,否则结果依然不可靠!!!
    #>
    if ($(isAdministratorPrivilege) -eq $False)
    {
        Write-Output '🤣Ops!please try anagin by @Administrator privilege'
        return $False
    }
    else
    {
        Write-Output '😁the current environment is @Administrator privilege'
    }

    Write-Output 'get the current working NIC informations...'
    # netsh wlan show interfaces | Select-String Name
    $Name = (netsh wlan show interfaces | Select-String Name).ToString() -replace '(Name.*):(.*)', '$2'; $Name = $Name.Trim()
    Write-Output "the Name=$Name"
    Write-Output '正在关闭无线网卡(disabling the wlan interface...'
    netsh interface set interface name=$Name admin=disable
    Write-Output 'waiting for the enable operation complete...'
    #需要等待几秒,以便网卡关闭顺利执行(相对耗时,根据自己的情况来调整)
    # Start-Sleep(3)
    # countdown_timer
    Write-Output 'try to enable the interface again ...'
    #重新启动WLAN网卡
    netsh interface set interface name=$Name admin=enable
    Write-Output 'waiting for the enable operation complete...'
    Start-Sleep(0.5)
    Write-Output 'list the current wifi signals...'
    # netsh wlan show networks
    netsh wlan show networks | Select-String ssid
    Write-Output 'the current connected network is:'
    netsh wlan show interfaces | Select-String ^\s*ssid
    
    ping www.baidu.com | Select-Object -First 6
}
```

#### 调用示例

- ```bash
  PS C:\Users\cxxu\Desktop> wifiList_forceByDisconnect_SudoFirst
  😁the current environment is @Administrator privilege
  get the current working NIC informations...
  the Name=Wi-Fi
  正在关闭无线网卡(disabling the wlan interface...
  
  waiting for the enable operation complete...
  try to enable the interface again ...
  
  waiting for the enable operation complete...
  list the current wifi signals...
  
  SSID 1 : ChinaNet-95y1520598
  SSID 2 : ChinaNet-sNRv
  SSID 3 : FAST_0770
  SSID 4 : CMCC-user
  the current connected network is:
      SSID                   : ChinaNet-95y15xxxx
  ```

  

## 命令行连接wifi🎈

- 常用wifi的连接通过可以考虑使用CLI进行

### powershell函数连接指定wifi

- 首次连接需要wifi输入密码
```powershell
function connectWlan
{
    param(
        $ssid = "WifiNameByYou"
    )
    Write-Output "try connecting to wifi ssid:$ssid"
    netsh wlan connect name=$ssid
}
```

### 断开当前wifi

- 某些时候我们要重新扫描可用wifi,或者其他原因,可以尝试先断开当前wifi
  - `netsh wlan disconnect`

### 重新连接到指定wifi

- 下面的函数尝试断开当前的wifi,并重新连接到指定的wifi

```powershell
function wifi_wlan_reconnect_to {
    param(
        $ssid = 'YourFavoriteWifiName'
    )
    Write-Output 'try disconnect current wifi🎈...'
    netsh wlan disconnect
    Write-Output "try connect to $ssid"
    netsh wlan connect name=$ssid
} 
```

- 连接示例:

```bash
PS D:\repos\scripts> wifi_wlan_reconnect_to "Redmi Note 11T Pro"
try disconnect current wifi🎈...
Disconnection request was completed successfully for interface "WLAN".
try connect to Redmi Note 11T Pro
Connection request was completed successfully.
```

