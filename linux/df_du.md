[toc]

### references

* [Understanding the Linux df And du Commands - Make Tech Easier](https://www.maketecheasier.com/linux-df-du-commands/#:~:text=Understanding%20the%20Linux%20df%20And%20du%20Commands%201,files%20which%20are%20occupying%20large%20amounts%20of%20space.)
* 

## df

* The **df command** (short for  ***d**isk **f**ree* ) is used to show the amount of free disk space available on Linux and other Unix-like systems and to understand the filesystems that have been mounted.

> `df` displays the amount of free space on the file system containing each file name argument.
>
> If no filename is provided, the free space on all currently mounted file systems is displayed.

* Here is what the output from running the `df` command without any parameters might looks like.
  * If a file system name is used as an argument (e.g. /dev/sda1) only the information for that file system will be displayed:

![1647958306717.png](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/1647958306717.png)

![1647958376476.png](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/1648010441975.png)

* The first column “Filesystem” gives the name of the storage (e.g. /dev/sda1) while the second column shows the size of the filesystem in Kilobytes.
* Likewise the third and fourth columns show how much of the filesystem is used and how much is free while the penultimate column shows the usage as a percentage.
* The last column “Mounted on” shows the path where the filesystem was mounted.
* Having the the size of the volume, the amount used and the free space listed in Kilobytes can make the output from `df` hard to read. Fortunately the “`-h`” option changes the output into some thing more friendly.

**df** -h

![1648010441975.png](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/1648011418713.png)

* As well as physical hard drives, `df` also lists other types of mounted filesystem,
* most notably
  * the `udev` filesystem for `/dev` and
  * the `tmpfs` filesystem for `/run` and its subdirectories `/run/...`.
  * These are file systems that run in memory and are part of the internal workings of Linux. For example, `/run/lock` is a place for processes to create lock files (to ensure orderly access to certain resources), for speed they are created in memory rather than on a physical disk. Likewise, the Linux device manager creates the special device files needed by the kernel in `/dev` directory.

### df -T

> * Another couple of useful flags for `df` are “`-T`” which will add an extra column to the output listing the `type` of each filesystem,

![1648011418713.png](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/1648012581565.png)

### df -l

> * and “`-l`” which will force `df` to only show the local filesystems (meaning that remote filesystems mounted via NFS or CIFS won’t be displayed).

```bash
cxxu_kali➜~» df -lh                                                             [12:58:44]
Filesystem      Size  Used Avail Use% Mounted on
rootfs          125G   73G   53G  59% /
none            125G   73G   53G  59% /dev
none            125G   73G   53G  59% /run
none            125G   73G   53G  59% /run/lock
none            125G   73G   53G  59% /run/shm
none            125G   73G   53G  59% /run/user
tmpfs           125G   73G   53G  59% /sys/fs/cgroup
cxxu_kali➜~» df -h                                                              [12:58:49]
Filesystem      Size  Used Avail Use% Mounted on
rootfs          125G   73G   53G  59% /
none            125G   73G   53G  59% /dev
none            125G   73G   53G  59% /run
none            125G   73G   53G  59% /run/lock
none            125G   73G   53G  59% /run/shm
none            125G   73G   53G  59% /run/user
tmpfs           125G   73G   53G  59% /sys/fs/cgroup
C:\             125G   73G   53G  59% /mnt/c
D:\             273G  252G   22G  93% /mnt/d
E:\              79G   64G   15G  81% /mnt/e
```

## **du**

* This **D**isk **U**sage command (du) displays how much disk space a directory is occupying.
* For example, to see how much data is in the “Downloads/” directory, type:

```bash
du Downloads/
```

The output will look something like this:

> du 检查目录占用的时候,需要为参数末尾增加 `/`,否则,将被当做文件而非目录进行计算

![1648012581565.png](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/1648013122209.png)

### du 检查文件大小

- 检查特定文件的大小

```bash
cxxu_kali➜users/cxxu/Downloads» du -h ecdict.csv                                [13:26:12]
63M     ecdict.csv
```

For a more friendly output use the “`-h`” option:

**![1648013122209.png](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/1647958376476.png)du** -h

* The `du` command will recursively traverse any sub directories and display the amount of space used.
* The total displayed for any given directory is the space used by the directory `itself and any subdirectories.`

### du: without seeing the details of the various subdirectories

* To find out the total amount of disk space used without seeing the details of the various subdirectories, use the “`-s`” parameter.
  * Used together with “`-h`“, the command looks like this:
  * ```bash
    cxxu_kali➜users/cxxu/Downloads» du -s -h ./                                     [13:29:24]
    2.2G    ./
    ```
* The “`-a`” parameter displays the size of `every file` in the directory and its subdirectories.
  * This is useful if you want to find large files.
  * The output from `du `can be piped into `sort` to give an ordered list of the files:
  * `du -a  Downloads/ | sort -n`
    * The “`-n`” parameter tells the `sort` command to regard `the first column of numbers` in the output from `du` as a numeric string.

### du apparent size

* By default, the `du` command shows `the disk space used by ` the directory or file`.
* To find `the apparent size of a directory`, use the `--apparent-size` option.
  * The “apparent size” of a file is `how much data is actually ` __in the file__.(文件中实际的数据量)

#### apparent size & disk usage size

##### references

- [DU &amp; LS - APPARENT SIZE vs DISK USAGE Size - Sparse Files and stuff - infotinks](http://www.infotinks.com/du-ls-apparent-size-vs-normal-size-sparse-files-stuff/#:~:text=Apparent%20size%20is%20the%20number%20of%20bytes%20your,to%20send%20the%20file%20over%20FTP%20or%20HTTP.)
- [4K对齐_百度百科 (baidu.com)](https://baike.baidu.com/item/4K%E5%AF%B9%E9%BD%90/3778627?fr=aladdin)

> * LS and DU can both display APPARENT SIZE and DISK USAGE/NORMAL size.
>   * DU displays the DISK USAGE size without any arguments,
>     * **du –apparent-size** : to display APPARENT SIZE you have to give the **du –apparent-size** argument
>   * **ls -l** gives APPARENT SIZE (in the middle of the output) and
>     * **ls -s** shows DISK USAGE size (on the left side of the output)

* **APPARENT size** (middle value in “ls -lsk”), is how ` the size appears to applications`.
* **DISK USAGE size** (left size value in “ls -lsk”), is how much `disk space the file takes up`
  * (so if you have `filesystem compression(文件系统压缩) `or `deduplication`(重复数据消除), this size would be smaller).
  * This is the space that is accounted for with DF.
  * this is the amount of space that cant be taken up by some other file on the filesystem, also this is `usually slightly bigger than apparent size `because the filesystem has to occupy the last block all the way, so `disk usage size is bigger`,` as filesystems are wasteful`.
  * `disk usage` is multiple integers of the blocksize.
    * – e.g. a file can have 3003 bytes characters which means it will have 3003 bytes apparent size.
    * In a `4k  blocksize` filesystem it would take up that `full first block` so 1093 bytes would be wasted,
    * so disk usage would be 4096 bytes – yet `only 3003 bytes are useful`.
      * Likewise in a 2k blocksize filesystem blocks the first block would be completely used,
      * all 2048 bytes of it, the second block will use 955 bytes that will be useful, and 1093 bytes of that last/second block would be wasted
      * — You can see that this waste can compound with more files on the filesystem.
      * Its safe to assume every file wastes part of that last block size (mathematically we average `half of the last blocksize` to be wasted).
      * Mathematically you can see the **total waste of unused space in blocks** by taking the **number of files** and **multiplying** by  ` half the block size`  .
      * So in a filesystem with `1million files` with a 4k blocksize filesystem, you would `waste 2 million k of data or 2.048 gigabytes`)
* conclusion
  * Most often though without compression or deduplication or sparse files (more on this in a second), APPARENT size is actually smaller than DISK USAGE.
    * Why? DISK USAGE counts the full size of the last (partial) block of the file.
    * The last block though can be partially full.
    * APPARENT size only counts the data thats in the last block.

```
sudo du -sh --apparent-size /var
```

* When you transfer a directory via [SCP](https://linuxize.com/post/how-to-use-scp-command-to-securely-transfer-files/) , [Rsync](https://linuxize.com/post/how-to-use-rsync-for-local-and-remote-data-transfer-and-synchronization/) ., or [SFTP](https://linuxize.com/post/how-to-use-linux-sftp-command-to-transfer-files/) the amount of data that is transferred over the network is `the apparent size of the files`.
* This is why `the size of space` on the disk used on the source when displayed with `du `(without `--apparent-size`) is `not the same as the size on the target`.

```bash
# cxxu_kali @ cxxuWin11 in /mnt/c/users/cxxu/downloads [15:18:07]
$ du 21世纪英汉汉英双向词典.txt
29408   21世纪英汉汉英双向词典.txt

# cxxu_kali @ cxxuWin11 in /mnt/c/users/cxxu/downloads [15:18:14]
$ du 21世纪英汉汉英双向词典.txt --apparent-size
29406   21世纪英汉汉英双向词典.txt

```

### du with sort

* For example, to print the 5 [largest directories](https://linuxize.com/post/find-large-files-in-linux/) within the `/var` directory, you would pipe the output of `du` to the `sort` command to sort the directories by their size and then pipe the output to the [`head`](https://linuxize.com/post/linux-head-command/) command that will print only the top 5 directories:

```bash
# cxxu_kali @ cxxuWin11 in /mnt/c/users/cxxu/downloads [22:06:04]
$ du -h  --apparent-size ./ | sort -k1 -hr|head -5
2.3G    ./
1.6G    ./Programs
369M    ./dicts
240M    ./Compressed
64M     ./Compressed/gcide-0.53
```

## **Conclusion**

* The `df` and `du` commands can be very useful for monitoring disk usage and for finding directories and/or files which are occupying large amounts of space.
* As an exercise, see if you can pipe the output of `du` into `sort` so that the directories are ordered according to usage.
