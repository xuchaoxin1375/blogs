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
bridge         - Changes to the `netsh bridge' context.
delete         - Deletes a configuration entry from a list of entries.
dhcpclient     - Changes to the `netsh dhcpclient' context.
dnsclient      - Changes to the `netsh dnsclient' context.
dump           - Displays a configuration script.
exec           - Runs a script file.
firewall       - Changes to the `netsh firewall' context.
help           - Displays a list of commands.
http           - Changes to the `netsh http' context.
interface      - Changes to the `netsh interface' context.
ipsec          - Changes to the `netsh ipsec' context.
lan            - Changes to the `netsh lan' context.
mbn            - Changes to the `netsh mbn' context.
namespace      - Changes to the `netsh namespace' context.
netio          - Changes to the `netsh netio' context.
p2p            - Changes to the `netsh p2p' context.
ras            - Changes to the `netsh ras' context.
rpc            - Changes to the `netsh rpc' context.
set            - Updates configuration settings.
show           - Displays information.
trace          - Changes to the `netsh trace' context.
wcn            - Changes to the `netsh wcn' context.
wfp            - Changes to the `netsh wfp' context.
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
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/b1b594f51d194ae7a807000657f1ecb4.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_17,color_FFFFFF,t_70,g_se,x_16)


### netsh wlan

- 进入`wlan` 模式(配置环境context)
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/f08c2b9d9fb84a768134cee632c8337d.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

### show(展示当前命令的可有命令)

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/37b15faa439e463d92d0d0dcab819c67.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

##  检查/扫描当前wifi信号

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

Example output (names have been obscured):

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

### 输出列表分析

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

  

Example output (names have been obscured):

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

### 深度刷新/重检查周围wifi列表

- 🎈🎈🎈使用管理员方式代开cmd/powershell
- 先禁用WLAN网卡

- ```bash
  netsh interface set interface name="wLAN" admin=disable
  ```

  

  - 根据具体情况,也可能是`netsh interface set interface name="wi-fi" admin=disable`
  - 可以通过:`netsh wlan show interfaces`
    - 检查无线网卡信息获取Name字段的值来获取
    - 大小写应该不区分

```powershell
function isAdministratorPrivilege
{
    if (!([Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544'))
    {
        Write-Output '🎈🎈🎈🎈🎈🎈🎈🎈🎈warning!🎈🎈🎈🎈🎈🎈🎈🎈🎈🎈🎈🎈🎈🎈'
        Write-Output '🤣😂😊current powershell run without administrator privilege!;请手动打开管理模式的terminal.'
        return 0
    }
    return 1
}


```



## 命令行连接wifi

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

