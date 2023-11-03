[toc]

## ref

- [How to Change Your DNS Server Settings in Windows 10 / 11? (cloudinfrastructureservices.co.uk)](https://cloudinfrastructureservices.co.uk/how-to-change-your-dns-server-settings-in-windows-10-11/)

- [debian - How to setup DNS manually on Linux? - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/494324/how-to-setup-dns-manually-on-linux)

### 方式1

- 点击任务栏的网络属性进行配置

### 方式2

使用命令行直接打开配置 DNS 的图形界面：

1. 打开命令提示符:输入 “cmd”打开老式shell或"pwsh"打开新式shell(powershell) 
2. 输入以下命令以打开网络连接设置：`ncpa.cpl`
   - 这将打开“网络连接”窗口。
3. 在“网络连接”窗口中，右键单击当前正在使用的网络连接，然后选择“属性”。
4. 在“网络连接属性”窗口中，选择“Internet 协议版本 4（TCP/IPv4）”，然后单击“属性”按钮。
5. 在“Internet 协议版本 4（TCP/IPv4）属性”窗口中，单击“高级”按钮。
6. 在“高级 TCP/IP 设置”窗口中，选择“DNS”选项卡。
7. 单击“添加”按钮以添加新的 DNS 服务器地址，或单击“编辑”或“删除”按钮以修改或删除现有 DNS 服务器地址。

### 方式3

- 使用netsh 配置

- 首先以管理员的方式启动shell(cmd或powershell)

- 假设您使用wifi,那么下面的命令将dns服务器改为`8.8.8.8`

- ```bash
   interface IP set dns “Wi-Fi” static 8.8.8.8
  ```

- 更完整的命令如下:

  - ```bash
     netsh interface ipv4 set dnsservers "wi-fi" static 8.8.8.8
    ```

- 参考手册:

  - ```bash
    
    Usage: set dnsservers [name=]<string> [source=]dhcp|static
                 [[address=]<IP address>|none]
                 [[register=]none|primary|both]
                 [[validate=]yes|no]
    
    Parameters:
    
          Tag            Value
          name         - The name or index of the interface.
          source       - One of the following values:
                         dhcp: Sets DHCP as the source for configuring DNS
                               servers for the specific interface.
                         static: Sets the source for configuring DNS servers
                                 to local static configuration.
          address      - One of the following values:
                         <IP address>: An IP address for a DNS server.
                         none: Clears the list of DNS servers.
          register     - One of the following values:
                         none: Disables Dynamic DNS registration.
                         primary: Register under the primary DNS suffix only.
                         both: Register under both the primary DNS suffix, as
                               well as under the connection-specific suffix.
          validate     - Specifies whether validation of the DNS server setting
                         will be performed. The value is yes by default.
    
    Remarks: Sets DNS server configuration to either DHCP or static mode. Only
             when source is 'static', is the 'addr' option also available for
             configuring a static list of DNS server IP addresses for the
             specified interface. If Validate switch is yes, then
             the newly set DNS server is validated.
    
    Examples:
    
           set dnsservers name="Wired Ethernet Connection" source=dhcp
           set dnsservers "Wired Ethernet Connection" static 10.0.0.1 primary
    ```

  #### name参数的确定

  - 使用`ncpa.cpl`查看最为直观:

    - 该界面显示的网卡(或虚拟网卡)上的首行黑体字就是`name`参数(有的地方叫做`connection`)
    - ![在这里插入图片描述](https://img-blog.csdnimg.cn/70784f522d6b4c70b06c978eac0cef77.png)

    - 注意wi-fi这一栏,wifi名字不是name参数,而字符串`wi-fi`可以作为参数,表示一种连接方式,而不关心具体连接到哪个网络

### linux配置

- 编辑文件` /etc/resolv.conf `

  - ```bash
    nameserver 8.8.8.8
    nameserver 8.8.4.4
    ```

    

  - 这将添加 Google 的公共 DNS 服务器地址 8.8.8.8 和 8.8.4.4。

    如果您希望使用其他 DNS 服务器地址，请将这些地址替换为您选择的其他地址。

