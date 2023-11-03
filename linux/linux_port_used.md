[toc]

# linux_端口占用扫描port scan

[How to check if port is in use on Linux or Unix - nixCraft (cyberciti.biz)](https://www.cyberciti.biz/faq/unix-linux-check-if-port-is-in-use-command/)

1. Run any one of the following command on Linux to see open ports:

   ```bash
   sudo lsof -i -P -n | grep LISTEN
   sudo netstat -tulpn | grep LISTEN
   sudo ss -tulpn | grep LISTEN
   sudo lsof -i:22 ## see a specific port such as 22 ##
   sudo nmap -sTU -O IP-address-Here
   ```

   

## lsof

> lsof (8)             - list open files

### root权限

> 如果不用root权限,那么扫描结果将为空!

```bash
Description      :
      An open file may be a regular file, a directory, a block special file, a character special file, an executing text reference, a library, a stream or a network  file  (Internet
       socket, NFS file or UNIX domain socket.)  A specific file or all the files in a file system may be selected by path.

       Instead  of  a formatted display, lsof will produce output that can be parsed by other programs.  See the -F, option description, and the OUTPUT FOR OTHER PROGRAMS section for
       more information.

       In addition to producing a single output list, lsof will run in repeat mode.  In repeat mode it will produce output, delay, then repeat the output operation until stopped with
       an interrupt or quit signal.  See the +|-r [t[m<fmt>]] option description for more information.

┌─[cxxu@cxxuAli] - [~/djangoProjs] - [2022-06-05 09:54:45]
└─[0] <git:(main 881ac45✱✈) > manly lsof -iPn

lsof - list open files
======================

      -i [i]   selects  the  listing  of  files any of whose Internet address
                matches the address specified in i.  If no address  is  speci‐
                fied, this option selects the listing of all Internet and x.25
                (HP-UX) network files.

                    -i6 - IPv6 only
                     TCP:25 - TCP and port 25
                     @1.2.3.4 - Internet IPv4 host address 1.2.3.4
                     @[3ffe:1ebc::1]:1234 - Internet IPv6 host address
                          3ffe:1ebc::1, port 1234
                     UDP:who - UDP who service port
                     TCP@lsof.itap:513 - TCP, port 513 and host name lsof.itap
                     tcp@foo:1-10,smtp,99 - TCP, ports 1 through 10,
                          service name smtp, port 99, host name foo
                     tcp@bar:1-smtp - TCP, ports 1 through smtp, host bar
                     :time - either TCP, UDP or UDPLITE time service port

      -n       inhibits  the  conversion of network numbers to host names for
                network  files.   Inhibiting  conversion  may  make  lsof  run
                faster.   It is also useful when host name lookup is not work‐
                ing properly.

      -P       inhibits the conversion of port numbers to port names for net‐
                work files.  Inhibiting the conversion may  make  lsof  run  a
                little faster.  It is also useful when port name lookup is not
                working properly.

                    -iTCP -sTCP:LISTEN

                    -iUDP -sUDP:Idle
```

### example



#### lsof & grep

```bash
┌─[cxxu@cxxuAli] - [~/djangoProjs] - [2022-06-05 09:58:06]
└─[0] <git:(main 881ac45✱✈) > sudo lsof -i -P -n |grep 9000
webhook   15407            root    3u  IPv6 21727403      0t0  TCP *:9000 (LISTEN)
┌─[cxxu@cxxuAli] - [~/djangoProjs] - [2022-06-05 09:58:34]
└─[0] <git:(main 881ac45✱✈) > sudo lsof -i -P -n |grep 3306
mysqld     1795           mysql   21u  IPv6    36196      0t0  TCP *:33060 (LISTEN)
mysqld     1795           mysql   37u  IPv6    36376      0t0  TCP *:3306 (LISTEN)
```

```bash
┌─[cxxu@cxxuAli] - [~/djangoProjs] - [2022-06-05 10:01:50]
└─[1] <git:(main 881ac45✱✈) > sudo lsof -i -P -n |grep AliYun
AliYunDun  1806            root   17u  IPv4    25221      0t0  TCP 172.16.27.115:33784->100.100.30.25:80 (ESTABLISHED)

┌─[cxxu@cxxuAli] - [~/djangoProjs] - [2022-06-05 10:01:57]
└─[0] <git:(main 881ac45✱✈) > sudo lsof -i -P -n |grep sshd
sshd        828            root    3u  IPv4    20786      0t0  TCP *:22 (LISTEN)

sshd      13847            root    3u  IPv4 21719320      0t0  TCP 172.16.27.115:22->223.104.160.95:24743 (ESTABLISHED)
sshd      13868            cxxu    3u  IPv4 21719320      0t0  TCP 172.16.27.115:22->223.104.160.95:24743 (ESTABLISHED)
sshd      13899            root    3u  IPv4 21720007      0t0  TCP 172.16.27.115:22->223.104.160.95:24744 (ESTABLISHED)
sshd      13920            cxxu    3u  IPv4 21720007      0t0  TCP 172.16.27.115:22->223.104.160.95:24744 (ESTABLISHED)
```





- **sshd** is the name of the application.
- **172.xxx or (*: for all ip)** is the IP address to which sshd application bind to (LISTEN)
- **22** is the TCP port that is being used (LISTEN)
- **85379** is the process ID of the sshd process



## netstat&ss

> ss &netstat不需要root权限,就可以返回结果

### netstat

- 主要用法

- > NAME
  >        netstat - Print network connections, routing tables, interface statistics, masquerade connections, and multicast memberships
  >
  > DESCRIPTION
  >        Netstat prints information about the Linux networking subsystem. 
  >
  >  The type of information printed is controlled by the first argument, as follows:
  >
  >    (none)
  >        By default, netstat displays a list of open sockets.  If you don't specify any address families, then the active sockets of all configured address families will be printed.
  >
  >    --route, -r
  >        Display the kernel routing tables. See the description in route(8) for details.  netstat -r and route -e produce the same output.
  >
  >    --groups, -g
  >        Display multicast group membership information for IPv4 and IPv6.
  >
  >    --interfaces, -i
  >        Display a table of all network interfaces.
  >
  >    --masquerade, -M
  >        Display a list of masqueraded connections.
  >
  >    --statistics, -s
  >        Display summary statistics for each protocol.

- <u>***The netstat command deprecated for some time on Linux.***</u>

```bash
┌─[cxxu@cxxuAli] - [~/djangoProjs] - [2022-06-05 10:10:55]
└─[0] <git:(main 881ac45✱✈) > manly netstat -tulpn

netstat  - Print network connections, routing tables, interface statis‐
=======================================================================

   --numeric,-n
       Show numerical addresses instead of trying to determine symbolic  host,
       port or user names.

  -p, --program
       Show the PID and name of the program to which each socket belongs.

  -l, --listening
       Show only listening sockets.  (These are omitted by default.)
```

#### examples

- 检查9000端口的情况

```bash
┌─[cxxu@cxxuAli] - [~] - [2022-06-06 09:23:10]
└─[0] <> netstat -tulpn | grep 9000
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
tcp6       0      0 :::9000                 :::*                    LISTEN      -
```



### ss

> The netstat command deprecated for some time on Linux. Therefore, you need to use the ss command as follows:

- ```bash
  sudo ss -tulw
  sudo ss -tulwn
  sudo ss -tulwn | grep LISTEN
  ```

  

> NAME
>        ss - another utility to investigate sockets
>
> SYNOPSIS
>        ss [options] [ FILTER ]
>
> DESCRIPTION
>        ss is used to dump socket statistics. It allows showing information similar to netstat.  It can display more TCP and state informations than other tools.

- `sudo ss -tulwn`

  



```bash
└─[130] <git:(main 881ac45✱✈) > manly ss -tulwn

ss - another utility to investigate sockets
===========================================

      -n, --numeric
              Do not try to resolve service names.

      -l, --listening
              Display only listening sockets (these are omitted by default).

      -t, --tcp
              Display TCP sockets.

      -u, --udp
              Display UDP sockets.

      -w, --raw
              Display RAW sockets.
```

#### examples

```bash
┌─[cxxu@cxxuAli] - [~/djangoProjs] - [2022-06-05 10:15:07]
└─[0] <git:(main 881ac45✱✈) > ss -tulw
Netid              State                Recv-Q               Send-Q                                   Local Address:Port                                   Peer Address:Port
icmp6              UNCONN               0                    0                                               *%eth0:ipv6-icmp                                         *:*
udp                UNCONN               0                    0                                              0.0.0.0:ipp                                         0.0.0.0:*
udp                UNCONN               0                    0                                              0.0.0.0:34571                                       0.0.0.0:*
udp                UNCONN               0                    0                                        127.0.0.53%lo:domain                                      0.0.0.0:*
udp                UNCONN               0                    0                                   172.16.27.115%eth0:bootpc                                      0.0.0.0:*
udp                UNCONN               0                    0                                              0.0.0.0:mdns                                        0.0.0.0:*
udp                UNCONN               0                    0                                            127.0.0.1:323                                         0.0.0.0:*
udp                UNCONN               0                    0                                                 [::]:46213                                          [::]:*
udp                UNCONN               0                    0                                                 [::]:mdns                                           [::]:*
udp                UNCONN               0                    0                                                [::1]:323                                            [::]:*
tcp                LISTEN               0                    128                                          127.0.0.1:42305                                       0.0.0.0:*
tcp                LISTEN               0                    10                                           127.0.0.1:dict                                        0.0.0.0:*
tcp                LISTEN               0                    128                                            0.0.0.0:http                                        0.0.0.0:*
tcp                LISTEN               0                    128                                      127.0.0.53%lo:domain                                      0.0.0.0:*
tcp                LISTEN               0                    128                                            0.0.0.0:ssh                                         0.0.0.0:*
tcp                LISTEN               0                    5                                            127.0.0.1:ipp                                         0.0.0.0:*
tcp                LISTEN               0                    128                                          127.0.0.1:postgresql                                  0.0.0.0:*
tcp                LISTEN               0                    128                                            0.0.0.0:888                                         0.0.0.0:*
tcp                LISTEN               0                    10                                             0.0.0.0:8000                                        0.0.0.0:*
tcp                LISTEN               0                    70                                                   *:33060                                             *:*
tcp                LISTEN               0                    128                                                  *:9000                                              *:*
tcp                LISTEN               0                    128                                                  *:mysql                                             *:*
tcp                LISTEN               0                    5                                                [::1]:ipp                                            [::]:*
tcp                LISTEN               0                    128                                              [::1]:postgresql                                     [::]:*
```



## Nmap

> nmap - Network exploration tool and security / port scanner
>
> DESCRIPTION
>        Nmap (“Network Mapper”) is an open source tool for network exploration and security auditing. It was designed to rapidly scan large networks, although it works fine against
>        single hosts. Nmap uses raw IP packets in novel ways to determine what hosts are available on the network, what services (application name and version) those hosts are
>        offering, what operating systems (and OS versions) they are running, what type of packet filters/firewalls are in use, and dozens of other characteristics. While Nmap is
>        commonly used for security audits, many systems and network administrators find it useful for routine tasks such as network inventory, managing service upgrade schedules, and
>        monitoring host or service uptime.
>
> ```bash
>    The output from Nmap is a list of scanned targets, with supplemental information on each depending on the options used. Key among that information is the “interesting ports
>    table”.  That table lists the port number and protocol, service name, and state. The state is either open, filtered, closed, or unfiltered.  Open means that an application on
>    the target machine is listening for connections/packets on that port.  Filtered means that a firewall, filter, or other network obstacle is blocking the port so that Nmap
>    cannot tell whether it is open or closed.  Closed ports have no application listening on them, though they could open up at any time. Ports are classified as unfiltered when
>    they are responsive to Nmap's probes, but Nmap cannot determine whether they are open or closed. Nmap reports the state combinations open|filtered and closed|filtered when it
>    cannot determine which of the two states describe a port. The port table may also include software version details when version detection has been requested. When an IP
>    protocol scan is requested (-sO), Nmap provides information on supported IP protocols rather than listening ports.
> 
>    In addition to the interesting ports table, Nmap can provide further information on targets, including reverse DNS names, operating system guesses, device types, and MAC
>    addresses.
> 
>    A typical Nmap scan is shown in Example 1. The only Nmap arguments used in this example are -A, to enable OS and version detection, script scanning, and traceroute; -T4 for
>    faster execution; and then the hostname.
> ```

- `sudo apt install Nmap`(系统可能不自带该命令)

### example

#### Nmap&本地主机



```bash
┌─[cxxu@cxxuAli] - [~] - [2022-06-06 09:05:49]
└─[0] <> sudo nmap -sT -O localhost

Starting Nmap 7.60 ( https://nmap.org ) at 2022-06-06 09:07 CST
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000063s latency).
Other addresses for localhost (not scanned): ::1
Not shown: 992 closed ports
PORT     STATE SERVICE
22/tcp   open  ssh
80/tcp   open  http
631/tcp  open  ipp
888/tcp  open  accessbuilder
3306/tcp open  mysql
5432/tcp open  postgresql
8000/tcp open  http-alt
9000/tcp open  cslistener
Device type: general purpose
Running: Linux 2.6.X
OS CPE: cpe:/o:linux:linux_kernel:2.6.32
OS details: Linux 2.6.32
Network Distance: 0 hops

OS detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 2.35 seconds

#UDP&TCP
┌─[cxxu@cxxuAli] - [~] - [2022-06-06 09:16:30]
└─[1] <> sudo nmap -sTU -O localhost

Starting Nmap 7.60 ( https://nmap.org ) at 2022-06-06 09:16 CST
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000061s latency).
Other addresses for localhost (not scanned): ::1
Not shown: 1990 closed ports
PORT     STATE         SERVICE
22/tcp   open          ssh
80/tcp   open          http
631/tcp  open          ipp
888/tcp  open          accessbuilder
3306/tcp open          mysql
5432/tcp open          postgresql
8000/tcp open          http-alt
9000/tcp open          cslistener
631/udp  open|filtered ipp
5353/udp open|filtered zeroconf
Device type: general purpose
Running: Linux 2.6.X
OS CPE: cpe:/o:linux:linux_kernel:2.6.32
OS details: Linux 2.6.32
Network Distance: 0 hops

OS detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 4.91 seconds
```

### 扫描公网主机

> - 主机ip做了混淆
>
> - 扫描速度较慢

####  Nmap & domain

```bash
┌─[cxxu@cxxuAli] - [~] - [2022-06-06 09:17:36]
└─[0] <> sudo nmap -sTU -O www.baidu.com

Starting Nmap 7.60 ( https://nmap.org ) at 2022-06-06 09:22 CST
Nmap scan report for www.baidu.com (110.242.68.3)
Host is up (0.015s latency).
Other addresses for www.baidu.com (not scanned): 110.242.68.4
Not shown: 1000 open|filtered ports, 998 filtered ports
PORT    STATE SERVICE
80/tcp  open  http
443/tcp open  https
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Device type: specialized|proxy server
Running (JUST GUESSING): AVtech embedded (88%), Blue Coat embedded (86%)
OS CPE: cpe:/h:bluecoat:packetshaper
Aggressive OS guesses: AVtech Room Alert 26W environmental monitor (88%), Blue Coat PacketShaper appliance (86%)
No exact OS matches for host (test conditions non-ideal).

OS detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 30.87 seconds
```

#### Nmap&ip

```bash

┌─[cxxu@cxxuAli] - [~] - [2022-06-06 09:16:41]
└─[0] <> sudo nmap -sTU -O 123.56.172.67

Starting Nmap 7.60 ( https://nmap.org ) at 2022-06-06 09:17 CST
Nmap scan report for 123.56.172.67
Host is up (0.0031s latency).
Not shown: 1000 open|filtered ports, 937 filtered ports, 57 closed ports
PORT     STATE SERVICE
22/tcp   open  ssh
80/tcp   open  http
888/tcp  open  accessbuilder
3306/tcp open  mysql
8000/tcp open  http-alt
9000/tcp open  cslistener
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.60%E=4%D=6/6%OT=22%CT=3389%CU=%PV=N%G=Y%TM=629D55B0%P=x86_64-pc
OS:-linux-gnu)SEQ(SP=107%GCD=1%ISR=109%TI=Z%CI=Z%TS=A)SEQ(SP=107%GCD=1%ISR=
OS:109%TI=Z%CI=Z%II=I%TS=A)OPS(O1=M5B4ST11NW7%O2=M5B4ST11NW7%O3=M5B4NNT11NW
OS:7%O4=M5B4ST11NW7%O5=M5B4ST11NW7%O6=M5B4ST11)WIN(W1=FE88%W2=FE88%W3=FE88%
OS:W4=FE88%W5=FE88%W6=FE88)ECN(R=Y%DF=Y%TG=40%W=FAF0%O=M5B4NNSNW7%CC=Y%Q=)T
OS:1(R=Y%DF=Y%TG=40%S=O%A=S+%F=AS%RD=0%Q=)T2(R=N)T3(R=N)T4(R=Y%DF=Y%TG=40%W
OS:=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=Y%DF=Y%TG=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=
OS:)T6(R=Y%DF=Y%TG=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T7(R=Y%DF=Y%TG=40%W=0%S=Z%
OS:A=S+%F=AR%O=%RD=0%Q=)U1(R=N)IE(R=Y%DFI=N%TG=40%CD=S)


OS detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 30.13 seconds
```



- 可以使用grep过滤



## Viewing the Internet network services list(查看常用端口介绍)

> - The /etc/services is a text file mapping between **human-friendly textual names** for internet services and <u>their underlying assigned</u> **port numbers and protocol types.** 
> - Use the [cat command](https://www.cyberciti.biz/faq/linux-unix-appleosx-bsd-cat-command-examples/?utm_source=Linux_Unix_Command&utm_medium=faq&utm_campaign=nixcmd) or [more command](https://bash.cyberciti.biz/guide/More_command?utm_source=Linux_Unix_Command&utm_medium=faq&utm_campaign=nixcmd)/[less command](https://bash.cyberciti.biz/guide/Less_command?utm_source=Linux_Unix_Command&utm_medium=faq&utm_campaign=nixcmd) to view it:

- 获取帮助`man services`
  - ` services - Internet network services list`

- ```bash
  ┌─[cxxu@cxxuAli] - [~/djangoProjs] - [2022-06-05 10:08:20]
  └─[0] <git:(main 881ac45✱✈) > man services
  ```

  

```bash
└─[1] <git:(main 881ac45✱✈) > bat /etc/services|grep ssh
ssh             22/tcp                          # SSH Remote Login Protocol
```



