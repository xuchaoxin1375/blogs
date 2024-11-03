[toc]

## abstract

- 在Linux操作系统中创建新用户通常涉及到几个关键步骤，这里会介绍通过命令行界面使用 `useradd` 或 `adduser` 命令创建新用户的流程。

### 使用 `useradd` 命令创建新用户（不带交互式选项）
```sh
sudo useradd 用户名
```
这条命令会创建一个新用户，但并不会自动为其创建主目录（/home/用户名），也不会设置密码。为了同时创建主目录，并允许用户登录，应当使用 `-m` 选项以及 `-s` 选项指定登录shell：

```sh
sudo useradd -m -s /bin/bash 用户名
```
这里的 `-m` 表示创建主目录，`-s` 指定默认的shell，这里假设使用的是bash shell。

### 设置用户密码：
创建新用户后，您还需要为其设置初始密码才能登录：
```sh
sudo passwd 用户名
```
执行此命令后，系统会提示输入密码，按指示输入两次密码以确认。

### 使用 `adduser` 命令创建新用户（带有交互式选项）
在某些Linux发行版（比如Ubuntu）中，`adduser` 命令实际上是一个友好的前端脚本，它会自动处理许多细节，包括创建主目录、设置密码以及询问一些附加信息：
```sh
sudo adduser 用户名
```
运行上述命令后，程序会逐步引导您完成创建用户的全过程，包括设置密码等步骤。

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

#### 总结

综上所述，在通用性上，`useradd` 可能略胜一筹，而在易用性上，特别是在需要直观交互的情况下，`adduser` 更具优势。不过，两者的核心功能——创建新用户——都是相同的，只是在具体实现和用户体验上有一定差异。



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

###  sudo权限组问题
- 某些版本运行adduser后,新建立的用户无法直接运行sudo命令
>xxuser is not in the sudoers file.  This incident will be reported.
* [Creating a new user and modifying its privileges in Linux | Average Linux User](https://averagelinuxuser.com/creating-new-user-linux/#:~:text=Simple%20way%20to%20create%20a%20new%20user%20in,be%20skipped%20if%20you%20want.%20And%20that%E2%80%99s%20it.)
* 执行`sudo adduser <UserName> sudo`赋予该用户sudo的使用权
```bash
cxxu@iZ2zef3tpqffm5ydsjqi4zsdsZ:/etc/apt$ su -
Password:
root@iZ2zef3tpqffm5ydjdfsfqi4zsZ:~# sudo addusr cxxu sudo
sudo: addusr: command not found
root@iZ2zef3tpqffm5ydjqi4zsZ:~# sudo adduser cxxu sudo
Adding user `cxxu' to group `sudo' ...
Adding user cxxu to group sudo
Done.
```



## 用户删除

### deluser删除用户的所有内容
####  用户进程检查
`ps -u <userName>`


- (debian系列发行版下),deluser是首先被推荐用来删除用户

以下操作建议再sudo权限下执行

- 终止要被删除的用户的所有进程 `sudo pkill -KILL -u <userName>`
  - There are different ways to kill a user’s processes, but the command shown here is widely available and is a more modern implementation than some of the alternatives.
  - The `pkill` command will find and kill processes. We’re passing in the ` KILL` signal, and using the `-u` (user) option.
- 执行 `sudo deluser --remove-home <UserName>`
  - ```bash
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

###  用户删除整合

#### 具有deluser的发行版
- `deleteUser <userName>`
```bash
deleteUser(){
    sudo pkill -KILL -u $1
    sudo deluser --remove-home $1
}
```
####  通用版本
```bash
deleteLinuxUser(){
    sudo pkill -KILL -u $1
    sudo userdel --remove $1
}
```
## 切换用户👺

- 使用 `su -l <userName>` 切换到指定用户
  - `-l` 可以简写为 `-`
  - 不写用户名默认切换到 `root`
- 还支持指定切换后的环境:(工作目录和shell)
  - -p 指定工作目录
  - -s 指定shell

* > In Linux, the `su` command (switch user) is used to run a command as a different user.
  >

## How the su Command Works

The `su` command is used to run a function as a different user. It is the easiest way to switch or change to the administrative account in the current logged in session.

Some versions of Linux, like Ubuntu, disable the root user account by default [making the system more secure](https://phoenixnap.com/kb/server-security-tips). But, this also restricts the user from running specific commands.

Using `su` to temporarily act as a root user allows you to bypass this restriction and perform different tasks with different users.

> Note : A  root  account is a master administrator account with full access and permissions in the system. Because of the severity of changes this account can make, and because of the risk of it being compromised, most Linux versions use limited user accounts for normal use.

## su Command Syntax

To use the `su` command, enter it into a command-line as follows:

```plaintext
su [options] [username [arguments]]
```

If a username is specified, `su` defaults to the superuser (root). Simply [find the user](https://phoenixnap.com/kb/how-to-list-users-linux) you need and add it to the `su` command syntax.

### su Command Options

To display a list of commands, enter the following:

```plaintext
su –h
```

```plaintext
cxxu@iZ2zef3tpqffm5ydjqi4zsZ:/etc/apt$ su -h
Usage: su [options] [LOGIN]

Options:
  -c, --command COMMAND         pass COMMAND to the invoked shell
  -h, --help                    display this help message and exit
  -, -l, --login                make the shell a login shell
  -m, -p,
  --preserve-environment        do not reset environment variables, and
                                keep the same shell
  -s, --shell SHELL             use SHELL instead of the default in passwd
```

## su Command Examples

### Switch to a Different User

To switch the logged-in user in this terminal window, enter the following:

```plaintext
su –l [other_user]
```

You’ll be asked for a password. Enter it, and the login will change to that user.

If you omit a username, it will default to the  root  account. Now, the logged-in user can run all system commands. This will also change the home directory and path to executable files.

Use the `whoami` command to verify you switched to a different user.

 Note : If you are having issues with authentication, you can [change the root or sudo password](https://phoenixnap.com/kb/change-root-password-ubuntu) in a couple of simple steps.

### Run Specific Command as a Different User

To run a specific command as a different user, use the `–c` option:

```plaintext
su –c [command] [other_user]
```

The system will respond by asking you for the user password.

When you enter this example, the system will use the specified account to run the `ls` (list directory contents) command.



### Use a Different Shell

To use a different shell, or operating environment, enter the following:

```plaintext
su –s /usr/bin/zsh
```

This command opens a root user account in  Z shell .

### Use a Different User in the Same Environment

You can keep the environment of the current user account with the `–p` option:

```plaintext
su –p [other_user]
```

Replace  \[other\_user\]  with the actual username you want to switch to.

The user account will switch, but you’ll keep the same home directory. This is useful if you need to run a command as a different user, but you need access to the current user’s data.

To verify you remained in the same home environment, use the `echo $HOME` command that will display the directory you are working in.

## Command Comparison: su vs sudo

### sudo Command

* The `sudo` command grants a one-time or limited-time access to root functionality.
* Typically, the [`sudo` command](https://phoenixnap.com/kb/linux-sudo-command) is used to quickly run an administrative command, then return to the user account’s regular permissions.

To provide sudo access, the user has to be [added to the sudo group](https://phoenixnap.com/kb/how-to-create-sudo-user-on-ubuntu).

>  Note : By default, some versions of Linux (such as Ubuntu) disable the root account. That means there’s no password assigned to the root user. However you can switch to root by running the following command and entering the currently logged-in user’s password:

```plaintext
sudo su -
```

### su Command

* The `su` command lets you switch the current user to any other user.
* If you need to run a command as a different (non-root) user, use the `–l [username]` option to specify the user account.
* Additionally,`su` can also be used to change to a different shell interpreter on the fly.
* `su` is an older but more ` fully-featured` command.
  * It can duplicate the functionality of `sudo ` by use of the `–c` option to pass a single command to the shell.

###  reference adduser
[reference link:Creating a new user and modifying its privileges in Linux](https://averagelinuxuser.com/creating-new-user-linux/#:~:text=Simple%20way%20to%20create%20a%20new%20user%20in,be%20skipped%20if%20you%20want.%20And%20that%E2%80%99s%20it.)

### references su/sudo

- [ su Command ](https://phoenixnap.com/kb/su-command-linux-examples)
### reference delete user

- [How to Delete a User on Linux (and Remove Every Trace) (howtogeek.com)](https://www.howtogeek.com/656549/how-to-delete-a-user-on-linux-and-remove-every-trace/)

  - 删除用之前,请确报备份相关数据;或者该用户的数据不需要被保留!

  [How to Delete a User on Linux (and Remove Every Trace)](https://www.howtogeek.com/656549/how-to-delete-a-user-on-linux-and-remove-every-trace/#h5o-11)1. [User Accounts on Linux](https://www.howtogeek.com/656549/how-to-delete-a-user-on-linux-and-remove-every-trace/#post-656549)

  1. [Our Scenario](https://www.howtogeek.com/656549/how-to-delete-a-user-on-linux-and-remove-every-trace/#h5o-12)
  2. [Check the Login](https://www.howtogeek.com/656549/how-to-delete-a-user-on-linux-and-remove-every-trace/#h5o-13)
  3. [Reviewing The User’s Processes](https://www.howtogeek.com/656549/how-to-delete-a-user-on-linux-and-remove-every-trace/#h5o-14)
  4. [Locking the Account](https://www.howtogeek.com/656549/how-to-delete-a-user-on-linux-and-remove-every-trace/#h5o-15)
  5. [Killing the Processes](https://www.howtogeek.com/656549/how-to-delete-a-user-on-linux-and-remove-every-trace/#h5o-16)
  6. [Archiving the User’s home Directory](https://www.howtogeek.com/656549/how-to-delete-a-user-on-linux-and-remove-every-trace/#h5o-17)
  7. [Removing cron Jobs](https://www.howtogeek.com/656549/how-to-delete-a-user-on-linux-and-remove-every-trace/#h5o-18)
  8. [Removing Print Jobs](https://www.howtogeek.com/656549/how-to-delete-a-user-on-linux-and-remove-every-trace/#h5o-19)
  9. [Deleting the User Account](https://www.howtogeek.com/656549/how-to-delete-a-user-on-linux-and-remove-every-trace/#h5o-20)
  10. [It’s a Wrap](https://www.howtogeek.com/656549/how-to-delete-a-user-on-linux-and-remove-every-trace/#h5o-21)

