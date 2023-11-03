# Linux必学的60个命令(4)-网络操作

Linux必学的60个命令：网络操作命令

Linux必学的网络操作命令 （1）

作者：曹元其 发文时间：2004.11.18

因为Linux系统是在Internet上起源和发展的，它与生俱来拥有强大的网络功能和丰富

的网络应用软件，尤其是TCP/IP网络协议的实现尤为成熟。Linux的网络命令比较多，其中

一些命令像ping、
ftp、telnet、route、netstat等在其它操作系统上也能看到，但也有一

些Unix/Linux系统独有的命令，如ifconfig、
finger、mail等。Linux网络操作命令的一个

特点是，命令参数选项和功能很多，一个命令往往还可以实现其它命令的功能。

ifconfig

1.作用

ifconfig用于查看和更改网络接口的地址和参数，包括IP地址、网络掩码、广播地址，

使用权限是超级用户。

2.格式

ifconfig -interface \[options\] address

3.主要参数

-interface：指定的网络接口名，如eth0和eth1。

up：激活指定的网络接口卡。

down：关闭指定的网络接口。

broadcast address：设置接口的广播地址。

pointopoint：启用点对点方式。

address：设置指定接口设备的IP地址。

netmask address：设置接口的子网掩码。

4.应用说明

ifconfig是用来设置和配置网卡的命令行工具。为了手工配置网络，这是一个必须掌握

的命令。使用该命令的好处是无须重新启动机器。要赋给eth0接口IP地址207.164.186.2，

并且马上激活它，使用下面命令：

#fconfig eth0 210.34.6.89 netmask 255.255.255.128 broadcast 210.34.6.127

该命令的作用是设置网卡eth0的IP地址、网络掩码和网络的本地广播地址。若运行不

带任何参数的ifconfig命令，这个命令将显示机器所有激活接诘男畔ⅰ４小?a"参数的

命令则显示所有接口的信息，包括没有激活的接口。注意，用ifconfig命令配置的网络设备

参数，机器重新启动以后将会丢失。

如果要暂停某个网络接口的工作，可以使用down参数：

#ifconfig eth0 down

ip

1.作用

ip是iproute2软件包里面的一个强大的网络配置工具，它能够替代一些传统的网络管理

工具，例如ifconfig、route等，使用权限为超级用户。几乎所有的Linux发行版本都支持该

命令。

2.格式

ip \[OPTIONS\] OBJECT \[COMMAND \[ARGUMENTS\]\]

3.主要参数

OPTIONS是修改ip行为或改变其输出的选项。所有的选项都是以-字符开头，分为长、短

两种形式。目前，ip支持如表1所示选项。

OBJECT是要管理者获取信息的对象。目前ip认识的对象见表2所示。

表1 ip支持的选项

-V,-Version 打印ip的版本并退出。

-s,-stats,-statistics
输出更为详尽的信息。如果这个选项出现两次或多次，则输出的

信息将更为详尽。

-f,-family
这个选项后面接协议种类，包括inet、inet6或link，强调使用的协议种

类。如果没有足够的信息告诉ip使用的协议种类，ip就会使用默认值inet或any。link比较

特殊，它表示不涉及任何网络协议。

-4 是-family inet的简写。

-6 是-family inet6的简写。

-0 是-family link的简写。

-o,-oneline
对每行记录都使用单行输出，回行用字符代替。如果需要使用wc、grep等

工具处理ip的输出，则会用到这个选项。

-r,-resolve 查询域名解析系统，用获得的主机名代替主机IP地址

COMMAND
设置针对指定对象执行的操作，它和对象的类型有关。一般情况下，ip支持对

象的增加(add)、删除(delete)和展示(show或list)。有些对象不支持这些操作，或者有其

它的一些命令。对于所有的对象，用户可以使用help命令获得帮助。这个命令会列出这个对

象支持的命令和参数的语法。如果没有指定对象的操作命令，ip会使用默认的命令。一般情

况下，默认命令是list，如果对象不能列出，就会执行help命令。

ARGUMENTS 是命令的一些参数，它们倚赖于对象和命令。ip支持两种类型的参数：

flag和parameter。flag由一个关键词组成；parameter由一个关键词加一个数值组成。为了

方便，每个命令都有一个可以忽略的默认参数。例如，参数dev是ip
link命令的默认参数，

因此ip link ls eth0等于ip link ls dev
eth0。我们将在后面的详细介绍每个命令的使用

，命令的默认参数将使用default标出。

4.应用实例

添加IP地址192.168.2.2/24到eth0网卡上：

#ip addr add 192.168.1.1/24 dev eth0

丢弃源地址属于192.168.2.0/24网络的所有数据报：

#ip rule add from 192.168.2.0/24 prio 32777 reject

ping

1.作用

ping检测主机网络接口状态，使用权限是所有用户。

2.格式

ping \[-dfnqrRv\]\[-c\]\[-i\]\[-I\]\[-l\]\[-p\]\[-s\]\[-t\] IP地址

3.主要参数

-d：使用Socket的SO_DEBUG功能。

-c：设置完成要求回应的次数。

-f：极限检测。

-i：指定收发信息的间隔秒数。

-I：网络界面使用指定的网络界面送出数据包。

-l：前置载入，设置在送出要求信息之前，先行发出的数据包。

-n：只输出数值。

-p：设置填满数据包的范本样式。

-q：不显示指令执行过程，开头和结尾的相关信息除外。

-r：忽略普通的Routing Table，直接将数据包送到远端主机上。

-R：记录路由过程。

-s：设置数据包的大小。

-t：设置存活数值TTL的大小。

-v：详细显示指令的执行过程。

ping
命令是使用最多的网络指令，通常我们使用它检测网络是否连通，它使用ICMP协

议。但是有时会有这样的情况，我们可以浏览器查看一个网页，但是却无法
ping通，这是

因为一些网站处于安全考虑安装了防火墙。另外，也可以在自己计算机上试一试，通过下面

的方法使系统对ping没有反应：

\# echo 1 \> /proc/sys/net/ipv4/icmp_echo_ignore_all

netstat

1.作用

检查整个Linux网络状态。

2.格式

netstat \[-acCeFghilMnNoprstuvVwx\]\[-A\]\[\--ip\]

3.主要参数

-a\--all：显示所有连线中的Socket。

-A：列出该网络类型连线中的IP相关地址和网络类型。

-c\--continuous：持续列出网络状态。

-C\--cache：显示路由器配置的快取信息。

-e\--extend：显示网络其它相关信息。

-F\--fib：显示FIB。

-g\--groups：显示多重广播功能群组组员名单。

-h\--help：在线帮助。

-i\--interfaces：显示网络界面信息表单。

-l\--listening：显示监控中的服务器的Socket。

-M\--masquerade：显示伪装的网络连线。

-n\--numeric：直接使用IP地址，而不通过域名服务器。

-N\--netlink\--symbolic：显示网络硬件外围设备的符号连接名称。

-o\--timers：显示计时器。

-p\--programs：显示正在使用Socket的程序识别码和程序名称。

-r\--route：显示Routing Table。

-s\--statistice：显示网络工作信息统计表。

-t\--tcp：显示TCP传输协议的连线状况。

-u\--udp：显示UDP传输协议的连线状况。

-v\--verbose：显示指令执行过程。

-V\--version：显示版本信息。

-w\--raw：显示RAW传输协议的连线状况。

-x\--unix：和指定"-A unix"参数相同。

\--ip\--inet：和指定"-A inet"参数相同。

4.应用实例

netstat
主要用于Linux察看自身的网络状况，如开启的端口、在为哪些用户服务，以

及服务的状态等。此外，它还显示系统路由表、网络接口状态等。可以说，它是一个综合性

的网络状态的察看工具。在默认情况下，netstat只显示已建立连接的端口。如果要显示处

于监听状态的所有端口，使用-a参数即可：

#netstat -a

Active Internet connections (only servers)

Proto Recv-Q Send-Q Local Address Foreign Address State

tcp 0 0 \*:32768 \*:\* LISTEN

tcp 0 0 \*:32769 \*:\* LISTEN

tcp 0 0 \*:nfs \*:\* LISTEN

tcp 0 0 \*:32770 \*:\* LISTEN

tcp 0 0 \*:868 \*:\* LISTEN

tcp 0 0 \*:617 \*:\* LISTEN

tcp 0 0 \*:mysql \*:\* LISTEN

tcp 0 0 \*:netbios-ssn \*:\* LISTEN

tcp 0 0 \*:sunrpc \*:\* LISTEN

tcp 0 0 \*:10000 \*:\* LISTEN

tcp 0 0 \*:http \*:\* LISTEN

\...\...

上面显示出，这台主机同时提供HTTP、FTP、NFS、MySQL等服务。

telnet

1.作用

telnet表示开启终端机阶段作业，并登入远端主机。telnet是一个Linux命令，同时也

是一个协议（远程登陆协议）。

2.格式

telnet
\[-8acdEfFKLrx\]\[-b\]\[-e\]\[-k\]\[-l\]\[-n\]\[-S\]\[-X\]\[主机名称IP地址\<通信端口>\]

3.主要参数

-8：允许使用8位字符资料，包括输入与输出。

-a：尝试自动登入远端系统。

-b：使用别名指定远端主机名称。

-c：不读取用户专属目录里的.telnetrc文件。

-d：启动排错模式。

-e：设置脱离字符。

-E：滤除脱离字符。

-f：此参数的效果和指定"-F"参数相同。

-F：使用Kerberos
V5认证时，加上此参数可把本地主机的认证数据上传到远端主机。

-k：使用Kerberos认证时，加上此参数让远端主机采用指定的领域名，而非该主机的域名。

-K：不自动登入远端主机。

-l：指定要登入远端主机的用户名称。

-L：允许输出8位字符资料。

-n：指定文件记录相关信息。

-r：使用类似rlogin指令的用户界面。

-S：服务类型，设置telnet连线所需的IP TOS信息。

-x：假设主机有支持数据加密的功能，就使用它。

-X：关闭指定的认证形态。

4.应用说明

用户使用telnet命令可以进行远程登录，并在远程计算机之间进行通信。用户通过网

络在远程计算机上登录，就像登录到本地机上执行命令一样。为了通过
telnet登录到远程

计算机上，必须知道远程机上的合法用户名和口令。虽然有些系统确实为远程用户提供登录

功能，但出于对安全的考虑，要限制来宾的操作权限，因此，这种情况下能使用的功能是很

少的。

telnet只为普通终端提供终端仿真，而不支持X-Window等图形环境。当允许远程用户登

录时，系统通常把这些用户放在一个受限制的Shell中，以防系统被怀有恶意的或不小心的

用户破坏。用户还可以使用telnet从远程站点登录到自己的计算机上，检查电子邮件、编辑

文件和运行程序，就像在本地登录一样。

ftp

1.作用

ftp命令进行远程文件传输。FTP是ARPANet的标准文件传输协议，该网络就是现今

Internet的前身，所以ftp既是协议又是一个命令。

2.格式

ftp \[-dignv\]\[主机名称IP地址\]

3.主要参数

-d：详细显示指令执行过程，便于排错分析程序执行的情形。

-i：关闭互动模式，不询问任何问题。

-g：关闭本地主机文件名称支持特殊字符的扩充特性。

-n：不使用自动登陆。

-v：显示指令执行过程。

4.应用说明

ftp
命令是标准的文件传输协议的用户接口，是在TCP/IP网络计算机之间传输文件简单

有效的方法，它允许用户传输ASCⅡ文件和二进制文件。为了使用ftp
来传输文件，用户必

须知道远程计算机上的合法用户名和口令。这个用户名/口令的组合用来确认ftp会话，并用

来确定用户对要传输的文件进行什么样的访问。另外，用户需要知道对其进行ftp会话的计

算机名字的IP地址。

用户可以通过使用ftp客户程序，连接到另一台计算机上；可以在目录中上下移动、列

出目录内容；可以把文件从远程计算机机拷贝到本地机上；还可以把文件从本地机传输到远

程系统中。ftp内部命令有72个，下面列出主要几个内部命令：

ls：列出远程机的当前目录。

cd：在远程机上改变工作目录。

lcd：在本地机上改变工作目录。

close：终止当前的ftp会话。

hash：每次传输完数据缓冲区中的数据后就显示一个#号。

get（mget）：从远程机传送指定文件到本地机。

put（mput）：从本地机传送指定文件到远程机。

quit：断开与远程机的连接，并退出ftp。

route

1.作用

route表示手工产生、修改和查看路由表。

2.格式

#route \[-add\]\[-net\|-host\] targetaddress \[-netmask Nm\]\[dev\]If\]

#route \[－delete\]\[-net\|-host\] targetaddress \[gw Gw\] \[-netmask
Nm\] \[dev\]If\]

3.主要参数

-add：增加路由。

-delete：删除路由。

-net：路由到达的是一个网络，而不是一台主机。

-host：路由到达的是一台主机。

-netmask Nm：指定路由的子网掩码。

gw：指定路由的网关。

\[dev\]If：强迫路由链指定接口。

4.应用实例

route命令是用来查看和设置Linux系统的路由信息，以实现与其它网络的通信。要实现两个

不同的子网之间的通信，需要一台连接两个网络的路由器，或者同时位于两个网络的网关来

实现。

在Linux系统中，设置路由通常是为了解决以下问题：该Linux系统在一个局域网中，局

域网中有一个网关，能够让机器访问Internet，那么就需要将这台机器的IP地址设置为

Linux机器的默认路由。使用下面命令可以增加一个默认路由：

route add 0.0.0.0 192.168.1.1

rlogin

1.作用

rlogin用来进行远程注册。

2.格式

rlogin \[ -8EKLdx \] \[ -e char \] \[-k realm \] \[ - l username \] host

3.主要参数

-8：此选项始终允许8位输入数据通道。该选项允许发送格式化的ANSI字符和其它的特

殊代码。如果不用这个选项，除非远端的不是终止和启动字符，否则就去掉奇偶校验位。

-E：停止把任何字符当作转义字符。当和-8选项一起使用时，它提供一个完全的透明连

接。

-K：关闭所有的Kerberos确认。只有与使用Kerberos
确认协议的主机连接时才使用这

个选项。

-L：允许rlogin会话在litout模式中运行。要了解更多信息，请查阅tty联机帮助。

-d：打开与远程主机进行通信的TCP
sockets的socket调试。要了解更多信息，请查阅

setsockopt的联机帮助。

-e：为rlogin会话设置转义字符，默认的转义字符是"～"。

-k：请求rlogin获得在指定区域内远程主机的Kerberos许可，而不是获得由

krb_realmofhost(3)确定的远程主机区域内的远程主机的Kerberos许可。

-x：为所有通过rlogin会话传送的数据打开DES加密。这会影响响应时间和CPU利用率，

但是可以提高安全性。

4.使用说明

如果在网络中的不同系统上都有账号，或者可以访问别人在另一个系统上的账号，那么

要访问别的系统中的账号，首先就要注册到系统中，接着通过网络远程注册到账号所在的系

统中。rlogin可以远程注册到别的系统中，它的参数应是一个系统名。

rcp

1.作用

rcp代表远程文件拷贝，用于计算机之间文件拷贝，使用权限是所有用户。

2.格式

rcp \[-px\] \[-k realm\] file1 file2 rcp \[-px\] \[-r\] \[-k realm\]
file

3.主要参数

-r：递归地把源目录中的所有内容拷贝到目的目录中。要使用这个选项，目的必须是一

个目录。

-p：试图保留源文件的修改时间和模式，忽略umask。

-k：请求rcp获得在指定区域内的远程主机的Kerberos许可，而不是获得由

krb_relmofhost(3)确定的远程主机区域内的远程主机的Kerberos许可。

-x：为传送的所有数据打开DES加密。

finger

1.作用

finger用来查询一台主机上的登录账号的信息，通常会显示用户名、主目录、停滞时间

、登录时间、登录Shell等信息，使用权限为所有用户。

2.格式

finger \[选项\] \[使用者\] \[用户\@主机\]

3.主要参数

-s：显示用户注册名、实际姓名、终端名称、写状态、停滞时间、登录时间等信息。

-l：除了用-s选项显示的信息外，还显示用户主目录、登录Shell、邮件状态等信息，

以及用户主目录下的.plan、.project和.forward文件的内容。

-p：除了不显示.plan文件和.project文件以外，与-l选项相同。

4.应用实例

在计算机上使用finger：

\[root\@localhost root\]\# Finger

Login Name Tty Idle Login Time Office Office Phone

root root tty1 2 Dec 15 11

root root pts/0 1 Dec 15 11

root root \*pts/1 Dec 15 11

5.应用说明

如果要查询远程机上的用户信息，需要在用户名后面接"\@主机名"，采用\[用户名\@主

机名\]的格式，不过要查询的网络主机需要运行finger守护进程的支持。

mail

1.作用

mail作用是发送电子邮件，使用权限是所有用户。此外，mail还是一个电子邮件程序。

2.格式

mail \[-s subject\] \[-c address\] \[-b address\]

mail -f \[mailbox\]mail \[-u user\]

3.主要参数

-b address：表示输出信息的匿名收信人地址清单。

-c address：表示输出信息的抄送（）收信人地址清单。

-f \[mailbox\]：从收件箱者指定邮箱读取邮件。

-s subject：指定输出信息的主体行。

\[-u user\]：端口指定优化的收件箱读取邮件。

nslookup

1.作用

nslookup命令的功能是查询一台机器的IP地址和其对应的域名。使用权限所有用户。它

通常需要一台域名服务器来提供域名服务。如果用户已经设置好域名服务器，就可以用这个

命令查看不同主机的IP地址对应的域名。

2.格式

nslookup ［IP地址/域名］

3.应用实例

（1）在本地计算机上使用nslookup命令

\$ nslookup

Default Server: name.cao.com.cn

Address: 192.168.1.9

\>

在符号">"后面输入要查询的IP地址域名，并回车即可。如果要退出该命令，输入"

exit"，并回车即可。

（2）使用nslookup命令测试named

输入下面命令：

nslookup

然后就进入交换式nslookup环境。如果named正常启动，则nslookup会显示当前DNS服务

器的地址和域名，否则表示named没能正常启动。

下面简单介绍一些基本的DNS诊断。

◆
检查正向DNS解析，在nslookup提示符下输入带域名的主机名，如hp712.my.com，

nslookup应能显示该主机名对应的IP地址。如果只输入hp712，nslookup会根据

/etc/resolv.conf的定义，自动添加my.com域名，并回答对应的IP地址。

◆检查反向DNS解析，在nslookup提示符下输入某个IP地址，如192.22.33.20，

nslookup应能回答该IP地址所对应的主机名。

◆检查MX邮件地址记录在nslookup提示符下输入：

set q=mx

然后输入某个域名，输入my.com和mail.my.com，nslookup应能够回答对应的邮件服务

器地址，即support.my.com和support2.my.com。

动手练习

1.危险的网络命令

互联网的发展使安全成为一个不能忽视的问题，finger、ftp、rcp和telnet在本质上

都是不安全的，因为它们在网络上用明文传送口令和数据，嗅探器可以非常容易地截获这些

口令和数据。而且，这些服务程序的安全验证方式也是有弱点的，很容易受到"中间服务器

"方式的攻击。这里笔者把一些不安全的命令根据危险等级列出，见表3所示。

现在ftp、telnet可以被SSH命令代替绑定在端口22上，其连接采用协商方式，使用

RSA加密。身份鉴别完成之后，后面的所有流量都使用IDEA
进行加密。SSH（Secure　

Shell）程序可以通过网络登录到远程主机，并执行命令。rcp、rlogin等远程调用命令也逐

渐被VNC软件代替。

2.在一张网卡上绑定多个IP地址

在Linux下，可以使用ifconfig方便地绑定多个IP地址到一张网卡。例如，eth0接口的

原有IP地址为192.168.0 .254，可以执行下面命令：

ifconfig eth0:0 192.168.0.253 netmask 255.255.255.0

ifconfig eth0:1 192.168.0.252 netmask 255.255.255.0

\...\...

3.修改网卡MAC地址

首先必须关闭网卡设备，命令如下：

/sbin/ifconfig eth0 down

修改MAC地址，命令如下：

/sbin/ifconfig eth0 hw ether 00:AA:BB:CC:DD:EE

重新启用网卡：

/sbin/ifconfig eht0 up

这样网卡的MAC地址就更改完成了。每张网卡的MAC地址是惟一，但不是不能修改的，只

要保证在网络中的MAC地址的惟一性就可以了。

4.初步部署IPv6

IPv4
技术在网络发展中起到了巨大的作用，不过随着时间的流逝它无论在网络地址的

提供、服务质量、安全性等方面都越来越力不从心，IPv6呼之欲出。Linux
是所有操作系统

中最先支持IPv6的，一般Linux基于2.4内核的Linux发行版本都可以直接使用IPv6，不过主

要发行版本没有加载IPv6模块，可以使用命令手工加载，需要超级用户的权限。

(1)加载IPv6模块

使用命令检测，其中inet6 addr:
fe80::5054:abff:fe34:5b09/64，就是eth0网卡的

IPv6地址。

\# modprobe IPv6

＃ifconfig

eth0 Link encap:Ethernet HWaddr 52:54:AB:34:5B:09

inet addr:192.168.1.2 Bcast:192.168.1.255 Mask:255.255.255.0

inet6 addr: fe80::5054:abff:fe34:5b09/64 Scope:Link

UP BROADCAST RUNNING MULTICAST MTU:1500 Metric:1

RX packets:0 errors:0 dropped:0 overruns:0 frame:0

TX packets:21 errors:0 dropped:0 overruns:0 carrier:0

collisions:0 txqueuelen:100

RX bytes:0 (0.0 b) TX bytes:1360 (1.3 Kb)

Interrupt:5 Base address:0xec00

(2)使用ping命令检测网卡的IPv6地址是否有效

#ping6 -I eth0 -c 2 fe80::200:e8ff:fea0:2586

和IPv4不一样，使用ping6命令时必须指定一个网卡界面，否则系统不知道将数据包发

送到哪个网络设备。I表示Interface、eth0是第一个网卡，－c表示回路，2表示ping6操作

两次。结果见图1所示。

图1 IPv6网络下的ping6命令

(3)使用ip命令在IPv6下为eth0增加一个IP地址

#ip -6 addr add 3ffe:ffff:0:f101::1/64 dev eth0

使用ifconfig命令，查看网卡是否出现第二个IPv6地址。

Linux网络的主要优点是能够实现资源和信息的共享，并且用户可以远程访问信息。

Linux提供了一组强有力的网络命令来为用户服务，这些工具能够帮助用户进行网络设定、

检查网络状况、登录到远程计算机上、传输文件和执行远程命令等。

上面介绍了Linux中比较重要的网络命令，其实Linux还有许多命令需要学习。Linux网

络操作命令的一个特点就是命令参数选项很多，并不要求全部记住，关键在于理解命令的主

要用途和学会使用帮助信息。
