## reference

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

## reference check users

- [How To List Users and Groups on Linux – devconnected
  ](https://devconnected.com/how-to-list-users-and-groups-on-linux/#:~:text=List%20Users%20on%20Linux%20In%20order%20to%20list,list%20of%20users%20currently%20available%20on%20your%20system.)
  1. [List Users on Linux](https://devconnected.com/how-to-list-users-and-groups-on-linux/#h5o-8)
  2. [List Usernames using the /etc/passwd file](https://devconnected.com/how-to-list-users-and-groups-on-linux/#h5o-9)
     1. [a – List Usernames using cut](https://devconnected.com/how-to-list-users-and-groups-on-linux/#h5o-10)
     2. [b – List Usernames using awk](https://devconnected.com/how-to-list-users-and-groups-on-linux/#h5o-11)
  3. [List Users on Linux using getent](https://devconnected.com/how-to-list-users-and-groups-on-linux/#h5o-12)
     1. [a – List Usernames with getent](https://devconnected.com/how-to-list-users-and-groups-on-linux/#h5o-13)
  4. [List Connected Users on your Linux host](https://devconnected.com/how-to-list-users-and-groups-on-linux/#h5o-14)
  5. [List Groups on Linux using the /etc/group file](https://devconnected.com/how-to-list-users-and-groups-on-linux/#h5o-15)
  6. [List Groupnames using the /etc/group](https://devconnected.com/how-to-list-users-and-groups-on-linux/#h5o-16)
  7. [List Groups using getent](https://devconnected.com/how-to-list-users-and-groups-on-linux/#h5o-17)
  8. [List Groups for the current user](https://devconnected.com/how-to-list-users-and-groups-on-linux/#h5o-18)
  9. [Conclusion](https://devconnected.com/how-to-list-users-and-groups-on-linux/#h5o-19)

### 逆序输出

- [How to Reverse the Order of Lines in a File in Linux | Baeldung on Linux](https://www.baeldung.com/linux/reverse-order-of-file-lines)

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

> 中途不想填写的可以直接回车继续

## 用户删除

### deluser删除用户的所有内容

- (debian系列发行版下),deluser是首先被推荐用来删除用户

以下操作建议再sudo权限下执行

- 终止要被删除的用户的所有进程 `sudo pkill -KILL`
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
