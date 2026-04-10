[toc]

## 命令行配置静态IP和DHCP动态IP

- 检查当前网卡名称

  ```
  Wireless LAN adapter WLAN:
  
     Connection-specific DNS Suffix  . :
     IPv6 Address. . . . . . . . . . . : 2409:8d80:610f:1a66:a829:f84d:f2cc:2312
     Temporary IPv6 Address. . . . . . : 2409:8d80:610f:1a66:fdd4:53d0:871f:5084
     Link-local IPv6 Address . . . . . : fe80::c15:ed09:1f04:1a4f%12
     IPv4 Address. . . . . . . . . . . : 192.168.1.165
     Subnet Mask . . . . . . . . . . . : 255.255.255.0
     Default Gateway . . . . . . . . . : fe80::a42a:c1ff:fe2b:f70b%12
                                         192.168.1.1
  ```

  - `Wireless LAN adapter WLAN:`说明名称为`WLAN`
  - 管理员权限执行:`netsh interface ipv4 set address name="WLAN" static 192.168.2.2 255.255.255.0 192.168.1.1`

- 恢复动态ip:`netsh interface ipv4 set address name="WLAN" source=dhcp`

  - Note:命令行中的双引号不能由单引号代替!