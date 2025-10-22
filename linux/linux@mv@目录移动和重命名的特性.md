[toc]



## Linux `mv` 命令用法总结

`mv`（move）命令用于移动文件或目录，以及重命名文件或目录(当然,也可能移动位置和重命名一起做了)。

更加简单的说,就是将被操作的对象的路径从A更改为B(`path_a -> path_b`)

> 为了便于讨论,假设mv的第一个操作参数为对象A,对应路径为`/pa/A`,而第二个参数B,对应路径为`/pb/B`
>
> 单独引用A,B时,它们表示的是对象的名字(文件或者目录的名字,比如`a.txt`,`dir1`)
>
> 其中pa,pb分别表示A,B所在目录,可以是多级目录

将`mv /pa/A /pb/B`效果细分一些,可以分为三种:

1. 不移动目录仅重命名:其中`pa==pb`,`A!=B`,例如`/path/a.txt->/path/b.txt`,如果`A==B`

   ```bash
   mv f f
   mv: 'f' and 'f' are the same file
   ```

2. 仅移动位置不改变名字:其中`B`是一个已经存在的目录的名字,例如`/path/dir1/a.txt->/path/dir2/a.txt`

3. 移动位置且重命名:其中`/pb/`存在,但是`/pb/B`尚不存在

此外,对于参数`B`,如果后面带有`/`,即`mv /pa/A /pb/B/`则mv命令将尝试把`/pb/B`理解为目录

- 如果事先存在`B`但`B`是文件,则命令会报错!(此时无论`B`加不加`/`,默认都会报错)

  - 不过,如果`A`是文件,且`B`不加`/`,那么配合使用强制参数`-f`,可以覆盖掉原来的`B`文件)

  - 如果`B`加`/`,那么强制参数也不起做用,因为`B`不是目录(无论`A`是文件还是目录)

    ```bash
    #( 10/22/25@11:13PM )( root@CxxuColorfulWin10 ):~/dir1
       lsd --tree
     .
    ├──  dir11
    │   ├──  f2
    │   └──  f3
    ├──  f
    └──  f0
    #( 10/22/25@11:13PM )( root@CxxuColorfulWin10 ):~/dir1
       mv f0 f/
    mv: cannot stat 'f/': Not a directory
    #( 10/22/25@11:13PM )( root@CxxuColorfulWin10 ):~/dir1
       mv f0 f/ -f
    mv: cannot stat 'f/': Not a directory
    #( 10/22/25@11:14PM )( root@CxxuColorfulWin10 ):~/dir1
       mv f0 f -f
    #( 10/22/25@11:15PM )( root@CxxuColorfulWin10 ):~/dir1
       mv dir11 f/ -f
    mv: cannot stat 'f/': Not a directory
    ```

    

- 如果事先存在`B`,且是个目录,则`B`后面是否增加`/`的执行效果是一样的,A移动到了B目录下(无论A是文件还是目录)
- 如果`B`事先不存在,那么mv会认为你想要将目录`A`移动并重命名为路径`/pb/B`(如果A是文件而不是目录,则会报错)

## 基本语法

```bash
mv [选项] 源文件/目录 目标文件/目录
```

mv(move的缩写)的操作对象是文件也可以是目录,其含义是将对象从位置A移动到位置B

> 为了便于讨论,文件(file)和目录(directory)统称为**对象**(object),虽然目录是特殊的文件,但是这里我们要考虑目录的特殊性,所以从特意区分文件和目录

A可以是文件或目录,B的类型(文件或目录)则需要分情况讨论:

- 如果mv执行的是重命名,那么显然B的本质是A,那么B的类型取决于A
- 如果mv执行的是文件移动(使得A所在目录发生改变),此时B只能是目录,而不可能是文件(无论A是什么类型)

> 和powershell不同,bash中移动和重命名都使用mv命令,powershell中不仅有(move-item,即mv)还有专门的重命名命令(rename-item,即rni),不过即便是在powershell中,mv可以也是可以完成重命名的任务

在交互式shell场景下,常用的重命名动作是先将工作目录切换(`cd`)到文件所在目录,然后执行`mv A B`的操作(使用相对路径来指定A,B,甚至只指定文件名)

出来上面这种情况外(被操作对象A所在目录不会发生改变,只是对象名字发生改变),mv会使得对象A被移动到另一个目录中去



## 主要功能

### 1. 重命名文件或目录
```bash
# 重命名文件
mv old_name.txt new_name.txt

# 重命名目录
mv old_dir new_dir
```

### 2. 移动文件或目录
```bash
# 移动文件到目录
mv file.txt /path/to/destination/

# 移动多个文件到目录
mv file1.txt file2.txt /path/to/destination/

# 移动目录到另一个目录
mv source_dir /path/to/destination/
```

## 常用选项

### `-i`（交互模式）
```bash
mv -i file.txt existing_file.txt
# 如果目标文件已存在，会提示是否覆盖
```

### `-f`（强制模式）
```bash
mv -f file.txt existing_file.txt
# 强制覆盖，不提示（默认行为）
```

### `-v`（详细模式）
```bash
mv -v file.txt /path/to/destination/
# 显示移动过程的详细信息
```

### `-u`（更新模式）
```bash
mv -u source.txt dest.txt
# 只有当源文件比目标文件新，或目标文件不存在时才移动
```

### `-b`（备份模式）
```bash
mv -b file.txt existing_file.txt
# 覆盖前备份目标文件（备份文件名加~后缀）
```

## 实用示例

### 基础操作
```bash
# 重命名单个文件
mv document.pdf report.pdf

# 移动文件到家目录
mv file.txt ~/

# 移动多个文件到目录
mv *.txt documents/
```

### 批量操作
```bash
# 将当前目录所有.jpg文件移动到images目录
mv *.jpg images/

# 移动并重命名
mv /path/to/old_name.txt /new/path/new_name.txt
```

### 安全操作
```bash
# 安全移动（避免意外覆盖）
mv -i important_file.txt backup/

# 移动时显示详细信息
mv -v *.log /var/log/archive/
```

## 注意事项

1. **覆盖行为**：默认情况下，`mv` 会直接覆盖同名的目标文件，不会提示
2. **跨文件系统**：当源和目标在不同文件系统时，`mv` 实际上是复制后删除
3. **权限要求**：
   - 需要对源文件有读权限
   - 需要对源目录有写权限（用于删除）
   - 需要对目标目录有写权限
4. **目录移动**：
   - 如果目标目录不存在，会重命名源目录
   - 如果目标目录存在，会将源目录移动到目标目录内

## 常见错误处理

```bash
# 权限不足
mv: cannot move 'file.txt' to 'protected/': Permission denied

# 目标不是目录（移动多个文件时）
mv: target 'file.txt' is not a directory

# 文件不存在
mv: cannot stat 'nonexistent.txt': No such file or directory
```

## 最佳实践

1. **使用 `-i` 选项**：避免意外覆盖重要文件
2. **使用 `-v` 选项**：确认移动操作是否按预期执行
3. **备份重要数据**：在批量操作前先备份
4. **检查目标路径**：确保目标目录存在且有写权限



```bash
#( 05/27/25@10:24AM )( cxxu@CxxuDesk ):~
   ls
dd1  wp
#( 05/27/25@10:24AM )( cxxu@CxxuDesk ):~
   tree -L 2
.
├── dd1
│   ├── x1
│   └── y2
└── wp
    ├── dd1
    ├── tt
    └── wp-config.php

4 directories, 4 files
#( 05/27/25@10:24AM )( cxxu@CxxuDesk ):~
   tree -L 3
.
├── dd1
│   ├── x1
│   └── y2
└── wp
    ├── dd1
    │   ├── a.sh
    │   ├── b.sh
    │   ├── c.sh
    │   ├── good.sh
    │   └── xix.sh
    ├── tt
    └── wp-config.php

4 directories, 9 files
#( 05/27/25@10:24AM )( cxxu@CxxuDesk ):~
   mv dd1 wp/          
mv: cannot overwrite 'wp/dd1': Directory not empty
#( 05/27/25@10:25AM )( cxxu@CxxuDesk ):~
   mv dd1 wp/dd1
#( 05/27/25@10:25AM )( cxxu@CxxuDesk ):~
   tree -L 3    
.
└── wp
    ├── dd1
    │   ├── a.sh
    │   ├── b.sh
    │   ├── c.sh
    │   ├── dd1
    │   ├── good.sh
    │   └── xix.sh
    ├── tt
    └── wp-config.php

4 directories, 7 files
```

