@[toc]
# 指定默认shell/登录shell/登录zsh shell后自动运行脚本/配置文件/zsh的配置文件

## 查看当前shell

- [How do I find out what shell I am using on Linux/Unix? - nixCraft (cyberciti.biz)](https://www.cyberciti.biz/tips/how-do-i-find-out-what-shell-im-using.html)

  - `ps -p $$`:Display your current shell name reliably.

    - ```bash
      cxxu@cxxuAli:~$ ps -p $$
        PID TTY          TIME CMD
       5586 pts/0    00:00:00 bash
      
      ```

      

  - **`echo "$SHELL"`** – Print the shell for the current user but not necessarily the shell that is running at the movement.

    - ```bash
      # cxxu @ cxxuAli in ~ [8:22:33]
      $ echo "$SHELL"
      /bin/zsh
      ```

      

  - **`echo $0`** – Another reliable and simple method to get the current shell interpreter name on Linux or Unix-like systems.

    - ```bash
      # cxxu @ cxxuAli in ~ [8:22:43]
      $ echo $0
      -zsh
      ```

    

  

## 指定默认shell

> 如果没有想要的shell,可以自行安装,再设置默认
> 对于已有的shell,细节如下:
### 查看本机可用shell

```bash
cxxu@cxxuAli:~$ cat /etc/shells
# /etc/shells: valid login shells
/bin/sh
/bin/bash
/bin/rbash
/bin/dash
/bin/zsh
/usr/bin/zsh
```



#### 查找指定shell

- 例如查找powershell是否已经安装:

```bash
$ cat /etc/shells|grep powershell
/opt/microsoft/powershell/7/pwsh

```



### 指定默认shell

- 例如,根据上述查询,选择一个心仪的shell作为 `chsh -s `的参数(绝对路径)

```
chsh -s /bin/bash
```

## 登录zsh 后自动运行脚本文件

> * 下方的参考列出了不同的zsh配置文件,以及触发运行配置文件的时机
> * bash 也有自己一套配置文件体系,可以查看官方文档/资料
>   * [使用在线文档,方便浏览Bash Reference Manual (gnu.org)](https://www.gnu.org/software/bash/manual/bash.html)

### zsh的配置文件

- `man zsh` 中末尾介绍了一些zsh的配置文件
- [Moving to zsh, part 2: Configuration Files – Scripting OS X](https://scriptingosx.com/2019/06/moving-to-zsh-part-2-configuration-files/)
  - | **all users** | **user** | **login shell** | **interactive shell** | **scripts** | **Terminal.app** |
    | ------------------- | -------------- | --------------------- | --------------------------- | ----------------- | ---------------------- |
    | `/etc/zshenv`     | `.zshenv`    | √                    | √                          | √                | √                     |
    | `/etc/zprofile`   | `.zprofile`  | √                    | x                           | x                 | √                     |
    | `/etc/zshrc`      | `.zshrc`     | √                    | √                          | x                 | √                     |
    | `/etc/zlogin`     | `.zlogin`    | √                    | x                           | x                 | √                     |
    | `/etc/zlogout`    | `.zlogout`   | √                    | x                           | x                 | √                     |
    |                     |                |                       |                             |                   |                        |

#### 不同shell共用配置文件


* 需要声明,不要过分要求bash和zsh使用同一份配置文件,bash,zsh的配置文件体系不同,
* 我们只好分开处理,毕竟,你也就用这一两种shell,配置一次,几乎是一劳永逸,花费过多时间求统一,不仅兼容性得不到保证,而且耗费不必要的时间!
* 不过我想到了一种可能的共用统一份配置方案,就是参考zsh的配置文件的命名,对bash的配置文件配置一个硬链接,这样维护一份文件就可以.
  * `ln -P .profile .zprofile`
* 不过通过导入配置的方式,本身就已经有很高的重用性