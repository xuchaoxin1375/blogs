@[toc]

## reference

- [How to Set Environment Variables in Linux {Step-by-Step Guide} (phoenixnap.com)](https://phoenixnap.com/kb/linux-set-environment-variable)

## conclusion

- 设置永久有效的变量就创建并配置/etc/profile.d 目录下的某个 sh 文件;

  - 当然,要想配置在/etc/profile 文件中也有效
  - 关于/etc/profile.d 目录下的配置文件(开机运行的脚本文件),和/etc/profile 作用之间的关系和区别,有如下论证
  - [bash - What do the scripts in /etc/profile.d do? - Unix &amp; Linux Stack Exchange](https://unix.stackexchange.com/questions/64258/what-do-the-scripts-in-etc-profile-d-do)

    - 将配置文件合适的分散到/etc/profile.d 目录中的独立脚本,可以提供维护时的方便(问题定位等等);
    - 同时让配置的修改更加灵活
    - 若通过/etc/profile 来调用/etc/profile.d 中的脚本,这使得位于不同文件中的脚本和位于同一个文件中的脚本效果一样
- 删除永久环境变量就从配置改变量的文件处移除即可

### 配置注意

- 由于/etc/profile中通过遍历/etc/profile.d/中的 `*.sh`文件,因此,如果选择配置在/etc/profile.d中的脚本文件,就必须使用 `*.sh`作为文件名,否则无法开机自动运行!
  - 当然,您可以在/etc/profile中修改遍历代码

```bash
# 配置环境变量文件:
# cxxu_kali @ cxxuWin11 in /mnt/c/users/cxxu/temp [19:12:34]
$ sudo cat >> \etc\profile.d\evns.sh
[sudo] password for cxxu_kali:
test_env_permanent="permanent!@cxxu"
# 加入打印语句,便于检查
echo "setting the permanent envs..."

# 检验
PS D:\repos\blogs> wsl
setting the permanent envs...
update Aliases done!

# cxxu_kali @ cxxuWin11 in ~ [19:24:36]
$ echo $test_env_permanent
permanent!@cxxu
```

## Most Common Environment Variables

> Here are some environment variables that an average user may encounter:

> linux 中,环境变量名也是区分大小写的

- **`PWD`** – Current working directory.
- **`HOME`** – The user’s home directory location.
- **`SHELL`** – Current shell ([bash](https://phoenixnap.com/kb/change-bash-prompt-linux), zsh, etc.).
- **`LOGNAME`** – Name of the user.
- **`UID`** – User’s unique identifier.
- **`HOSTNAME`** – Device’s [hostname](https://phoenixnap.com/kb/ubuntu-20-04-change-hostname) on the network.
- **`MAIL`** – User’s mail directory.
- **`EDITOR`** – The Linux system default [text editor](https://phoenixnap.com/kb/best-linux-text-editors-for-coding).
- **`TEMP`** – Directory location for temporary files.

## How to Check Environment Variables

### View All Environment Variables

- Use the **`printenv`** command to view all environment variables. Since there are many variables on the list, use the **`less`** command to control the view:

  ```bash
  printenv | less
  ```
- The output will show the first page of the list and then allow you to go further by pressing **Space** to see the next page or **Enter** to display the next line:

  - Exit the view by pressing **`Q`** .

### Search a Single Environment Variable

- To check a single environment variable value, use the following command:

  ```bash
  printenv VARIABLE_NAME
  ```

> The **`HOME`** variable value is the home folder path:

- Alternatively, display the value of a variable by using the **`echo`** command. The syntax is:

  - the `$` signal precede variable

    ```bash
    echo $[VARIABLE_NAME]
    ```

### Search Specific Environment Variables

- To find all the variables containing a certain character string, use the [grep command](https://phoenixnap.com/kb/grep-command-linux-unix-examples):

  ```bash
  printenv | grep [VARIABLE_NAME]
  ```
- Another command you can use to check environment variables is **`set`** .

  - However, this command will also include local variables, as well as shell variables and shell functions.
  - ```bash
    # cxxu_kali @ cxxuWin11 in /mnt/c/users/cxxu/temp [18:24:12]
    $ set |head
    '!'=0
    '#'=0
    '$'=713
    '*'=(  )
    -=569JNRXghikls
    0=-zsh
    '?'=0
    @=(  )
    ARGC=0
    BG
    ```
- Find an environment variable in the list that contains all the variables and shell functions by using **`set | grep`** :

  ```bash
  set | grep [VARIABLE_NAME]
  ```

**Note:** Take a look at our in-depth guide on how to use the [Linux set command](https://phoenixnap.com/kb/linux-set) to learn more about it.

## Set an Environment Variable in Linux
### set a shell variable

- The simplest way to set a variable using the command line is to type its name followed by a value:

  ```bash
  [VARIABLE_NAME]=[variable_value]
  ```

* As an example, create a variable called **`EXAMPLE`** with a text value.

  - If you type the command correctly, the shell does not provide any output.
* The **`set | grep`** command confirms the creation of the variable. However, **`printenv`** does not return any output.

- This is because the variable created in this way is `a shell variable`.

* Another way to confirm this is to type **`bash`** and start a child shell session. Using the **`echo`** command to search for the **`EXAMPLE`** variable now returns no output:

**Note:** In a child process, **`EXAMPLE`** is not an existing variable.

### How to Export an Environment Variable

- If you want to turn `a shell variable` into `an environment variable`, return to the parent shell and **`export`** it with the export command:

```bash
  export [VARIABLE_NAME]
```

- Use **`printenv`** to confirm the successful export:

```bash
# cxxu_kali @ cxxuWin11 in /mnt/c/users/cxxu/temp [19:12:26]
$ printenv test_env
test env
```

- If you open a child shell session now, **`echo`** will return the environment variable value:

```bash
# cxxu_kali @ cxxuWin11 in /mnt/c/users/cxxu/temp [18:42:04]
$ test_env="test env"
# cxxu_kali @ cxxuWin11 in /mnt/c/users/cxxu/temp [19:09:00] C:1
$ set|grep test_env
test_env='test env'
# 导出临时变量(使得子进程shell可以继承访问到该变量)
# cxxu_kali @ cxxuWin11 in /mnt/c/users/cxxu/temp [19:09:04]
$ export test_env

# cxxu_kali @ cxxuWin11 in /mnt/c/users/cxxu/temp [19:09:14]
$ bash
┌──(cxxu_kali㉿cxxuWin11)-[/mnt/c/users/cxxu/temp]
└─$ echo $test_env
test env
```

- The environment variable created in this way `disappears after you exit the current shell session`.

### Set an Environment Variable in Linux Permanently

> - If you wish a variable to persist after you close the shell session, you need to set it as an environmental variable permanently.
> - You can choose between setting it for the current user or all users.

#### set permanent environment variables for `a single user`

- To set permanent environment variables for `a single user`, edit the **`.bashrc`** file:

  ```bash
  sudo vim ~/.bashrc
  ```
- Write a line for each variable you wish to add using the following syntax:

  ```bash
  export [VARIABLE_NAME]=[variable_value]
  ```
- Save and exit the file. The changes are applied after you restart the shell.

  - If you want to apply the changes during the current session, use the [source command](https://phoenixnap.com/kb/linux-source-command):

    ```bash
    source ~/.bashrc
    ```

#### set permanent environment variables for all users

- To set permanent environment variables for all users, create an **`.sh`** file in the **`/etc/profile.d`** **_folder_**:

  ```bash
  sudo vim /etc/profile.d/[filename].sh
  ```
- The syntax to add variables to the file is the same as with **`.bashrc`** 
	- Save and exit the file. The changes are applied at the next logging in.



## How to Unset an Environment Variable

- To unset an environment variable, use the **`unset`** command:

  ```bash
  unset [VARIABLE_NAME]
  ```
- This command permanently removes variables exported through a terminal command.

  - Variables stored in configuration files are also removed from the current shell session.
  - However, they are set again upon next logging in.
- To permanently unset a variable you stored in a file, go to the file, and remove the line containing the variable definition.

## 修改已有的永久环境变量

- [How to Add a Directory to Your $PATH in Linux (howtogeek.com)](https://www.howtogeek.com/658904/how-to-add-a-directory-to-your-path-in-linux/#:~:text=You%20can%20use%20the%20export%20command%20to%20add,sure%20it%20searches%20your%20directory%20first%2C%20before%20%2Fusr%2Flocal%2Fbin.)
###  注意事项
-  linux中区分大小写,所以PATH不同于path
- 与windows不同,linux采用 `:`分隔环境变量的不同取值

- 根据默认的/etc/profile 的脚本来看,到底是配置在/etc/profile的内容先执行还是/etc/profile.d/*.sh先执行,这取决于您将profile中的内容写在遍历代码前还是后
- 您可以使用 `unset [variable_name]`来抹去已有的变量值,然后赋值以新的值
###  配置PATH变量
- 如果仅仅是简单的追加某个变量的取值段,譬如给PATH添加一个新的取值
  - 可以在/etc/profile..中配置
    - `export PATH=newValueToAdd:$PATH`
    	- 	注意大小要求
    	- 变量取值中带有空格时,需要使用`" "`来包裹
    - 或者 ` export PATH="$PATH:/NEW_PATH"`
      - 给其他任意变量添加多个取值都是一样的方法,例如:
      - ```
        # 原始值:
        # cxxu_kali @ cxxuWin11 in ~ [19:53:23]
        $ echo $test_env_permanent
        permanent!@cxxu
        # 开始添加
        # cxxu_kali @ cxxuWin11 in ~ [19:54:07] C:130
        $ export test_env_permanent=/test:$test_env_permanent
        
        # cxxu_kali @ cxxuWin11 in ~ [19:54:24]
        $ echo $test_env_permanent
        /test:permanent!@cxxu
        # 可见,头部添加了一个值/test
        ```
  
##  应用环境变量
###  利用已有的环境变量创建新的环境变量
>引用环境变量的方式和普通变量的方式类似(主要的不同在于生命周期和作用域)

```bash
# 查看已经有的变量
# cxxu_kali @ cxxuWin11 in /mnt/d/repos/scripts on git:main x [9:42:23]
$ echo $repos
/mnt/d/repos
#利用已有变量repos创建新的环境变量
# cxxu_kali @ cxxuWin11 in /mnt/d/repos [9:41:19]
$ export script=$repos/scripts

# cxxu_kali @ cxxuWin11 in /mnt/d/repos [9:42:03]
$ cd $script
# 可以看到路径的变换效果
# cxxu_kali @ cxxuWin11 in /mnt/d/repos/scripts on git:main x [9:42:13]
$ pwd
/mnt/d/repos/scripts
```
###  字符串内引用环境变量
例如`echo`,`cd` 之类的命令都可以将含有环境变量的引用解析环境变量的值
```bash
#  echo
# cxxu_kali @ cxxuWin11 in /mnt/d/repos [9:48:24]
$ echo $repos
/mnt/d/repos

# cxxu_kali @ cxxuWin11 in /mnt/d/repos [9:48:08]
$ echo "$repos"
/mnt/d/repos
#  cd 
# cxxu_kali @ cxxuWin11 in /mnt/d/repos/scripts on git:main x [9:51:56]
$ cd

# cxxu_kali @ cxxuWin11 in ~ [9:51:58]
$ cd "$script"

# cxxu_kali @ cxxuWin11 in /mnt/d/repos/scripts on git:main x [9:52:00]
$
```


###  配置环境变量时可能遇到的问题
>- 注意别名环境变量名不是随便取的,要避免某些特殊值,比如在我的环境下,aliases这个词不可以直接作为左值:出现异常:
>	` attempt to set associative array to scalar`
>- 如果发生环境变量之间的相互引用,需要将被引用的写在前面
>	- linux 似乎允许多重嵌套引用,windows做类似事情的时候就容易解析不全,层数受限 
>	例如
```bash
export d="/mnt/d"
export c="/mnt/c"
export repos="/mnt/d/repos"
export scripts="$repos/scripts"
export linuxShellScripts="$scripts/linuxShellScripts"
export aliasesConfig="$scripts/linuxShellScripts/.aliases.sh"
export aliases_jumper="$linuxShellScripts/.aliases_jumper.sh"

```
## 变量名和变量类型的赋值要求

### references

- [bash - .zshrc inconsistent type for assignment? - Stack Overflow](https://stackoverflow.com/questions/45254941/zshrc-inconsistent-type-for-assignment)
> 注意,指派新的环境变量注意别名环境变量名不是随便取的,要避免某些特殊值,比如aliases这个词不可以直接作为左值: attempt to set associative array to scalar
- path与PATH
```bash
#( 04/12/22@10:59AM )( cxxu@cxxuAli ):~/linuxShellScripts
   set |egrep -i "^path"
PATH=/usr/node/node-v16.14.2-linux-x64/bin/:/home/cxxu/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin

path=( /usr/node/node-v16.14.2-linux-x64/bin/ /home/cxxu/.cargo/bin /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/games /usr/local/games /snap/bin )
```
- 又比如变量名`aliases`
```bash
#( 04/12/22@10:59AM )( cxxu@cxxuAli ):~/linuxShellScripts
   echo $aliases
omz_history git log --graph --de....
```

可见,linux系统中既有一个名为`PATH`的环境变量,也有一个字母全小写的`path`,但其取值类型不同,故而,

- 形如`path=xxx:$PATH`将会报错:`inconsistent type for assignment`
