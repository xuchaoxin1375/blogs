# linux/windows_ip查看(公网ip/私网ip)/通过域名查找ip/解读tracert 的返回结果

## references

- [How to Check the IP Address in Linux: 12 Steps (with Pictures) (wikihow.com)](https://www.wikihow.com/Check-the-IP-Address-in-Linux#:~:text=How to Check IP Address in Linux 1,address. 7 Try the "hostname" command. See More.)

### 查看公网ip

#### 通用方法

> 不知到靠不靠谱,不同网站结果不同

- [iP地址查询--手机号码查询归属地 | 邮政编码查询 | iP地址归属地查询 | 身份证号码验证在线查询网 (ip138.com)](https://www.ip138.com/)

- [IP.cn - IP 地址www.baidu.com](https://ip.cn/ip/www.baidu.com.html)

  

#### linux

> 或者NAT 代表

- `curl ifconfig.me`

  - ```
    ┌─[cxxu@u12] - [~] - [2022-04-14 09:16:43]
    └─[0] <> curl ifconfig.me
    183.134.108.7%
    ```

### 查看私有ip

#### 简单情况:

- ```
  # cxxu @ cxxuAli in ~ [9:37:59] C:130
  $ hostname -I
  172.16.27.115
  ```

#### 复杂情况(譬如虚拟机/wsl子系统)

> wsl 扫描到了多块网卡(包括软件虚拟化出来的)

```bash
# cxxu @ CxxuWin11 in ~ [9:35:50]
$ hostname -I
172.29.112.1 192.168.6.1 192.168.80.1 10.61.5.232
```

> 这些内网IP都可以通过ssh连接到统一主机的同一用户

#### 优化显示

##### windows powershell:

```
PS D:\repos\scripts> ipconfig|sls ipv4|sort
InputStream:51:   IPv4 Address. . . . . . . . . . . : 172.29.112.1
InputStream:42:   IPv4 Address. . . . . . . . . . . : 192.168.43.165
InputStream:19:   IPv4 Address. . . . . . . . . . . : 192.168.6.1
InputStream:27:   IPv4 Address. . . . . . . . . . . : 192.168.80.1

#连同ipv6:
PS D:\repos\scripts> ipconfig|sls  -Pattern 'ipv(4|6)' |sort
InputStream:51:   IPv4 Address. . . . . . . . . . . : 172.29.112.1
InputStream:42:   IPv4 Address. . . . . . . . . . . : 192.168.43.165
InputStream:19:   IPv4 Address. . . . . . . . . . . : 192.168.6.1
InputStream:27:   IPv4 Address. . . . . . . . . . . : 192.168.80.1
InputStream:39:   IPv6 Address. . . . . . . . . . . : 2409:8928:43e:37f:80f7:126e:ce36:c456
InputStream:50:   Link-local IPv6 Address . . . . . : fe80::45ea:9308:32c6:3afb%24
InputStream:41:   Link-local IPv6 Address . . . . . : fe80::80f7:126e:ce36:c456%21
InputStream:18:   Link-local IPv6 Address . . . . . : fe80::b9a5:881b:6e1d:3046%7
InputStream:26:   Link-local IPv6 Address . . . . . : fe80::c1f1:349f:8708:b1fd%19
InputStream:40:   Temporary IPv6 Address. . . . . . : 2409:8928:43e:37f:1161:ead4:eecf:fe7

```

##### wsl ifconfig:

```
# cxxu @ CxxuWin11 in /mnt/d/repos/PythonLearn on git:main x [10:10:51]
$ hostname -I|sed 's/ /\n/g'
172.29.112.1
192.168.6.1
192.168.80.1
192.168.43.165
2409:8928:43e:37f:80f7:126e:ce36:c456
2409:8928:43e:37f:1161:ead4:eecf:fe7
```

> 可见,两者扫描到的ip基本是一致的

#### 对比hostname -I & ifconfig

```
[oh-my-zsh] Random theme 'rkj-repos' loaded┌─[cxxu@u12] - [~] - [2022-04-14 09:39:45]
└─[0] <> hostname -I
192.168.80.137
┌─[cxxu@u12] - [~] - [2022-04-14 09:39:50]
└─[0] <> ifconfig
eth0      Link encap:Ethernet  HWaddr 00:0c:29:a7:7e:ec
          inet addr:192.168.80.137  Bcast:192.168.80.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fea7:7eec/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:164505 errors:30 dropped:0 overruns:0 frame:0
          TX packets:97613 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:163365568 (163.3 MB)  TX bytes:9450427 (9.4 MB)
          Interrupt:19 Base address:0x2000

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:11204 errors:0 dropped:0 overruns:0 frame:0
          TX packets:11204 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:908564 (908.5 KB)  TX bytes:908564 (908.5 KB)

```

### ip command

>  `ip`命令可以执行查看/配置等操作

```bash
NAME
       ip - show / manipulate routing, network devices, interfaces and tunnels
       
SYNOPSIS
       ip [ OPTIONS ] OBJECT { COMMAND | help }

       ip [ -force ] -batch filename

       OBJECT := { link | address | addrlabel | route | rule | neigh | ntable | tunnel |
               tuntap | maddress | mroute | mrule | monitor | xfrm | netns | l2tp |
               tcp_metrics | token | macsec }

       OPTIONS := { -V[ersion] | -h[uman-readable] | -s[tatistics] | -d[etails] |
               -r[esolve] | -iec | -f[amily] { inet | inet6 | ipx | dnet | link } | -4 |
               -6 | -I | -D | -B | -0 | -l[oops] { maximum-addr-flush-attempts } |
               -o[neline] | -rc[vbuf] [size] | -t[imestamp] | -ts[hort] | -n[etns] name
               | -a[ll] | -c[olor] -br[ief] }
               
               
               
               

```



#### 用法

```bash
# cxxu @ CxxuWin11 in /mnt/c/Users/cxxu [10:02:20]
$ cheat ip
# To display all interfaces with addresses:
ip addr

# To take down / up the wireless adapter:
ip link set dev wlan0 {up|down}

# To set a static IP and netmask:
ip addr add 192.168.1.100/32 dev eth0

# To remove a IP from an interface:
ip addr del 192.168.1.100/32 dev eth0

# To remove all IPs from an interface:
ip address flush dev eth0

# To display all routes:
ip route

# To display all routes for IPv6:
ip -6 route

# To add default route via gateway IP:
ip route add default via 192.168.1.1

# To add route via interface:
ip route add 192.168.0.0/24 dev eth0

# To get the route used for an destination
ip route get to 8.8.8.8

# To change your mac address :
ip link set dev eth0 address aa:bb:cc:dd:ee:ff

# To view neighbors (using ARP and NDP):
ip neighbor show
```

## windows:通过域名查找ip

####  ping

-  有时获取的地址似乎不可用

- ```
  PS D:\repos\scripts> ping www.baidu.com
  
  Pinging www.a.shifen.com [36.152.44.95] with 32 bytes of data:
  Reply from 36.152.44.95: bytes=32 time=28ms TTL=53
  Reply from 36.152.44.95: bytes=32 time=30ms TTL=53
  Reply from 36.152.44.95: bytes=32 time=242ms TTL=53
  Reply from 36.152.44.95: bytes=32 time=35ms TTL=53
  
  Ping statistics for 36.152.44.95:
      Packets: Sent = 4, Received = 4, Lost = 0 (0% loss),
  Approximate round trip times in milli-seconds:
      Minimum = 28ms, Maximum = 242ms, Average = 83ms
      
  
  ```

- ```
  # linux
  
  #( 04/14/22@10:49AM )( cxxu@CxxuWin11 ):/mnt/d/repos/PythonLearn@main✗✗✗
     ping www.baidu.com
  PING www.a.shifen.com (36.152.44.95): 56 data bytes
  64 bytes from 36.152.44.95: icmp_seq=0 ttl=53 time=39.712 ms
  64 bytes from 36.152.44.95: icmp_seq=1 ttl=53 time=72.160 ms
  64 bytes from 36.152.44.95: icmp_seq=2 ttl=53 time=60.708 ms
  64 bytes from 36.152.44.95: icmp_seq=3 ttl=53 time=45.045 ms
  ```

- > wsl:
  >
  > ```bash
  > sudo apt upgrade ping
  > Reading package lists... Done
  > Building dependency tree... Done
  > Reading state information... Done
  > Package ping is a virtual package provided by:
  >   iputils-ping 3:20211215-1
  >   inetutils-ping 2:2.2-2
  > You should explicitly select one to install.
  > ```
  >
  > > 可见,ping命令需要通过安装`inetutils-ping`来使用

> linux/windows 都有nslookup/ping命令

### nslookup linux

- [nslookup Command in Linux: 7 Practical Examples (linuxhandbook.com)](https://linuxhandbook.com/nslookup-command/#:~:text=Examples of nslookup command in Linux. 1 1.,Display all DNS records with nslookup. More items)

```

# cxxu @ CxxuWin11 in /mnt/d/repos/PythonLearn on git:main x [10:29:27] C:130
$ nslookup www.baidu.com
Server:         192.168.43.1
Address:        192.168.43.1#53

Non-authoritative answer:
www.baidu.com   canonical name = www.a.shifen.com.
Name:   www.a.shifen.com
Address: 36.152.44.96
Name:   www.a.shifen.com
Address: 36.152.44.95


# cxxu @ CxxuWin11 in /mnt/d/repos/PythonLearn on git:main x [10:29:35]
$ nslookup www.weibo.com
Server:         192.168.43.1
Address:        192.168.43.1#53

Non-authoritative answer:
www.weibo.com   canonical name = weibo.com.
Name:   weibo.com
Address: 39.156.6.91
Name:   weibo.com
Address: 39.156.6.90
Name:   weibo.com
Address: 2409:8c00:8421:1f01::30
Name:   weibo.com
Address: 2409:8c00:8421:1f01::31
```



### nslookup winodws

```
PS D:\repos\scripts> nslookup www.zhihu.com
Server:  UnKnown
Address:  192.168.43.1

Non-authoritative answer:
Name:    1595096.sched.d0-dk.tdnsdp1.cn
Addresses:  2409:8c30:1000:40:65::
          2409:8c38:80:181::3c
          2409:8c20:6ed1:10e:6d::
          2409:8c20:6ed1:10e:6e::
          2409:8c20:6ed1:10e:6f::
          2409:8c20:6ed1:10e:70::
          2409:8c30:1000:40:62::
          2409:8c30:1000:40:63::
          2409:8c30:1000:40:64::
          112.17.58.159
          117.148.161.194
Aliases:  www.zhihu.com
          www.zhihu.com.ipv6.dsa.dnsv1.com


PS D:\repos\scripts> nslookup www.weibo.com
Server:  UnKnown
Address:  192.168.43.1

Non-authoritative answer:
Name:    weibo.com
Addresses:  2409:8c00:8421:1f01::31
          2409:8c00:8421:1f01::30
          39.156.6.91
          39.156.6.90
Aliases:  www.weibo.com


PS D:\repos\scripts>
```



## 路由跟踪(trace route)

### reference

- [Tracert on Windows Returns Slower than on Linux - Stack Overflow](https://stackoverflow.com/questions/5574205/tracert-on-windows-returns-slower-than-on-linux)
- [How to Use TRACERT to Troubleshoot TCP/IP Problems in Windows (microsoft.com)](https://support.microsoft.com/en-us/topic/how-to-use-tracert-to-troubleshoot-tcp-ip-problems-in-windows-e643d72b-2f4f-cdd6-09a0-fd2989c7ca8e)
- [How to Read a Traceroute – InMotion Hosting Support Center](https://www.inmotionhosting.com/support/server/ssh/read-traceroute/)

### How to Use the TRACERT Utility

> - tracert(windows) 通过发送icmp数据包来跟踪路由
> - 用RTT显示结果
> - 跟据TTL来计算

- The TRACERT diagnostic utility determines the route to a destination by sending Internet Control Message Protocol (ICMP) echo packets to the destination. 
  - In these packets, TRACERT uses varying IP `Time-To-Live (TTL)` values. 
    - Because each `router` along the path is required to d`ecrement the packet's TTL by at least 1` before forwarding the packet, 
  - the` TTL` is effectively a `hop counter`. 
  - When the TTL on a packet reaches zero (0), the router `sends an ICMP "Time Exceeded" message back` to the source computer.



- TRACERT sends` the first echo packet with a TTL of 1 `and increments the TTL by 1 on each subsequent transmission发送, until the destination `responds` or until `the maximum TTL is reached`. 
  - The ICMP "Time Exceeded" messages that `intermediate routers `send back show the route. 
  - Note however that some routers `silently drop packets that have expired TTLs`, and these packets are `invisible` to TRACERT.



- TRACERT prints out `an ordered list of the intermediate routers that return ICMP "Time Exceeded" messages.`
  -  Using the -d option with the tracert command instructs TRACERT `not to perform a DNS lookup` on each IP address, so that TRACERT reports the IP address of **the near-side interface of the routers**.

### tracert(windows)&traceroute(unix-like)

>The Windows `tracert` tool sends [ICMP echo requests](http://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/tracert.mspx?mfr=true); many routers will just `DROP` ICMP echo requests. Thus the tool must wait for an internal timeout before declaring that route dead.
>
>The Linux `traceroute` tool sends UDP connection attempts; routers have to forward these packets, so it works pretty reliably. This means the tool won't have to wait for timeouts from most of the routers along the way.

> The Windows `tracert` waits about 1 second between hops. The Linux `traceroute` does not wait between hops. There is no documented option for the Windows `tracert` to disable this delay.

##### example of tracert

```powershelll
PS D:\repos\scripts> tracert -d www.weibo.com

Tracing route to weibo.com [2409:8c00:8421:1f01::31]
over a maximum of 30 hops:

  1     8 ms    12 ms    12 ms  2409:8928:43e:37f::99
  2     *        *        *     Request timed out.
  3   206 ms    25 ms    29 ms  2409:8028:5000:32::4016
  4     *        *        *     Request timed out.
  5     *        *        *     Request timed out.
  6     *        *        *     Request timed out.
  7     *        *        *     Request timed out.
  8     *        *        *     Request timed out.
  9     *        *        *     Request timed out.
 10     *        *        *     Request timed out.
 11     *        *        *     Request timed out.
 12     *        *        *     Request timed out.
 13     *        *        *     Request timed out.
 14    95 ms    58 ms    47 ms  2409:8c00:8421:1f01::31
 
Trace complete.
```

> 实验过程中,tracert 每次仅发送1个数据包

#### example of traceroute

```bash
#( 04/14/22@ 1:34PM )( cxxu@CxxuWin11 ):/mnt/c/Users/cxxu
   traceroute www.weibo.com
traceroute to www.weibo.com (39.156.6.90), 30 hops max, 60 byte packets
 1  * * *
 2  * * *
 3  * * *
 4  * * *
 5  * * *
 6  *
 (3*5+1=16)
 
 #( 04/14/22@ 1:39PM )( cxxu@cxxuAli ):~
   traceroute www.zhihu.com
traceroute to www.zhihu.com (103.18.209.53), 30 hops max, 60 byte packets
 1  10.36.92.62 (10.36.92.62)  2.055 ms 10.36.100.62 (10.36.100.62)  2.020 ms 10.36.96.62 (10.36.96.62)  2.269 ms
 2  * * 10.36.104.1 (10.36.104.1)  5.983 ms
 3  11.94.60.241 (11.94.60.241)  2.002 ms 10.255.59.221 (10.255.59.221)  1.769 ms 10.102.248.130 (10.102.248.130)  1.930 ms
 4  * 11.94.130.145 (11.94.130.145)  3.862 ms 10.102.249.26 (10.102.249.26)  4.087 ms
 5  10.102.155.62 (10.102.155.62)  2.896 ms * 10.102.155.122 (10.102.155.122)  3.521 ms
 6  36.110.169.217 (36.110.169.217)  4.324 ms 106.39.196.29 (106.39.196.29)  4.553 ms 106.38.196.221 (106.38.196.221)  4.624 ms
 7  36.110.246.221 (36.110.246.221)  5.260 ms 36.110.246.209 (36.110.246.209)  4.904 ms 36.110.251.70 (36.110.251.70)  5.197 ms
 8  * 106.38.244.38 (106.38.244.38)  6.649 ms  6.594 ms
 9  103.18.209.53 (103.18.209.53)  5.230 ms 106.38.244.38 (106.38.244.38)  6.092 ms 103.18.209.53 (103.18.209.53)  5.283 ms
 
 
```

> - Traceroute sends out three packets per TTL increment. 
> - Each column corresponds to the time is took to `get one packet back` (round-trip-time).
>
> This tries to `account for situations` such as:
>
> - A traceroute packet is routed along a different link than other attempts
>
>   11 130.117.3.201 (130.117.3.201) 109.762 ms 130.117.49.197 (130.117.49.197) 118.191 ms 107.262 ms
>
> - A traceroute packet is dropped
>
>   9 154.54.26.142 (154.54.26.142) 104.153 ms * *

> - 可见,traceroute 每次发送16个信息包
> - 可以指定最大跳数
>   - 但是如果再最大跳数之间就路由到了终点主机,就会提前停止

### 解读tracert(windows)/traceroute(linux)

- [How to Read a Traceroute – InMotion Hosting Support Center](https://www.inmotionhosting.com/support/server/ssh/read-traceroute/)

- [networking - What do the three columns in traceroute output mean? - Server Fault](https://serverfault.com/questions/6403/what-do-the-three-columns-in-traceroute-output-mean)

- ```
  PS D:\repos\scripts> tracert -d www.weibo.com
  
  Tracing route to weibo.com [2409:8c00:8421:1f01::31]
  over a maximum of 30 hops:
  
    1     8 ms    12 ms    12 ms  2409:8928:43e:37f::99
    2     *        *        *     Request timed out.
    3   206 ms    25 ms    29 ms  2409:8028:5000:32::4016
    4     *        *        *     Request timed out.
    5     *        *        *     Request timed out.
    6     *        *        *     Request timed out.
    7     *        *        *     Request timed out.
  ```

  - 第一列代表该行是路由(路径)的第几跳
  - 第2~4三列表示,tracert对每一条都会发送三个数据包来检测一致性(RTT含义为(round trip time))
  - 最后一列表示该跳的ip/hostname



