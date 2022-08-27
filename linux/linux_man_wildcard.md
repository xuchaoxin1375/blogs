[toc]

# linux_man_wildcard/whatis/正则匹配/匹配以keyword开头的条目

> 使用`apropos`检索man手册,是利用手册的好方法,但有时候,apropos默认返回的结果太多,不利于定位

## whatis &apropos &man

> 三者对比:
>
> ```bash
> # cxxu @ CxxuWin11 in ~/.config/cheat [19:07:35] C:16
> $ whatis whatis
> whatis (1)           - display one-line manual page descriptions
> 
> # cxxu @ CxxuWin11 in ~/.config/cheat [19:07:39]
> $ whatis apropos
> apropos (1)          - search the manual page names and descriptions
> # cxxu @ CxxuWin11 in ~/.config/cheat [19:08:09]
> $ whatis man
> man (1)              - an interface to the system reference manuals
> man (7)              - macros to format man pages
> man (1posix)         - display system documentation
> ```
>
> - 其中,`man -k`近似于`apropos`
> - `man -f`近似于`whatis`(但是不起完全一样,特别是使用某些额外的选项时)

### whatis -w [keyward_wildcard] /-r  [regex]

```bash
 -r, --regex
              Interpret  each  name as a regular expression.  If a name matches any part of a page name, a match will be made.  This option causes whatis to be somewhat slower due to
              the nature of database searches.

-w, --wildcard
              Interpret each name as a pattern containing shell style wildcards.  For a match to be made, an expanded name must match the entire page name.  This option causes whatis
              to be somewhat slower due to the nature of database searches.
```

#### whatis -w

```bash
# cxxu @ CxxuWin11 in ~/.config/cheat [18:57:37]
$ whatis -w file*
FILE (3)             - overview of system data types
file (1)             - determine file type
file (1posix)        - determine file type
file-hierarchy (7)   - File system hierarchy overview
File::FcntlLock (3pm) - File locking with fcntl(2)
File::FcntlLock::Inline (3pm) - File locking with fcntl(2)
File::FcntlLock::Pure (3pm) - File locking with fcntl(2)
File::FcntlLock::XS (3pm) - File locking with fcntl(2)
filefrag (8)         - report on file fragmentation
filefuncs (3am)      - provide some file related functionality to gawk
fileno (3)           - check and reset stream status
fileno_unlocked (3)  - nonlocking stdio functions
filesystems (5)      - Linux filesystem types: ext, ext2, ext3, ext4, hpfs
```

#### whatis -r

```bash
# cxxu @ CxxuWin11 in ~/.config/cheat [19:13:36] C:16
$ whatis -r ^file
FILE (3)             - overview of system data types
file (1)             - determine file type
file (1posix)        - determine file type
file-hierarchy (7)   - File system hierarchy overview
File::FcntlLock (3pm) - File locking with fcntl(2)
File::FcntlLock::Inline (3pm) - File locking with fcntl(2)
File::FcntlLock::Pure (3pm) - File locking with fcntl(2)
File::FcntlLock::XS (3pm) - File locking with fcntl(2)
filefrag (8)         - report on file fragmentation
filefuncs (3am)      - provide some file related functionality to gawk
fileno (3)           - check and reset stream status
fileno_unlocked (3)  - nonlocking stdio functions
filesystems (5)      - Linux filesystem types: ext, ext2, ext3, ext4, hpfs,

```



### 使用man命令来达到相同的效果

```bash
# cxxu @ CxxuWin11 in ~/.config/cheat [18:57:31]
$ man  -f file*  -w
FILE (3)             - overview of system data types
file (1)             - determine file type
file (1posix)        - determine file type
file-hierarchy (7)   - File system hierarchy overview
File::FcntlLock (3pm) - File locking with fcntl(2)
File::FcntlLock::Inline (3pm) - File locking with fcntl(2)
File::FcntlLock::Pure (3pm) - File locking with fcntl(2)
File::FcntlLock::XS (3pm) - File locking with fcntl(2)
filefrag (8)         - report on file fragmentation
filefuncs (3am)      - provide some file related functionality to gawk
fileno (3)           - check and reset stream status
fileno_unlocked (3)  - nonlocking stdio functions
filesystems (5)      - Linux filesystem types: ext, ext2, ext3, ext4, hpfs, iso9660

```

### oh-my-zsh 框架

```bash
# cxxu @ CxxuWin11 in ~/.config/cheat [19:05:44] C:130
$ man file                                                                                                                                                                                 file                     File::FcntlLock          File::FcntlLock::Pure    filefrag                 file-hierarchy           fileno_unlocked
FILE                     File::FcntlLock::Inline  File::FcntlLock::XS      filefuncs                fileno                   filesystems
```

