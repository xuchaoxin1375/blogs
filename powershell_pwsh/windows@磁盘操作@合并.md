[TOC]



##  扩展卷不可用问题

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210222175445576.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)


##  合并只能是相邻之间的分区进行的操作
- 同时,只能将位于后面的分区压缩出空闲空间并入位于前面的盘符(即被压缩的部分只能并回被压缩的分区/作为新的独立分区)

- 因此,这里给出的==建议==是:

- 第一个盘符(作为系统盘,同时要分配足够大的空间否则日后将不便扩容)(根据上述规律,您若想为第一个盘(任何位于前面(先对与后面的盘)而言)扩容,需要相邻的盘(记为next盘)压缩成两部分next1,next2,将next1中的数据移动到next2中,以便空出next1,这时方可将next1并入位于前面的盘中)


- 如果确实需要对位于前面的盘符进行扩容,可以考虑使用傲梅助手来处理)
  - 如果手动处理,那么建议多进程来移动数据(备份)
  - 所谓多进程,就是将需要移动的数据分为几个部分,然后分别复制这几个部分的不同文件夹
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210714112229813.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

##  命令行操作

- 使用cmd或则powershell均可以启动diskpart工具

### 参考文档

- [diskpart | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/diskpart)

### diskpart工具

- 先进入diskpart环境：
  - 在终端中输入`diskpart.exe`
  - 或者在win+R打开"运行"窗口,输入`diskpart`启动diskpart工具

#### 获取命令说明@帮助

- 在`diskpart`窗口中输入`?`回车

- ```bash
  DISKPART> ?
  
  Microsoft DiskPart version 10.0.22621.1
  
  ACTIVE      - Mark the selected partition as active.
  ADD         - Add a mirror to a simple volume.
  ASSIGN      - Assign a drive letter or mount point to the selected volume.
  ATTRIBUTES  - Manipulate volume or disk attributes.
  ATTACH      - Attaches a virtual disk file.
  AUTOMOUNT   - Enable and disable automatic mounting of basic volumes.
  BREAK       - Break a mirror set.
  CLEAN       - Clear the configuration information, or all information, off the
                disk.
  ...
  
  COMPACT     - Attempts to reduce the physical size of the file.
  CONVERT     - Convert between different disk formats.
  CREATE      - Create a volume, partition or virtual disk.
  DELETE      - Delete an object.
  DETAIL      - Provide details about an object.
  DETACH      - Detaches a virtual disk file.
  EXIT        - Exit DiskPart.
  EXTEND      - Extend a volume.
  EXPAND      - Expands the maximum size available on a virtual disk.
  FILESYSTEMS - Display current and supported file systems on the volume.
  FORMAT      - Format the volume or partition.
  GPT         - Assign attributes to the selected GPT partition.
  HELP        - Display a list of commands.
  IMPORT      - Import a disk group.
  INACTIVE    - Mark the selected partition as inactive.
  LIST        - Display a list of objects.
  MERGE       - Merges a child disk with its parents.
  ONLINE      - Online an object that is currently marked as offline.
  OFFLINE     - Offline an object that is currently marked as online.
  RECOVER     - Refreshes the state of all disks in the selected pack.
                Attempts recovery on disks in the invalid pack, and
  ...
  
  ```

### 列举已安装的磁盘

- ```bash
  DISKPART> list disk
  
    Disk ###  Status         Size     Free     Dyn  Gpt
    --------  -------------  -------  -------  ---  ---
    Disk 0    Online          476 GB   116 MB        *
  ```

  - 查询结果表示,本计算机安装了1个磁盘(编号为 0),容量为476GB,还有116MB未被使用
  - 注意磁盘(disk)不同于分区,一个磁盘可以包含若干个逻辑分区(partion)

### 选中需要操作的磁盘🎈

- 如何选中某个存储对象?

- ```bash
  DISKPART> select ?
  
  Microsoft DiskPart version 10.0.22621.1
  
  DISK        - Shift the focus to a disk. For example, SELECT DISK.
  PARTITION   - Shift the focus to a partition. For example, SELECT PARTITION.
  VOLUME      - Shift the focus to a volume. For example, SELECT VOLUME.
  VDISK       - Shift the focus to a virtual disk. For example, SELECT VDISK.
  
  ```

- 文档告诉我们,可以利用`select disk 0`可以选中编号为0的磁盘

- ```bash
  DISKPART> select disk 0
  
  Disk 0 is now the selected disk.
  
  ```

### 列举选中磁盘的分区情况🎈

- 通过帮助文档可以知道,diskpart中存在的list子命令,可以列举一些信息

  - ```bash
    LIST        - Display a list of objects.
    ```

- 为例获得list子命令的详细信息,需要使用`list ?`查询一下

  - ```bash
    DISKPART> list ?
    
    Microsoft DiskPart version 10.0.22621.1
    
    DISK        - Display a list of disks. For example, LIST DISK.
    PARTITION   - Display a list of partitions on the selected disk.
                  For example, LIST PARTITION.
    VOLUME      - Display a list of volumes. For example, LIST VOLUME.
    VDISK       - Displays a list of virtual disks.
    ```

  - 可以看到,我们可以查询磁盘,以及指定(select)磁盘的分区还有卷和虚拟磁盘

#### 查询分区(类型@大小)

- ```bash
  DISKPART> list partition
  
    Partition ###  Type              Size     Offset
    -------------  ----------------  -------  -------
    Partition 1    System             260 MB  1024 KB
    Partition 2    Reserved            16 MB   261 MB
    Partition 3    Primary            124 GB   389 MB
    Partition 4    Recovery           789 MB   124 GB
    Partition 5    Primary            272 GB   125 GB
    Partition 6    Primary             78 GB   398 GB
    Partition 7    Recovery           730 MB   476 GB
  ```

#### 查询分配的卷@分区名称@文件系统类型

- ```bash
  DISKPART> list volume
  
    Volume ###  Ltr  Label        Fs     Type        Size     Status     Info
    ----------  ---  -----------  -----  ----------  -------  ---------  --------
    Volume 0     C   win11        NTFS   Partition    124 GB  Healthy    Boot
    Volume 1     D   Files        NTFS   Partition    272 GB  Healthy
    Volume 2     E   win10        NTFS   Partition     78 GB  Healthy
    Volume 3         SYSTEM       FAT32  Partition    260 MB  Healthy    System
    Volume 4                      NTFS   Partition    789 MB  Healthy    Hidden
    Volume 5                      NTFS   Partition    730 MB  Healthy    Hidden
  ```

  - 本例中,前三个的Label字段是卷名(也就是windows资源管理器上可以看到的分区(卷)的名字)
    - 分区被格式化成可以可读写数据的状态,并分配了名字(盘符)后,就成为了卷,卷还可以有自己的标签
    - 标签可以理解为都某个分区的用途的标识,而盘符则是一个字母(比如C,D),在命令行访问的时候可以提供简写方便

### 查询某个存储对象的情况@detail命令

- ```bash
  DISKPART> help detail
  
  Microsoft DiskPart version 10.0.22621.1
  
  DISK        - Display the properties of the selected disk.
  PARTITION   - Display the properties of the selected partition.
  VOLUME      - Display the properties of the selected volume.
  VDISK       - Displays the properties of the selected virtual disk.
  ```

- `help detail volume`可以查询到detail volume的用法
  - 这里使用`detail volume ?`是查询不了😂

- ```bash
  DISKPART> help detail volume
  
      Displays the properties for the selected volume and the list of disks on
      which the volume resides.
  
  Syntax:  DETAIL VOLUME
  
      A volume must be selected for this operation to succeed.
  
  Example:
  
      DETAIL VOLUME
  
  DISKPART>
  ```

#### 查询直指定卷的信息

- 

  ```bash
  DISKPART> select volume 0
  
  Volume 0 is the selected volume.
  
  DISKPART> detail volume
  
    Disk ###  Status         Size     Free     Dyn  Gpt
    --------  -------------  -------  -------  ---  ---
  * Disk 0    Online          476 GB   116 MB        *
  
  Read-only              : No
  Hidden                 : No
  No Default Drive Letter: No
  Shadow Copy            : No
  Offline                : No
  BitLocker Encrypted    : No
  Installable            : Yes
  
  Volume Capacity        :  124 GB
  Volume Free Space      :   85 GB
  
  ```

  - 先选中卷,比如0号卷:`select volume 0`
    - 再指定查询的对象级别为卷,即:`detail volume`
    - 本例返回结果表示,该卷容量为:124GB,空闲空间为85GB

## 分区(卷)的删除🎈

### 现在进入危险操作🎈

- ==!!!!!==
- 小心观察各个盘符的容量,选择您需要删除的盘符的分区号
- 务必根据您具体的情况来选择**盘符**((代表分区的)字母)
- 还可以结合gui来比对(通过win+r 执行diskmgmt.msc)
  - 但是一般`list volume`命令的信息已经足够了
    - 这也是推荐的,因为该命令将每个卷的编号(标识)都列出来,可以很方便查看和引用卷
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210714112434537.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

### delete 命令

- ```bash
  DISKPART> delete ?
  
  Microsoft DiskPart version 10.0.22621.1
  
  DISK        - Delete a missing disk from the disk list.
  PARTITION   - Delete the selected partition.
  VOLUME      - Delete the selected volume.
  ```

  - 通过查询delete命令可以看出,我们需要选中`select`某个卷,然后才可以删除

- ```bash
  select volume 2
  delete volume
  ```

### 删除分区实操

- 首先以管理员模式打开终端

  - 我使用的是powershell

  - 例如,我想要删除卷2

    - ```bash
      select volume 2
      detail volume
      delete volume override
      ```

    - ```bash
      	
      PS D:\exes\windowsTools> diskpart.exe
      
      Microsoft DiskPart version 10.0.22621.1
      
      Copyright (C) Microsoft Corporation.
      On computer: CXXUWN11
      
      DISKPART> select volume 2
      
      Volume 2 is the selected volume.
      
      DISKPART> detail volume
      
        Disk ###  Status         Size     Free     Dyn  Gpt
        --------  -------------  -------  -------  ---  ---
      * Disk 0    Online          476 GB   116 MB        *
      
      Read-only              : No
      Hidden                 : No
      No Default Drive Letter: No
      Shadow Copy            : No
      Offline                : No
      BitLocker Encrypted    : No
      Installable            : Yes
      
      Volume Capacity        :   78 GB
      Volume Free Space      :   21 GB
      
      DISKPART> delete volume override
      
      DiskPart successfully deleted the volume.
      ```

      - 这里的删除操作使用了`delete volume override`,包含参数`override`

      - 某些情况下,不带override参数可能删不掉

        - ```bash
          DISKPART> delete volume
          
          Virtual Disk Service error:
          The device is in use.
          
          
          The selected volume or partition is in use.
          To continue with the operation use the OVERRIDE parameter.
          ```

        - 加上`override`后重试

###  操作失败的情况😂

- 这种情况下,可以考虑用pe系统来操作

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210714112803458.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

### 重新查询操作结果

- ```bash
  DISKPART> list disk
  
    Disk ###  Status         Size     Free     Dyn  Gpt
    --------  -------------  -------  -------  ---  ---
    Disk 0    Online          476 GB    78 GB        *
    
  DISKPART> list volume
  
    Volume ###  Ltr  Label        Fs     Type        Size     Status     Info
    ----------  ---  -----------  -----  ----------  -------  ---------  --------
    Volume 0     C   win11        NTFS   Partition    124 GB  Healthy    Boot
    Volume 1     D   Files        NTFS   Partition    272 GB  Healthy
    Volume 3         SYSTEM       FAT32  Partition    260 MB  Healthy    System
    Volume 4                      NTFS   Partition    789 MB  Healthy    Hidden
    Volume 5                      NTFS   Partition    730 MB  Healthy    Hidden
    
  ```

- 可以看到,被删除成功的分区(卷)消失

- 未分配空间为78GB,和被删除分区大小一致

#### 通过diskmgmt.msc查看

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210630082157843.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210630082116301.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)


## 创建分区和卷🎈

- [diskpart |create](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/create)

### offset@size

- ```bash
  DISKPART> list partition
  
    Partition ###  Type              Size     Offset
    -------------  ----------------  -------  -------
    Partition 1    System             260 MB  1024 KB
    Partition 2    Reserved            16 MB   261 MB
    Partition 3    Primary            124 GB   389 MB
    Partition 4    Recovery           789 MB   124 GB
    Partition 5    Primary            272 GB   125 GB
    Partition 7    Recovery           730 MB   476 GB
  
  ```

- 当前磁盘中有一个一块的容量

  - "next_offset=offset+size+unallocated"
  - 这个递推公式表明了offset的数值增长规律
  - 公式右侧的两个offset,size都是同一行的两个值
    - unallocated是没有被分配的区域,这部分容量在被分配(公式化前,无法使用)
    - next_offset,是下一行的Offset值
  - 如果感兴趣的话,可以算出来,磁盘的位置261MB+16MB=276MB处到389MB处的区间内存在一块未分配的空间(大小为389-276=112MB)
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/22643214d5844b0099e8b39cd86049ef.png)

## 分区(卷)扩容🎈

### extend命令

- ```bash
  
  DISKPART> help extend
  
      Extends the volume or partition with focus, and its file system, into free
      (unallocated) space on a disk.
  
  Syntax:  EXTEND [SIZE=<N>] [DISK=<N>] [NOERR]
          EXTEND FILESYSTEM [NOERR]
          .......
  On basic disks, the free space must be on the same disk as the volume or
      partition with focus. The free space must also immediately follow the
      volume or partition with focus (start at the next sector offset).
  
      On dynamic disks with simple or spanned volumes, a volume can be extended
      to any free space on any dynamic disk. Using this command, you can convert
      a simple dynamic volume into a spanned dynamic volume. Mirrored, RAID-5 and
      striped volumes cannot be extended.
  
      If the partition was previously formatted with the NTFS file system, the
      file system is automatically extended to fill the larger partition. No data
      loss occurs. If the partition was previously formatted with a different
      file system than NTFS, the command fails with no change to the partition.
      If the partition was not previously formatted with a file system, the
      partition will still be extended.
  
      A volume or partition must be selected for this operation to succeed.
  ```

  - **The free space must also immediately follow the   volume or partition with focus (start at the next sector offset).**

    - 说明,未分配空间必须紧跟着被扩容分区,否则无法顺利执行!

    - ```bash
      DISKPART> extend
      
      There is not enough usable free space on specified disk(s) to extend the
      volume.
      
      ```

- ```bash
  
  DISKPART> list volume
  
    Volume ###  Ltr  Label        Fs     Type        Size     Status     Info
    ----------  ---  -----------  -----  ----------  -------  ---------  --------
    Volume 0     C   win11        NTFS   Partition    124 GB  Healthy    Boot
    Volume 1     D   Files        NTFS   Partition    272 GB  Healthy
    Volume 2         SYSTEM       FAT32  Partition    260 MB  Healthy    System
    Volume 3                      NTFS   Partition    789 MB  Healthy    Hidden
    Volume 4                      NTFS   Partition    730 MB  Healthy    Hidden
  DISKPART> select volume  1
  
  Volume 1 is the selected volume.
  
  DISKPART> extend
  
  DiskPart successfully extended the volume.
  
  DISKPART> list volume
  
    Volume ###  Ltr  Label        Fs     Type        Size     Status     Info
    ----------  ---  -----------  -----  ----------  -------  ---------  --------
    Volume 0     C   win11        NTFS   Partition    124 GB  Healthy    Boot
  * Volume 1     D   Files        NTFS   Partition    350 GB  Healthy
    Volume 2         SYSTEM       FAT32  Partition    260 MB  Healthy    System
    Volume 3                      NTFS   Partition    789 MB  Healthy    Hidden
    Volume 4                      NTFS   Partition    730 MB  Healthy    Hidden
  
  DISKPART>
  ```

- 扩容前,先使用`list volume`查询磁盘卷的情况

- 不带参数的extend默认将被扩容卷紧邻的空闲空间全部并入

##  可以考虑使用pe系统进行磁盘操作

- pe系统通常有各种分区助手(比如傲梅分区助手)
- 或者`diskGenius`配合系统自带的磁盘管理工具

###  傲梅分区助手提供了更高级的操作(参考官方文档)

- [https://www.disktool.cn/compare-edition.html](https://www.disktool.cn/compare-edition.html)
- 可以将分区格式从NTFS和FAT32格式的转换,无损合并
- 双向合并分区


###  也可以直接在本系统上安装一个傲梅助手
为了将非相邻的磁盘分区合并(这里是间接合并的方案,不是一步到位的,除非你想合并的分区在磁盘上本来就行相邻),可以将中间的分区备份,然后将该分区删除,执行合并,两两合并,直到能够合并到C盘分区
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210222174906608.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

#### 通过一系列合并后提交操作
- 重启后即可