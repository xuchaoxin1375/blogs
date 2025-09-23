

## 目录或文件磁盘占用分析工具dust🎈

dust是一个开源的多线程的磁盘占用分析工具,功能丰富[bootandy/dust: A more intuitive version of du in rust](https://github.com/bootandy/dust)

对于ubuntu系统

```bash
cd ~
# 下载链接请到项目的release页面获取最新链接,下面的链接作为例子,下载后保存为dust.deb文件
wget -O dust.deb https://github.com/bootandy/dust/releases/download/v1.2.1/du-dust_1.2.1-1_amd64.deb
sudo dpkg -i dust.deb
rm dust.deb -v #移除安装包
#简单用例
dust .

```

### 分析目录

dust(跨平台,linux,windows,macos都可以用)有很多选项可以用,比如`-X`可以排除指定目录或文件不加入统计,详情使用`dust -h`

统计`/www`目录

```bash
dust /www/
```

使用选项来分析指定目录(如果主要关心网站根目录或图片占用)

```bash
dust -n 1000 -p /www/wwwroot/
```

针对性分析目录(使用正则选项)

```bash
dust . -n 500 -b -p -e wp-content/uploads
```

## 高级用法🎈

常用的参数组合:

```bash
-n 500 -b -p -d 1
```

- `-n, --number-of-lines <NUMBER>   Number of lines of output to show. (Default is terminal_height - 10)`

- `-b, --no-percent-bars            No percent bars or percentages will be displayed`
- `-d, --depth <DEPTH>              Depth to show`
- `-p, --full-paths                 Subdirectories will not have their path shortened`

### 深度约束

```bash
dust . -n 500 -b -p -d 2
```

约束`-d`取值1,2的效果分别如下

```bash
# root @ wnx0020303 in /www/wwwroot/lyz [7:13:56]
$ dust . -n 500 -b -p -d 1
865M   ┌── ./teilehub.com
953M   ├── ./AutoToros.com
995M   ├── ./petvitabella.com
1.0G   ├── ./www.hogarjoy.com
1.0G   ├── ./carpartseuropa.com
1.1G   ├── ./deportealegria.com
1.1G   ├── ./teilefast.com
1.1G   ├── ./www.hogarhaven.com
1.2G   ├── ./homelicht.com
1.2G   ├── ./prolampen.com
1.2G   ├── ./MecanicaTop.com
1.2G   ├── ./medbeauty24.com
1.3G   ├── ./mdecineesthtique.com
1.3G   ├── ./IberianGear.com
1.4G   ├── ./fahrzeugfit.com
1.4G   ├── ./deporteesvida.com
1.5G   ├── ./lapasindeportiva.com
1.5G   ├── ./www.hogarpatio.com
1.6G   ├── ./animalitop.com
2.1G   ├── ./deutschekfzparts.com
2.1G   ├── ./glamwear24.com
2.4G   ├── ./activedeportes.com
2.8G   ├── ./pasoadeporte.com
 32G ┌─┴ .

```



```bash
# root @ wnx0020303 in /www/wwwroot/lyz [7:12:11]
$ dust . -n 500 -b -p -d 2
....
1.5G   ├─┴ ./lapasindeportiva.com
4.0K   │ ┌── ./www.hogarpatio.com/.htaccess
4.0K   │ ├── ./www.hogarpatio.com/.user.ini
4.0K   │ ├── ./www.hogarpatio.com/404.html
4.0K   │ ├── ./www.hogarpatio.com/index.html
1.5G   │ ├── ./www.hogarpatio.com/wordpress
1.5G   ├─┴ ./www.hogarpatio.com
1.6G   │ ┌── ./animalitop.com/wordpress
1.6G   ├─┴ ./animalitop.com
8.0K   │ ┌── ./deutschekfzparts.com/5.de
2.1G   │ ├── ./deutschekfzparts.com/wordpress
2.1G   ├─┴ ./deutschekfzparts.com
2.1G   │ ┌── ./glamwear24.com/wordpress
2.1G   ├─┴ ./glamwear24.com
4.0K   │ ┌── ./activedeportes.com/.htaccess
4.0K   │ ├── ./activedeportes.com/.user.ini
4.0K   │ ├── ./activedeportes.com/404.html
4.0K   │ ├── ./activedeportes.com/index.html
2.4G   │ ├── ./activedeportes.com/wordpress
2.4G   ├─┴ ./activedeportes.com
4.0K   │ ┌── ./pasoadeporte.com/.htaccess
4.0K   │ ├── ./pasoadeporte.com/.user.ini
4.0K   │ ├── ./pasoadeporte.com/404.html
4.0K   │ ├── ./pasoadeporte.com/index.html
2.8G   │ ├── ./pasoadeporte.com/wordpress
2.8G   ├─┴ ./pasoadeporte.com
 32G ┌─┴ .

```



### 正则匹配

又例如,在windows下我要分析当前目录下所有wordpress的2025年上传的文件占用(其他目录的占用不关心或不需要加入统计报告中)

使用`-e`正则匹配会大大降低速度,因此要酌情使用

注意windows下的路径`\\`

> 则可以使用命令`dust . -n 20 -b -p -e wp-content\\uploads\\2025`

其中`-n`是要显示的行数,可以适当调大一些,比如我有100个站,那么设置值为300~500

```cmd
#⚡️[Administrator@CXXUDESK][C:\sites\wp_sites][15:04:27][UP:23.12Days]
PS> dust . -n 20 -b -p -e wp-content\\uploads\\2025
5.3M       ┌── .\\2.es\\wp-content\\uploads
5.3M     ┌─┴ .\\2.es\\wp-content
5.3M   ┌─┴ .\\2.es
5.4M   │     ┌── .\\2.de\\wp-content\\uploads\\2025
5.4M   │   ┌─┴ .\\2.de\\wp-content\\uploads
5.4M   │ ┌─┴ .\\2.de\\wp-content
5.4M   ├─┴ .\\2.de
5.4M   │     ┌── .\\2.us\\wp-content\\uploads\\2025
5.4M   │   ┌─┴ .\\2.us\\wp-content\\uploads
5.4M   │ ┌─┴ .\\2.us\\wp-content
5.4M   ├─┴ .\\2.us
6.6M   ├── .\\Temp
7.9M   │     ┌── .\\1.de\\wp-content\\uploads\\2025
7.9M   │   ┌─┴ .\\1.de\\wp-content\\uploads
7.9M   │ ┌─┴ .\\1.de\\wp-content
7.9M   ├─┴ .\\1.de
8.3M   │     ┌── .\\1.us\\wp-content\\uploads\\2025
8.3M   │   ┌─┴ .\\1.us\\wp-content\\uploads
8.3M   │ ┌─┴ .\\1.us\\wp-content
8.3M   ├─┴ .\\1.us
 76M ┌─┴ .

```



## windows上分析磁盘占用

dust项目可以在windows上运行,使用scoop可以方便地安装和使用

```cmd
#⚡️[Administrator@CXXUDESK][C:\sites\wp_sites\1.de\wp-content\uploads][15:00:17][UP:23.12Days]
PS> dust -n 10 -b -p -e wp-content\\uploads\\2025  C:\sites\wp_sites\1.de\
2.4M         ┌── C:\\sites\\wp_sites\\1.de\\wp-content\\uploads\\2025\\03
378K         │ ┌── C:\\sites\\wp_sites\\1.de\\wp-content\\uploads\\2025\\02\\tissu-jersey-imprime-attrape-reves-colores-sur-fond-bleu-fonce.jpg
389K         │ ├── C:\\sites\\wp_sites\\1.de\\wp-content\\uploads\\2025\\02\\baumwolljersey-malomi-panel_MAL-SCHMETTERLING_2.jpg
544K         │ ├── C:\\sites\\wp_sites\\1.de\\wp-content\\uploads\\2025\\02\\tissu-pour-pull-a-impression-numerique-motif-serpent-brun.jpg
764K         │ ├── C:\\sites\\wp_sites\\1.de\\wp-content\\uploads\\2025\\02\\tissu-pour-pull-a-impression-numerique-coeurs-fraises-et-motifs-geometriques-sur-fond-noir.png
836K         │ ├── C:\\sites\\wp_sites\\1.de\\wp-content\\uploads\\2025\\02\\baumwoll-popeline-georgine-pink_132.041-3006_2.jpg
5.3M         ├─┴ C:\\sites\\wp_sites\\1.de\\wp-content\\uploads\\2025\\02
7.9M       ┌─┴ C:\\sites\\wp_sites\\1.de\\wp-content\\uploads\\2025
7.9M     ┌─┴ C:\\sites\\wp_sites\\1.de\\wp-content\\uploads
7.9M   ┌─┴ C:\\sites\\wp_sites\\1.de\\wp-content
7.9M ┌─┴ C:\\sites\\wp_sites\\1.de
```



### 运行示例



```bash
#( 06/10/25@ 1:11AM )( root@wnx0020303 ):/www
   ls -1
backup
disk.pl
dk_project
php_session
reserve_space.pl
server
wwwlogs
wwwroot
```

也可以分析目录下的文件,找出最大的若干文件,比如分析图片目录下的大图片

```bash
2.0M   │ ├── DEQ24WES01349-212821_9855ed452a90910a37946f424c898fda_dtl_1.jpg
2.0M   │ ├── DEQ23WES96579-196424_2a28521b8cf3ffd47babb064c1dbebb6_dtl_1.jpg
2.0M   │ ├── DEQ24WES52409-213672_7b6dee3dd136c78767d17db01f4cba0e_dtl_1.jpg
2.0M   │ ├── DEQ24WES72918-213646_caeca0f2194923374585dcde25563424_dtl_1.jpg
2.0M   │ ├── cf4751dea6115b066030897e37dcb87e.png
2.0M   │ ├── DEQ23WES42485-193055_678c4877ffb8441a271d13d25df42919_dtl_1.jpg
2.0M   │ ├── DEQ22WES06371-189112_4bd79f39db8ed78822983ae95462ad92_dtl_1.jpg
2.1M   │ ├── DEQ15ERI30291-39509_7e36adad6175bd3fa937e6ca941b60d4_dtl_1_17e914d9-cfd5-4e54-a748-54c1da80a319.jpg
2.1M   │ ├── DEQ23WES57486-201067_e6554a3af9e9248cb1ab4b1366ae442f_dtl_1.jpg
2.1M   │ ├── adc4c0881c8cd6713c7a6d9edfc17efa.jpg
2.1M   │ ├── DEQ23WES26495-202938_32f845b59616eac143efb462b2777033_dtl_1.jpg
2.2M   │ ├── DEQ24WES41977-210565_ac38e0d0c821ad582964312840c7c888_dtl_1.jpg
2.2M   │ ├── DEQ23WES96953-201068_c5cfec61887f9843f7053f6264674085_dtl_1.jpg
2.2M   │ ├── DEQ23WES17747-196412_7a46dd716741a5422c0103521e96f583_dtl_1.jpg
2.2M   │ ├── DEQ24WES09509-221828_09d77095389a7a49c655bec8f3d2c82e_dtl_1.jpg
2.4M   │ ├── DEQ24WES09179-221815_67005f08925c307093c736afb1f88d32_dtl_1.jpg
2.7M   │ ├── ada0a087c68e5a983551041dcebc0d83.jpg
2.7M   │ ├── f570637490b0c4e7e0fa42273928d3d9.jpg
3.5M   │ ├── 08383c999c0b1c3a41db39a4264fbf47.jpg
 14M   │ ├── interior-7537974.jpg
 16M   │ ├── bc633a3e763e916886c97f95a77b6dd7.jpg
8.0G   ├─┴ 02
 12G ┌─┴ .

```



## 识读dust的输出报告

dust使用阶梯式的结构呈现统计结果,从左往右,在同一个竖线向右生成的同一级阶梯表示他们属于同一个目录下,例如`dust /www/`分析后,左侧的第一个数字表示`/www`占用的总大小

它的下一级(包含了`backup  disk.pl  dk_project  php_session  reserve_space.pl  server  wwwlogs  wwwroot`这些内容)

其中`wwwroot`占用了331G,它的下一级`zw`,也就是`/www/wwwroot/zw`这个目录占用了`127G`

默认情况下,大目录(文件)显示在下面,小目录(文件)显示在上面