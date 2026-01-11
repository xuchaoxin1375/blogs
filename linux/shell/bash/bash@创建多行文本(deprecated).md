[toc]



## abstract

- linux文件输入输出重定向
- shell命令行或脚本内 写入多行文本到文件中🎈
- cat,tee 重定向输入

### references

- [Unix / Linux - Shell Input/Output Redirections (tutorialspoint.com)](https://www.tutorialspoint.com/unix/unix-io-redirections.htm)



## sudo重定向输出权限不足(permission denied)

* [command line - How to solve &#34;permission denied&#34; when using sudo with redirection in Bash? - Ask Ubuntu](https://askubuntu.com/questions/230476/how-to-solve-permission-denied-when-using-sudo-with-redirection-in-bash)

### 一般情况下的文本重定向

- 类似于 `echo "test" >> test`
  - bash中的这一要求和powershell不同,powershell可以不加echo

- 直接再echo 前面加sudo 不改变权限效果,所以如果要往高权限文件写入内容需要寻求其他方法

### 使用sudo bash -c

在原来普通权限语句的前加上`sudo bash -c`

```bash
$ sudo bash -c "echo test >> /etc/apt/testbysudo"                    [17:39:04]
$ cat /etc/apt/testbysudo                                            [17:39:16]
test
```

### sudo + cat 创建文件

```bash
$ sudo bash -c "cat > /etc/apt/testbysudo"                           [17:42:39]
lines by `sudo bash -c cat >`
```

同样也是可以的

> 但是输入重定向(<<,here-document)变得不太好用



注意,虽然下面的命令(没有用`sudo bash -c`不会报错,但是不能解决权限问题

```bash
# cxxu @ bfxuxiaoxin in ~ [15:09:55] C:130
$ sudo cat > abc
[sudo] password for cxxu:
12
34

# cxxu @ bfxuxiaoxin in ~ [15:10:05]
$ ls
abc  demo  example.txt  f1  file  gitee_install.sh  install.sh

# cxxu @ bfxuxiaoxin in ~ [15:10:06]
$ cat abc
12
34
```

```bash
# cxxu @ bfxuxiaoxin in ~ [15:11:53] C:1
$ sudo cat > /etc/testperm
zsh: permission denied: /etc/testperm
```



## 使用tee 👺

- [Linux tee Command {Command Options and Examples} (phoenixnap.com)](https://phoenixnap.com/kb/linux-tee#:~:text=%20tee%20Commands%20in%20Linux%20With%20Examples%20,Output.%20%205%20Ignore%20Interrupts.%20%20More%20)

> tee - read from standard input and write to standard output and files

- 利用 ` tee` 来代替重定向输出 `>`
  - tee经常和管道符一起使用,但却不是必须
- 例如执行 `ifconfig | tee ifinfo`
  - 该命令会将网卡信息即写入到文件,也打印到终端
  - 又比如: `echo "service sshd start" |sudo tee -a /etc/rc.local`
    - 该命令可以配置linux 开机自己启动ssh服务
    - 将sudo 作用于tee命令

### 案例

配合eof写入多行

```bash
$ sudo tee fileBytee << eof                                          [18:07:17]
heredoc> line1
heredoc> line2
heredoc> eof
[sudo] password for cxxu_kali:
line1
line2
$ nl fileBytee                                                       [18:08:38]
     1  line1
     2  line2     


```
往高权限目录写入文件

```bash
# cxxu @ bfxuxiaoxin in ~ [16:06:53]
$ sudo tee /etc/testperm << eof
1
22
333.
eof
1
22
333.

# cxxu @ bfxuxiaoxin in ~ [16:07:13]
$ cat /etc/testperm
1
22
333.

```



### tee -a 追加

- 从键盘上输入多行内容
- 使用`ctrl+D`完成输入
- 适用于手动交互输入多行内容(不适合脚本中使用)

- 下面是一个保存清华源到一个文件的过程;在单独的空行键入`ctrl+D`完成文件的创建

```bash
$ # cxxu @ bfxuxiaoxin in ~ [16:22:19]
$ sudo tee -a ./KaliAptSourceQingHua
deb http://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free
deb http://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free

# cxxu @ bfxuxiaoxin in ~ [16:22:35]
$ cat KaliAptSourceQingHua
deb http://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free
#使用ctrl+d 结束输入完成创建
```

#### tee也可以配合<<符使用

- 使用<< token 来结束输入

```bash
# cxxu_kali @ cxxuWin11 in ~ [9:16:39]
$ sudo tee -a  ./ustcAptSourceQingHua <<eof
heredoc> deb http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib

deb-src http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib

heredoc> eof
# 此时文件已经创建完成
#以下是tee的回显
deb http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib

deb-src http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib

## 再次检查确认
# cxxu_kali @ cxxuWin11 in ~ [9:25:55]
$ nl ustcAptSourceQingHua
     1  deb http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib

     2  deb-src http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib
```



### 临时切换到管理员解决权限不足问题

使用`sudo -i`命令切换到管理员执行重定向文件操作

### 覆盖法

> 在别处创建文件然后通过sudo mv覆盖掉
> 这比较绕,但是编写脚本的时候也是是一种选择

- 例如,您可以将/etc/apt/下的文件读取到出来,
- 通过管道符在用户家目录创建一个有对应内容的文件,
- 然后在家目录中修改该文件,
- 再将该文件通过sudo mv 覆盖到原位置;
- 注意备份文件
