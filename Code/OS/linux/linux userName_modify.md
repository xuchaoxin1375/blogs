[toc]

# linux_修改用户名(rename username)

- [How to rename user in Linux (also rename group & home directory) - LinuxTechLab](https://linuxtechlab.com/rename-user-in-linux-rename-home-directory/)
  - [Rename user in Linux](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-5)
  - [Renaming Home directory](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-6)
  - [Changing UID for the user](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-7)
  - [Renaming the group](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-8)

- [Linux Change or Rename User Name and UID - nixCraft (cyberciti.biz)](https://www.cyberciti.biz/faq/howto-change-rename-user-name-id/)
  - [View current user and group membership for user named tom](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-5)
  - Rename and change username from tom to jerry on Linux
  - [A note about running process](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-7)
  - [Rename and change primary groupname from tom to jerry](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-8)
  - [How to change user home directory from /home/tom/ to /home/jerry](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-9)
  - [How to change user tom UID from 5001 to 10000](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-10)
  - 可以通过用户名修改
  - 可以修改UID

## 涉及命令一览

- usermod
- groupmod
  - `groupmod -n`

## 用户终止进程

> - 确保用户数据安全保存好后
> - 进入root用户

## root用户操作

> 修改用户`cxxu_kali`为`cxxu`



- ```
  
  ┌──(root㉿CxxuWin11)-[/mnt/c/Users/cxxu]
  └─# pkill -u cxxu_kali -KILL
  
  ┌──(root㉿CxxuWin11)-[/mnt/c/Users/cxxu]
  └─# usermod -l cxxu cxxu_kali
  ```

### 属主/组(groupname)修改id userName

- `usermod -n <newName> <oldName>`

- ```
  ┌──(root㉿CxxuWin11)-[/home]
  └─# id cxxu
  uid=1000(cxxu) gid=1000(cxxu) groups=1000(cxxu),27(sudo)
  ```

- 



### 家目录修改

- ` usermod -d /home/<newUserName> -m <newUserName>`
  - 如果不生效,可以直接将家目录重命名

### 检查新家目录属性

- ` ls -l /home/<newUserName>`

- ```
  #( 04/13/22@11:32AM )( cxxu@CxxuWin11 ):~
     ls -l /home/cxxu
  total 0
  drwxr-xr-x 1 cxxu cxxu 512 Apr  5 15:32 dirTohardlinks
  drwxr-xr-x 1 cxxu cxxu 512 Apr  5 15:51 dirToSymlinks
  -rw-r--r-- 3 cxxu cxxu  17 Apr  5 15:33 name1
  lrwxrwxrwx 1 cxxu cxxu   7 Apr  5 15:53 num -> numbers
  -rw-r--r-- 3 cxxu cxxu  17 Apr  5 15:33 numbers
  drwxr-xr-x 1 cxxu cxxu 512 Apr  5 17:28 pip
  drwxr-xr-x 1 cxxu cxxu 512 Apr 12 16:10 Translate-Shell
  -rw-r--r-- 2 cxxu cxxu  41 Apr  1 16:39 words
  drwxr-xr-x 1 cxxu cxxu 512 Apr 12 16:34 wudao-dict
  #( 04/13/22@11:37AM )( cxxu@CxxuWin11 ):~
     ls -l /home
  total 0
  drwxr-xr-x 1 cxxu            cxxu            512 Apr 13 11:37 cxxu
  drwxr-xr-x 1 cxxu_maintainer cxxu_maintainer 512 Mar 31 13:38 cxxu_maintainer
  
  # 使用exa 查看
  #( 04/13/22@11:37AM )( cxxu@CxxuWin11 ):~
     exa -lhgi /home
              inode Permissions Size User            Group           Date Modified Name
   3940649674394352 drwxr-xr-x     - cxxu            cxxu            13 Apr 11:37  cxxu
  ```



## 命令整合成脚本

根据您的情况,将下面的`old`变量(需要被修改的名字)和`new`(新名字)分别改为自己想要的值

``` 
old=cxxu_maintainer
new=cxxu_tester

#sudo -i
sudo pkill -u $old -9 
sudo usermod -l $new $old
sudo usermod -d /home/$new -m $new
sudo groupmod -n $new $old

id $new
cd /home
ll
```





