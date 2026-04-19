[toc]

## abstract

- 介绍windows上查看网络网卡和ip地址信息的各种方法
- powershell NetTCPIP模块在网络方面的应用

[NetTCPIP Module | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/nettcpip/?view=windowsserver2022-ps)

## 管理网络适配器的powershell模块

### 网卡查看

- [NetAdapter Module | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/netadapter/?view=windowsserver2022-ps)

- 例如获取计算机上的网卡(包括实体网卡和虚拟网卡)

  ```powershell
  Get-NetAdapter |select Name,InterfaceDescription,MacAddress,Status |sort name
  ```

  

- 示例
  
  ```powershell
  PS [C:\Users\cxxu\Desktop]> Get-NetAdapter |select Name,InterfaceDescription,MacAddress,Status |sort name
  
  Name                          InterfaceDescription                       MacAddress        Status
  ----                          --------------------                       ----------        ------
  Bluetooth Network Connection  Bluetooth Device (Personal Area Network)   30-F6-EF-07-2E-65 Disconnected
  Ethernet                      Realtek PCIe GbE Family Controller         D4-93-90-34-16-69 Disconnected
  Local Area Connection* 2      Microsoft Wi-Fi Direct Virtual Adapter #2  32-F6-EF-07-2E-61 Up
  Tailscale                     Tailscale Tunnel                                             Up
  VMware Network Adapter VMnet1 VMware Virtual Ethernet Adapter for VMnet1 00-50-56-C0-00-01 Up
  VMware Network Adapter VMnet8 VMware Virtual Ethernet Adapter for VMnet8 00-50-56-C0-00-08 Up
  Wi-Fi                         Intel(R) Wi-Fi 6E AX211 160MHz             30-F6-EF-07-2E-61 Up
  ```
  
- 这里`Name`属性通常和`InterfaceAlias`属性是相同的

### 查看全部网卡信息

```powershell
Get-NetIPInterface|sort InterfaceAlias #按照网卡名称排序
```

例如

```powershell
PS C:\Users\cxxu\Desktop> Get-NetIPInterface|sort InterfaceAlias

ifIndex InterfaceAlias                  AddressFamily NlMtu(Bytes) InterfaceMetric Dh
                                                                                   cp
------- --------------                  ------------- ------------ --------------- --
7       Bluetooth Network Connection    IPv6                  1500              65 D…
7       Bluetooth Network Connection    IPv4                  1500              65 E…
22      Ethernet                        IPv4                  1500               5 E…
22      Ethernet                        IPv6                  1500               5 D…
6       Local Area Connection* 1        IPv4                  1500              25 E…
6       Local Area Connection* 1        IPv6                  1500              25 D…
17      Local Area Connection* 2        IPv6                  1500              25 D…
17      Local Area Connection* 2        IPv4                  1500              25 D…
1       Loopback Pseudo-Interface 1     IPv6            4294967295              75 D…
1       Loopback Pseudo-Interface 1     IPv4            4294967295              75 D…
5       Tailscale                       IPv6                  1280               5 D…
5       Tailscale                       IPv4                  1280               5 D…
24      vEthernet (Default Switch)      IPv4                  1500            5000 D…
24      vEthernet (Default Switch)      IPv6                  1500            5000 E…
4       VMware Network Adapter VMnet1   IPv4                  1500              35 D…
4       VMware Network Adapter VMnet1   IPv6                  1500              35 E…
20      VMware Network Adapter VMnet8   IPv4                  1500              35 D…
20      VMware Network Adapter VMnet8   IPv6                  1500              35 E…
3       Wi-Fi                           IPv6                  1492              30 E…
3       Wi-Fi                           IPv4                  1500              30 E…

```

网卡信息这么多一般是安装了虚拟机

又比如某台式机上没有安装虚拟机等注册虚拟网卡的软件,查看网卡列表信息数量就会少,还可以进一步选择关键属性

```powershell
PS C:\Users\Administrator> Get-NetIPInterface -AddressFamily IPv4|select InterfaceAlias,ConnectionState,AddressFamily

InterfaceAlias              ConnectionState AddressFamily
--------------              --------------- -------------
以太网                            Connected          IPv4
Loopback Pseudo-Interface 1       Connected          IPv4
```



## 查询ip地址和相关信息👺



### powershell命令行

[Get-NetIPAddress (NetTCPIP) | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/nettcpip/get-netipaddress?view=windowsserver2022-ps)

- 这里主要关心的是ipv4地址
- 也一并介绍了当计算机上有多个网卡(包括物理网卡(分为有线网卡和无线网卡)和虚拟网卡(比如虚拟机注册的网卡,代理工具注册的网卡))

### 网卡中英文对照

这里仅介绍最常见的两种**物理网卡(实体网卡)**(以太网(Ethernet)卡,WLAN(Wi-Fi)网卡)

以下命令行兼容中文和英文windows系统

### 只查看ipv4

```powershell
"Wi-Fi","WLAN","*EtherNet*", "*以太网*"|% {Get-netipaddress -InterfaceAlias $_ -AddressFamily IPv4 -ErrorAction SilentlyContinue|select InterfaceAlias, IPAddress}
```

### 一口气查看ipv4,ipv6

```powershell
"Wi-Fi","WLAN","*EtherNet*", "*以太网*" | ForEach-Object { 
    $p1 = Get-NetIPAddress -InterfaceAlias $_ -AddressFamily IPv4 -ErrorAction SilentlyContinue | Select-Object InterfaceAlias, @{Name = "IPv4"; Expression = { $_.IPAddress } }
    $p2 = Get-NetIPAddress -InterfaceAlias $_ -AddressFamily IPv6 -ErrorAction SilentlyContinue | Select-Object IPAddress
    $p1|Add-Member -MemberType NoteProperty -Name "IPv6" -Value $p2.IPAddress -PassThru
}|fl
```

运行结果示例



```powershell
InterfaceAlias : Wi-Fi
IPv4           : 192.168.1.154
IPv6           : {fe80::3758:3e74:5252:a85e%11, 240e:379:3e39:2b00:e807:8d25:1b2a:bee8, 240e:379:3e39:2b00:b99b:becd:740e:f1bf}

InterfaceAlias : Ethernet
IPv4           : 169.254.149.97
IPv6           : fe80::f06a:9c5:c285:5169%12
```

如果要查看表格形式,可以把末尾的`|fl`改为`|ft -wrap`



### 图形界面查看

#### 系统设置网络

- 对于较新windows,打开系统设置,点击网络(Internet),查看网络属性,其中包括了ip地址
- 或者在运行窗口(win+r)输入` ms-settings:network `,然后选择一个已连接的网络(wifi或有线以太网)

#### 控制面板

- 命令行输入`  ncpa.cpl` (Network Control Panel Application)可以快速打开相应的网络控制面板
- 可以设置网卡以及右键属性查看连接详情,里面包含了ip地址等信息

## 使用传统命令行查看

### cmd/powershell 通用

#### arp

- 使用`arp -a`,观察他返回的第一个结果

- 如果只想查看第一个结果,使用`arp -a|sls '---'|Select-Object -First 1`即可

  - 例如

    ```bash
    PS>arp -a|sls '---'|Select-Object -First 1
    
    接口: 192.168.1.178 --- 0x3
    ```
  
  - 那么您当前网络内的ip应该是`192.168.1.178`

#### ipconfig

- 使用`ipconfig`查看,这种方法是最多人提到的,但是观察起来不方便

  - 我们可以用命令行,输入`ipconfig | findstr /i "IPv4.*:.*"`进行查询

  - 有时候可以查到多个地址

    - ```bash
      PS>ipconfig | findstr /i "IPv4.*:.*"
         IPv4 地址 . . . . . . . . . . . . : 192.168.219.1
         IPv4 地址 . . . . . . . . . . . . : 192.168.32.1
         IPv4 地址 . . . . . . . . . . . . : 192.168.1.178
      ```

  - 如果有多个地址,为了区分他们,我们可以运行`ipconfig`,或者更加详细的`ipconfig /all`查看详情

- 从经验上看,一般都是192.168开头,并且第3个字段是`1`的往往就是我们想要的ipv4地址(但这不必然)

#### netsh interface 

和ipconfig类似但是内容更加紧凑

```cmd
netsh interface ip show addresses
```

### powershell 

除了`Get-NetIpAddress`这类命令,还有`Get-CimInstance`方法

#### Get-CimInstance

通过Win32_NetworkAdapterConfiguration获取

```powershell
PS [C:\Users\cxxu\Desktop]>  Get-CimInstance -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress -ne $null } | Select-Object Description, IPAddress

Description                                IPAddress
-----------                                ---------
Tailscale Tunnel                           {169.254.83.107, fe80::2f4c:2c3e:13e9:1c81}
VMware Virtual Ethernet Adapter for VMnet1 {192.168.174.1, fe80::c538:5a79:d7bf:35de}
VMware Virtual Ethernet Adapter for VMnet8 {192.168.37.1, fe80::6a9a:3215:bace:cd81}
Intel(R) Wi-Fi 6E AX211 160MHz             {192.168.1.178, fe80::602a:eb89:bc9c:22bf, 240e:379:3fa1:100:38d1:ed54:77d5:9710, 240e:379:3fa1:100:a548:a4e1:78ca:27d0}
Microsoft Wi-Fi Direct Virtual Adapter #2  {192.168.137.1, fe80::4569:8dca:ec45:64c0}
```



## FAQ

## 查看到多个ip

### 安装了vmware

- 在您的主机上安装了VMware虚拟机软件之后，您可能会看到多个IPv4地址，这是因为主机操作系统自身至少有一个物理网络接口，而VMware会为虚拟机创建额外的网络适配器，例如：

  1. **主机的IPv4地址**：
     - 这通常是您主机通过物理网络接口连接到网络所获得的IP地址。在Windows操作系统的命令提示符中，您可以运行`ipconfig`命令查看所有网络接口的信息，包括名称（如“以太网适配器”或“无线局域网适配器”）及其对应的IPv4地址。

  2. **虚拟网络适配器的IPv4地址**：
     - VMware会在主机上创建虚拟网络适配器，用于与虚拟机通信。常见的VMware虚拟网络类型有三种：
       - **VMnet1（Host-only）**: 这种模式下，虚拟机只能与主机以及在同一网络下的其他虚拟机通信，其IPv4地址一般不同于主机的真实网络地址。
       - **VMnet8 (NAT)**: 使用NAT模式时，虚拟机通过NAT共享主机的网络连接，虚拟机会有独立的私有IPv4地址，且可以通过NAT转换与外部网络通信。
       - **VMnet0 (Bridged)**: 桥接模式下，虚拟机直接桥接到主机的一个物理网络接口，虚拟机可以获得与主机同一网络段的IPv4地址，就像网络上的另一台独立计算机。
- 要区分这些IPv4地址，请在运行`ipconfig`命令后，仔细查看输出的结果，每一部分都会标明网络适配器的名称。
- 如果想单独查看某个网络适配器的配置，可以使用`ipconfig /all`命令，它会列出所有网络接口的详细信息，从中你可以根据适配器描述来判断哪个是主机的真实IP地址，哪个是VMware虚拟网络适配器的IP地址。

### 其他情况

- 不仅仅是VMware会注册虚拟网卡,其他软件也可能会类似的行为

