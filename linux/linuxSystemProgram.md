# linux_系统编程系统库调用和函数所在头文件的查询/apropos获取按功能查找命令

## man&apropos

### man

#### man man

从 `man man`中,我们可以了解到使,我们要查询某个

- 命令/程序
- 函数
- 文件结构
- 数据结构

的时候,都可以使用man获取帮助

```
DESCRIPTION
       man  is  the  system's manual pager.  Each page argument given to man is normally
       the name of a program, utility or function.  
The manual page associated with each
       of these arguments is then found and displayed. 
 A section, if provided, will di‐
       rect man to look only in that section of the manual.  The default  action  is  to
       search  in  all  of the available sections following a pre-defined order (see DE‐
       FAULTS), and to show only the first page found, even if page  exists  in  several
       sections.

       The  table below shows the section numbers of the manual followed by the types of
       pages they contain.

       1   Executable programs or shell commands
       2   System calls (functions provided by the kernel)
       3   Library calls (functions within program libraries)
       4   Special files (usually found in /dev)
       5   File formats and conventions, e.g. /etc/passwd
       6   Games
       7   Miscellaneous  (including  macro  packages  and  conventions),  e.g.  man(7),
           groff(7), man-pages(7)
       8   System administration commands (usually only for root)
       9   Kernel routines [Non standard]

       A manual page consists of several sections.

       Conventional  section  names  include NAME, SYNOPSIS, CONFIGURATION, DESCRIPTION,
       OPTIONS, EXIT STATUS, RETURN VALUE, ERRORS, ENVIRONMENT,  FILES,  VERSIONS,  CON‐
       FORMING TO, NOTES, BUGS, EXAMPLE, AUTHORS, and SEE ALSO.
```

#### man 3

从上述文档中可知,section3 中包含我们需要的库调用(library)的相关内容,为我们用 `c`

#### man 模糊搜索(-k)/暴力搜索(-K)

- 您可以使用 `man -k`或者 `apropos` 来查询某个关键词/函数名

```bash
 -k, --apropos
              Equivalent to apropos.  Search the short manual page descriptions for key‐
              words and display any matches.  See apropos(1) for details.

       -K, --global-apropos
              Search for text in all manual pages.  This is a brute-force search, and is
              likely  to take some time; if you can, you should specify a section to re‐
              duce the number of pages that need to be searched.  Search  terms  may  be
              simple strings (the default), or regular expressions if the --regex option
              is used.

              Note that this searches the sources of the manual pages, not the  rendered
              text,  and  so  may include false positives due to things like comments in
              source files.  Searching the rendered text would be much slower.
```

譬如,要搜索和时间相关的函数(sleep)

```bash
# cxxu_kali @ CxxuWin11 in /mnt/c/Users/cxxu [19:02:23] C:130
$ man -k sleep
clock_nanosleep (2)  - high-resolution sleep with specifiable clock
nanosleep (2)        - high-resolution sleep
rtcwake (8)          - enter a system sleep state until specified wakeup time
sleep (1)            - delay for a specified amount of time
sleep (3)            - sleep for a specified number of seconds
sleep.conf.d (5)     - Suspend and hibernation configuration file
systemd-hibernate.service (8) - System sleep state logic
systemd-hybrid-sleep.service (8) - System sleep state logic
systemd-sleep (8)    - System sleep state logic
systemd-sleep.conf (5) - Suspend and hibernation configuration file
systemd-suspend-then-hibernate.service (8) - System sleep state logic
systemd-suspend.service (8) - System sleep state logic
usleep (3)           - suspend execution for microsecond intervals
```

##### 配合使用grep来提炼系统调用中的相关主题

```bash
# cxxu_kali @ CxxuWin11 in /mnt/c/Users/cxxu [19:02:48] C:1
$ man -k sleep |grep '(3)'
sleep (3)            - sleep for a specified number of seconds
usleep (3)           - suspend execution for microsecond intervals
```

#### 查看man section 3 中sleep函数

> * synopsis 给出了该函数所在的头文件以及函数的返回类型

```bash
SLEEP(3)                        Linux Programmer's Manual                       SLEEP(3)

NAME
       sleep - sleep for a specified number of seconds

SYNOPSIS
       #include <unistd.h>

       unsigned int sleep(unsigned int seconds);

DESCRIPTION
       sleep()  causes  the calling thread to sleep either until the number of real-time
       seconds specified in seconds have elapsed or until a signal arrives which is  not
       ignored.

RETURN VALUE
       Zero  if  the requested time has elapsed, or the number of seconds left to sleep,
       if the call was interrupted by a signal handler.
```

> * Notes 部分给出了该库函数的实现涉及到哪些系统调用

```bash

NOTES
       On Linux, sleep() is implemented via nanosleep(2).  See the nanosleep(2) man page
       for a discussion of the clock used.

   Portability notes
       On  some  systems, sleep() may be implemented using alarm(2) and SIGALRM (POSIX.1
       permits this); mixing calls to alarm(2) and sleep() is a bad idea.

       Using longjmp(3) from a signal handler or modifying the handling of SIGALRM while
       sleeping will cause undefined results.

SEE ALSO
       sleep(1), alarm(2), nanosleep(2), signal(2), signal(7)
```

### man 2

> man 2 中的函数是系统调用级别的,他们可以用来编写man 3中的函数(库)

### man 5

* 查看一条命令的基本实现时,有时会设计到文件和数据结构
  * `5   File formats and conventions, e.g. /etc/passwd`

以 `who`命令为例

- `man who`
  - 不同于 `unix`,linux的man往往不包含相关主题的所有信息(更详细的信息经常放置再 `info`命令中(该命令可能需要手动安装才有))
  - 

```bash

SEE ALSO
       Full documentation <https://www.gnu.org/software/coreutils/who>
       or available locally via: info '(coreutils) who invocation'
```

- `info who`
  - 和unix相比,linux的文档信息相对更加分散
    - 从下面的介绍中(结合 `who`的语法),我们可以知道, `who`的实现原理依赖于对若干个文件操作(这些文件记录用户登录信息)

```bash

‘who’ prints information about users who are currently logged on.
Synopsis:

     who [OPTION] [FILE] [am i]

   If given no non-option arguments, ‘who’ prints the following
information for each user currently logged on: login name, terminal
line, login time, and remote hostname or X display.

   If given one non-option argument, ‘who’ uses that instead of a
default system-maintained file (often ‘/var/run/utmp’ or ‘/etc/utmp’) as
the name of the file containing the record of users logged on.

‘/var/log/wtmp’ is commonly given as an argument to ‘who’ to look at who
has previously logged on.

   If given two non-option arguments, ‘who’ prints only the entry for
the user running it (determined from its standard input), preceded by
the hostname.  Traditionally, the two arguments given are ‘am i’, as in
‘who am i’.

   Timestamps are listed according to the time zone rules specified by
the ‘TZ’ environment variable, or by the system default rules if ‘TZ’ is
not set.  *Note Specifying the Time Zone with ‘TZ’: (libc)TZ Variable.

```

- ch我们尝试进一步查找 `utmp`文件的信息

  - `apropos utmp`
    - 如果对utmp/wtmp文件好奇,可以通过 `man utmp`专门了解
  - 也可以先通过 `apropos`得到的主要信息如下
  - ```bash
    # cxxu @ cxxuAli in ~ [20:14:46]
    $ apropos utmp|grep 5
    utmp (5)             - login records
    utmpx (5)            - login records
    ```
- 从中我们得到 `utmp`文件的结构信息以及数据结构

  - ```bash

    DESCRIPTION
           The utmp file allows one to discover information about who is currently using the
           system.  There may be more users currently using the system, because not all pro‐
           grams use utmp logging.

           Warning: utmp must not be writable by the user class "other", because many system
           programs (foolishly) depend on its integrity.  You risk faked system logfiles and
           modifications  of  system files if you leave utmp writable to any user other than
           the owner and group owner of the file.

           The file is a sequence of utmp structures, declared as follows in <utmp.h>  (note
           that  this  is only one of several definitions around; details depend on the ver‐
           sion of libc):
     The file is a sequence of utmp structures, declared as follows in <utmp.h>  (note
           that  this  is only one of several definitions around; details depend on the ver‐
           sion of libc):

               /* Values for ut_type field, below */

               #define EMPTY         0 /* Record does not contain valid info
                                          (formerly known as UT_UNKNOWN on Linux) */
               #define RUN_LVL       1 /* Change in system run-level (see
                                          init(1)) */
               #define BOOT_TIME     2 /* Time of system boot (in ut_tv) */
               #define NEW_TIME      3 /* Time after system clock change
                                          (in ut_tv) */
               #define OLD_TIME      4 /* Time before system clock change
                                          (in ut_tv) */
               #define INIT_PROCESS  5 /* Process spawned by init(1) */
               #define LOGIN_PROCESS 6 /* Session leader process for user login */
               #define USER_PROCESS  7 /* Normal process */
               #define DEAD_PROCESS  8 /* Terminated process */
               #define ACCOUNTING    9 /* Not implemented */

               #define UT_LINESIZE      32
               #define UT_NAMESIZE      32
               #define UT_HOSTSIZE     256

               struct exit_status {              /* Type for ut_exit, below */
                   short e_termination;          /* Process termination status */
                   short e_exit;                 /* Process exit status */
               };

               struct utmp {
                   short   ut_type;              /* Type of record */
                   pid_t   ut_pid;               /* PID of login process */
                   char    ut_line[UT_LINESIZE]; /* Device name of tty - "/dev/" */
                   char    ut_id[4];             /* Terminal name suffix,
                                                    or inittab(5) ID */
                   char    ut_user[UT_NAMESIZE]; /* Username */
                   char    ut_host[UT_HOSTSIZE]; /* Hostname for remote login, or
                                                    kernel version for run-level
                                                    messages */
                   struct  exit_status ut_exit;  /* Exit status of a process
                                                    marked as DEAD_PROCESS; not
                                                    used by Linux init(1) */
                   /* The ut_session and ut_tv fields must be the same size when
                      compiled 32- and 64-bit.  This allows data files and shared
                      memory to be shared between 32- and 64-bit applications. */
               #if __WORDSIZE == 64 && defined __WORDSIZE_COMPAT32
                   int32_t ut_session;           /* Session ID (getsid(2)),
                                                    used for windowing */

    ```

#### 查看头文件(whereis)

- `whereis utmp.h`

```bash
# cxxu_kali @ CxxuWin11 in /mnt/c/Users/cxxu [20:22:39]
$ whereis utmp.h
utmp.h: /usr/include/utmp.h
```

> 现在头文件基本上很难体现的数据结构基本了

### 模仿类似功能的系统编程

- 根据上述查阅和分析,who 会读取特定文件某些信息,这些我文件中的数据具有数据结构,我们也可以使用相关的数据结构和系统调用实现相关的一些功能

#### 读取文件相关的系统调用/库调用

> 读取操作需要手动调用其依赖的其他基本操作调用!(譬如,打开文件/关闭文件)

- 如果只找系统调用,所以我们再过滤出section 2中的内容
- `apropos read|grep file|grep 2`
- 或者,同时过滤出系统调用和库调用(section2/3)

  - ```bash
    # cxxu_kali @ CxxuWin11 in /mnt/c/Users/cxxu [20:44:35] C:1
    $ apropos read|egrep '[23]'|egrep file
    _llseek (2)          - reposition read/write file offset
    eventfd_read (3)     - create a file descriptor for event notification
    fts_read (3)         - traverse a file hierarchy
    llseek (2)           - reposition read/write file offset
    lseek (2)            - reposition read/write file offset
    lseek64 (3)          - reposition 64-bit read/write file offset
    pread (2)            - read from or write to a file descriptor at a given offset
    pread64 (2)          - read from or write to a file descriptor at a given offset
    pwrite (2)           - read from or write to a file descriptor at a given offset
    pwrite64 (2)         - read from or write to a file descriptor at a given offset
    read (2)             - read from a file descriptor
    readahead (2)        - initiate file readahead into page cache
    ```
- 查看最接近需求的read(2)(man section2)

  - `man 2 read`
    - 和 `read`相关联的操作
    - ```
      SEE ALSO
             close(2),  fcntl(2),  ioctl(2),  lseek(2),  open(2),  pread(2), readdir(2), read‐
             link(2), readv(2), select(2), write(2), fread(3)

      ```
