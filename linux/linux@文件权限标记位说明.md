[toc]



在 Linux 中，文件权限是系统安全的核心机制之一。

它决定了谁可以读取、修改或执行某个文件或目录。

------

## linux文件系统中的权限结构概览

每个文件或目录的权限由 10 个字符组成，例如：

```
-rwxr-xr--
```

0(123)(456)(789)

其中第一位是类型位

后面三组每组3位,表示对不同对象的权限,组内三位都有可能为`-`,如果不取`-`,则从左往右分别只能是`r,w,x`,代表的值分别是`4,2,1`(对应于$2^{2}$,$2^{1}$,$2^{0}$,而`-`视为0)

| 位置     | 宽度 | 含义                                                         |
| -------- | ---- | ------------------------------------------------------------ |
| 第1位    | 1    | 文件类型：`-` (现代化ls可能表示为`.`)表示普通文件，`d` 表示目录，`l` 表示链接 |
| 第2-4位  | 3    | 所有者权限（Owner）                                          |
| 第5-7位  | 3    | 所属组权限（Group）                                          |
| 第8-10位 | 3    | 其他用户权限（Others）                                       |

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

### 🔐 权限类型说明

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

| 权限字符 | 含义                | 数值表示 |
| -------- | ------------------- | -------- |
| `r`      | 读权限（read）      | 4        |
| `w`      | 写权限（write）     | 2        |
| `x`      | 执行权限（execute） | 1        |
| `-`      | 无权限              | 0        |

组内3位权限求和的可能取值:最小为0,最大为7,且0~7中的数字都有可能

权限组合是通过加法计算的，例如：

- `rwx` = 4 + 2 + 1 = **7**
- `rw-` = 4 + 2 = **6**
- `r--` = 4 = **4**

------

### 🧮 常见权限数字组合

| 数字  | 含义                                           |
| ----- | ---------------------------------------------- |
| `777` | 所有人可读、写、执行（完全开放）               |
| `755` | 所有者可读写执行，其他人只读执行（常用于程序） |
| `644` | 所有者可读写，其他人只读（常用于配置文件）     |
| `700` | 仅所有者可读写执行（私密文件）                 |

------

### 🛠️ 修改权限命令：`chmod`

#### 数字方式：

```bash
chmod 755 filename
```

#### 符号方式：

```bash
chmod u+x filename     # 给所有者添加执行权限
chmod g-w filename     # 移除组的写权限
chmod o=r filename     # 设置其他人只读
```

------

### 📁 目录权限特殊说明

目录的权限与文件略有不同：

| 权限 | 含义                             |
| ---- | -------------------------------- |
| `r`  | 可列出目录内容（如 `ls`）        |
| `w`  | 可创建、删除、重命名目录中的文件 |
| `x`  | 可进入目录（如 `cd`）            |

⚠️ 注意：删除文件的权限取决于目录的写权限，而不是文件本身。

------

###  权限设置

- **递归修改权限**：

  ```bash
  chmod -R 755 /path/to/dir
  ```

- **复制权限**：

  ```bash
  chmod --reference=source.file target.file
  ```

- **设置粘滞位（防止他人删除你的文件）**：

  ```bash
  chmod +t /shared/dir
  ```

------

`chmod`（change mode）是 Linux/Unix 系统中用于修改文件或目录权限的命令。权限决定了谁可以读取、写入或执行文件/目录。



## chmod 的两种表示法

符号表示法比较直观,数字表示法比较简洁

### 1. 符号表示法（Symbolic Mode）

格式：
```bash
chmod [who][operator][permission] 文件/目录
```

- **who**（谁）：
  - `u`：所有者（user）
  - `g`：所属组（group）
  - `o`：其他用户（others）
  - `a`：所有人（all，等同于 ugo）

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

### 2. 数字表示法（Octal / Absolute Mode）

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

## 常用场景

| 场景                         | 命令                                          |
| ---------------------------- | --------------------------------------------- |
| 使脚本可执行                 | `chmod +x script.sh` 或 `chmod 755 script.sh` |
| 仅所有者可读写，其他人无权限 | `chmod 600 secret.txt`                        |
| 网站目录通常设为             | `chmod 755`（目录）和 `chmod 644`（文件）     |
| 共享目录（组内可读写）       | `chmod 775 shared_dir/`                       |

---

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

