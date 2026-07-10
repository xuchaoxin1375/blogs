[toc]

## abstract

在 Linux 中，文件权限是系统安全的核心机制之一。

它决定了谁可以读取、修改或执行某个文件或目录。

------

## linux文件系统中的权限结构概览

每个文件或目录的位模式由 10 个字符组成

例如：`-rwxr-xr--` 是一串代表**文件类型**和**访问权限**的字符串(通常称为Permissions)。它可以拆解为四个部分来理解：

0(123)(456)(789)

> 其中第1位是类型位,后面9位才是权限位
>

后面三组每组3位,表示对不同对象的权限,组内三位都有可能为`-`,如果不取`-`,则从左往右分别只能是`r,w,x`,代表的值分别是`4,2,1`(对应于$2^{2}$,$2^{1}$,$2^{0}$,而`-`视为0)

| 位置     | 宽度 | 含义                                                         |
| -------- | ---- | ------------------------------------------------------------ |
| 第1位    | 1    | 文件类型：`-` (现代化ls可能表示为`.`)表示普通文件，`d` 表示目录，`l` 表示链接 |
| 第2-4位  | 3    | 所有者权限（Owner）                                          |
| 第5-7位  | 3    | 所属组权限（Group）                                          |
| 第8-10位 | 3    | 其他用户权限（Others）                                       |

## 相关命令

### stat 命令查看权限位

虽然`ls -l`可以列出文件权限位，但是`stat`列出的`access`还给出了数字表示形式

```bash
(base) #( 04/17/26@10:18AM )( cxxu@CxxuDesk ):~
   stat archived
  File: archived
  Size: 4096            Blocks: 8          IO Block: 4096   directory
Device: 8,48    Inode: 38          Links: 2
Access: (0755/drwxr-xr-x)  Uid: ( 1000/    cxxu)   Gid: ( 1000/    cxxu)
```



### chmod命令修改权限位

`chmod`（change mode）是 Linux/Unix 系统中用于修改文件或目录权限的命令。权限决定了谁可以读取、写入或执行文件/目录。

> `chmod `命令根据 mode 修改每个给定文件的文件模式位，其中 mode 可以是表示要进行的更改的符号表示 或者是一个表示新模式位的位模式的八进制数。

chmod命令用法灵活,使用前一般是要深思熟虑的;

但如果是一些常用的文件权限设置,则可以依靠记忆直接执行;

```bash
   chmod --help
Usage: chmod [OPTION]... MODE[,MODE]... FILE...
  or:  chmod [OPTION]... OCTAL-MODE FILE...
  or:  chmod [OPTION]... --reference=RFILE FILE...
Change the mode of each FILE to MODE.
```

符号模式的格式为` [ugoa...][[+-=][perms...]...]]`, 其中 perms 是从集合 rwxXst 中零个或多个字母，或者是从集合 ugo 中单个字母。 可以给出多个符号模式，用逗号分隔。

字母 ugoa 的组合控制将改变哪些用户对文件的访问权限：文件的所有者（u）， 文件所属组中的其他用户（g）、文件所属组外的其他用户（o），或所有用户（a）。 如果这些都不给出，效果就像给出了 a 一样，但 umask 中设置的位不会受到影响。

运算符+会导致选定的文件模式位被添加到每个文件的现有文件模式位上； - 导致它们被移除； and = 导致它们被添加，并导致未提及的位被移除，但目录的未提及的设置用户和组 ID 位不受影响。

字母 rwxXst 用于选择受影响用户的文件模式位：读取（r）、写入（w）、执行（或搜索目录）（x）， 如果文件是目录或已为某些用户（X）设置了执行权限，则仅执行搜索，在执行时设置用户或组 ID（s）， 受限删除标志或粘性位（t） 替代一个或多个这些字母，您可以指定 ugo 中的确切一个字母：文件所有者（u）被授予的权限 授予文件所属组（g）的成员的其他用户的权限， 以及授予不属于前两类用户的权限（o）。

一个数值模式由一到四个八进制数字（0-7）组成，通过将具有 4、2 和 1 值的位相加得到。 省略的数字被视为前导零。 第一个数字选择设置用户 ID（4）、设置组 ID（2）和受限删除或粘性（1）属性。 第二个数字选择文件所有者的权限：读取（4）、写入（2）和执行（1）； 第三个选择文件组内其他用户的权限，使用相同的值；第四个选择文件组外其他用户的权限 使用相同的值。

**chmod 永远不会改变符号链接的权限**；chmod 系统调用无法改变它们的权限。 由于符号链接的权限从未被使用，所以这不是一个问题。 然而，**对于命令行中列出的每个符号链接，chmod 会改变指向的文件的权限**。 相比之下，chmod 会忽略在递归目录遍历过程中遇到的符号链接。

------

```bash
#( 10/03/25@11:38PM )( root@CxxuFirebat ):~
   ll
total 24K
drwxr-xr-x 2 root root 4.0K Oct  3 22:53 archived
-rw-r--r-- 1 root root  20K Oct  3 22:34 install.sh
lrwxrwxrwx 1 root root   13 Oct  3 23:38 zstdL -> /usr/bin/zstd
```

使用` chmod +x install.sh`可以为上述例子中的`install.sh`文件添加可执行权限,原本需要`bash install.sh`执行,现在可以省略`bash`

```bash
   ll install.sh
-rwxr-xr-x 1 root root 20K Oct  3 22:34 install.sh
```

可以看到,`chmod +x`为所有用户(组)提供了可执行权限

### 权限类型说明

每个文件或目录有三类用户：

1. **所有者（User / Owner）**：文件的创建者或拥有者。
2. **所属组（Group）**：文件所属用户组的成员。
3. **其他用户（Others）**：系统中除所有者和组成员外的所有用户。

每类用户可设置三种权限：

- **r（read）**：读取权限
  - 文件：可查看内容
  - 目录：可列出目录内容（如 `ls`）
- **w（write）**：写入权限
  - 文件：可修改内容
  - 目录：可在目录中创建、删除、重命名文件
- **x（execute）**：执行权限
  - 文件：可作为程序运行（如脚本、二进制文件）
  - 目录：可进入该目录（如 `cd`）

#### 权限数字关系表

| 权限字符 | 含义                | 数值表示 |
| -------- | ------------------- | -------- |
| `r`      | 读权限（read）      | 4        |
| `w`      | 写权限（write）     | 2        |
| `x`      | 执行权限（execute） | 1        |
| `-`      | 无权限              | 0        |

组内3位权限求和的可能取值:最小为0,最大为7,且0~7中的数字都有可能

权限组合是通过加法计算的，例如：

- `rwx` = 4+2+1 = **7**
- `rw-` = 4+2+0 = **6**
- `r--` = 4+0+0 = **4**

------

### 常见权限数字组合

| 数字  | 含义                                                    |
| ----- | ------------------------------------------------------- |
| `777` | 所有人可读、写、执行（完全开放）                        |
| `755` | 所有者可读写执行，其他人只读执行（常用于程序）          |
| `644` | 所有者可读写，其他人只读（常用于**配置文件**,不可执行） |
| `700` | 仅所有者可读写执行（私密文件）                          |

------



### 目录权限特殊说明

目录的权限与文件略有不同：

| 权限 | 含义                             |
| ---- | -------------------------------- |
| `r`  | 可列出目录内容（如 `ls`）        |
| `w`  | 可创建、删除、重命名目录中的文件 |
| `x`  | 可进入目录（如 `cd`）            |

⚠️ 注意：删除文件时检查的权限,不仅仅是文件本身的**写权限**,还取决于目录的**写权限**，

------

## 粘滞位(sticky)

`chmod +t` 命令用于设置 **粘滞位（Sticky Bit）**。在现代 Linux 系统中，它通常应用于**共享目录**，以保护其中的文件不被他人误删。

```bash
(base) #( 04/17/26@10:34AM )( cxxu@CxxuDesk ):~
   ls -l getopts_ind.sh
-rwxr-xr-x 1 cxxu cxxu 594 Feb  8 15:29 getopts_ind.sh
# 设置粘滞位(+t)
(base) #( 04/17/26@10:34AM )( cxxu@CxxuDesk ):~
   chmod +t getopts_ind.sh
   
(base) #( 04/17/26@10:35AM )( cxxu@CxxuDesk ):~
   ls -l getopts_ind.sh
-rwxr-xr-t 1 cxxu cxxu 594 Feb  8 15:29 getopts_ind.sh
```

可以看到修改后的模式位多出来一个`t`

```bash
(base) #( 04/17/26@10:35AM )( cxxu@CxxuDesk ):~
   ls -l log.log
-rw-r--r-- 1 cxxu cxxu 1 Mar  1 18:09 log.log
(base) #( 04/17/26@10:37AM )( cxxu@CxxuDesk ):~
   chmod +t log.log
(base) #( 04/17/26@10:37AM )( cxxu@CxxuDesk ):~
   ls -l log.log
-rw-r--r-T 1 cxxu cxxu 1 Mar  1 18:09 log.log
```

这里`log.log`本身不具备执行权限,因此`+t`后多出来的位是`T`而不是`t`

------

###  核心作用：防止“误删”

在一个普通权限的目录中，如果用户对目录有“写（w）”权限，他们就可以删除该目录下的**任何**文件，即使该文件并不属于他们。

**开启粘滞位（+t）后，规则变为：**

只有以下三类人可以删除或重命名目录下的文件：

1. **文件所有者**（文件的 Creator）。
2. **目录所有者**（该共享目录的主人）。
3. **超级用户（root）**。

其他即便拥有写权限的用户，也无法删除别人的文件。

------

###  权限表现形式

当你执行完该命令后，使用 `ls -ld /shared/dir` 查看权限，你会发现在权限字符串的末尾出现了一个 **`t`** 或 **`T`**：

- **`rwxrwxrwt` (小写 t)**：表示该目录原本就有执行（x）权限，且开启了粘滞位。
- **`rwxrwxrwT` (大写 T)**：表示该目录**原本没有执行（x）权限**，此时粘滞位**虽然开启但不会真正起作用**（因为进入不了目录）。

------

###  经典案例：`/tmp` 目录

Linux 系统中的 `/tmp` 目录是粘滞位的最典型应用。

所有用户都可以在 `/tmp` 创建临时文件（权限通常是 `1777`），但如果没有粘滞位，用户 A 就能删掉用户 B 正在运行的程序生成的临时文件，导致系统混乱。通过设置 `+t`，系统确保了每个人只能管理自己的临时数据。

------

###  命令用法

- **添加粘滞位**：

  ```bash
  chmod +t /shared/dir
  ```
  
- **使用数字表示法（四位权限码）**：

  粘滞位对应的数字是 **1**。如果你想设置一个权限为 777 的共享目录并加上粘滞位：

  ```bash
  chmod 1777 /shared/dir
  ```
  
- **移除粘滞位**：

  

  ```bash
  chmod -t /shared/dir
  ```

------

### 总结

| **特性**     | **详情**                        |
| ------------ | ------------------------------- |
| **主要目标** | 保护文件不被非所有者删除。      |
| **应用对象** | 主要是多用户共享的可写目录。    |
| **符号标识** | 权限末尾的 `t`。                |
| **数字标识** | 第一位数字为 `1`（如 `1755`）。 |

如果你正在配置一个供团队上传文件的共享文件夹，执行 `chmod +t` 是保证数据安全的最佳实践。

## chmod 的两种表示法

符号表示法比较直观,数字表示法比较简洁

###  符号表示法ugoa（Symbolic Mode）

格式：
```bash
chmod [who][operator][permission] 文件/目录
```

- **who**（谁）：
  - `u`：所有者（user）
  - `g`：所属组（group）
  - `o`：其他用户（others）
  - `a`：所有人（all，等同于 ugo）

  > 所有者用user表示而不是owner表示,避免和others混淆

- **operator**（操作符）：
  - `+`：添加权限
  - `-`：移除权限
  - `=`：设置为指定权限（覆盖原有）

- **permission**（权限）：
  - `r`、`w`、`x`

#### 示例：
```bash
# 给所有者添加执行权限
chmod u+x script.sh

# 移除组和其他用户的写权限
chmod go-w file.txt

# 设置所有用户只有读权限
chmod a=r file.txt

# 给所有人添加读和执行权限（目录常用）
chmod a+rx mydir/
```

---

###  数字表示法(rwx)（Octal / Absolute Mode）

用三位八进制数表示权限，每位对应一类用户：

| 权限 | 数值 |
| ---- | ---- |
| r    | 4    |
| w    | 2    |
| x    | 1    |

将权限相加得到每位的数字：

- `rwx` = 4+2+1 = **7**
- `rw-` = 4+2+0 = **6**
- `r-x` = 4+0+1 = **5**
- `---` = 0

格式：假设X,Y,Z分被对应三组角色的八进制数
```bash
chmod XYZ 文件/目录
```
其中：
- X：所有者权限
- Y：组权限
- Z：其他用户权限

#### 示例：
```bash
# 所有者：读写执行（7），组：读执行（5），其他：读执行（5）
chmod 755 script.sh

# 所有者：读写（6），组：读（4），其他：无权限（0）
chmod 640 config.conf

# 所有用户完全控制（谨慎使用！）
chmod 777 dangerous_file
```

---

### 权限变更时打印详细信息

使用`--verbose`查看`chmod`的执行信息

```bash
   chmod --verbose +x log.log
mode of 'log.log' changed from 1644 (rw-r--r-T) to 1755 (rwxr-xr-t)
```

还可以用来查看文件的详细权限位:

```bash
(base) #( 04/17/26@10:54AM )( cxxu@CxxuDesk ):~
   chmod --verbose --reference=log.log log.log
mode of 'log.log' retained as 1755 (rwxr-xr-t)
```



## 目录上的执行权限含义

对于目录而言，**执行权限（Executable, `x`）** 的意义与普通文件完全不同。在文件上，`x` 代表运行程序；但在目录上，`x` 权限通常被称为 **“搜索权限”（Search bit）**。

它是访问目录内容的**“通行证”**。以下是详细解析：

------

### 1. 核心意义：进入与穿透

如果一个目录没有 `x` 权限，你将无法“进入”这个目录，也**无法打开访问该目录下的任何子内容**(但是可以列出该目录内部文件名)。

- **没有 `x` 权限**：你无法使用 `cd` 进入该目录。
- **拥有 `x` 权限**：你可以将该目录作为路径的一部分。例如，要访问 `/data/photos/me.jpg`，你必须对 `data` 和 `photos` 目录都拥有 `x` 权限，才能最终触达到文件。

------

### 2. 读（r）与执行（x）的区别

这是很多初学者容易混淆的地方。我们可以通过下表对比：

| **权限组合**          | **允许的操作**                                               | **禁止的操作**                                               |
| --------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **仅有 `r`** (无 `x`) | 可以用 `ls` 列出目录下的文件名。                             | **无法** `cd` 进去；**无法**查看文件详情（大小、权限）；**无法**读取文件内容。 |
| **仅有 `x`** (无 `r`) | **可以** `cd` 进去；如果知道确切文件名，**可以**读取文件内容。 | **无法**使用 `ls` 查看目录里有哪些文件。                     |
| **`r` + `x`**         | 完全访问：既能列出文件列表，也能进入并操作。                 | -                                                            |

> **关键点：** 如果你没有 `x` 权限，即便你有 `r` 权限能看到文件名，你也无法获取文件的元数据（如 `ls -l` 显示的权限和所有者会变成一堆问号 `?`）。

```bash
(base) #( 04/17/26@10:45AM )( cxxu@CxxuDesk ):~
   chmod +x dir
(base) #( 04/17/26@10:45AM )( cxxu@CxxuDesk ):~
   ls -l -d dir
drwxr-xr-x 4 cxxu cxxu 4096 Mar 14 19:08 dir
(base) #( 04/17/26@10:45AM )( cxxu@CxxuDesk ):~
   ls dir
1.txt  2.txt  project  s1

# 移除x权限
(base) #( 04/17/26@10:46AM )( cxxu@CxxuDesk ):~
   chmod -x dir
(base) #( 04/17/26@10:46AM )( cxxu@CxxuDesk ):~
   ls -l -d dir
drw-r--r-- 4 cxxu cxxu 4096 Mar 14 19:08 dir
# 发现列出dir目录内容时遇到一些权限问题,但还是能够看到文件名列表,只是文件内容不可查看
(base) #( 04/17/26@10:46AM )( cxxu@CxxuDesk ):~
   ls dir
ls: cannot access 'dir/project': Permission denied
ls: cannot access 'dir/2.txt': Permission denied
ls: cannot access 'dir/1.txt': Permission denied
ls: cannot access 'dir/s1': Permission denied
1.txt  2.txt  project  s1

(base) #( 04/17/26@10:46AM )( cxxu@CxxuDesk ):~
   cat dir/1.txt
cat: dir/1.txt: Permission denied

```



------

### 3. 写（w）与执行（x）的配合

**写权限（w）必须配合执行权限（x）才能生效。**

- 如果你只有 `w` 而没有 `x`，你无法进入目录，自然也就无法在该目录下创建、删除或重命名任何文件。
- 通常为了管理目录，我们会同时赋予 `wx` 权限。

------

### 4. 权限组合的实际应用场景

- **高度机密目录（仅 `x`）**：

  如果你想让别人能运行你目录里的某个脚本，但不想让他们看到目录里还有其他什么文件。你可以只给目录 `x` 权限。用户必须输入完整的文件路径（如 `./secret_dir/run.sh`）才能执行，直接输入 `ls secret_dir` 会被拒绝。

- **公共资源目录（`r-x`）**：

  这是最常见的设置。允许所有人进入目录并列出内容，但不允许创建或删除文件。

------

### 总结

在 Linux 权限管理中：

- **目录的 `r`**：决定你能不能**看**里面有什么。
- **目录的 `x`**：决定你能不能**通过**或**进入**这个目录。

**没有 `x` 权限，目录就像一把锁死的门，即使你能从窗户（`r` 权限）看到里面的东西，也无法走进去触碰它们。**

## 常用场景

| 场景                         | 命令                                          |
| ---------------------------- | --------------------------------------------- |
| 使脚本可执行                 | `chmod +x script.sh` 或 `chmod 755 script.sh` |
| 仅所有者可读写，其他人无权限 | `chmod 600 secret.txt`                        |
| 网站目录通常设为             | `chmod 755`（目录）和 `chmod 644`（文件）     |
| 共享目录（组内可读写）       | `chmod 775 shared_dir/`                       |

---

###  权限设置常见用例

- **递归修改权限**：

  ```bash
  chmod -R 755 /path/to/dir
  ```

- **复制权限**：

  ```bash
   --reference=RFILE  use RFILE's mode instead of specifying MODE values.
                           RFILE is always dereferenced if a symbolic link.
  
  ```

  > RFILE（reference file)

  ```bash
  chmod --reference=<referencefile> ...
  ```

- **设置粘滞位（防止他人删除你的文件）**：

  ```bash
  chmod +t /shared/dir
  ```

------





## 注意事项🎈

### 目录x权限

**目录必须有 `x` 权限才能进入**，即使有 `r` 权限也无法 `cd`。

```bash
drwxr-xr-x cxxu cxxu 4.0 KB Sun Oct  5 20:02:33 2025 ├──  archived
.rw-r--r-- cxxu cxxu   4 B  Sun Oct  5 20:02:33 2025 │   └──  f
```



```bash
#( 10/05/25@ 8:02PM )( cxxu@CxxuFirebat ):~
   chmod -x archived
#( 10/05/25@ 8:03PM )( cxxu@CxxuFirebat ):~
   ls archived
ls: cannot access 'archived/f': Permission denied
f
#( 10/05/25@ 8:03PM )( cxxu@CxxuFirebat ):~
   cd archived
cd: permission denied: archived
#( 10/05/25@ 8:03PM )( cxxu@CxxuFirebat ):~
   cat archived/f
cat: archived/f: Permission denied
#( 10/05/25@ 8:12PM )( cxxu@CxxuFirebat ):~
   lsd -l --tree
lsd: ./archived/f: Permission denied (os error 13).

drwx------ cxxu cxxu 4.0 KB Sun Oct  5 20:12:28 2025  .
drw-r--r-- cxxu cxxu 4.0 KB Sun Oct  5 20:02:33 2025 ├──  archived
.rw-r--r-- cxxu cxxu  19 KB Sun Oct  5 19:59:45 2025 ├──  gitee_install.sh
.rw-r--r-- cxxu cxxu  19 KB Sun Oct  5 19:59:45 2025 └──  install.sh
```

如果使用管理员权限(比如借用sudo)来查看,可以无视`x`权限的缺失

```bash
#( 10/05/25@ 8:09PM )( cxxu@CxxuFirebat ):~
   sudo ls -l archived
total 4
-rw-r--r-- 1 cxxu cxxu 4 Oct  5 20:02 f
```

可见,这个权限限制仅对非root有效

恢复权限:

```bash

#( 10/05/25@ 8:12PM )( cxxu@CxxuFirebat ):~
   chmod +x archived
#( 10/05/25@ 8:12PM )( cxxu@CxxuFirebat ):~
   lsd -l --tree
drwx------ cxxu cxxu 4.0 KB Sun Oct  5 20:12:42 2025  .
drwxr-xr-x cxxu cxxu 4.0 KB Sun Oct  5 20:02:33 2025 ├──  archived
.rw-r--r-- cxxu cxxu   4 B  Sun Oct  5 20:02:33 2025 │   └──  f
.rw-r--r-- cxxu cxxu  19 KB Sun Oct  5 19:59:45 2025 ├──  gitee_install.sh
.rw-r--r-- cxxu cxxu  19 KB Sun Oct  5 19:59:45 2025 └──  install.sh
```



### 删除文件的权限

删除文件的权限由其所在目录的 `w`（写）权限决定,而非文件本身。

- 文件系统中，**文件名存储在目录中**，而文件内容存储在 inode 中。
- 删除一个文件，实际上是**从目录中移除该文件名到 inode 的链接**。
- 因此，删除操作是对**目录**的修改，而不是对文件本身的修改。

即使你对某个文件**没有写权限**（甚至没有读权限），只要对**其所在目录有 `w` 权限**，你就可以删除它。

- 反之，即使你对文件有 `rwx` 全权限，但对目录**没有 `w` 权限**，也无法删除该文件。

```bash
#( 10/05/25@ 8:17PM )( cxxu@CxxuFirebat ):~
   eza -l --tree --header
Permissions Size User Date Modified Name
drwx------     - cxxu  5 Oct 20:17  .
drwxr-xr-x     - cxxu  5 Oct 20:02  ├── archived
.rw-r--r--     4 cxxu  5 Oct 20:02  │   └── f

#( 10/05/25@ 8:17PM )( cxxu@CxxuFirebat ):~
   chmod -w archived
#( 10/05/25@ 8:18PM )( cxxu@CxxuFirebat ):~
   eza -l --tree --header
Permissions Size User Date Modified Name
drwx------     - cxxu  5 Oct 20:18  .
dr-xr-xr-x     - cxxu  5 Oct 20:02  ├── archived
.rw-r--r--     4 cxxu  5 Oct 20:02  │   └── f


```

现在,尝试移除archived目录下的文件`f`(现在用户对目录`archived`的w权限缺失,无法删除其下的文件)

```bash

#( 10/05/25@ 8:18PM )( cxxu@CxxuFirebat ):~
   rm archived/f
rm: cannot remove 'archived/f': Permission denied

# 恢复对archived目录的w权限,然后重新删除即可
#( 10/05/25@ 8:18PM )( cxxu@CxxuFirebat ):~
   chmod +w archived
#( 10/05/25@ 8:19PM )( cxxu@CxxuFirebat ):~
   eza -l --tree --header
Permissions Size User Date Modified Name
drwx------     - cxxu  5 Oct 20:19  .
drwxr-xr-x     - cxxu  5 Oct 20:02  ├── archived
.rw-r--r--     4 cxxu  5 Oct 20:02  │   └── f

#( 10/05/25@ 8:19PM )( cxxu@CxxuFirebat ):~
   rm archived/f
#( 10/05/25@ 8:19PM )( cxxu@CxxuFirebat ):~
   eza -l --tree --header
Permissions Size User Date Modified Name
drwx------     - cxxu  5 Oct 20:19  .
drwxr-xr-x     - cxxu  5 Oct 20:19  ├── archived

```

⚠️ **注意**：为了防止用户随意删除他人文件，通常会在共享目录（如 `/tmp`）上设置 **sticky bit**（`t` 权限位），此时只有文件所有者、目录所有者或 root 才能删除文件。

✅ **结论**：能否删除文件，取决于**父目录是否具有 `w` 权限**（以及 sticky bit 的限制），与文件自身的权限无关。

```bash
chmod -R 755 /path/to/dir
```

---

## 查看当前权限

使用 `ls -l` 查看文件权限：
```bash
$ ls -l myfile.txt
-rw-r--r-- 1 user group 0 Jan 1 12:00 myfile.txt
```
- 第一个 `-` 表示是普通文件（`d` 表示目录）
- 接下来的 `rw-r--r--` 分为三组：
  - `rw-`：所有者（user）
  - `r--`：组（group）
  - `r--`：其他（others）

