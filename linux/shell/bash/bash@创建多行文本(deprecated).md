[toc]



## abstract

- linux文件输入输出重定向
- shell命令行或脚本内 写入多行文本到文件中🎈
- cat,tee 重定向输入

### references

- [Unix / Linux - Shell Input/Output Redirections (tutorialspoint.com)](https://www.tutorialspoint.com/unix/unix-io-redirections.htm)



### Redirection Commands👺

Following is a complete list of commands which you can use for redirection −

| Sr.No. | Command & Description                                        |
| ------ | ------------------------------------------------------------ |
| 1      | **pgm > file** Output of pgm is redirected to file           |
| 2      | **pgm < file** (pgm从文件读取输入)Program pgm reads its input from file |
| 3      | **pgm >> file** Output of pgm is appended to file            |
| 4      | **n> file** Output from stream with descriptor **n** redirected to file |
| 5      | **n>> file** Output from stream with descriptor **n** appended to file |
| 6      | **n>& m** Merges output from stream **n** with stream **m**  |
| 7      | **n<& m** Merges input from stream **n** with stream **m**   |
| 8👺     | **<< tag** (读取标准输入内容块)Standard input comes from here through next tag at the start of line |
| 9      | $\textbf{|}$(管道符) Takes output from one program, or process, and sends it to another |

* Note that the file descriptor:
  * **0** is normally standard input (STDIN),
  * **1** is standard output (STDOUT),
  * **2** is standard error output (STDERR).



## 单行内容写入到文件

基础操作

```bash
$ echo "write to file" > file0                                       [13:08:41]
$ nl file0                                                           [13:08:56]
     1  write to file
```

当然,后面介绍的多行输入也都能够单行输入的需求(多行内容重定向的方法都适用于单行重定向)

## 创建多行文本

在 Linux 中，有多种方法可以创建多行文本文件。根据不同的需求，可以选择适合的命令：

- 如果要简单快速地创建文件，可以使用 `echo`、`printf` 或 `tee`。
- 如果要进行交互式编辑，可以使用文本编辑器 `nano` 或 `vi`。
- 对于批量生成和更复杂的文本操作，`sed`、`awk` 和 `here document` 提供了更多的灵活性和控制。

本文主要讨论here  doc重定向到文本文件的方法

下面提到的 token 是自定义的结束符(delimiter),一般使用 eof

### here doc常见写法

`Here Document`（简称 **Here Doc**）是 Bash（及其他 Shell）中一种非常实用的**多行输入重定向**机制，用于将一段文本作为命令的输入，而无需创建临时文件。

```bash
command << DELIMITER
内容行1
内容行2
...
DELIMITER
```

1. 中间所有行都会作为 `command` 的标准输入（stdin）,最常见的是`cat`等命令。

2. `<<` 是 Here Document 操作符。

3. `DELIMITER` 是**自定义分隔符**（通常用 `EOF`、`END`、`STOP` 等），内让输入完毕后标记结束就用此分隔符,但必须**单独一行顶格写**,否则不被认为是结束分隔符（除非用 `<<-`）。

   

## here doc重定向内容到文件

heredoc多达8种写法(后4种可以不看),这些写法中都能够找到`<< DELIMITER`这个结构,最常见的`DELIMITER`是`EOF`,前置或者后置

```bash
command << DELIMITER
内容行1
内容行2
...
DELIMITER
```



1. `> file << EOF`
2. `file << EOF`
3. `<< EOF > file`
4. `<< EOF >> file`
5. `cat > file << EOF`
6. `cat >> file << EOF`
7. `cat << EOF > file`
8. `cat << EOF >> file`

其中`cat` 可以省略,效果一样,所以我们主要**观察前面4种**

> 1. `>file << EOF`
> 2. `file << EOF`
> 3. `<< EOF > file`
> 4. `<< EOF >> file`

这里的重定向到文本分为覆盖是和追加式,主要取决于`file`前的`>`是一个还是两个,`> file`是覆盖式,`>> file`是追加式

第1,2种一个是**覆盖式**,一个是**追加式,**

第3,4种类似,一个是覆盖式,另一个是追加式,

同种风格的覆盖式和追加式只是`>`和`>>`的区别

这样我可以从(1,2);以及(3,4)两组分别选择一个代表,比如1,3作为代表进行讨论

- `file < EOF`
- `<< EOF > file`

其中写法1为`> file < EOF`,我分成两部分看待`[> file] [< EOF]`,这里用两个中括号来表示这两部分

而写法3也可以划分为`[<< EOF] [> file]`,这两部分和写法1中划分的两部分相同,只不过顺序对调

由上述讨论,我们可以很容易掌握heredoc的用法

此外还有`tee`,这在后面的章节介绍

### 案例

```bash
#覆盖式写入(慎用)
# cxxu @ bfxuxiaoxin in ~ [15:20:07]
$ > file << eof
line1
line2
eof

# cxxu @ bfxuxiaoxin in ~ [15:21:19]
$ cat file
line1
line2
```



```bash

#追加式写入(常用添加配置文件,比如~/.bashrc,~/.zshrc)
# cxxu @ bfxuxiaoxin in ~ [15:21:22]
$ >> file << eof
line1
line2
eof

# cxxu @ bfxuxiaoxin in ~ [15:21:34]
$ cat file
line1
line2
line1
line2

# cxxu @ bfxuxiaoxin in ~ [15:21:38]
$ >> file << eof
line1
line2
eof

# cxxu @ bfxuxiaoxin in ~ [15:29:32]
$ cat file
line1
line2
line1
line2
line1
line2
```



```bash
# cxxu @ bfxuxiaoxin in ~ [15:32:37]
$ cat > file << eof
heredoc> 1
heredoc> 2
heredoc> eof

# cxxu @ bfxuxiaoxin in ~ [15:32:58]
$ cat file
1
2

# cxxu @ bfxuxiaoxin in ~ [15:33:00]
$ cat >> file << eof
heredoc> 3
heredoc> 4
heredoc> eof

# cxxu @ bfxuxiaoxin in ~ [15:33:44]
$ cat file
1
2
3
4

```

```bash
# cxxu @ bfxuxiaoxin in ~ [15:38:36]
$  << EOF > file
heredoc> 1
heredoc> 2
heredoc> EOF

# cxxu @ bfxuxiaoxin in ~ [15:43:31]
$ cat file
1
2

# cxxu @ bfxuxiaoxin in ~ [15:43:35]
$ cat file

# cxxu @ bfxuxiaoxin in ~ [15:43:39] C:130
$ << EOF >>file
heredoc> 3
heredoc> 4
heredoc> EOF

# cxxu @ bfxuxiaoxin in ~ [15:43:53]
$ cat file
1
2
3
4
```

```bash
# cxxu @ bfxuxiaoxin in ~ [15:18:00]
$ cat << EOF > file.txt
heredoc> l1
heredoc> l2
heredoc> EOF

# cxxu @ bfxuxiaoxin in ~ [15:18:23]
$ cat file
line1
line2
line11
line22

# cxxu @ bfxuxiaoxin in ~ [15:18:30]
$ cat file.txt
l1
l2

# cxxu @ bfxuxiaoxin in ~ [16:04:11]
$ cat << EOF > file
1
2
EOF

# cxxu @ bfxuxiaoxin in ~ [16:04:18]
$ cat file
1
2

# cxxu @ bfxuxiaoxin in ~ [16:04:20]
$ cat << EOF >> file
3
4
EOF

# cxxu @ bfxuxiaoxin in ~ [16:04:38] C:130
$ cat file
1
2
3
4
```



### 用例

向`~/.zshrc`添加以下别名配置

```bash
# Alias for brew to run as linuxbrew user
alias brew='sudo -u linuxbrew brew'

```



```bash
#( 09/14/25@11:15AM )( root@s2 ):~
   >> ~/.zshrc << EOF
heredoc> # Alias for brew to run as linuxbrew user
alias brew='sudo -u linuxbrew brew'
heredoc> EOF

```

检查

```bash
#( 09/14/25@11:15AM )( root@s2 ):~
   tail ~/.zshrc
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
export PYTHONPATH="/repos/scripts/wp/woocommerce/woo_df:$PYTHONPATH"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# Alias for brew to run as linuxbrew user
alias brew='sudo -u linuxbrew brew'
```

发现确实添加进去

### heredoc的特点小结

#### 1. 向命令提供多行输入

例如，使用 `cat` 命令输出多行文本：

```bash
cat << EOF
This is line 1
This is line 2
This is line 3
EOF
```

输出结果为：

```plaintext
This is line 1
This is line 2
This is line 3
```

在这里，`EOF` 是分隔符（可以用任何不冲突的字符串），直到出现另一个 `EOF` 时，所有内容都会被 `cat` 处理。

#### 2. 将 `heredoc` 内容重定向到文件

可以使用 `heredoc` 将多行内容重定向写入文件：

```bash
cat << EOF > output.txt
This is line 1
This is line 2
This is line 3
EOF
```

这样会将 `heredoc` 的内容写入 `output.txt` 文件。若文件已存在，则会覆盖文件内容。若要追加内容，可使用 `>>`：

```bash
cat << EOF >> output.txt
This is an appended line
EOF
```

#### 3. 在 `heredoc` 中使用变量

`heredoc` 支持变量展开，默认情况下，变量会在内容中被解释。比如：

```bash
name="Alice"
cat << EOF
Hello, $name!
EOF
```

输出：

```plaintext
Hello, Alice!
```

#### 4. 禁用变量和命令替换

如果希望在 `heredoc` 中禁用变量替换和命令替换，可以在分隔符前加上引号，例如 `<< 'EOF'`，这样 `$name` 就不会被解释：

```bash
cat << 'EOF'
Hello, $name!
EOF
```

输出将是：

```plaintext
Hello, $name!
```

#### 5. 用于脚本中的配置文件生成

`heredoc` 常用于生成配置文件。例如，生成一个简单的 nginx 配置文件：

```bash
sudo tee /etc/nginx/sites-available/example.com.conf > /dev/null << EOF
server {
    listen 80;
    server_name example.com;
    root /var/www/html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
```

在此例中，`\$` 用于转义 `$` 符号，使其不被解释。



## cat 和重定向

这部分详见Cat的用法

### 利用cat 创建一个多行文件

```bash
$ cat > fileByCat                                                    [13:09:08]
line1
line2
#结束输入:可以通过键入ctrl+D完成文件的创建,不过此前需要确保有一个回车(也就是说ctrl+D在单独的行键入才有效);
# 检查文件创建
$ nl fileByCat                                                       [13:15:19]
     1  line1
     2  line2
# 文件追加也没问题
$ cat >> fileByCat                                                   [13:15:29]
line by "cat >>"
$                                                                    [13:18:10]
$ nl fileByCat                                                       [13:18:11]
     1  line1
     2  line2

     3  line by "cat >>"
$              
```

### cat 合并文件并作为全新创建的文件的内容(concatenate files)

```bash
# 生成演示文件
$ cat > file1                                                        [13:30:53]
file1 content:
lin1
lin2
$ cat > file2                                                        [13:31:37]
file2 content:
lin3
lin4
# 执行合并
$ cat file1 file2 > fileConcatenated                                 [13:36:14]
$ nl fileConcatenated                                                [13:36:33]
     1  file1 content:
     2  lin1
     3  lin2
     4  file2 content:
     5  lin3
     6  lin4
$   
```

 将file1的内容接到file2中(末尾)

```

$ cat file1 >> file2
# 查看合并结果
$ cat file2                                                          [13:50:51]
file2 content:
lin3
lin4
file1 content:
lin1
lin2
```

## 在脚本文件中一次性打印多行指定内容👺

> 类似键盘输入模拟文件输入,将数据传给命令

```bash
#!/bin/sh

cat << EOF
This is a simple lookup program
for good (and bad) restaurants
in Cape Town.
EOF

```

相当于分别echo :

- This is a simple lookup program
- for good (and bad) restaurants
- in Cape Town.

###  将字符串传递给命令行(<<<)

- 使用管道符,意味着管道符后面的任务是在subshell中执行的

- 参数可以传递到subshell中,这没问题,但是,当我们要在current shell 中拿到subshell中的处理结果,则需要小心

  - 要么再追加一个管道符,将需要取值的命令接在后面,要么避免使用管道符,采取变通的办法.

- 使用`<<<`将某个字符串传递给命令行,可以不开辟subshell,从而可以避免出现意外结果

- [bash - What does <<< mean? - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/80362/what-does-mean)

  

## sudo重定向输出权限不足(permission denied)

references

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
