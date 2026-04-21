[toc]

## abstract

在Linux操作系统中创建新用户通常涉及到几个关键步骤，这里会介绍通过命令行界面使用 `useradd` 或 `adduser` 命令创建新用户的流程。



##  查看本机用户👺

###  具有家目录的用户(非root用户)

- `ls /home`

```bash
root@arch-virtual-machine:/home# ls
arch  cxxu  roo
```

###  查看所有用户(包括隐藏用户)

```bash
cat /etc/passwd | nl|tac|less
```


  - tac命令用于逆序输出(这一般是我们最先想看到的!) 

- 通常,用户id比较大的(>1000)是给人类用户使用的,或者人工创建的用户(具有通常具有家目录)

## 用户组

在 Linux 权限管理中，**主用户组（Primary Group）**和**附加用户组（Secondary/Supplementary Group）**是实现多租户隔离与协作的核心机制。

可以将这两种组理解为：主组决定了你**“是谁”**（身份归属），而附加组决定了你**“能做什么”**（额外权限）。

------

### 主用户组 (Primary Group)

主组是用户登录系统后的默认身份。

- **唯一性**：每个用户**有且仅有一个**主用户组。
- **GID (Group ID)**：主组的 ID 存储在 `/etc/passwd` 文件的第四列。
- **文件归属**：当用户创建一个新文件或目录时，该文件的**所属组**默认就是该用户的主组。
- **私有组机制 (UPG)**：现代 Linux（如 Ubuntu, CentOS）默认采用“用户私有组”策略，即创建一个名为 `jack` 的用户时，系统会自动创建一个同名的 `jack` 组作为其主组。

------

###  附加用户组 (Secondary Group)

附加组用于给用户分配额外的权限，使其能够访问不属于自己主组的文件。

- **多样性**：一个用户可以属于**零个或多个**附加组。
- **权限扩展**：通常用于授权特定的系统功能。例如，将用户加入 `docker` 组，用户无需 `sudo` 即可运行容器；加入 `sudo` 或 `wheel` 组，用户可获得管理员权限。
- **存储位置**：附加组的关系定义在 `/etc/group` 文件中。

------

###  对比总结表

| **特性**     | **主用户组 (Primary)**     | **附加用户组 (Secondary)**            |
| ------------ | -------------------------- | ------------------------------------- |
| **数量限制** | 必须有且只能有一个         | 可以有多个，也可以没有                |
| **主要作用** | 定义新创建文件的默认所属组 | 获取其他项目或系统的访问权限          |
| **配置历史** | `/etc/passwd`              | `/etc/group`                          |
| **典型例子** | 个人私有组（与用户名相同） | `sudo`, `docker`, `www-data`, `video` |

## 添加用户

### 使用 `adduser` 命令创建新用户

有交互式选项

在某些Linux发行版（比如Ubuntu）中，`adduser` 命令实际上是一个友好的前端脚本，它会自动处理许多细节，包括创建主目录、设置密码以及询问一些附加信息：

```sh
sudo adduser 用户名
```

运行上述命令后，程序会逐步引导您完成创建用户的全过程，包括设置密码等步骤。

### 使用 `useradd` 命令创建新用户

不带交互式选项,可以编写一键添加的命令行,适合于自动化脚本中使用;

```sh
sudo useradd 用户名
```
这条命令会创建一个新用户，但并不会自动为其创建主目录（/home/用户名），也不会设置密码。为了同时创建主目录，并允许用户登录，应当使用 `-m` 选项以及 `-s` 选项指定登录shell：

```sh
sudo useradd -m -s /bin/bash 用户名
```
这里的 `-m` 表示创建主目录，`-s` 指定默认的shell，这里假设使用的是bash shell。

在 Linux 系统中，`useradd` 和 `adduser` 都是用于创建用户的命令，但它们的设计哲学和使用体验有很大差异。

简单来说：**`useradd` 是底层工具**，高效但冷冰冰；**`adduser` 是交互式脚本**（通常是 Perl 脚本），更人性化。

------



##  useradd：底层工具（原生、简洁、直接）

`useradd` 是 Linux 系统的标准底层命令。它在创建用户时**默认不会**创建家目录，也不会提示你设置密码，所有配置都需要通过参数手动指定。

### 核心用法

```Bash
# 基本创建（不带家目录，不带密码）
sudo useradd username

# 常用组合：创建家目录、指定 Shell、加入附加组
sudo useradd -m -s /bin/bash -G sudo username
```

### 常用参数表

| **参数** | **说明**                                                 |
| -------- | -------------------------------------------------------- |
| **`-m`** | **最常用**。自动创建用户家目录（`/home/username`）。     |
| **`-s`** | 指定登录后使用的 Shell（如 `/bin/bash` 或 `/bin/zsh`）。 |
| **`-g`** | 指定初始**主用户组**（GID 或组名）。                     |
| **`-G`** | 指定用户所属的**附加组**（多个组用逗号隔开）。           |
| **`-e`** | 设置账号有效期（格式 YYYY-MM-DD）。                      |
| **`-u`** | 指定用户的 UID。                                         |

> **注意**：使用 `useradd` 后，必须紧跟 `sudo passwd username` 来设置密码，否则**账号是锁定状态**。
>
> `useradd`命令行选项中没有提供直接设置密码的选项;

------

##  adduser：友好脚本（交互、自动、全能）

`adduser` 在 Debian/Ubuntu 等发行版中非常流行。它是对 `useradd` 的高级封装，会自动帮你处理家目录创建、Shell 指定以及密码设置。

### 核心用法

```Bash
sudo adduser username
```

执行后，系统会进入**交互模式**，提示你执行以下操作：

1. 输入并确认密码。
2. 输入用户全名、房间号、电话等（可直接回车跳过）。
3. 自动从 `/etc/skel` 复制配置文件。

### 特点

- **自动化**：默认创建 `/home/username`。
- **交互式**：不需要记复杂的参数。
- **安全性**：强制要求在创建过程中设置密码。

------

##  关键区别对比

| **特性**       | **useradd**                                 | **adduser**                        |
| -------------- | ------------------------------------------- | ---------------------------------- |
| **类型**       | 二进制编译程序（原生）                      | Perl 脚本（高级封装）              |
| **家目录**     | 默认不创建（需加 `-m`）                     | 默认创建                           |
| **交互性**     | 非交互，需手动设置密码                      | 交互式，引导设置                   |
| **默认 Shell** | 通常是 `/bin/sh`（较难用）                  | 通常跟随系统默认（如 `/bin/bash`） |
| **适用场景**   | 脚本自动化、批量创建、极简系统（如 Alpine） | 日常手动管理、Ubuntu/Debian 新手   |

------

##  最佳实践建议

### 场景 A：你在写自动化脚本

建议使用 `useradd`。因为它的行为是完全可预测的，不会中断脚本要求用户输入信息。

```Bash
# 脚本中使用示例
sudo useradd -m -s /bin/bash -G developers new_dev
echo "new_dev:TemporaryPassword123" | sudo chpasswd
```

### 场景 B：你手动给新同事开账号

建议使用 `adduser`。它更省心，不容易漏掉创建家目录或设置权限的步骤。

```Bash
sudo adduser colleague_name
```

### 场景 C：在 Alpine 或 CentOS 系统中

在某些极简环境（如 Alpine Linux）或 RHEL/CentOS 中，`adduser` 可能只是 `useradd` 的一个软链接，此时两者的行为可能完全一致。建议在这种情况下优先查阅该发行版的 `man` 手册。

------





### 基于useradd的一键命令行模板

创建新用户cxxu,允许其使用sudo(添加到sudo组)

对于debian系列的系统

```bash
username='cxxu' 
sudo useradd -m -s /bin/bash $username # 配置改用户默认使用bash,兼容性最好
passwd $username
usermod -aG sudo $username
```

有些工具强调普通用户角色或者非root用户角色来运行,比如brew,wp-cli工具

对于archlinux,纯净安装的版本sudo不可用,需要手动安装并且设置

```bash
#  安装 sudo
sudo pacman -S sudo

#  创建 sudo 组
groupadd sudo

#  将用户加入 sudo 组（替换 $username为具体的名字）
usermod -aG sudo $username

```



## 配置用户免密调用sudo

### 命令行自动编辑

```bash
username='cxxu' #根据需要更改要操作的用户名
#  创建一个包含新规则的临时文件
echo "$username ALL=(ALL) NOPASSWD: ALL" > /tmp/new_sudo_rule

#  使用 visudo 验证临时文件的语法
if visudo -c -f /tmp/new_sudo_rule; then
    echo "语法正确，正在合并..."
    #  将验证通过的规则追加到 /etc/sudoers.d/ 目录下的一个新文件中
    sudo install -m 440 /tmp/new_sudo_rule "/etc/sudoers.d/${username}_nopasswd"
    echo "✅ 用户 $username 已被授予无密码 sudo 权限。"
else
    echo "❌ 语法错误！规则未被应用。"
    rm /tmp/new_sudo_rule
    exit 1
fi

#  清理临时文件
rm /tmp/new_sudo_rule

```

### 手动编辑

```bash
#配置可选的免密sudo,使用标准做法visudo添加以下行(需要注意变量的替换),这会编辑到sudoers文件
"$username ALL=(ALL) NOPASSWD:ALL" 
```

说明:

- `-aG` 表示“追加到组”（append to group），不会影响用户已有的其他组。

- sudoers文件的前几行(参考),使用root权限下运行`visudo`打开

  ```bash
  # This file MUST be edited with the 'visudo' command as root.
  #
  # Please consider adding local content in /etc/sudoers.d/ instead of
  # directly modifying this file.
  ```

### sudo可用性检查

切换到新建用户并检查其sudo可用性

```bash
su - $username
```

1. **首选 `sudo -l`**：因为它专为列出权限设计，安全无害。
2. **次选 `sudo whoami`**：简单直接，效果明显。

```bash
cxxu@s1 /root % sudo -l
Matching Defaults entries for cxxu on s1:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin, use_pty

User cxxu may run the following commands on s1:
    (ALL : ALL) ALL
    (ALL) NOPASSWD: ALL
```

注意,部分命令可能在配置了sudo免密后仍然要求校验sudo用户的密码,比如brew包管理工具的安装过程

#### 实操

- `sudo adduser <userName>`

```bash
➜  ~ sudo adduser cxxu_kali
Adding user `cxxu_kali' ...
Adding new group `cxxu_kali' (1000) ...
Adding new user `cxxu_kali' (1000) with group `cxxu_kali' ...
Creating home directory `/home/cxxu_kali' ...
Copying files from `/etc/skel' ...
New password:
Retype new password:
passwd: password updated successfully
Changing the user information for cxxu_kali
Enter the new value, or press ENTER for the default
        Full Name []:
        Room Number []:
        Work Phone []:
        Home Phone []:
        Other []:
Is the information correct? [Y/n]
➜  ~ sudo adduser cxxu_kali sudo
Adding user `cxxu_kali' to group `sudo' ...
Adding user cxxu_kali to group sudo
Done.
```

- 中途不想填写的可以直接回车继续

- 在比较新的linux发行版中已经可以使用友好的`adduser`来添加linux用户



### 设置或更新用户密码🎈

创建新用户后，您还需要为其设置初始密码才能登录

如果创建用户时忘记了指定密码或则长期没有登录忘记密码,使用`passwd`命令为指定用户更新密码

```sh
sudo passwd 用户名
```
执行此命令后，系统会提示输入密码，按指示输入两次密码以确认。



### 用户分组

- 创建新用户时，系统会根据 `/etc/default/useradd` 文件中的配置自动分配用户ID（UID）和用户组ID（GID），也可以通过 `-u` 参数指定UID，通过 `-g` 参数指定主用户组。
- 若要创建用户并将其加入到已存在的特定用户组，可以使用 `-G` 参数，例如：`sudo useradd -m -G 用户组名 用户名`。

确保作为超级用户（root）执行这些操作，因为管理用户账户通常需要管理员权限。

## 比较adduser@useradd

在Linux环境中，`useradd` 和 `adduser` 命令都用于创建新用户，但在通用性和易用性方面有一些区别：

1. **通用性**：
   - `useradd` 是Linux系统内核自带的基本命令，几乎在所有基于Unix/Linux的操作系统中都有。它提供的功能较为基础，需要手动配合其他命令（如`passwd`）来设置密码，以及通过额外参数（如`-m`）创建家目录等。
   - `adduser` 在一些Linux发行版中（如Debian及其衍生版，如Ubuntu）实际上是`useradd`的一个包装脚本，增加了更多人性化的交互式选项，因此在这些系统中更为常用。但它并非所有Linux发行版的标准命令，所以相比`useradd`在通用性上可能稍弱。

2. **易用性**：
   - `useradd` 命令更适合在编写脚本自动化任务或需要精确控制用户创建过程时使用，因为它提供了丰富的参数，可以精细调整用户账户的各种属性，但对新手而言可能需要查阅文档以了解各个参数的作用。
   - `adduser` 则更偏向于交互式操作，执行命令后会有一系列的提示，指导用户输入相关信息，如密码、全名、房间号等，并且默认会创建家目录、邮箱文件等，无需额外参数。因此，对于日常手工操作和不熟悉命令行的新手来说，`adduser` 显得更加友好和易用。

综上所述，在通用性上，`useradd` 可能略胜一筹，而在易用性上，特别是在需要直观交互的情况下，`adduser` 更具优势。不过，两者的核心功能——创建新用户——都是相同的，只是在具体实现和用户体验上有一定差异。



###  sudo权限组问题
- 某些版本运行adduser后,新建立的用户无法直接运行sudo命令
>xxuser is not in the sudoers file.  This incident will be reported.
* [Creating a new user and modifying its privileges in Linux | Average Linux User](https://averagelinuxuser.com/creating-new-user-linux/#:~:text=Simple%20way%20to%20create%20a%20new%20user%20in,be%20skipped%20if%20you%20want.%20And%20that%E2%80%99s%20it.)
* 执行`sudo adduser <UserName> sudo`赋予该用户sudo的使用权
```bash
cxxu@iZ2zef3tpqffm5ydsjqi4zsdsZ:/etc/apt$ su -
Password:
root@iZ2zef3tpqffm5ydjqi4zsZ:~# sudo adduser cxxu sudo
Adding user `cxxu' to group `sudo' ...
Adding user cxxu to group sudo
Done.
```



## 用户删除🎈

无论用哪种方式创建，删除时的逻辑是相似的：

### userdel

- **只删账号**：`sudo userdel username`
- **删除账号及其家目录**：`sudo userdel -r username` （**慎用**，会删除用户所有数据）

有些发型版支持`deluser`;

### deluser删除用户的所有内容
####  用户进程检查
`ps -u <userName>`


- debian系列发行版下,deluser是首先被推荐用来删除用户

以下操作建议在sudo权限下执行

- 终止要被删除的用户的所有进程 `sudo pkill -KILL -u <userName>`
  - There are different ways to kill a user’s processes, but the command shown here is widely available and is a more modern implementation than some of the alternatives.
  - The `pkill` command will find and kill processes. We’re passing in the ` KILL` signal, and using the `-u` (user) option.
- 执行 `sudo deluser --remove-home <UserName>`

#### 命令行模板

```bash
# 先确认shell处于非目标用户会话下便于删除
username='cxxu'
sudo pkill -KILL -u $username
sudo deluser --remove-home $username
```



#### 实操



```bash
┌──(cxxu_maintainer㉿CxxuWin11)-[/mnt/c/Users/cxxu]
└─$ sudo deluser --remove-home cxxu_kali
Looking for files to backup/remove ...
Removing user `cxxu_kali' ...
Warning: group `cxxu_kali' has no more members.
Done.
```

### userdel删除用户

- 非debain系列发行版可用 `userdel`删除用户
  - `sudo userdel --remove <userName>`将一并删除用户家目录
  - 默认情况下(不带有--remove选项时),不会删除家目录


####  通用版本

```bash
deleteLinuxUser(){
    sudo pkill -KILL -u $1
    sudo userdel --remove $1
}
```

## 修改root密码

当前可以登录root用户shell,则可以直接通过`passwd`设置新密码

> 例如宝塔用户

如果当前shell并非root,但是知道root旧密码,则也可以使用`passwd`修改密码

其他情况请另见它文.

