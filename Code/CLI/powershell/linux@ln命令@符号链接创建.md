[toc]

## abstract

[ln(1) - Linux manual page (man7.org)](https://www.man7.org/linux/man-pages/man1/ln.1.html)

ln命令十分灵活,可以一次性创建指定的多个文件/目录的链接

在不指定创建的链接名(LINK_NAME)的情况下,链接名和要被创建链接的目标(TARGET)同名

在ln命令中,TARGET不可省略,而链接明LINK_NAME是可以根据需要省略不写

提现在用法上,也是TARGET(位置参数)优先指定,而且可以连续指定多个TARGET(在连续指定多个TARGET的情况下,LINK_NAME是无法指定的(这时ln命令的一个缺点),并且命令行中最后一个位置参数会被解释为这批TARGET的链接会被创建于哪一个目录(DIRECTORY))

不过ln的最后一种用法允许你调整语序,以更清晰的方式批量创建链接(使用`-t`指定这批TARGET的链接要创建在哪个目录下)

- ```bash
  ln --help
  Usage: ln [OPTION]... [-T] TARGET LINK_NAME
    or:  ln [OPTION]... TARGET
    or:  ln [OPTION]... TARGET... DIRECTORY
    or:  ln [OPTION]... -t DIRECTORY TARGET...
  In the 1st form, create a link to TARGET with the name LINK_NAME.
  In the 2nd form, create a link to TARGET in the current directory.
  In the 3rd and 4th forms, create links to each TARGET in DIRECTORY.
  Create hard links by default, symbolic links with --symbolic.
  By default, each destination (name of new link) should not already exist.
  When creating hard links, each TARGET must exist.  Symbolic links
  can hold arbitrary text; if later resolved, a relative link is
  interpreted in relation to its parent directory.
  
  Mandatory arguments to long options are mandatory for short options too.
        --backup[=CONTROL]      make a backup of each existing destination file
    -b                          like --backup but does not accept an argument
    -d, -F, --directory         allow the superuser to attempt to hard link
                                  directories (note: will probably fail due to
                                  system restrictions, even for the superuser)
    -f, --force                 remove existing destination files
    -i, --interactive           prompt whether to remove destinations
    -L, --logical               dereference TARGETs that are symbolic links
    -n, --no-dereference        treat LINK_NAME as a normal file if
                                  it is a symbolic link to a directory
    -P, --physical              make hard links directly to symbolic links
    -r, --relative              create symbolic links relative to link location
    -s, --symbolic              make symbolic links instead of hard links
    -S, --suffix=SUFFIX         override the usual backup suffix
    -t, --target-directory=DIRECTORY  specify the DIRECTORY in which to create
                                  the links
    -T, --no-target-directory   treat LINK_NAME as a normal file always
    -v, --verbose               print name of each linked file
        --help     display this help and exit
        --version  output version information and exit
  
  The backup suffix is '~', unless set with --suffix or SIMPLE_BACKUP_SUFFIX.
  The version control method may be selected via the --backup option or through
  the VERSION_CONTROL environment variable.  Here are the values:
  
    none, off       never make backups (even if --backup is given)
    numbered, t     make numbered backups
    existing, nil   numbered if numbered backups exist, simple otherwise
    simple, never   always make simple backups
  
  Using -s ignores -L and -P.  Otherwise, the last option specified controls
  behavior when a TARGET is a symbolic link, defaulting to -P.
  
  GNU coreutils online help: <https://www.gnu.org/software/coreutils/>
  Full documentation <https://www.gnu.org/software/coreutils/ln>
  or available locally via: info '(coreutils) ln invocation'
  ```

  

`ln` 命令用于在文件之间创建链接。链接可以是硬链接（hard link）或者符号链接（symbolic link）。



### NAME

`ln` - 在文件之间创建链接

### SYNOPSIS

1. `ln [OPTION]... [-T] TARGET LINK_NAME`
2. `ln [OPTION]... TARGET`
3. `ln [OPTION]... TARGET... DIRECTORY`
4. `ln [OPTION]... -t DIRECTORY TARGET...`

> 其中,`[OPTION]`表示ln命令的选项,而后面紧跟着的`...`表示选项可以有多个

第一种用法中的`[OPTION]... [-T]`提示了`[-T]`,表明这种选项组合有特殊性

>   -T, --no-target-directory   treat LINK_NAME as a normal file always

## 理解TARGET

这里要说明**符号链接的位置**和**符号链接所指的目标位置(TARGET)**

为了便于理解和说明,借助一个真实例子:在目录`/etc/fail2ban`有一个符号链接`filter.d.repos`,相关信息如下

```bash
# root @ s1 in /etc/fail2ban [16:48:37]
$ file filter.d.repos
filter.d.repos: broken symbolic link to /www/sh/fail2ban/filter.d/
```

file命令输出内容表示符号链接`filter.d.repos`link to(指向的目标)为`/www/sh/fail2ban/filter.d/`

```bash
# root @ s1 in /etc/fail2ban [16:48:51]
$ ll /etc/fail2ban/filter.d.repos
lrwxrwxrwx 1 root root 26 Nov 25 16:45 /etc/fail2ban/filter.d.repos -> /www/sh/fail2ban/filter.d/
```

类似的,在`/etc/fail2ban`用`ls -l`(`ll`)查看得到输出含义类似,`/etc/fail2ban/filter.d.repos -> /www/sh/fail2ban/filter.d/`这里的箭头指向就是`ln`命令语法中的目标(`TARGET`)占位符的角色

> symbol->target

在这个例子中,符号链接`filter.d.repos`的位置是`/etc/fail2ban/filter.d.repos`,这个值可以通过`ls`命令查看

```bash
$ ls /etc/fail2ban/filter.d.repos -F
/etc/fail2ban/filter.d.repos@
```

`-F`是的链接类型的名字带上后缀`@`标识出来

而符号链接`filter.d.repos`所指向的目标(TARGET)为`/www/sh/fail2ban/filter.d/`

在`ln`命令的一般用法中,可以理解为:

> 为TARGET创建对应的符号链接,`ln symbol_target symbol_position`

## ln的四种语法详细说明

1.  `ln [OPTION]... [-T] TARGET LINK_NAME`

这个用法是创建一个名为`LINK_NAME`的链接，指向`TARGET`文件或目录。

- `[OPTION]...`：表示你可以加多个选项，比如 `-s` 表示软链接。
- `[-T]`：是一个可选参数，用于控制是否将**链接视为目录**（不常使用）。
- `TARGET`：你要链接的目标路径。
- `LINK_NAME`：你想创建的链接名字。

示例：

```bash
ln -s /path/to/file /path/to/symlink
```

在这个示例中，`-s`选项表示创建一个符号链接（symbolic link），`/path/to/file`是链接的目标文件，`/path/to/symlink`是链接名称(链接的路径)。



2. `ln [OPTION]... TARGET`

这个其实和上一条是**同一种情况** ，只是省略了 `LINK_NAME`，这时系统会默认在**当前目录**下创建一个**与目标(TARGET)同名的链接**。

默认情况下，链接名称与`TARGET`相同，但创建在当前目录中。

> ⚠️ 这种方式只能在你当前目录下创建链接，且不能用于多个文件。 

- `TARGET`：目标文件。

示例：

```bash
ln /path/to/p1
```

在当前目录中创建一个名为`p1`的硬链接，指向`p1`文件。

3. `ln [OPTION]... TARGET... DIRECTORY`

这个用法是将一个或多个目标文件`TARGET`链接到指定的目录`DIRECTORY`中。符号链接的名字和`TARGET`相同.

- `TARGET...`：一个或多个目标文件。
- `DIRECTORY`：存放符号链接的目录。

示例：

```bash
ln /path/to/p1 /path/to/p2 /path/to/directory
```

在`/path/to/directory`目录中创建两个硬链接(`p1,p2`)，分别指向`p1`和`p2`。

4. `ln [OPTION]... -t DIRECTORY TARGET...`

这个用法与上一个用法类似，但在选项中显式指定目标目录`DIRECTORY`。符号链接的名字和`TARGET`相同,每个符号链接将**保留目标文件的名称**。

- `DIRECTORY`：目标目录。
- `TARGET...`：一个或多个目标文件。

示例：

```bash
ln -t /path/to/directory p1 p2
```

在`/path/to/directory`目录中创建两个硬链接，分别指向`p1`和`p2`。

### 常用选项

- `-s, --symbolic`：创建符号链接而不是硬链接。
- `-f, --force`：强制覆盖已经存在的链接。
- `-n, --no-dereference`：在目标是符号链接时，不要跟随目标。
- `-T, --no-target-directory`：将链接视为文件而不是目录。
- `-t DIRECTORY, --target-directory=DIRECTORY`：将链接创建在指定的目录中。

### 符号链接有效性

如果某个符号链接的TARGET不存在(比如被移除,或者创建符号链接之时就没存在过),使用`file`命令查看会提示`broken`字样,

```bash
$ file filter.d.repos
filter.d.repos: broken symbolic link to /www/sh/fail2ban/filter.d/
```

或者使用`ll`查看指定符号链接,箭头颜色会和正常符号链接不同

### ln注意事项

- 使用绝对路径创建软链接更稳定（避免相对路径带来的问题）。
- 创建前确保符号路径名不存在(未被占用)，否则 `ln` 命令会报错。

如果你想强制覆盖已有的链接，可以加 `-f` 参数：

```bash
ln -sf source target
```

---

```bash
# cxxu @ CxxuDesk in /mnt/c/repos/scripts/wp/woocommerce/woo_df/sh on git:main x [10:24:45] 
$ sudo ln -s /mnt/c/repos/scripts/wp/woocommerce/woo_df/sh /www/sh/ -v
ln: failed to create symbolic link '/www/sh/': No such file or directory

# cxxu @ CxxuDesk in /mnt/c/repos/scripts/wp/woocommerce/woo_df/sh on git:main x [10:24:51] C:1
$ sudo ln -s /mnt/c/repos/scripts/wp/woocommerce/woo_df/sh /www/sh -v 
'/www/sh' -> '/mnt/c/repos/scripts/wp/woocommerce/woo_df/sh'
```

#### 相对路径使用不当引起错误的符号链接指向

```bash
#( 11/30/25@10:37AM )( cxxu@CxxuDesk ):~
   touch f1
#( 11/30/25@10:37AM )( cxxu@CxxuDesk ):~
   ls
archived  f1
#( 11/30/25@10:37AM )( cxxu@CxxuDesk ):~
   mkdir dir
#( 11/30/25@10:37AM )( cxxu@CxxuDesk ):~
   ls
archived  dir  f1
#( 11/30/25@10:37AM )( cxxu@CxxuDesk ):~
   ln -s f1 dir
#( 11/30/25@10:37AM )( cxxu@CxxuDesk ):~
   tree
.
├── archived
├── dir
│   └── f1 -> f1
└── f1

3 directories, 2 files
#( 11/30/25@10:38AM )( cxxu@CxxuDesk ):~
   cd dir
#( 11/30/25@10:38AM )( cxxu@CxxuDesk ):~/dir
   ll
total 0
lrwxrwxrwx 1 cxxu cxxu 5 Nov 30 10:37 f1 -> f1

#( 11/30/25@10:39AM )( cxxu@CxxuDesk ):~/dir
   cat f1
cat: f1: Too many levels of symbolic links
```

这里出现的关键命令` ln -s f1 dir`出现了两个相对路径,并且`dir`是明确存在的目录.

此命令相当于`   ln -s ./f1 ./dir`,这个命令会在`dir`目录下创建1个`f1`符号,其指向为`f1`,也就是`./f1`,然而这个符号链接是无效的

当用户进入到`dir`目录后,可以列出其中存在的符号`f1`(`dir/f1`),但是当用户尝试访问此符号时,会被解析到`dir/f1`,读者或许已经发现了这个`f1`符号链接指向了自己,从而造成了一个闭环,指向不到头.

因此上面的例子最后出现了`Too many levels of symbolic links`的错误提示

现在,移除旧的`f1`符号,我们稍微改变一下这个例子,TARGET从`f1`(也就是`./f1`)变更为`../f1`重新试验

```bash
#( 11/30/25@10:48AM )( cxxu@CxxuDesk ):~
   ln -s ../f1 dir -v
'dir/f1' -> '../f1'
#( 11/30/25@10:49AM )( cxxu@CxxuDesk ):~
   tree
.
├── archived
├── dir
│   └── f1 -> ../f1
└── f1

3 directories, 2 files
#( 11/30/25@10:49AM )( cxxu@CxxuDesk ):~
   ll dir/f1
lrwxrwxrwx 1 cxxu cxxu 8 Nov 30 10:49 dir/f1 -> ../f1
```

可以发现,此变更后`dir/f1`符号指向为`../f1`(也就是`dir/../f1`,指向的是`dir`的父目录中的`f1`文件,f1文件存在,且没有造成闭环指向,此用例是一个正确`ln`的用例)

## -T选项的作用(gnu ln)

针对gnu的`ln`命令手册的第一中用法包含了`-T`的可选项

```bash
ln [OPTION]... [-T] TARGET LINK_NAME
```

此种用法下,ln命令中的 `-T` 选项是用来**强制将目标(TARGET)视为普通文件（non-directory）**的。

> -T, --no-target-directory   treat LINK_NAME as a normal file always

`LINK_NAME`被视为文件;

在 GNU `ln` 中，`-T` 的作用是强制将目标视为一个**文件**而非**目录**。

- **如果不带 `-T`：** 如果目标 `$LINK_NAME` 已经是一个现有的目录，`ln -s` 会默认把链接创建在该目录**里面**（例如：`$SH_SYM/$SH_SCRIPT_DIR`）。
- **如果带了 `-T`：** 它会尝试直接替换 `$LINK_NAME` 这个路径名，如果 `$LINK_NAME` 是目录，它会报错或按预期覆盖，而不会跳进目录内部。



我们知道,在linux上(其他系统一般也是),创建一个与已经存在的文件或目录同名的文件会失败,目录也是.

而在`ln`命令中,有一定的灵活性,在`LINK_NAME`已经存在且是个目录的时候会尝试这个目录内创建符号(相当于多一个机会)

但是这种行为有利有弊,好处类比了`mv`命令移动某个对象到已有的目录汇总,但有时候这种行为不是我们需要的,可以用`-T`来阻止这种行为 

### 不使用-T

当使用 `ln` 命令创建硬链接或软链接时，目标路径（`TARGET`，即链接指向的地方）可以是文件也可以是目录。

通常，`ln` 命令的行为会根据 `TARGET` 是否是已存在的目录而变化：

1. **如果 `TARGET` 是一个已存在的目录**：
   - `ln SOURCE TARGET` 会在 `TARGET` 目录内创建一个名为 `SOURCE` 的链接。
   - 例如：`ln file.txt existing_dir` 会创建链接 `existing_dir/file.txt`。
2. **如果 `TARGET` 不存在，或者是一个普通文件**：
   - `ln SOURCE TARGET` 会创建名为 `TARGET` 的链接，指向 `SOURCE`。
   - 例如：`ln file.txt new_link` 会创建链接 `new_link`。



### 使用`-T` 选项

`-T` 选项强制 `ln` 命令将目标路径 (`TARGET`) 视为一个**普通文件**，即使该路径实际上是一个已存在的目录。

- **结果**：它会创建一个名为 `TARGET` 的链接，指向 `SOURCE`。
- **用途**：主要用于防止在脚本或自动化流程中，因为目标路径意外变成一个目录而导致链接被创建在错误的子路径下。



首先在家目录创建一个`dir`目录,确保此目录存在

试验1:使用`-T`尝试创建一个符号`~/dir`使其指向`~/f1`

- (1-1)如果`~/dir`已经存在,结果命令行会报错,无论`~/dir`是文件还是目录(如果是目录的话,在不使用`-T`的时候效果不同)
- (1-2)如果`~/dir`事先不存在,则创建`~/dir`指向`~/f1`

试验2:不使用`-T`:

- (2-1)如果ln发现`~/dir`不存在,则会创建具有此路径的符号,且`~/dir`指向`~/f1`
- (2-2)如果ln发相`~/dir`已经存在,则会尝试在`~/dir`目录内创建符号`f1`,能否成功主要取决于`~/dir/`目录下是否已经有名为`f1`的文件或目录
  - (2-2-1)如果`~/dir/f1`事先不存在,则创建`~/dir/f1`这个符号,其指向`~/f1`;
  - (2-2-2)如果`~/dir/f1`在ln创建之前已经存在,则会报错

```bash
#( 11/30/25@11:12AM )( cxxu@CxxuDesk ):~
   mkdir ~/dir -v
mkdir: created directory '/home/cxxu/dir'
#( 11/30/25@11:13AM )( cxxu@CxxuDesk ):~
   ln -s -T  ~/f1 ~/dir -v
ln: failed to create symbolic link '/home/cxxu/dir': File exists
#( 11/30/25@11:13AM )( cxxu@CxxuDesk ):~
   ln -s  ~/f1 ~/dir -v
'/home/cxxu/dir/f1' -> '/home/cxxu/f1'
```

可以看出,使用了`-T`,在`~/dir`不存在的时候效果和不使用`-T`相同,都尝试创建符号`~/dir`指向`~/file1`且能成功

如果`~/dir`事先存在,且是个目录,则会有关键性的不同

观察`ln`用法手册中的第1种和第3种用法(也可以分被称为用法1和用法3)

```bash
Usage: ln [OPTION]... [-T] TARGET LINK_NAME
  or:  ln [OPTION]... TARGET
  or:  ln [OPTION]... TARGET... DIRECTORY
  or:  ln [OPTION]... -t DIRECTORY TARGET...
```

事实上,第三种用法的`DIRECTORY`位置上和第一种的`LINK_NAME`相对应

> 特别是第一种用法不使用`-T`的情况下且第三种用法的`TARGET`只有1个的情况下,即
>
> ```bash
> ln [OPTION]... TARGET LINK_NAME
> ln [OPTION]... TARGET DIRECTORY
> ```

`DIRECTORY`和`LINK_NAME`的一个重要不同在于,前者这里指的是一个已经存在的路径并且是一个目录,而后者是一个尚不存在路径.

### 末尾的斜杠

由于表现形式上的一致相似性,我们把这一对用法的格式抽象为`ln [option] p q`的用法:

这里再讨论一下`q`当做目录时末尾带不带`/`的差别,当路径或名称`q`是`/`结尾时,`ln`命令会当做用法3来执行,也就是说`/`是显式强调使用用法3(但是`q`目录尚不存在时这会报错)

> 假设我们运行`ln`命令前不知道或者无法确定`q`的存在性

如果q是一个包含1至多级目录的路径,比如q为`/www/`时,如果`/www/`不存在,就会报错,需要你手动创建

```bash
# root @ CxxuFirebat in ~ [16:35:06]
$ ln -s /mnt/c/repos/scripts/wp/woocommerce/woo_df/sh /www/ -v
ln: failed to create symbolic link '/www/': No such file or directory

# root @ CxxuFirebat in ~ [16:35:24] C:1
$ mkdir /www

# root @ CxxuFirebat in ~ [16:35:30]
$ ln -s /mnt/c/repos/scripts/wp/woocommerce/woo_df/sh /www/ -v
'/www/sh' -> '/mnt/c/repos/scripts/wp/woocommerce/woo_df/sh'


```

借助`-v`选项可以看到,需要被创建符号的目标(TARGET)路径`/mnt/c/repos/scripts/wp/woocommerce/woo_df/sh`的最后一节名字为`sh`,那么最终命令`ln -s /mnt/c/repos/scripts/wp/woocommerce/woo_df/sh /www/ `会在目录`/www/`下创建一个名为`sh`的符号(完整路径为`/www/sh`);

如果去掉末尾的`/`,且`/www`尚不存在,则会创建符号`/www`,其指向TRAGET`/mnt/c/repos/scripts/wp/woocommerce/woo_df/sh`

### 用法1和用法3小结

第1种用法和第3种用法有点容易混淆,尤其命令格式`ln [option] p q`中`q`是不是一个已经存会影响最终的效果

为了便于讨论,这里展开为`ln [option] /path/1/p /path/2/q`

- 如果目录`/path/2/`不存在就会报错

  1. 如果路径`/path/2/q`是已经存在,分情况:

     - `/path/2/q`是个目录,则该命令会创建`/path/2/q/p`,对应与用法3.(1-1)
     - `/path/2/q`是一个已存在的文件,则会报错(1-2)

  2. 如果路径`/path/2/q`不存在但是`/path/2/`目录存在,则该命令创建`/path/2/q`,这种情况下,对应于用法1;

     - 且如果p是一个目录(文件夹),且第一次执行`ln /path/1/p /path/2/q`创建`/path/2/q`(用法1),同样的命令执行第2遍,变成用法3,会创建出`/path/2/q/p`,如果再执行第3次,则会报错(已存在),但是可以使用`-f`来覆盖旧的同名符号或文件

       执行完2次后看似到此为止了,但事实上,执行2次之后,会得到一个特殊的目录结构,下面的例子说明这一点;我们应该避免创建出这种结构,这会创建出一个cd不到头的路径,让一些遍历目录的程序执行不到头或者发生错误;

       避免此类问题的2个方案:而使用`-T`选项可以避免此类错误,这会将用法强制解释为用法1;或者借助shell的路径存在判断,做具体情况的针对性处理,比如`q`已经存在的情况下先删除,然后再执行`ln`创建


接下来的例子中,展示符号链接的闭环和无限自我嵌套,其中`.../sh`是一个目录,对其执行若干符号链接创建语句

```bash
# root @ CxxuFirebat in ~ [16:36:23] 这里对应于ln的第1种语法,/www/目录事先存在而/www/x事先不存在
$ ln -s /mnt/c/repos/scripts/wp/woocommerce/woo_df/sh /www/x -v
'/www/x' -> '/mnt/c/repos/scripts/wp/woocommerce/woo_df/sh'

# root @ CxxuFirebat in ~ [16:37:05] 这里对应于ln的第3种语法(/www/x/此时已经存在,)
$ ln -s /mnt/c/repos/scripts/wp/woocommerce/woo_df/sh /www/x -v
'/www/x/sh' -> '/mnt/c/repos/scripts/wp/woocommerce/woo_df/sh'
```

抽象的说,设`m`,`n`都是指向目录`x`的符号链接,且如果`m`是`n`的父目录,则造成路径嵌套

> `n`被创建在`m`中,而`m`指向目录`x`,从而`n`(同名目录)也被创建到`x`目录中,这就得到路径`m/x/n`
>
> 而`n`也指向`x`,根据前面的信息可知`x`中包含`n`,从而得到路径`m/x/n/n`,以此类推,`m/x/n/n/.../n`也存在

回到上面的例子,`m=/www/x`,`n=/www/x/sh`,且`m`是`n`的父目录,`m,n`都指向同一个目录`x=/mnt/c/repos/scripts/wp/woocommerce/woo_df/sh`

```bash
# root @ CxxuFirebat in /www/x [17:13:33]
$ cd sh

# root @ CxxuFirebat in /www/x/sh [17:13:37]
$ ls -l sh
lrwxrwxrwx 1 cxxu cxxu 45 Oct  8 17:10 sh -> /mnt/c/repos/scripts/wp/woocommerce/woo_df/sh

# root @ CxxuFirebat in /www/x/sh [17:13:41]
$ cd sh

# root @ CxxuFirebat in /www/x/sh/sh [17:13:46]
$ ls -l sh
lrwxrwxrwx 1 cxxu cxxu 45 Oct  8 17:10 sh -> /mnt/c/repos/scripts/wp/woocommerce/woo_df/sh

# root @ CxxuFirebat in /www/x/sh/sh [17:13:54]
$ cd sh

# root @ CxxuFirebat in /www/x/sh/sh/sh [17:13:56]
$ ls -l sh
lrwxrwxrwx 1 cxxu cxxu 45 Oct  8 17:10 sh -> /mnt/c/repos/scripts/wp/woocommerce/woo_df/sh

# root @ CxxuFirebat in /www/x/sh/sh/sh [17:13:58]
$ pwd
/www/x/sh/sh/sh
...
```

## -n选项

BSD（包括 macOS）版本的 `ln` 命令通常不支持 `-T` (或 `--no-target-directory`) 选项;

这是 GNU Coreutils（Linux 常用的工具集）和 BSD 工具集之间一个经典的兼容性差异。

对于gnu `ln`有两组相关选项:

```bash
--no-dereference       -n      -- treat destination symbolic link to a directory as if it were a normal file
--no-target-directory  -T      -- treat destination as a normal file
```

在bsd版本上,替换已有符号链接主要通过`-h(-n)`选项配合`-f`实现;

```bash
SYNOPSIS
     ln [-L | -P | -s [-F]] [-f | -iw] [-hnv] source_file [target_file]
     ln [-L | -P | -s [-F]] [-f | -iw] [-hnv] source_file ... target_dir
     link source_file target_file
     ....
-h    If the target_file or target_dir is a symbolic link, do not follow it.  This is most useful with the -f
           option, to replace a symlink which may point to a directory.
```

在 BSD/macOS 上，要达到类似 `-T` 的“直接覆盖/替换”效果，通常使用 `-n` 选项（有时与 `-f` 配合）：

- **`-n` (或 `-h`)：** 如果目标名是一个指向目录的**符号链接**，将其视为**文件**，而不是它指向的目录。简单来说，`-h` 的核心作用是：**把符号链接本身当成一个“文件”处理，**而不是顺着链接摸到它背后的实际目标**。**
- **`-f`：** 强制删除已存在的目标。

```
ln -snfv <link_to_path> <link_path>
```

## 删除符号链接

删除指向目录的符号链接（$x \to y$）

> 假设y是目录,而x是指向y的符号链接

原则是：操作对象必须是“文件”本身，而非“路径”,否则可能误删文件

| **命令**        | **效果**         | **安全等级**    | **备注**                                                     |
| --------------- | ---------------- | --------------- | ------------------------------------------------------------ |
| **`unlink x`**  | 删除链接 $x$     | **极高 (推荐)** | 最专业。不支持递归，即便误加 `/` 也会报错，完全不伤及 $y$。  |
| **`rm x`**      | 删除链接 $x$     | **高**          | 简单直接。如果 $x$ 是链接，不会触动 $y$。                    |
| **`rm -rf x`**  | 删除链接 $x$     | **中**          | 常用但有风险。只要**不带斜杠**，它只删链接。                 |
| **`rm -rf x/`** | **清空目录 $y$** | **极危险**      | 末尾的 `/` 告诉系统“进入这个目录”，会导致 $y$ 的内容被递归删除。 |

## ln示例🎈

#### 创建硬链接：

```bash
ln p1 p2
```

创建一个名为`p2`的硬链接，指向`p1`。

或者说为`p1`创建一个位于`p2`路径下的符号(别名),这样如果的好处是:

- `p1`特别长,输入不方便,就可以利用`p2`来代替
- 又比如`p1`是个定期更新的配置文件或目录路径,而某个应用需要读取固定位置下的配置文件,就可以这样创建`p2`符号路径(指向`p1`)



#### 创建符号链接：

```bash
ln -s p1 symlink
```

创建一个名为`symlink`的符号链接，指向`p1`。

#### 在指定目录中创建链接：

```bash
ln p1 p2 /path/to/directory
```

在`/path/to/directory`目录中创建两个硬链接，分别指向`p1`和`p2`。

#### 强制覆盖已经存在的链接：

```bash
ln -sf p1 existing_symlink
```

创建一个名为`existing_symlink`的符号链接，指向`p1`，并覆盖已有的`existing_symlink`。

以上是`ln`命令的基本用法及常用选项的详细介绍。如果需要更多帮助，可以使用`man ln`命令查看手册页。

#### 综合

为当前目录下的`installer.sh`,`uninstaller.sh`在目标目录`/www/shs`下创建强制性(如果存在同名文件则覆盖)两个同名的符号链接

```bash
ln -sf installer.sh uninstaller.sh /www/shs
```

等价于

```
ln -sf -t /www/shs installer.sh uninstaller.sh 
```



##  linux:硬连接和软连接的对比

```bash
#创建硬链接会改变文件的引用计数
#( 05/24/22@ 2:31PM )( cxxu@cxxuAli ):~/testLink
   ec 'abc'>p1
#( 05/24/22@ 2:31PM )( cxxu@cxxuAli ):~/testLink
   ls -li
total 4
1835411 -rw-rw-r-- 1 cxxu cxxu 4 May 24 14:31 p1
#( 05/24/22@ 2:31PM )( cxxu@cxxuAli ):~/testLink
   ln p1 p2_hard
#( 05/24/22@ 2:32PM )( cxxu@cxxuAli ):~/testLink
   ls -li
total 8
1835411 -rw-rw-r-- 2 cxxu cxxu 4 May 24 14:31 p1
1835411 -rw-rw-r-- 2 cxxu cxxu 4 May 24 14:31 p2_hard

#符号链接不会改变引用计数
#( 05/24/22@ 2:32PM )( cxxu@cxxuAli ):~/testLink
   ln -s p1 file3_symbolic
#( 05/24/22@ 2:32PM )( cxxu@cxxuAli ):~/testLink
   ls -li
total 8
1835411 -rw-rw-r-- 2 cxxu cxxu 4 May 24 14:31 p1
1835411 -rw-rw-r-- 2 cxxu cxxu 4 May 24 14:31 p2_hard
1835412 lrwxrwxrwx 1 root root 5 May 24 14:32 file3_symbolic -> p1
#( 05/24/22@ 2:32PM )( cxxu@cxxuAli ):~/testLink
   rm p1
#( 05/24/22@ 2:32PM )( cxxu@cxxuAli ):~/testLink
   ls -li
total 4
1835411 -rw-rw-r-- 1 cxxu cxxu 4 May 24 14:31 p2_hard
1835412 lrwxrwxrwx 1 root root 5 May 24 14:32 file3_symbolic -> p1
```

###  ls -li

```bash
#( 05/24/22@ 2:38PM )( cxxu@cxxuAli ):~/testLink
   manly ls -l -i

ls - list directory contents
============================

      -i, --inode
              print the index number of each file

      -l     use a long listing format
```

### ls -l

```bash
ls -l p1 
-rw-rw-r--. 1 lilo lilo 0 Feb 26 07:08 p1
```

From the output above we can deduct a following information:

- -rw-rw-r- permissions
- 1 : **number of linked hard-links**
- lilo: owner of the file
- lilo: to which group this file belongs to
- 0: size
- Feb 26 07:08 modification/creation date and time
- p1: file/directory name
