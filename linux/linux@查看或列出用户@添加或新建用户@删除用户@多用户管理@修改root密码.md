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

- ```bash
  cat /etc/passwd | nl|tac|less
  ```


  - tac命令用于逆序输出(这一般是我们最先想看到的!) 

- 通常,列出的`末尾若干行`是我们创建给人登录的(具有通常具有家目录)

## 添加用户

### 使用 `adduser` 命令创建新用户

有交互式选项

在某些Linux发行版（比如Ubuntu）中，`adduser` 命令实际上是一个友好的前端脚本，它会自动处理许多细节，包括创建主目录、设置密码以及询问一些附加信息：

```sh
sudo adduser 用户名
```

运行上述命令后，程序会逐步引导您完成创建用户的全过程，包括设置密码等步骤。

### 使用 `useradd` 命令创建新用户

不带交互式选项,可以编写一键添加的命令行

```sh
sudo useradd 用户名
```
这条命令会创建一个新用户，但并不会自动为其创建主目录（/home/用户名），也不会设置密码。为了同时创建主目录，并允许用户登录，应当使用 `-m` 选项以及 `-s` 选项指定登录shell：

```sh
sudo useradd -m -s /bin/bash 用户名
```
这里的 `-m` 表示创建主目录，`-s` 指定默认的shell，这里假设使用的是bash shell。

#### 一键命令行模板🎈

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
# 1. 安装 sudo
sudo pacman -S sudo

# 2. 创建 sudo 组
groupadd sudo

# 3. 将用户加入 sudo 组（替换 $username为具体的名字）
usermod -aG sudo $username

```



#### 配置用户免密调用sudo

##### 命令行自动编辑

```bash
username='cxxu' #根据需要更改要操作的用户名
# 1. 创建一个包含新规则的临时文件
echo "$username ALL=(ALL) NOPASSWD: ALL" > /tmp/new_sudo_rule

# 2. 使用 visudo 验证临时文件的语法
if visudo -c -f /tmp/new_sudo_rule; then
    echo "语法正确，正在合并..."
    # 3. 将验证通过的规则追加到 /etc/sudoers.d/ 目录下的一个新文件中
    sudo install -m 440 /tmp/new_sudo_rule "/etc/sudoers.d/${username}_nopasswd"
    echo "✅ 用户 $username 已被授予无密码 sudo 权限。"
else
    echo "❌ 语法错误！规则未被应用。"
    rm /tmp/new_sudo_rule
    exit 1
fi

# 4. 清理临时文件
rm /tmp/new_sudo_rule

```

##### 手动编辑

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

#### sudo可用性检查

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



### 分组

- 创建新用户时，系统会根据 `/etc/default/useradd` 文件中的配置自动分配用户ID（UID）和用户组ID（GID），也可以通过 `-u` 参数指定UID，通过 `-g` 参数指定主用户组。
- 若要创建用户并将其加入到已存在的特定用户组，可以使用 `-G` 参数，例如：`sudo useradd -m -G 用户组名 用户名`。

确保作为超级用户（root）执行这些操作，因为管理用户账户通常需要管理员权限。

### 比较adduser@useradd

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
