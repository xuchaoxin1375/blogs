@[toc]
# linux_C_fork函数的使用

- [Linux bash命令习题 - 代码先锋网 (codeleading.com)](https://www.codeleading.com/article/54272302317/)
- 

## references

- [Process Identification  pid_t data type in C language ](https://www.includehelp.com/c/process-identification-pid_t-data-type.aspx)
- [getpid(2) - Linux manual page (man7.org)](https://man7.org/linux/man-pages/man2/getpid.2.html)

## code

### 主程序



- [Source code for "The Linux Programming Interface" (man7.org)](https://www.man7.org/tlpi/code/)

> 使用到的函数的解释如下

```c

#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include "prints.h"
/* NAME
       fork - create a child process

SYNOPSIS
       #include <sys/types.h>
       #include <unistd.h>
       pid_t fork(void);

RETURN VALUE
       On success, the PID of the child process is returned in the parent
       (即,fork()成功时,子进程的pid被返回给父进程), and 0 is returned in the child.(而被fork出来的进程去检查进程中的相应变量时会是0)
       On failure, -1 is returned in the parent, no child process is created, and  errno is set appropriately.

*/
/*
SLEEP(3)                                                                       Linux Programmer's Manual                                                                      SLEEP(3)

NAME
       sleep - sleep for a specified number of seconds

SYNOPSIS
       #include <unistd.h>

       unsigned int sleep(unsigned int seconds);

DESCRIPTION
       sleep() causes the calling thread to sleep either until the number of real-time seconds specified in seconds have elapsed or until a signal arrives which is not ignored.

RETURN VALUE
       Zero if the requested time has elapsed, or the number of seconds left to sleep, if the call was interrupted by a signal handler.
 */

int main()
{
       pid_t fpid; // fpid表示fork函数返回的值
       fpid = fork();
       dprint(fpid);
       int time_sec=30;
       // 判断fork()是否成创建子进程
       if (fpid < 0)
              printf("error in fork!");
       /* 如果成功创建子进程,则父子进程将执行相同的代码
       为了区分父子进程的后续执行,在下方进一步对进程id做判断
       其中,我们使用了getpid(),用来获取当前进程的ID */
       /* 如果运行这段代码是子进程,那么就会进入到判断会是true(因为,fork返回给子进程中fpid变量的值是0),从而执行else if{}块中的操作
       而如果是父进程(fork()的调用者进程执行以下代码时,fpid不会是0,会跳到else块中执行*/
       else if (fpid == 0)
       {

              printf("child process: id is %d\n", getpid());
              dprint(fpid);
              int i = time_sec;
              while (i--)
              {
                     sleep(1);
                     dprint(i);
                     printf("child process is running____");
              }
       }
       else
       {
              printf("parent process, my process id is %d\n", getpid());
              dprint(fpid);
              int j = time_sec;
              while (j--)
              {
                     sleep(1);
                     dprint(j);
                     printf("parent process is running!!!!");
              }
       }
       return 0;
}
```

### 调试宏头文件

```c
// 数值调试宏
#ifndef CXXU
#define CXXU 1

#define dprint(expr) printf(#expr " = %d\n", expr)
#define gprint(expr) printf(#expr " = %g\n", expr)
#define fprint(expr) printf(#expr " = %f\n", expr)
#define sprint(expr) printf(#expr " = %s\n", expr)
#define sprintln(expr) printf(expr "\n")


#endif
```



### 编译程序

- `   gcc testFork.c -o testFork`

![image-20220424085925618](https://img-blog.csdnimg.cn/img_convert/2d14486de86f6e7bc1e4ba5ae7e2dad5.png)

