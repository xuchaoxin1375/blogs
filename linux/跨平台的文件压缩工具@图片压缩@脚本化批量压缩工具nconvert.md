[toc]

## abstract

- [XnView Software · NConvert](https://www.xnview.com/en/nconvert/#downloads)

### 一键安装脚本

如果将来有更新,比如包的下载链接,或者下载/解压后的目录发生变化,请自行调试,基本逻辑就是这样

在ubuntu22/24下测试通过(2025)

```bash
wget https://download.xnview.com/NConvert-linux64.tgz
tar -xzf NConvert-linux64.tgz #得到Nconvert目录
sudo chmod +x NConvert/nconvert #给nconvert文件添加执行权限
sudo mv NConvert/nconvert /usr/local/bin/nconvert #移动到/usr/local/bin目录,这样可以在任何地方调用nconvert命令
nconvert -help |head -n 20 #测试是否安装成功(查看帮助的前10行)
echo ...
```

### 粘贴到bash中直接运行

```bash
#( 05/14/25@ 4:50PM )( cxxu@CxxuDesk ):~
   wget https://download.xnview.com/NConvert-linux64.tgz
tar -xzf NConvert-linux64.tgz #得到Nconvert目录
sudo chmod +x NConvert/nconvert #给nconvert文件添加执行权限
sudo mv NConvert/nconvert /usr/local/bin/nconvert #移动到/usr/local/bin目录,这样可以在任何地方调用nconvert命令
nconvert -help |head -n 20 #测试是否安装成功(查看帮助的前10行)
echo ...
--2025-05-14 16:50:53--  https://download.xnview.com/NConvert-linux64.tgz
Resolving download.xnview.com (download.xnview.com)... 212.83.169.215
Connecting to download.xnview.com (download.xnview.com)|212.83.169.215|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 16084696 (15M) [application/x-gzip]
Saving to: ‘NConvert-linux64.tgz.2’

NConvert-linux64.tgz.2                                     100%[======================================================================================================================================>]  15.34M  2.55MB/s    in 11s

2025-05-14 16:51:05 (1.34 MB/s) - ‘NConvert-linux64.tgz.2’ saved [16084696/16084696]

[sudo] password for cxxu:
** NCONVERT v7.221 (c) 1991-2025 Pierre-E Gougelet (Mar 28 2025/11:07:59) **
        Version for Linux x86 (X11)  (All rights reserved)
** This is freeware software (for non-commercial use)

The JPEG code is based in part on the work of the Independent JPEG Group's software.
The PNG code is based in part on the work of the Group 42, Inc.
This software is based in part on compression library of Jean-loup Gailly and Mark Adler

Usage : nconvert [options] file ...

OPTIONS:
  -quiet                   : Quiet mode
  -info                    : Display informations only
  -fullinfo                : Display informations & metadata only
  -v[.]                    : Verbose
  -in format               : Input format number or -1
  -page num                : Page/image number
  -xall                    : Extract all images
  -multi                   : Create a multi-page (TIFF/DCX/LDF/PDF only)
  -npcd num                : PCD 0:192x128, 1:384x256, 2:768x512 (default)
../..
```



### 手动逐步安装

```bash

# cxxu @ CxxuDesk in /mnt/c/Users/Administrator/Downloads [15:04:11]
$ tar -xzf NConvert-linux64.tgz

# cxxu @ CxxuDesk in /mnt/c/Users/Administrator/Downloads [15:04:40]
$ cd NConvert

# cxxu @ CxxuDesk in /mnt/c/Users/Administrator/Downloads/NConvert [15:04:43]
$ ls
Formats.txt  Plugins  Plugins.txt  ReadMe.txt  Usage.txt  WhatsNew.txt  license.txt  nconvert

# cxxu @ CxxuDesk in /mnt/c/Users/Administrator/Downloads/NConvert [15:04:44]
$ chmod +x nconvert

# cxxu @ CxxuDesk in /mnt/c/Users/Administrator/Downloads/NConvert [15:04:50]
$ ls
Formats.txt  Plugins  Plugins.txt  ReadMe.txt  Usage.txt  WhatsNew.txt  license.txt  nconvert

# cxxu @ CxxuDesk in /mnt/c/Users/Administrator/Downloads/NConvert [15:04:51]
$ l
total 2.8M
drwxrwxrwx 1 cxxu cxxu 4.0K Mar 28 18:23 .
drwxrwxrwx 1 cxxu cxxu 4.0K May 14 15:04 ..
-rwxrwxrwx 1 cxxu cxxu  32K Feb 25  2020 Formats.txt
drwxrwxrwx 1 cxxu cxxu 4.0K Mar 28 18:21 Plugins
-rwxrwxrwx 1 cxxu cxxu 5.6K Apr 26  2022 Plugins.txt
-rwxrwxrwx 1 cxxu cxxu 5.1K Apr 26  2022 ReadMe.txt
-rwxrwxrwx 1 cxxu cxxu 6.2K Apr 26  2022 Usage.txt
-rwxrwxrwx 1 cxxu cxxu 6.9K Sep  8  2023 WhatsNew.txt
-rwxrwxrwx 1 cxxu cxxu 3.6K Apr 26  2022 license.txt
-rwxrwxrwx 1 cxxu cxxu 2.7M Mar 28 18:23 nconvert

# cxxu @ CxxuDesk in /mnt/c/Users/Administrator/Downloads/NConvert [15:04:56]
$ ./nconvert -q 50 -o output.png /mnt/c/ShareTemp/9B75D542-166A-489C-9083-47A18447F2B9_0fa79188-99a4-4035-b62c-265dfc4e54a9.png
** NCONVERT v7.221 (c) 1991-2025 Pierre-E Gougelet (Mar 28 2025/11:07:59) **
        Version for Linux x86 (X11)  (All rights reserved)
** This is freeware software (for non-commercial use)

Conversion of /mnt/c/ShareTemp/9B75D542-166A-489C-9083-47A18447F2B9_0fa79188-99a4-4035-b62c-265dfc4e54a9.png into output.png OK

```

