Linux必学的60个命令(6)-其他

Linux必学的60个命令：其它

Linux必学的重要命令 （1）

作者：曹元其 发文时间：2004.12.16

在前面几讲中，我们把Linux命令按照在系统中的作用分成几个部分分别予以介绍。但

是，还有一些命令不好划分，然而学习它们同样是比较重要的。

tar

1.作用

tar命令是Unix/Linux系统中备份文件的可靠方法，几乎可以工作于任何环境中，它的

使用权限是所有用户。

2.格式

tar \[主选项+辅选项\] 文件或目录

3.主要参数

使用该命令时，主选项是必须要有的，它告诉tar要做什么事情，辅选项是辅助使用的

，可以选用。

主选项：

-c
创建新的档案文件。如果用户想备份一个目录或是一些文件，就要选择这个选项。

-r
把要存档的文件追加到档案文件的未尾。例如用户已经做好备份文件，又发现还有

一个目录或是一些文件忘记备份了，这时可以使用该选项，将忘记的目录或文件追加到备份

文件中。

-t 列出档案文件的内容，查看已经备份了哪些文件。

-u
更新文件。就是说，用新增的文件取代原备份文件，如果在备份文件中找不到要更

新的文件，则把它追加到备份文件的最后。

-x 从档案文件中释放文件。

辅助选项：

-b
该选项是为磁带机设定的，其后跟一数字，用来说明区块的大小，系统预设值为20

（20×512 bytes）。

-f 使用档案文件或设备，这个选项通常是必选的。

-k
保存已经存在的文件。例如把某个文件还原，在还原的过程中遇到相同的文件，不

会进行覆盖。

-m 在还原文件时，把所有文件的修改时间设定为现在。

-M 创建多卷的档案文件，以便在几个磁盘中存放。

-v 详细报告tar处理的文件信息。如无此选项，tar不报告文件信息。

-w 每一步都要求确认。

-z
用gzip来压缩/解压缩文件，加上该选项后可以将档案文件进行压缩，但还原时也一

定要使用该选项进行解压缩。

4.应用说明

tar 是Tape
Archive（磁带归档）的缩写，最初设计用于将文件打包到磁带上。如果下

载过Linux的源代码，或许已经碰到过tar文件。tar是一个基于文件的命令，它本质上是连

续地、首尾相连地堆放文件。使用tar可以打包整个目录树，这使得它特别适合用于备份。

归档文件可以全部还原，或者从中展开单独的文件和目录。备份可以保存到基于文件的设备

或磁带设备上。文件可以在还原时重定向，以便将它们重新放到一个与最初保存它们的目录

（或系统）不同的目录（或系统）。tar与文件系统无关，可以使用在ext2、ext3、JFS、

Reiser和其它文件系统上。它支持各种备份介质，包括软盘、光盘写入器、可重写的光盘、

JazZip、磁带、高端磁带等。Linux中以.tar结尾的文件都是用tar创建的。它的使用超出了

单纯的备份，可用来把许多不同文件放到一起组成一个易于分开的文件。如果使用Linux源

代码安装程序，一定使用过tar文件。这是一个基于文件的命令，它本质上是连续地、首尾

相连地堆放文件。 tar官方网址是http://www.gnu.
org/software/tar/tar.html。

请注意，不要忘了Linux是区分大小写的。例如，tar命令应该总是以小写的形式执行。

命令行开关可以是大写、小写或大小写的混合。例如，-t和-T执行不同的功能。文件或目录

名称可以混合使用大小写，而且就像命令和命令行开关一样是区分大小写的。

5.应用实例

tar是一个命令行的工具，没有图形界面。使用Konsole打开一个终端窗口，接下来是一

个简单的备份命令（在/temp目录中创建一个back.tar的文件，/usr目录中所有内容都包含

在其中。）：

\$tar cvf - /usr \> /temp/back.tar

另外，tar命令支持前面第三讲中讲过的crontab命令，可以用crontab工具设置成基于

时间的有规律地运行。例如，每晚6点把/usr目录备份到hda---第一个IDE接口的主驱动器
(

总是位于第一个硬盘)中，只要将下面语句添加到root的crontab中即可：

\$00 06 \* \* \* tar cvf /dev/hda1/usrfiles.tar - /usr

一般情况下，以下这些目录是需要备份的：

◆/etc
包含所有核心配置文件，其中包括网络配置、系统名称、防火墙规则、用户、

组，以及其它全局系统项。

◆ /var
包含系统守护进程（服务）所使用的信息，包括DNS配置、DHCP租期、邮件缓

冲文件、HTTP服务器文件、dB2实例配置等。

◆/home
包含所有默认用户的主目录，包括个人设置、已下载的文件和用户不希望失去

的其它信息。

◆/root 根（root）用户的主目录。

◆/opt
是安装许多非系统文件的地方。IBM软件就安装在这里。OpenOffice、JDK和其

它软件在默认情况下也安装在这里。

有些目录是可以不备份的：

◆ /proc
应该永远不要备份这个目录。它不是一个真实的文件系统，而是运行内核和

环境的虚拟化视图，包括诸如/proc/kcore这样的文件，这个文件是整个运行内存的虚拟视

图。备份这些文件只是在浪费资源。

◆/dev
包含硬件设备的文件表示。如果计划还原到一个空白的系统，就可以备份/dev

。然而，如果计划还原到一个已安装的Linux 系统，那么备份/dev是没有必要的。

unzip

1.作用

unzip 命令位于/usr/bin目录中，它们和MS DOS下的pkzip、pkunzip及MS
Windows中的

Winzip软件功能一样，将文件压缩成.zip文件，以节省硬盘空间，当需要的时候再将压缩文

件用unzip命令解开。该命令使用权限是所有用户。

2.格式

unzip \[-cflptuvz\]\[-agCjLMnoqsVX\]\[-P
\<密码>\]\[.zip文件\]\[文件\]\[-d \<目录>\]\[-x \<

文件>\]

3.主要参数

-c：将解压缩的结果显示到屏幕上，并对字符做适当的转换。

-f：更新现有的文件。

-l：显示压缩文件内所包含的文件。

-p：与-c参数类似，会将解压缩的结果显示到屏幕上，但不会执行任何的转换。

-t：检查压缩文件是否正确。

-u：与-f参数类似，但是除了更新现有的文件外，也会将压缩文件中的其它文件解压缩

到目录中。

-v：执行是时显示详细的信息。

-z：仅显示压缩文件的备注文字。

-a：对文本文件进行必要的字符转换。

-b：不要对文本文件进行字符转换。

-C：压缩文件中的文件名称区分大小写。

-j：不处理压缩文件中原有的目录路径。

-L：将压缩文件中的全部文件名改为小写。

-M：将输出结果送到more程序处理。

-n：解压缩时不要覆盖原有的文件。

-o：不必先询问用户，unzip执行后覆盖原有文件。

-P\<密码>：使用zip的密码选项。

-q：执行时不显示任何信息。

-s：将文件名中的空白字符转换为底线字符。

-V：保留VMS的文件版本信息。

-X：解压缩时同时回存文件原来的UID/GID。

\[.zip文件\]：指定.zip压缩文件。

\[文件\]：指定要处理.zip压缩文件中的哪些文件。

-d\<目录>：指定文件解压缩后所要存储的目录。

-x\<文件>：指定不要处理.zip压缩文件中的哪些文件。

-Z
unzip：-Z等于执行zipinfo指令。在Linux中，还提供了一个叫zipinfo的工具，能

够察看zip压缩文件的详细信息。unzip最新版本是5.50。

gunzip

1.作用

gunzip命令作用是解压文件，使用权限是所有用户。

2.格式

gunzip \[-acfhlLnNqrtvV\]\[-s \<压缩字尾字符串>\]\[文件\...\]

或者

gunzip \[-acfhlLnNqrtvV\]\[-s \<压缩字尾字符串>\]\[目录\]

3.主要参数

-a或\--ascii：使用ASCII文字模式。

-c或\--stdout或\--to-stdout：把解压后的文件输出到标准输出设备。

-f或-force：强行解开压缩文件，不理会文件名称或硬连接是否存在，以及该文件是否

为符号连接。

-h或\--help：在线帮助。

-l或\--list：列出压缩文件的相关信息。

-L或\--license：显示版本与版权信息。

-n或\--no-name：解压缩时，若压缩文件内含有原来的文件名称及时间戳记，则将其忽

略不予处理。

-N或\--name：解压缩时，若压缩文件内含有原来的文件名称及时间戳记，则将其回存到

解开的文件上。

-q或\--quiet：不显示警告信息。

-r或\--recursive：递归处理，将指定目录下的所有文件及子目录一并处理。

-S\<压缩字尾字符串>或\--suffix\<压缩字尾字符串>：更改压缩字尾字符串。

-t或\--test：测试压缩文件是否正确无误。

-v或\--verbose：显示指令执行过程。

-V或\--version：显示版本信息。

4.说明

gunzip是个使用广泛的解压缩程序，它用于解开被gzip压缩过的文件，这些压缩文件预

设最后的扩展名为".gz"。事实上，gunzip就是gzip的硬连接，因此不论是压缩或解压缩

，都可通过gzip指令单独完成。gunzip最新版本是1.3.3 。

unarj

1.作用

unarj解压缩格式为.arj格式的文件，使用权限是所有用户。

2.格式

unarj \[eltx\]\[.arj压缩文件\]

3.主要参数

e：解压缩.arj文件。

l：显示压缩文件内所包含的文件。

t：检查压缩文件是否正确。

x：解压缩时保留原有的路径。

4.说明

带有.arj扩展名的文件是由用于MS
DOS和Windows的ARJ实用程序创建的。因为ARJ是一

种不能免费获得源代码的共享件程序，所以在Linux平台上几乎不存在与其功能匹配的工具

，要解压缩.arj文件，就要使用unarj实用程序。unarj比ARJ慢，能力也不如ARJ，但至少能

够顺利地抽取大多数.arj文件。unarj
只能将文件抽取到当前的工作目录、列出档案内容，

或者测试档案。从ARJ
Software的站点或携带所需Linux发行版的FTP服务器上可以下载

unarj源码。另外，unarj通常是基本Linux发行版的一部分，因此可以在主要发行版本的

CD-ROM上找到它。如果需要可到所有Linux发行版链接的列表下载，ARJ软件网址为http:

//www.arjsoft.com，ARJ的下载页面为http://www.arjsoft.com/files.htm。unarj最新版

本是 2.65，注意unarj选项不是以减号(-)开头的。

mtools

1.作用

mtools
实际上是一个命令集合，是DOS文件系统的工具程序，它可以模拟许多DOS命令

，使用起来非常方便。使用权限是所有用户。Linux系统提供了一组称为
mtools的可移植工

具，可以让用户轻松地从标准的DOS软盘上读、写文件和目录。它们对DOS和Linux环境之间

交换文件非常有用。mtools的使用非常简单，如果想把软盘里所有的文件都拷贝到硬盘上，

那么就可以执行以下命令：

mcopy a:\*.\*

也就是说，只需要在相应的DOS命令之前加上一个字母"m"，就可以完成对应的功能了

。一般Linux发行版本中都有这个软件，可以使用下面命令检查一下。

rpm -qa\|grep mtools

如果没有安装，也没有关系，可以从网上下载(http://mtools.linux.lu/)一个最新版

本来安装。目前可供下载的最新mtools版本是3.9.9，下载链接为

http://mtools.linux.lu/mtools-3.9.9-3.i386.rpm。下载后安装一下即可。

2.包括的命令

mcd 目录名：改变MS DOS下的目录。

mcopy 源文件 目标文件：在MS DOS和Unix之间复制文件。

mdel 文件名：删除MS DOS下的文件。

mdir 目录名：显示MS DOS下的目录。

mformat 驱动器号：在低级格式化的软盘上创建MS DOS文件系统。

rnlabel 驱动器号：产生MS DOS下的卷标。

mmd 目录名：建立MS DOS下的目录。

mrd 目录名：删除MS DOS下的目录。

mren 源文件 目标文件：重新命名已存在的MS DOS文件。

mtype 文件名：显示MS DOS文件的内容。

请注意，这些命令和对应的MS
DOS命令非常相似。在mtools命令中，"/"和"\\"是可

以混用的。因为文件列表的是DOS系统下的文档，对大小写并不敏感，所以"CDE"和"cde

"在这里是一样的。

3.应用实例

(1)如果把软盘进行快速格式化，可以使用命令mformat：

mformat A：

mtools
当初发展的目的是用来处理DOS文件系统的，所以只能用在FAT文件格式的分区

上。需要注意的是，如果用mount命令来挂载了FAT16/32分区，那么就不能使用mtools的指

令来处理这些分区上的文件。这是因为一旦FAT16/32分区挂到了Linux文件目录下，Linux就

会将其视为文件系统本身的一部分，这时如果要对其操作就必须使用Linux本身所附带的指

令集。

(2)将DOS盘上的文件htca.c复制到当前目录下，并用ls命令进行验证。

\$ mcopy a:\\htca.c

\$ ls -l htca.c

-rw-r- -r- - 1 xxq xxq 27136 Jan 1 01:80 htca.c

man

1.作用

man命令用来提供在线帮助，使用权限是所有用户。在Linux系统中存储着一部联机使用的手

册，以供用户在终端上查找。使用man命令可以调阅其中的帮助信息，非常方便和实用。

2.格式

man 命令名称

man \[-acdfhkKtwW\] \[-m system\] \[-p string\] \[-C config_file\] \[-M
path\] \[-P

pager\] \[-S section_list\] \[section\] name \...

3.参数

-C config_file：指定设定文件man.conf，缺省值是/etc/man.conf。

-M path：指定了联机手册的搜寻路径,
如果没有指定则使用环境变数MANPATH的设定；

如果没有使用MANPATH，
则会使用/usr/lib/man.conf内的设定；如果MANPATH是空字串，则

表示使用缺省值。

-P pager：指定使用何种pager.man会优先使用此选项设定，然后是依环境变数

MANPAGER设定，然后是环境变数PAGER；man缺省使用/usr/bin/less -is。

-S section_list man：所搜寻的章节列表(以冒号分隔)，此选项会覆盖环境变数

MANSECT的设定。

-a
man：缺省情况是在显示第一个找到的手册之后，就会停止搜寻，使用此选项会强迫

man继续显示所有符合name的联机手册。

-c：即使有最新的cat
page，也继续对联机手册重新作排版，本选项在屏幕的行列数改

变时或已排版的联机手册损坏时特别有意义。

-d：不要真的显示联机手册，只显示除错讯息。

-D：同时显示联机手册与除错讯息。

-h：显示求助讯息然后结束程式 。

-K：对所有的联机手册搜寻所指定的字串。请注意，本功能回应速度可能很慢，如果指

定section（区域）会对速度有帮助。

-m system：依所指定的system名称而指定另一组的联机手册。

man：是manual（手册）的缩写。在输入命令有困难时，可以立刻得到这个文档。例如,

如果使用ps命令时遇到困难，可以输入man
ps得到帮助信息，此时会显示出ps的手册页（

man page）。

由于手册页man page是用less程序来看的(可以方便地使屏幕上翻和下翻),
所以在man

page里可以使用less的所有选项。

less中比较重要的功能键有:

\[q\] 退出；

\[Enter\] 一行行地下翻；

\[Space\] 一页页地下翻；

\[b\] 上翻一页；

\[/\] 后跟一个字符串和\[Enter\]来查找字符串；

\[n\] 发现上一次查找的下一个匹配。

4.阅读手册页

手册页在很少的空间里提供了很多的信息，
这里简单介绍一下大多数手册页中都有的

部分内容。Linux手册页主要有九个部分：用户指令、系统调用、程序库、设备说明、文件

格式、游戏、杂项、系统指令、内核，手册页快照见图1所示。

图1 ps命令手册页快照

Linux手册页布局见表1。

5.应用实例

Linux
命令中有一些基础的、重要的命令，例如ps、find、cat和ls等。下面来举一个

综合应用的例子，由此可以看出man的地位在Linux中可谓至关重要。但是，man所显示的信

息却不是普通的文本，如果直接将这些文字重定向到一个文本文件，就会发现在man中高亮

显示的文字就变成了两个，而且有不计其数的制表符，使打印、编辑都变得非常不便。不过

，使用下面这样一条语句就能得到ps命令打印。

\# man ps \| col -b \| lpr

这条命令同时运用了输出重定向和管道两种技巧，作用是将ps命令的帮助信息可以直接

打印出来。更多的Man文件可以查看Linux Man Pages简体中文版主页，其链接为

http://cmpp.linuxforum.net/ 。

unencode

1.作用

unencode命令可以把一个二进制文件表编码为一个文本文件，使用权限是所有用户。

2.格式

uuencode \[-hv\] \[源文件\] 目标文件

3.主要参数

－h：列出指令使用格式(help) 。

－v：列出版本信息。

4.应用说明

uuencode指令可以将二进制文件转化成可使用电子邮件发送的ASCII编码形式。

uuencode编码后的资料都以
begin开始，以end作为结束，且通常其中的每一行的开始均为

"M"，中间部分是编码过的文件，编码后的文件比源文件要大一些。

uudecode

1.作用

uudecode命令用来将uuencode编码后的档案还原，uudecode只会将begin与end标记之间

的编码资料还原，程序会跳过标记以外的资料。它的使用权限为所有用户。

2.格式

uuencode \[-hv\] \[file1 \...\]

3.主要参数

－h：列出指令使用格式(help)。

－v：列出版本信息。

4.应用实例

使用下面命令一次还原几个文件：

uuencode file1.uud file2.uud file3.uud

动手练习

1.在Linux命令行下发送邮件

虽然Linux桌面应用发展很快，但是命令行（Shell）在Linux中依然有很强的生命力。

如果能确认电子邮件服务器支持8bit的字节，就可以直接使用下面命令：

cat ＜附件文件名＞ \| mail ＜邮件地址＞

cat（cat是concatenate的缩写）命令是将几个文件处理成一个文件，并将这种处理的

结果保存到一个单独的输出文件，这里我们用它来合并邮件的文本。

写好邮件名称，比如叫cjkmail，然后使用下面命令：

\$uuencode ＜附件文件名＞ ＜附件文件名＞ \>\>cjkmail

这样就可以用vi编辑器写cjkmail文件，并在前面写上信的正文，然后寄出。

对方收到信后，把信中属于cjkmail中的内容拷贝出来，存为themail.uue。如果对方是

在Windows下，就可以用WinRAR或WinZip解压，这样就可以看到附件。

如果对方也使用Linux，可以用undecode命令还原：

\$ uudencode -o＜附件文件名＞ themail.uue

2.实现tar的分卷

笔者想把一个378MB的文件压缩成多个63MB的文件（笔者的USB为64MB），使用下面命令

：

\$tar czvf - dir \| split -d -b 63m

然后合并命令：

\$cat x\* \> dir.tgz

以上例子实际是由三个命令组合完成的，即用tar打包，用split分割，用cat合并。"

tar czvf -
dir"的意思是把dir目录打包，并输出到标准输出（argv），这样就可以直接

用管道输出给split。

3.连续执行一个命令

使用watch命令，可以反复执行命令。如果和ls配合，可以达到观察某文件大小变化的

效果。

\$watch ls －l file.name

4.用tar命令导出一个文件

有一个tar格式的DVD文件GLvPro6.4_linux.tar，因为该文件非常大（4.7GB），如果全

部解压比较麻烦，可以用下面命令先导出readme.txt看看。

tar xvf GLvPro6.4_linux.tar readme.txt

这样readme.txt就单独被导出了。

5.用tar打包一个目录时只备份其中的几个子目录

tar cf \--exclude home/cjh home/cao

这样home目录下只有cjh和cao两个子目录备份。

到此为止，Linux必学的60个命令已经全部介绍完了。Linux的命令行方式功能强大，

如果熟练掌握了Linux的常用命令，往往只需要通过各种技巧就可以组合构成一条复杂的命

令，从而完成用户任务。Linux系统中的命令实在是太多了，不可能像在MS
DOS中把所有的

命令及参数都记住。Linux系统提供了一些方法，比如可以通过"help"和"man"来查询名

令。
