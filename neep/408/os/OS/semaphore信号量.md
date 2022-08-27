@[toc]

# OS:信号量理论基础/自旋锁&互斥锁/linux_信号量(sem_t)&sem_wait&sem_post

## references

- [Semaphores (uni-hamburg.de)](https://www3.physnet.uni-hamburg.de/physnet/Tru64-Unix/HTML/APS33DTE/DOCU_010.HTM)
- <<操作系统概念v9>>

- [sem_wait(3): lock semaphore - Linux man page (die.net)](https://linux.die.net/man/3/sem_wait)

- [sem_post(3): unlock semaphore - Linux man page (die.net)](https://linux.die.net/man/3/sem_post)

- [Semaphores and Mutexes (niu.edu)](http://faculty.cs.niu.edu/~hutchins/csci480/semaphor.htm)

### 自旋锁&互斥锁

- 临界区问题的基于硬件的解决方案不但复杂，而且不能为程序员直接使用。
- 因此，操作系统设计人员构建软件工具，以**解决临界区问题一最简单的工具**就是**互斥锁(mutexlock)**
  - (事实上，mutex来源于mutual exclusion)
  - 我们采用**互斥锁保护临界区**，从而防止竞争条件。
  - 也就是说，一个进程在进入临界区时应得到锁；
  - 它在退出临界区时释放锁。
    - 函数**acquire()**获取锁，而函数**release()**释放锁
  - 每个互斥锁有一个**布尔变量available**,它的值表示锁是否可用。
    - 如果锁是可用的，那么调用acquire()会成功，并且锁不再可用。
    - 当一个进程试图获取不可用的锁时，它会阻塞，直到锁被释放。

- 这里所给实现的主要缺点是，它需要忙等待( busy waiting)。
- 当有一个进程在临界区中，任何其他进程在进入临界区时必须连续循环地调用acquire()。
  - 其实,(**这种类型的互斥锁也被称为自旋锁（spinlock)**，因为进程不停地旋转，以等待锁变得可用。
  - (在前面采用指令test_and_set()和 compare_and_swap()的那些例子中，有同样的问题。)
  - 在实际多道程序系统中，即当多个进程共享同一CPU时，这种连续循环显然是个问题。
  - 忙等待浪费CPU周期,而这原本可以有效用于其他进程。
- **自旋锁确实有一个优点**:(
  - 当进程在等待锁时，没有上下文切换(上下文切换可能需要相当长的时间)。
  - 因此，当使用锁的时间较短时，自旋锁还是有用的。
  - 自旋锁通常用于多处(理器系统，一个线程可以在一个处理器上“旋转”，而其他线程在其他处理器上执行临界区。

> - **自旋锁**是[计算机科学](https://zh.wikipedia.org/wiki/计算机科学)用于多线程[同步](https://zh.wikipedia.org/wiki/同步_(计算机科学))的一种[锁](https://zh.wikipedia.org/wiki/互斥锁)，线程反复检查锁变量是否可用。
> - 由于线程在这一过程中保持执行，因此是一种[忙等待](https://zh.wikipedia.org/wiki/忙等待)。
> - 一旦获取了自旋锁，**线程会一直保持该锁，直至显式释放自旋锁**。
>
> - 自旋锁避免了进程上下文的调度开销，因此对于线程只会阻塞很短时间的场合是有效的。
>   - 因此操作系统的实现在很多地方往往用自旋锁。
>   - Windows操作系统提供的轻型[读写锁](https://zh.wikipedia.org/wiki/读写锁)（SRW Lock）内部就用了自旋锁。
>   - 显然，单核CPU不适于使用自旋锁，这里的单核CPU指的是单核单线程的CPU，
>     - 因为，在**同一时间只有一个线程是处在运行状态**，假设运行线程A发现无法获取锁，只能等待解锁，但因为A自身不挂起，所以那个持有锁的线程B没有办法进入运行状态，只能等到操作系统分给A的时间片用完，才能有机会被调度。**这种情况下使用自旋锁的代价很高**。
>     - 获取、释放自旋锁，实际上是读写自旋锁的存储内存或寄存器。
>     - 因此这种读写操作必须是[原子的](https://zh.wikipedia.org/wiki/原子操作)。通常用[test-and-set](https://zh.wikipedia.org/wiki/Test-and-set)等原子操作来实现。
>

> 当已经有一个线程加锁后，其他线程加锁则就会失败，互斥锁和自旋锁对于加锁失败后的处理方式是不一样的：

- **互斥锁**加锁失败后，线程会**释放 CPU** ，给其他线程；(自我阻塞;需要其他进程来唤醒才可以继续运行)
- **自旋锁**加锁失败后，线程会**忙等待**，直到它拿到锁；

### 信号量基础

- 互斥锁,通常认为是最简单的同步工具。
- 本节将会讨论一个更鲁棒的工具，它的**功能类似于互斥锁，但是它能提供更为高级的方法，以便进程能够同步活动**。

![image-20220602210157867](https://s2.loli.net/2022/06/02/WLxUvBQkpb5wOhc.png)

- 一个信号量(semaphore)S是个整型变量，它除了初始化外只能通过两个标准原子操作：wait。
- 和signal()来访问。操作waitO最初称为P(荷兰语probcren,测试)；
- 操作signal()最初称为V(荷兰语verhogen,增加)在wait。
- 和signalO操作中，信号量整数值的修改应不可分割地执行。
  - 也就是说，当一个进程修改信号量值时，没有其他进程能够同时修改同一信号量的值。
  - 另外，对于wait(S),S整数值的测试和修改(S--),也不能被中断。

#### 信号量的使用(二进制信号量&计数信号量)

- 信号量的使用操作系统通常区分**计数信号量**与**二进制信号量**。
- 计数信号量(countingsemaphore)的值不受限制，而二进制信号量(binarysemaphore)的值只能为0或1。
- 因此，二进制信号量类似于互斥锁。
- 事实上，在没有提供互斥锁的系统上，可以使用二进制信号量来提供互斥。
- 计数信号量可以用于**控制访问具有多个实例的某种资源**。
- 信号量的初值为可用资源数量。
- 当进程需要使用资源时，需要对该信号量执行wait()操作(减少信号量的计数)。
- 当进程释放资源时，需要对该信号量执行signalO操作(增加信号量的计数)。
- 当信号量的计数为0时，所有资源都在使用中。
- 之后，需要使用资源的进程将会阻塞，直到计数大于0。

> 我们也可以使用信号量来解决各种同步问题。

例如，现有两个并发运行的进程：p1有语句S1而p2有语句s2。

假设要求只有在S1执行后才能执行S2。

我们可以轻松实现这一要求：

让p1和p2共享同一信号量synch,并且初始化为0。

在进程p1中，插入语句：

```c
S1;
signal(synch);
```

在进程p2中,插入语句:

```c
wait(synch);
S2;
```

因为synch初始化为0,只有在P1调用signal(synch),即,S1语句执行之后,P2才会执行S2

#### 代码中的信号量

- 在代码中对计数信号量做wait操作时,如果尚有资源可以分配(资源计数大于0),那么线程(或者进程)就可以尝试执行下一行代码;这主要体现进程间对有限资源的竞争关系,如果可用资源(例如,记作S1)的数量(大于1,那么可能有多个线程可以都可以顺利执行wait(S1)操作,只有当线程执行wait(S1)时遇到S1.value<=0才会这一步被阻塞;(S1.value>0的时候,执行wait(S1)不需要等待其他线程执行signal(S1)才可以执行成功,他们几乎可以同时执行成功)

- 特别地,对于二进制信号量(比如,记作S2),由于可用资源不超过1,最多只有一个进程能够执行成功(不被阻塞),而当其他进程也想要wait(S2),就会因为资源缺乏而导致被阻塞,无法继续执行;直到最初那个占有资源的线程执行signal(S2)将资源数+1;这时候其他处于等待(block)的进程会有一个被唤醒(unblock)
- 可见,如果需要创建临界区,据需要使用互斥信号量来创建,这时,可以保证,同一时刻,只有一个线程会执行临界区代码;
  - 而计数信号量则不能够保证这一点
  - 同步信号量经常配合互斥信号量使用,譬如消费者-生产者问题
  - ![image-20220603090744389](https://s2.loli.net/2022/06/03/uJ2klAZcQfO9qjN.png)

##### 信号量与线程代码共享

经常地,不同线程会使用同一份代码(程序),尽管源代码一样,但是各自线程执行的代码就不一定一样,特别时带有判断结果的线程代码,不同的线程会因为执行时机和环境的变化影响下,可能会进入到不同的分支

###### 对于读者-写者问题

![image-20220603093329865](https://s2.loli.net/2022/06/03/54EWLvkyoK1mYei.png)

借助判断分支结构,我们可以实现灵活的线程互斥

- 例如`读者进程`的结构,为了实现读者和写者之间互斥,同时还要避免读者之间的互斥,我们处理单纯的靠信号量来表征资源的使用情况,还借助了一个整形的计数变量来辅助算法的实现.控制互斥代码的执行
  - 要确保当读者进程执行读操作时,保没有写者在工作,读者需要拿到rw锁后才开始读
  - 这时候,如果有多个读者,应该允许他们并发读取资源(文件/数据库/...)
    - 为了不让读者之间产生互斥,我们要避免所有读者线程都会执行rw锁的加锁操作(这将导致多余的互斥)
    - 借助计数变量count,只让第一个读者(只有一个读者的时候)加锁(这时足以确保没有写者进程在写)
    - 所有的读者线程,总共只需要加一把锁(由第一个读者加上,用来排斥后续的写线程),这把锁对于其他读线程不可见,但是当所有读者任务结束,则由最后一个结束读任务的读者释放signal(rw_mutex)
      - 如果在还有其他读者在读的时候就释放rw_mutex,会造成写者有机会乱入,造成混乱.
    - 同时,当有多个读者的时候,要避免执行加锁(wait(rw_mutex)操作,实现读者线程间的不互斥
    - 换句话说,只要线程不执行加锁代码(尽管存在相关代码,但是被分支判断避开),那么相应的锁对线程就是不可见(相当于没(阻碍)影响)



#### 信号量的实现

![image-20220602205839951](https://s2.loli.net/2022/06/02/wtJmbfSaDKs154G.png)

为了克服忙等待需要，可以这样修改信号量操作wait和signal的定义：

- 当一个进程执行操作wait并且发现信号量值不为正时，它必须等待。
- 然而，该进程不是忙等待而是阻塞自己。
- 阻塞操作将一个进程放到与信号量相关的等待队列中，并且将该进程状态切换成等待状态。
- 然后，控制转到CPU调度程序，以便选择执行另一个进程。
- 等待信号量S而阻塞的进程，在其他进程执行操作signal()后，应被重新执行。
- 进程的重新执行是通过操作wakeup()来进行的，它将进程从等待状态改为就绪状态。
- 然而，进程被添加到就绪队列.(取决于CPU调度算法，CPU可能会也可能不会从正在运行的进程切换到新的就绪进程。)
- 操作block()挂起调用它的进程。操作wakeup(P)重新启动阻塞进程P的执行。
- 这两个操作都是由操作系统作为基本系统调用来提供的。
- 注意，这样实现的信号量的值可以是负数，而在具有忙等待的信号量经典定义下，信号量的值不能为负。如果信号量的值为负，那么它的绝对值就是等待它的进程数。
- 出现这种情况源于，在实现操作wait时互换了递减和测试的顺序。
- 通过每个进程控制块PCB的一个链接字段，等待进程的链表可以轻松实现。
- 每个信号最包括一个整数和一个PCB链表指针。
  - 向链表中增加和删除进程以便确保有限等待的一种方法采用FIFO队列，这里的信号量包括队列的首指针和尾指针。
  - 然而，一般来说，链表可以使用任何排队策略。
- 信号量的正确使用不依赖于信号量链表的特定排队策略关键的是，信号量操作应原子执行。
- 我们应保证：对**同一信号**量，**没有两个进程可以同时执行**操作wait和signal,这是一个临界区问题。
- 对于单处理器环境，在执行操作wait和signal时，可以简单禁止中断。
  - 这种方案在单处理器环境下能工作，这是因为一旦中断被禁用，不同进程指令不会交织在一起。
  - 只有当前运行进程一直执行，直到中断被重新启用并且调度程序重新获得控制。
- 对于多处理器环境，**每个处理器的中断都应被禁止**；否则，在不同处理器上不同的运行进程可能会以任意不同方式一起交织执行。
  - 每个处理器中断的禁止会很困难，也会严重影响性能。
  - 因此，SMP系统应**提供其他加锁技术**，如compare_and_swap()或自旋锁，以确保waitO与signal()原子执行。
  - 重要的是要承认，对于这里定义的操作wait()和signal(),我们**并没有完全取消忙等待**。
  - 我们只是将**忙等**待从**进入区**移到**临界区**。
  - 此外，我们将**忙等待限制在操作wait()和signal()的临界区内**，这些区比较短(如经合理编码，它们不会超过10条指令)。
  - 因此，**临界区几乎不被占用，忙等待很少发生，而且所需时间很短**。
  - 对于应用程序，存在一种**完全不同**的情况，即**临界区可能很长**(数分钟或数小时)或几乎总是被占用在这种情况下，**忙等待极为低效**。

## synopsis(概要)

> - Semaphores are used to control access to shared resources by processes.
> -  Counting semaphores
>   -  have a positive integral value **representing** <u>the number of processes that can concurrently lock the semaphore.</u>
>
> - There are named and unnamed semaphores. 
>   - Named semaphores provide access to a resource between multiple processes. 
>   - Unnamed semaphores provide multiple accesses to a resource within a single process or between related processes. 
>   - <u>Some semaphore functions are specifically designed to perform operations on named or unnamed semaphores</u>.

### What is a semaphore in LINUX?

A semaphore is fundamentally an integer whose value is never allowed to fall below 0. There are two operations on a semaphore: wait and post. The post operation increment the semaphore by 1, and the wait operations does the following: If the semaphore has a value > 0, the semaphore is decremented by 1. If the semaphore has value 0, the caller will be blocked (busy-waiting or more likely on a queue) until the semaphore has a value larger than 0, and then it is decremented by 1.

We declare a semaphore as:

```
sem_t sem;
```

where sem_t is a typedef defined in a header file as (apparently) a kind of unsigned char.

An example of this might be that we have a set of N interchangeable resources. We start with semaphore S = N. We use a resource, so there are now N-1 available (wait), and we return it when we are done (post). If the semaphore has value 0, there are no resources available, and we have to wait (until someone does a post).

Semaphores are thus used to coordinate concurrent processes.

This is what some people call a "counted semaphore". There is a similar notion called a "binary semaphore" which is limited to the values 0 and 1.

A semaphore may be named or unnamed. These notes assume we are using named semaphores.

## sem_t的定义

```c
typedef union
{
  char __size[__SIZEOF_SEM_T];
  long int __align;
} sem_t;
```





## sem_post(3) - Linux man page

### Name

sem_post - unlock a semaphore

### Synopsis

```
#include <semaphore.h>
int sem_post(sem_t *sem);
```

Link with *-pthread*.

### Description

**sem_post**() increments (unlocks) the semaphore pointed to by *sem*. If the semaphore's value consequently becomes greater than zero, then another process or thread blocked in a ***[sem_wait](https://linux.die.net/man/3/sem_wait)**(3)* call will be woken up and proceed to lock the semaphore.

## sem_wait(3) - Linux man page

### Name

sem_wait, sem_timedwait, sem_trywait - lock a semaphore

### Synopsis

```
#include <semaphore.h>

int sem_wait(sem_t *sem);

int sem_trywait(sem_t *sem);

int sem_timedwait(sem_t *sem, const struct timespec *abs_timeout);
```

Link with *-pthread*.

Feature Test Macro Requirements for glibc (see **[feature_test_macros](https://linux.die.net/man/7/feature_test_macros)**(7)):

- **sem_timedwait**(): _POSIX_C_SOURCE >= 200112L || _XOPEN_SOURCE >= 600

### Description

**sem_wait**() decrements (locks) the semaphore pointed to by *sem*. If the semaphore's value is greater than zero, then the decrement proceeds, and the function returns, immediately. If the semaphore currently has the value zero, then the call blocks until either it becomes possible to perform the decrement (i.e., the semaphore value rises above zero), or a signal handler interrupts the call.

**sem_trywait**() is the same as **sem_wait**(), except that if the decrement cannot be immediately performed, then call returns an error (*errno* set to **EAGAIN**) instead of blocking.

**sem_timedwait**() is the same as **sem_wait**(), except that *abs_timeout* specifies a limit on the amount of time that the call should block if the decrement cannot be immediately performed. The *abs_timeout* argument points to a structure that specifies an absolute timeout in seconds and nanoseconds since the Epoch, 1970-01-01 00:00:00 +0000 (UTC). This structure is defined as follows:

```
struct timespec {
    time_t tv_sec;      /* Seconds */
    long   tv_nsec;     /* Nanoseconds [0 .. 999999999] */
};
```

If the timeout has already expired by the time of the call, and the semaphore could not be locked immediately, then **sem_timedwait**() fails with a timeout error (*errno* set to **ETIMEDOUT**).

If the operation can be performed immediately, then **sem_timedwait**() never fails with a timeout error, regardless of the value of *abs_timeout*. Furthermore, the validity of *abs_timeout* is not checked in this case.

### Return Value

All of these functions return 0 on success; on error, the value of the semaphore is left unchanged, -1 is returned, and *errno* is set to indicate the error.

## sem_overview(7) - Linux man page

### Name

sem_overview - overview of POSIX semaphores

### Description

POSIX semaphores allow **processes and threads** to **synchronize their actions.**

- A semaphore is an **integer** whose value is **never allowed to fall below zero**. 

- Two operations can be performed on semaphores: 
  - increment the semaphore value by one (***[sem_post](https://linux.die.net/man/3/sem_post)**(3)*); 
  - and decrement the semaphore value by one (***[sem_wait](https://linux.die.net/man/3/sem_wait)**(3)*). 
- If the value of a semaphore is currently zero, then a ***[sem_wait](https://linux.die.net/man/3/sem_wait)**(3)* operation **will block until the value becomes greater than zero.**

POSIX semaphores come in **two forms**: <u>**named** semaphores and **unnamed** semaphores.</u>

- **Named semaphores**

  - A named semaphore is identified by a name of the form */somename*; 
  - that is, a null-terminated string of up to **NAME_MAX***-4* (i.e., 251) characters **consisting of an initial slash**, **followed by one or more characters**, <u>none of which are slashes.</u> 
  - Two processes can operate on the same named semaphore by passing the same name to ***[sem_open](https://linux.die.net/man/3/sem_open)**(3)*.
  - The ***[sem_open](https://linux.die.net/man/3/sem_open)**(3)* function creates a new named semaphore or opens an existing named semaphore.
    -  After the semaphore has been opened, it can be operated on using ***[sem_post](https://linux.die.net/man/3/sem_post)**(3)* and ***[sem_wait](https://linux.die.net/man/3/sem_wait)**(3)*. 
  - When a process has finished using the semaphore, it can use ***[sem_close](https://linux.die.net/man/3/sem_close)**(3)* to close the semaphore. 
  - When all processes have finished using the semaphore, it can be removed from the system using ***[sem_unlink](https://linux.die.net/man/3/sem_unlink)**(3)*.

- **Unnamed semaphores (memory-based semaphores)**

  An unnamed semaphore does not have a name. Instead the semaphore is placed in a region of memory that is shared between multiple threads (a *thread-shared semaphore*) or processes (a *process-shared semaphore*). A thread-shared semaphore is placed in an area of memory shared between the threads of a process, for example, a global variable. A process-shared semaphore must be placed in a shared memory region (e.g., a System V shared memory segment created using ***[shmget](https://linux.die.net/man/2/shmget)**(2)*, or a POSIX shared memory object built created using ***[shm_open](https://linux.die.net/man/3/shm_open)**(3)*).Before being used, an unnamed semaphore must be initialized using ***[sem_init](https://linux.die.net/man/3/sem_init)**(3)*. It can then be operated on using ***[sem_post](https://linux.die.net/man/3/sem_post)**(3)* and ***[sem_wait](https://linux.die.net/man/3/sem_wait)**(3)*. When the semaphore is no longer required, and before the memory in which it is located is deallocated, the semaphore should be destroyed using ***[sem_destroy](https://linux.die.net/man/3/sem_destroy)**(3)*.

The remainder of this section describes some specific details of the Linux implementation of POSIX semaphores.

### Versions

Prior to kernel 2.6, Linux only supported unnamed, thread-shared semaphores. On a system with Linux 2.6 and a glibc that provides the NPTL threading implementation, a complete implementation of POSIX semaphores is provided.

### Persistence

POSIX named semaphores have kernel persistence: if not removed by ***[sem_unlink](https://linux.die.net/man/3/sem_unlink)**(3)*, a semaphore will exist until the system is shut down.



## 例程
###  一个带有疑惑的进程间信号量程序

- [c - Share POSIX semaphore among multiple processes - Stack Overflow](https://stackoverflow.com/questions/32205396/share-posix-semaphore-among-multiple-processes)
- [Semaphore between processes example in C – Vishal Chovatiya](http://www.vishalchovatiya.com/semaphore-between-processes-example-in-c/)
- 参考:[Posix信号量 ](https://www.cnblogs.com/tianzeng/p/9314463.html)

> - 估计是,进程间使用的信号量比较适合用`有名信号量`
> - 无名信号量导致不正确的结果

```c
#include <sys/wait.h>
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <semaphore.h>
int main(int argc, char const *argv[])
{
    sem_t s;
    /*   The pshared argument indicates whether this semaphore is to be shared between  the  threads of a process, or between processes.

       If  pshared has the value 0, then the semaphore is shared between the threads of a process,
       and should be located at some address that is visible to all threads (e.g., a global  vari‐
       able, or a variable allocated dynamically on the heap).

         If  pshared  is  nonzero,  then  the  semaphore  is shared between processes, and should be located in a region of shared memory (see shm_open(3), mmap(2), and shmget(2)).   (Since  a   child created by fork(2) inherits its parent's memory mappings, it can also access the semaphore.)  
         Any process that can access the shared memory region can operate on the semaphore
       using sem_post(3), sem_wait(3), and so on. */
    sem_init(&s, 0, 3);
    // 注意fork的新进程要共享s
    pid_t pid = fork();
    if (pid == 0)
    {
        sleep(1);
        sem_post(&s);
        sem_post(&s);
        sem_post(&s);

        printf("by child:@s.__align:%ld\n", s.__align);
        exit(1);
    }
    else
    {

        printf("查看初始值:@s.__align:%ld\n", s.__align);
        printf("开始调用sem_wait若干次...\n");
        printf("@1");
        sem_wait(&s);
        printf("@s.__align:%ld\n", s.__align);
        printf("@2");
        sem_wait(&s);
        printf("@s.__align:%ld\n", s.__align);
        printf("@3");
        sem_wait(&s);
        printf("@s.__align:%ld\n", s.__align);

        printf("waiting...\n");

        printf("开始被阻塞,直到被另一个进程的sem_post唤醒!\n");
        sem_wait(&s);
        printf("@s.__align:%ld\n", s.__align);
        wait(NULL);
    }
    return 0;
}

```

####  运行结果

```
# cxxu @ cxxuAli in ~/cppCodes/barber on git:master x [21:34:48] 
$ sem_test                           
查看初始值:@s.__align:3
开始调用sem_wait若干次...
@1@s.__align:2
@2@s.__align:1
@3@s.__align:0
waiting...
开始被阻塞,直到被另一个进程的sem_post唤醒!
by child:@s.__align:6

```
###  一个正常的例程(基于线程的信号量程序)

```c

// #include <string.h>
#include <stdlib.h>
// #include <math.h>
#include <time.h>
#include <pthread.h>
// #include <stdbool.h>
// #include <string.h>
// #include <errno.h>
// #include <time.h>

#include <sys/wait.h>
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <semaphore.h>
sem_t s;
void *thread_function1(void *arg)
{
   

    // sem_wait(&s);
    printf("@thread1:sleeping 2 second...\n");
    sleep(2);
    int value;
    // before post check the value
    sem_getvalue(&s, &value);
    printf("by child:@s_value:%d\n", value);
    sem_post(&s);
    printf("sem_post done!\n");
    //after post check the value
    sem_getvalue(&s, &value);
    printf("by child:@s_value:%d\n", value);
    /* post again?(to show sem value increase)*/
    sem_post(&s);
    // after post check the value
    sem_getvalue(&s, &value);
    printf("by child:@s_value:%d\n", value);

    // exit(1);
}

int main(int argc, char const *argv[])
{
    /*   The pshared argument indicates whether this semaphore is to be shared between  the  threads of a process, or between processes.

       If  pshared has the value 0, then the semaphore is shared between the threads of a process,
       and should be located at some address that is visible to all threads (e.g., a global  vari‐
       able, or a variable allocated dynamically on the heap).

         If  pshared  is  nonzero,  then  the  semaphore  is shared between processes, and should be located in a region of shared memory (see shm_open(3), mmap(2), and shmget(2)).   (Since  a   child created by fork(2) inherits its parent's memory mappings, it can also access the semaphore.)
         Any process that can access the shared memory region can operate on the semaphore
       using sem_post(3), sem_wait(3), and so on. */
    sem_init(&s, 0, 3);
    // 注意fork的新进程要共享s
    /*     pid_t pid = fork();
        if (pid == 0)
        {
            sleep(1);
            sem_post(&s);
            sem_post(&s);
            sem_post(&s);
            int value = -1;
            sem_getvalue(&s, &value);
            printf("by child:@s_value:%d\n", value);
            exit(1);
        } */
    // else
    // {
    pthread_t a_thread;
    int res;
    res = pthread_create(&a_thread, NULL, thread_function1, NULL);
    if (res != 0)
    {
        perror("Thread creation failure");
    }

    int value;
    printf("查看初始值:@s.__align:%ld\n", s.__align);
    printf("开始调用sem_wait若干次...\n");

    for (int i = 0; i < 3; i++)
    {
        /* code */

        printf("@%d", i);
        sem_wait(&s);
        // printf("@s.__align:%ld\n", s.__align);
        sem_getvalue(&s, &value);
        usleep(100000); // 100ms
        printf("@s_value:%d\n", value);
    }

    printf("waiting...\n");

    printf("再次调用wait,将被阻塞,直到被另一个进程的sem_post唤醒!(子线程2秒后执行sem_post来唤醒当前主线程(unblock))!\n");
    printf("大概被阻塞2s...\n");
    sem_wait(&s);
    // 再次查看信号量值
    sem_getvalue(&s, &value);
    printf("@s_value:%d\n", value);
    printf("about 2sencond elapsed!\n");
    printf("waiting the child pthread join..\n");
    pthread_join(a_thread, NULL);
    printf("child thread joined!");
    // }
    // return 0;
}

```

####  编译(-pthread)运行

```
# cxxu @ cxxuAli in ~/cppCodes/barber on git:master x [20:12:57] 
$ gcc sem_test.c -o sem_test -pthread

# cxxu @ cxxuAli in ~/cppCodes/barber on git:master x [20:12:58] 
$ sem_test                           
查看初始值:@s.__align:3
开始调用sem_wait若干次...
@0thread_function1--------------sem_wait
@thread1:sleeping 2 second...
@s_value:2
@1@s_value:1
@2@s_value:0
waiting...
再次调用wait,将被阻塞,直到被另一个进程的sem_post唤醒!(子线程2秒后执行sem_post来唤醒当前主线程(unblock))!
大概被阻塞2s...
by child:@s_value:0
@s_value:0
about 2sencond elapsed!
waiting the child pthread join..
sem_post done!
by child:@s_value:0
by child:@s_value:1
child thread joined!%                                                                
```
