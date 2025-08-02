[toc]



你可以使用 `Test-Connection` 或 `Test-NetConnection` 来测试某个主机是否有响应：

------

### 方式 1：使用 `Test-Connection`（适用于所有 Windows 版本）

```powershell
Test-Connection -ComputerName "example.com" -Count 4
```

**说明：**

- `-ComputerName`：要测试的主机名或 IP 地址。
- `-Count 4`：发送 4 个 ICMP 请求（类似 `ping`）。

如果主机可达，你会看到类似：

```powershell
Source        Destination     IPV4Address      IPV6Address  Bytes    Time(ms)
------        -----------     -----------      -----------  -----    --------
MyPC          example.com     93.184.216.34                 32       12
MyPC          example.com     93.184.216.34                 32       10
```

如果主机不可达，会报错：

```powershell
Test-Connection : Ping 发送失败
```

------

### 方式 2：使用 `Test-NetConnection`（Windows 8+ 推荐）

```powershell
Test-NetConnection -ComputerName "example.com" -Port 80
```

**说明：**

- `-ComputerName`：要测试的主机。
- `-Port 80`：可选，测试某个特定端口（如 Web 服务器的 80 端口）。

如果主机可达，会返回：

```powershell
ComputerName     : example.com
RemoteAddress    : 93.184.216.34
TcpTestSucceeded : True
```

如果 `TcpTestSucceeded : False`，说明连接失败。

#### 例

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][12:33:35][UP:4.79Days]                                                        PS> Test-NetConnection -ComputerName "baidu.com" -Port 80                                                                                                                                                                           ComputerName     : baidu.com                                                                                       RemoteAddress    : 39.156.66.10
RemotePort       : 80
InterfaceAlias   : 以太网
SourceAddress    : 192.168.5.24
TcpTestSucceeded : True
```



------

### 方式 3：使用 `ping`（适用于所有版本）

```powershell
ping example.com
```

适用于简单的测试，但不适合脚本化处理结果。

------

**哪种方法最适合你的需求？你是想测试主机的 ICMP 响应，还是特定端口的可用性？**