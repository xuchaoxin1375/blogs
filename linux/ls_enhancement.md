

# ls enhancement:exa ls with header and wonderful color(ls 显示表头)

## references

- [How to install and use Exa, a modern replacement for the ls command in Ubuntu 16.04 | Our Code World](https://ourcodeworld.com/articles/read/832/how-to-install-and-use-exa-a-modern-replacement-for-the-ls-command-in-ubuntu-16-04)

  - 快速安装

- [Install exa on Ubuntu 20.04 | Lindevs](https://lindevs.com/install-exa-on-ubuntu/)

  - 本方案更加完整:(安装+清理+卸载)

  

## 较新版本的发行版

- `sudo apt install exa`
  - 譬如 ubuntu 21/kali rolling

## 安装流程(通用安装:包括较老版本)

```bash
curl https://sh.rustup.rs -sSf | sh

# Till the date of publication of this article, the latest available download version is the 0.8.0

wget -c https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip
#upzip the tool
unzip exa-linux-x86_64-0.8.0.zip

# Move the unziped binary with the name "exa-linux-x86_64" to "/usr/local/bin/" with the exa name
# so that we can use the program name`exa`directly
sudo mv exa-linux-x86_64 /usr/local/bin/exa
```

## 效果

![image-20220411104829838](https://s2.loli.net/2022/04/11/jZo4ysOI1m7zAG5.png)

### exa -lhgi

- 文件属组/属主
- 文件inode

```
#( 04/11/22@10:48AM )( cxxu@cxxuAli ):~
   exa -lhgi
  inode Permissions Size User Group Date Modified Name
1320913 drwxrwxr-x     - cxxu cxxu   9 Apr 13:47  djangoProjects
1317341 .rw-rw-r--   26k cxxu cxxu   9 Apr 18:28  ela.sql
1318680 .rw-rw-r--   223 cxxu cxxu  26 Mar 21:27  events.txt
1322691 .rw-rw-r--  616k cxxu cxxu   7 Dec  2021  exa-linux-x86_64-0.8.0.zip
1318678 .rw-rw-r--     0 cxxu cxxu   7 Apr 16:07  fileOfCxxu
1322547 .rw-r--r--     4 root root   7 Apr 16:28  fileOfRoot
1316849 .rw-rw-r--   17k cxxu cxxu   8 Apr 17:23  gitee_install.sh
1316848 .rw-rw-r--   16k cxxu cxxu   8 Apr 17:23  install.sh
1318655 drwxrwxrwx     - cxxu cxxu   8 Apr 14:12  linuxShellScripts
1318656 .rw-rw-r--   287 cxxu cxxu  26 Mar 13:10  pets.txt
1318222 .rw-rw-r--   282 cxxu cxxu  26 Mar 11:38  pets.txt.bak
1318681 drwxrwxrwx     - cxxu cxxu  26 Mar 18:46  sedLearn
# 对比:
#( 04/11/22@10:52AM )( cxxu@cxxuAli ):~
   exa -lh
Permissions Size User Date Modified Name
drwxrwxr-x     - cxxu  9 Apr 13:47  djangoProjects
.rw-rw-r--   26k cxxu  9 Apr 18:28  ela.sql
.rw-rw-r--   223 cxxu 26 Mar 21:27  events.txt
.rw-rw-r--  616k cxxu  7 Dec  2021  exa-linux-x86_64-0.8.0.zip
.rw-rw-r--     0 cxxu  7 Apr 16:07  fileOfCxxu
.rw-r--r--     4 root  7 Apr 16:28  fileOfRoot
.rw-rw-r--   17k cxxu  8 Apr 17:23  gitee_install.sh
.rw-rw-r--   16k cxxu  8 Apr 17:23  install.sh
drwxrwxrwx     - cxxu  8 Apr 14:12  linuxShellScripts
.rw-rw-r--   287 cxxu 26 Mar 13:10  pets.txt
.rw-rw-r--   282 cxxu 26 Mar 11:38  pets.txt.bak
drwxrwxrwx     - cxxu 26 Mar 18:46  sedLearn

#ls -li
#( 04/11/22@10:55AM )( cxxu@cxxuAli ):~
   ls -li
total 700
1320913 drwxrwxr-x 6 cxxu cxxu   4096 Apr  9 13:47 djangoProjects
1317341 -rw-rw-r-- 1 cxxu cxxu  26730 Apr  9 18:28 ela.sql
1318680 -rw-rw-r-- 1 cxxu cxxu    223 Mar 26 21:27 events.txt
1322691 -rw-rw-r-- 1 cxxu cxxu 616385 Dec  7 14:03 exa-linux-x86_64-0.8.0.zip
1318678 -rw-rw-r-- 1 cxxu cxxu      0 Apr  7 16:07 fileOfCxxu
1322547 -rw-r--r-- 1 root root      4 Apr  7 16:28 fileOfRoot
1316849 -rw-rw-r-- 1 cxxu cxxu  17046 Apr  8 17:23 gitee_install.sh
1316848 -rw-rw-r-- 1 cxxu cxxu  16963 Apr  8 17:23 install.sh
1318655 drwxrwxrwx 4 cxxu cxxu   4096 Apr  8 14:12 linuxShellScripts
1318656 -rw-rw-r-- 1 cxxu cxxu    287 Mar 26 13:10 pets.txt
1318222 -rw-rw-r-- 1 cxxu cxxu    282 Mar 26 11:38 pets.txt.bak
1318681 drwxrwxrwx 2 cxxu cxxu   4096 Mar 26 18:46 sedLearn
```



## 更多功能/帮助信息

```
#( 04/11/22@10:48AM )( cxxu@cxxuAli ):~
   exa --help
Usage:
  exa [options] [files...]

  -?, --help         show list of command-line options
  -v, --version      show version of exa

DISPLAY OPTIONS
  -1, --oneline      display one entry per line
  -l, --long         display extended file metadata as a table
  -G, --grid         display entries as a grid (default)
  -x, --across       sort the grid across, rather than downwards
  -R, --recurse      recurse into directories
  -T, --tree         recurse into directories as a tree
  -F, --classify     display type indicator by file names
  --colo[u]r=WHEN    when to use terminal colours (always, auto, never)
  --colo[u]r-scale   highlight levels of file sizes distinctly
  .....

```

