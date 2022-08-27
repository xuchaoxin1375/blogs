## references

-  [How to Use the find Command in Linux](https://www.howtogeek.com/771399/how-to-use-the-find-command-in-linux/ "How to Use the find Command in Linux")

* [Linux Find Command | How does Linux Find Command work? (educba.com)](https://www.educba.com/linux-find-command/)
* [Mommy, I found it! — 15 Practical Linux Find Command Examples (thegeekstuff.com)](https://www.thegeekstuff.com/2009/03/15-practical-linux-find-command-examples/)

## find 和硬链接检索

- 所有指向统一个文件的硬链接都具有相同的`inode`

  - 当然,同一文件的所有`symbolic link`和`hard link`都具有一致的`inode`

  - 查看文件的inode号可以通过`ls --inode`

    - ```
      $ ls --inode|sort -n
      2533274790464558 dirToSymlinks
      2533274790488885 num
      2533274790919396 words
      3659174697316891 dirTohardlinks
      8725724278214695 name1
      8725724278214695 numbers
      9288674231547765 pip
      ```

    - 

- 我们只需要根据文件的任意一个硬链接就可以获取文件的`inode`

- 在通过`find -inum`来搜索同一个硬盘分区上的某个文件的所有硬连接(也包括可区分的`symbolic link`)

  - > - 不同于软符号链接(symbolic link),可以通过多个命令来查询
    >
    >   - `ls -l`
    >
    >   - `file`
    >
    >     
    >
    > 虽然检索某个文件的所有名称(硬连接)这个需求很少,但也是提供一种方法

    - ```
      # cxxu_kali @ CxxuWin11 in ~ [8:55:33]
      $ find ./ -inum 8725724278214695 -exec ls -l {} \;
      -rw-r--r-- 3 cxxu_kali cxxu_kali 17 Apr  5 15:33 ./dirTohardlinks/numbers
      -rw-r--r-- 3 cxxu_kali cxxu_kali 17 Apr  5 15:33 ./name1
      -rw-r--r-- 3 cxxu_kali cxxu_kali 17 Apr  5 15:33 ./numbers
      
      # cxxu_kali @ CxxuWin11 in ~ [8:55:38]
      $ find ./ -inum 8725724278214695 -exec ls -l -inum {} \;
      8725724278214695 ./dirTohardlinks/numbers
      8725724278214695 ./name1
      8725724278214695 ./numbers
      #上述指令结果说明,返回的三个文件(名称)都指向同一个文件.
      ```

    
