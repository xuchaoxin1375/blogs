###  prints.h
> 调试宏
```c
// 数值调试宏
#ifndef CXXU
#define CXXU 1
// 修改sizeint来指定打印宽度:(注意,必须以字符串的形式修改,(数字要包裹双引号))
// 负数,就是左对齐
#define sizeint__ "25"
#define sizestr__ "%" sizeint__ "s"
#define dprint(expr) printf(sizestr__ " = %d @%%d\n", #expr, expr)
#define ldprint(expr) printf(sizestr__ " = %ld @%%ld\n", #expr, expr)
#define cprint(expr) printf(sizestr__ " = %c @%%c\n", #expr, expr)
#define sprint(expr) printf(sizestr__ " = %s @%%s\n", #expr, expr)
#define gprint(expr) printf(sizestr__ " = %g\n", #expr, expr)

#define fprint(expr) printf(sizestr__ " = %f\n", #expr, expr)
// #define sprint(expr) printf("\t@sprint"#expr " = %s\n", expr)

// #define sprint(expr) printf(expr)
#define sprintln(expr) printf(expr "\n")
#define pre_print(expr) printf(expr)

// 直接传递变量给pprint(取地址操作包含在了宏中)
#define pprint(expr) printf(sizestr__ " = %p &var%%p\n", "&" #expr, &expr)
// 直接打印传入的地址(指针变量)
#define pprinta(expr) printf(sizestr__ " = %p %%p (pointer:" #expr ")\n", #expr, expr)
// extern void func();
// extern int multiply(int a, int b);
// extern char *str_multiplier;

#endif
```
###  多重fork
```c
#include <sys/types.h>
#include <unistd.h>
#include <pthread.h>

#include "prints.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include "common_fun.c"

/* 	用C语言写一个程序名字为procs4，该程序运行过程中共有4个进程

procs4程序（父进程）创建2个子进程p1和p2，
p1子进程再创建一个子进程p3。

4个进程完成如下工作：
父进程打印字符串“I am main process”；
p1子进程打印“I am child process p1”字符串；
p2子进程打印“I am child process p2”；

子进程p3打印字符串“I am child process p3”，然后使用exec（族）系统调用打印当前目录下文件和子目录的详细信息。

并且每个进程都要打印自己的pid。
 */
/*
完成本任务需要知道:
主进程如果在子进程之前结束,那么子进程中执行getppid()的结果可能会是1

(即,子进程变成了孤儿进程,托交给init)

  PID TTY          TIME CMD
    1 ?        00:00:10 systemd
// pid=1进程详情
┌─[cxxu@cxxuAli] - [~] - [2022-04-28 08:09:38]
└─[0] <> ps -p 1 u
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.3  77828  7248 ?        Ss   Apr11   0:10 /sbin/init noibrs splash

为例放置子进程变成孤儿,可以通过让各级父进程sleep()一段时间,让子进程先执行完
 */

int counter = 0;
int main(int argc, char const *argv[])
{
    pid_t fp1;
    pid_t fp2;
    sprintln("---before fork---,this line should just be print once");
    sprintln("~~~fork p1");
    fp1 = fork();
    // fp2 = fork();//本语句会被主进程和p1进程分别执行一次!(实际效果将不是我们想要的)
    // sprintln("---after fork---");
    // counter += 1;
    // dprint(counter);
    dprint(fp1);
    // dprint(fp2);
    if (fp1 == 0)
    {
        printf("\t");
        sprintln("I am child process p1");

        dprint(getpid());
        dprint(getppid());
        /* code */
        pid_t fp3 = fork();
        if (fp3 == 0)
        {
            pre_print("\t\t");
            sprintln("I am child process p3");
            dprint(getpid());
            dprint(getppid());
            // execl("/bin/ls", "ls", "-l", (void *)NULL);
        }
        else{
            sleep(1);
        }
        
    }
    /* 正因为将多个多个fork直接写在一起(同一层),那么第一个子进程和主进程一样,会执行第二个fork
    所以为例只让主进程执行第二个或者之后的fork操作,应当将后续的fork写在只有主进程才会进入的判断分支中
     */
    // else if (fp2 == 0)
    // {
    //     printf("\t");
    //     pre_print("I am child prcess p2");
    //     dprint(getpid());
    //     dprint(getppid());
    // }
    else
    {
        sprintln("I am main process");
        dprint(getpid());
        sprintln("~~~fork p2---");
        fp2 = fork();
        if (fp2 == 0)
        {
            printf("\t");
            sprintln("I am child prcess p2");
            dprint(getpid());
            dprint(getppid());
        }
        sleep(1);
    }

    return 0;
}

```
![在这里插入图片描述](https://img-blog.csdnimg.cn/1a34b5a2dcb545529593f57c4c5b8d34.png)
##  参考书籍:linux_unix system programming references books
> 以下书籍电子版可以从zlibrary上下载(yandex->zlibrary) 

> 有时候,仅仅靠man手册还是难以将某些问题搞清楚
> 使用搜索引擎搜索资料不够系统
> 阅读经典书记可以帮助我们理解细节,体验示例代码,系统的学习系统编程

-  	Linux/Unix系统编程手册
	- [The Linux programming interface: a Linux and UNIX system programming handbook | Michael Kerrisk  download](https://book4you.org/book/829755/45845b)
- APUE(UNIX环境高级编程) 
	- 	[ Advanced Programming in the UNIX Environment, 3rd Edition/apue (book4you.org)](https://book4you.org/dl/2167553/85f281)
- *Understanding Unix-Linux Programming (Bruce Molay)*
	- 中文名:Unix_linux 编程实践教程
- 
##  使用exit(n)&wait(wstatus)技术


> 下面结合linux帮助手册和试验代码来说明这一种父子进程通信技术

####  wait_exit.c

```c
#include <sys/types.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/wait.h>
#include "common_fun.c"
#include "prints.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
/* 任务1: */
/* 	用C语言写一个程序名字为procs4，该程序运行过程中共有4个进程

procs4程序（父进程）创建2个子进程p1和p2，
p1子进程再创建一个子进程p3。

4个进程完成如下工作：
父进程打印字符串“I am main process”；
p1子进程打印“I am child process p1”字符串；
p2子进程打印“I am child process p2”；

子进程p3打印字符串“I am child process p3”，然后使用exec（族）系统调用打印当前目录下文件和子目录的详细信息。

并且每个进程都要打印自己的pid。
 */
/* 任务2:
p0等待p1,p2任务全部完成
p1睡眠5秒钟,然后创建p3,p3也睡眠5秒钟,p1待p3结束退出后p1也一并退出(整个过程耗时10秒)
p2和p1是兄弟级别,p2和p1几乎同时开始睡眠,都是5秒钟(这五秒钟内和p1的睡眠时间是重叠的,故不会加长总时长)
综上,全部任务大约耗时10s;(但是三个进程各自睡眠5秒;其中p1,p2在都在前5秒内睡眠,p3单独睡眠,后5秒)

 */
/*
完成本任务需要知道:
主进程如果在子进程之前结束,那么子进程中执行getppid()的结果可能会是1

(即,子进程变成了孤儿进程,托交给init)

  PID TTY          TIME CMD
    1 ?        00:00:10 systemd
// pid=1进程详情
┌─[cxxu@cxxuAli] - [~] - [2022-04-28 08:09:38]
└─[0] <> ps -p 1 u
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.3  77828  7248 ?        Ss   Apr11   0:10 /sbin/init noibrs splash

为例放置子进程变成孤儿,可以通过让各级父进程sleep()一段时间,让子进程先执行完
 */

/* 使用exit()/wait() 技术进行父子进程间接通信 */
/*
NAME
       wait, waitpid, waitid - wait for process to change state
SYNOPSIS         top
       #include <sys/wait.h>

       pid_t wait(int *wstatus);
       pid_t waitpid(pid_t pid, int *wstatus, int options);

       int waitid(idtype_t idtype, id_t id, siginfo_t *infop, int options);
                        This is the glibc and POSIX interface; see
                          NOTES for information on the raw system call.
*/
/* wait 记录结果的解析宏 */
/*
WIFEXITED(wstatus)
        returns true if the child terminated normally, that is, by calling exit(3) or _exit(2), or by returning from main().

WEXITSTATUS(wstatus)
        returns the exit status of the child.  This consists of the least significant 8 bits of the status argument that the child specified in a call to exit(3) or _exit(2) or
        as the argument for a return statement in main().  This macro should be employed only if WIFEXITED returned true.

WIFSIGNALED(wstatus)
        returns true if the child process was terminated by a signal.
*/

/* If WIFEXITED(STATUS), the low-order 8 bits of the status.  
通过wait(wstatus)向内核拿到子进程的exit()的弥留之言并记录在wstatus中时,其值和子进程传入exit()的值已经发生了变化,
想要取得传入exit()中的值,可以用WEXITSTATUS(wstatus)来解析这个被wait()修改过的状态值
*/
// #define __WEXITSTATUS(status) (((status)&0xff00) >> 8)


/*  All of these system calls are used to wait for state changes in a  child of the calling process,
 and obtain information about the  child whose state has changed.
   A state change is considered to  be:
   the child terminated;
   the child was stopped by a signal;
   or  the child was resumed by a signal.

   In the case of a terminated  child, performing a wait allows the system to release the  resources associated with the child;
   if a wait is not performed,  then the terminated child remains in a "zombie" state (see NOTES  below).

     If a child has already changed state, then these calls return  immediately.
     Otherwise, they block until either a child changes  state or a signal handler interrupts the call
     (assuming that system calls are not automatically restarted using the SA_RESTART  flag of sigaction(2)).
     In the remainder of this page,
     a child  whose state has changed and which has not yet been waited upon by  one of these system calls is termed `waitable`.  */
int counter = 0;
int wstatus = -1;
void p0_code();
void p1_code();
void p2_code();
void p3_code();
int main(int argc, char const *argv[])
{
    pid_t fp1;
    // pid_t fp2;
    sprintln("---before fork---,this line should just be print once");
    sprintln("~~~fork p1");
    fp1 = fork();
    // fp2 = fork();//本语句会被主进程和p1进程分别执行一次!(实际效果将不是我们想要的)
    // sprintln("---after fork---");
    // counter += 1;
    // dprint(counter);
    // dprint(fp1);
    // dprint(fp2);

    if (fp1 < 0)
    {
        perror("waitprocess::fork error!");
    }
    if (fp1 == 0)
    {
        p1_code();
    }
    else
    {
        p0_code();
    }
}
void p0_code()
{
    printf("I am main process,p0:%d", getpid());
    printf("\n");
    // dprint(getpid());
    sprintln("~~~fork p2---");
    int stauts_;

    int fp2 = fork();
    if (fp2 < 0)
    {
        perror("waitprocess::fork error!");
    }
    if (fp2 == 0)
    {
        p2_code();
    }
    // sleep(1);
    // p0 later code
    // 使用wait()来改进本程序
    // wait(&status_);
    /* 等待所有子进程exit,可以让父进程不停调用wait(),当只有当所有子进程都exit,wait()在返回-1 */
    while (wait(&wstatus) != -1)
    {
        pre_print("😂❤️");
        dprint(WEXITSTATUS(wstatus));
        dprint(WIFEXITED(wstatus));
    }
    sprintln("p0的子进程p1,p2都已经结束!");
    // 查看子进程传递给exit()的遗言
    sprintln("p0 exit!");
    exit(EXIT_SUCCESS);
}
void p1_code()
{
    printf("\t");
    printf("I am child process p1:%d,pp1:%d\n", getpid(), getppid());
    printf("\n");

    // dprint(getpid());
    // dprint(getppid());
    sprintln("p1 will sleep, (before fork p3)...");
    timer("p1", 5);
    /* code */
    sprintln("~~~fork p3~~~");
    pid_t fp3 = fork();
    if (fp3 == 0)
    {
        p3_code();
    }
    else
    {
        // p1_code() later;
        /* p1等待p3结束
        (父进程p0则需要等待p1,p2) */
        // sprintln("p1进程将睡眠3s..");
        // sleep(3);
        /* Wait for a child to die. When one does, put its status in *STAT_LOC
        and return its process ID. For errors, return (pid_t) -1. */
        // 不在乎子进程p3的遗言,则传递NULL给wait()
        sprintln("p1 waiting for p3 exit...");
        wait(NULL);
        // dprint(WIFEXITED(status_));
        sprintln("wow,p3 exited, p1's wait is ended!");
        sprintln("p1 exit!");
        // 结束p1
        exit(EXIT_SUCCESS);
        // exit(15);
    }
}
void p2_code()
{

    printf("\t");
    printf("I am child prcess p2:%d;pp2:%d", getpid(), getppid());
    printf("\n");
    // dprint(getpid());
    // dprint(getppid());
    sprintln("p2 is sleeping...");
    timer("p2", 5);
    /* 结束p2 */
    sprintln("p2 exit!");
    exit(EXIT_SUCCESS);
}
void p3_code()
{
    // p3_code();
    pre_print("\t\t");
    printf("I am child process p3:%d;pp3:%d", getpid(), getppid());
    printf("\n");
    // dprint(getpid());
    // dprint(getppid());
    // execl("/bin/ls", "ls", "-l", (void *)NULL);
    sprintln("p3 is sleeping..");
    // sleep(1);
    timer("p3", 5);
    /* Call all functions registered with `atexit' and `on_exit',
    in the reverse of the order in which they were registered,
    perform stdio cleanup, and terminate program execution with STATUS. */
    sprintln("p3 exit!");
    exit(EXIT_SUCCESS);
}
```
####  comon_fun.c
```c
#include "prints.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <errno.h>
#include <time.h>
void timer(char *invoker, int seconds)
{
    printf("%s:sleeping(%d)s\n", invoker, seconds);
    for (int i = 0; i < seconds; i++)
    {
        // printf("i=%d\n", i);
        printf("\t\t%s:%d\n", invoker, i);
        sleep(1);
        // sprintln("hh");
    }
}
```
####  prints.h
```c
// 数值调试宏
#ifndef CXXU
#define CXXU 1
// 修改sizeint来指定打印宽度:(注意,必须以字符串的形式修改,(数字要包裹双引号))
// 负数,就是左对齐
#define sizeint__ "25"
#define sizestr__ "%" sizeint__ "s"
#define dprint(expr) printf(sizestr__ " = %d @%%d\n", #expr, expr)
#define ldprint(expr) printf(sizestr__ " = %ld @%%ld\n", #expr, expr)
#define cprint(expr) printf(sizestr__ " = %c @%%c\n", #expr, expr)
#define sprint(expr) printf(sizestr__ " = %s @%%s\n", #expr, expr)
#define gprint(expr) printf(sizestr__ " = %g\n", #expr, expr)

#define fprint(expr) printf(sizestr__ " = %f\n", #expr, expr)
// #define sprint(expr) printf("\t@sprint"#expr " = %s\n", expr)

// #define sprint(expr) printf(expr)
#define sprintln(expr) printf(expr "\n")
#define pre_print(expr) printf(expr)

// 直接传递变量给pprint(取地址操作包含在了宏中)
#define pprint(expr) printf(sizestr__ " = %p &var%%p\n", "&" #expr, &expr)
// 直接打印传入的地址(指针变量)
#define pprinta(expr) printf(sizestr__ " = %p %%p (pointer:" #expr ")\n", #expr, expr)
// extern void func();
// extern int multiply(int a, int b);
// extern char *str_multiplier;

#endif
```