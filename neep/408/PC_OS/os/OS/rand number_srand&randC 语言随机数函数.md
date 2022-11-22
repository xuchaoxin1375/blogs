
@[toc]
## references

- [What’s a seed in a random number generator? · YourBasic](https://yourbasic.org/algorithms/random-number-generator-seed/)
- [C语言随机数生成教程，C语言rand和srand用法详解 (biancheng.net)](http://c.biancheng.net/view/2043.html)
- [Random seed - Wikipedia](https://en.wikipedia.org/wiki/Random_seed)

###    文档参考在线

- [srand(3): pseudo-random number generator - Linux man page (die.net)](https://linux.die.net/man/3/srand)

- [time(2): time in seconds - Linux man page (die.net)](https://linux.die.net/man/2/time)

  

## 简要文档

RAND(3)                         Linux Programmer's Manual                        RAND(3)

NAME
       rand, rand_r, srand - pseudo-random number generator

### SYNOPSIS(主要的随机函数)

​       #include <stdlib.h>

       int rand(void);
    
       int rand_r(unsigned int *seedp);
    
       void srand(unsigned int seed);

### Description

The **rand**() function returns a pseudo-random integer in the range 0 to **RAND_MAX** inclusive (i.e., the mathematical range [0, **RAND_MAX**]).

The **srand**() function sets its argument as the seed for a new sequence of pseudo-random integers to be returned by **rand**(). These sequences are repeatable by calling **srand**() with the same seed value.

If no seed value is provided, the **rand**() function is automatically seeded with a value of 1.

The function **rand**() is not reentrant or thread-safe, since it uses hidden state that is modified on each call. This might just be the seed value to be used by the next call, or it might be something more elaborate. In order to get reproducible behavior in a threaded application, this state must be made explicit; this can be done using the reentrant function **rand_r**().

Like **rand**(), **rand_r**() returns a pseudo-random integer in the range [0, **RAND_MAX**]. The *seedp* argument is a pointer to an *unsigned int* that is used to store state between calls. If **rand_r**() is called with the same initial value for the integer pointed to by *seedp*, and that value is not modified between calls, then the same pseudo-random sequence will result.

The value pointed to by the *seedp* argument of **rand_r**() provides only a very small amount of state, so this function will be a weak pseudo-random generator. Try **[drand48_r](https://linux.die.net/man/3/drand48_r)**(3) instead.





### RETURN VALUE

-  The  rand()  and rand_r() functions return a value between 0 and RAND_MAX (inclusive). 

-  The srand() function returns no value.

## 例程Example

> - POSIX.1-2001 gives the following example of an **implementation** of rand() and srand(),
> - possibly useful when one needs the same sequence on two different machines.
> - 从下面的模拟实现中,我们可以清楚的知道srand和rand的工作方式(大致就是共同操作一个`共享变量next`)

```c

static unsigned long next = 1;

/* RAND_MAX assumed to be 32767 
下面的取模操作正好体现了这一点(生产的随机数范围0~32767*/
int myrand(void) {
    //next的递归公式(知道前一个next就知道响铃next的取值,进而全序列的值都可以知道)
    next = next * 1103515245 + 12345;
    return((unsigned)(next/65536) % 32768);
}
//模拟实现srand(接受一个seed作为参数,同时修改全局变量next)
//全局变量next可以直接被另一个函数rand(这里时模拟的myrand()直接访问(而不需要通过传参的形式访问))
void mysrand(unsigned seed) {
    next = seed;
}


```

- The following program can be used t**o display the pseudo-random sequence produced by rand()** when <u>given a particular seed.</u>

```c
#include <stdlib.h>
#include <stdio.h>
//输入seed(种子,决定随机数的序列)&nloops(需要生产多少个随机数来观察)来运行编译后的本程序
int main(int argc, char *argv[])
{
    int j, r, nloops;
    unsigned int seed;

   if (argc != 3) {
        fprintf(stderr, "Usage: %s <seed> <nloops>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

   seed = atoi(argv[1]);
    nloops = atoi(argv[2]);

   srand(seed);
    for (j = 0; j < nloops; j++) {
        r =  rand();
        printf("%d\n", r);
    }

   exit(EXIT_SUCCESS);
}
```

### 运行结果

#### 编译

#( 05/31/22@11:46PM )( cxxu@cxxuAli ):~/cppCodes/barber@master✗✗✗
   `gcc test_rand_seed.c  -o trs`

编译后的程序名位`trs`

#### 测试结果

```
#( 05/31/22@11:47PM )( cxxu@cxxuAli ):~/cppCodes/barber@master✗✗✗
   trs 1 3
1804289383
846930886
1681692777
#( 05/31/22@11:47PM )( cxxu@cxxuAli ):~/cppCodes/barber@master✗✗✗
   trs 1 6
1804289383
846930886
1681692777
1714636915
1957747793
424238335
#( 05/31/22@11:47PM )( cxxu@cxxuAli ):~/cppCodes/barber@master✗✗✗
   trs 2 4
1505335290
1738766719
190686788
260874575
#( 05/31/22@11:47PM )( cxxu@cxxuAli ):~/cppCodes/barber@master✗✗✗
   trs 2 3
1505335290
1738766719
190686788
#( 05/31/22@11:47PM )( cxxu@cxxuAli ):~/cppCodes/barber@master✗✗✗
```



### 默认rand()

```c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

int main(int argc, char const *argv[])
{
    while (1)
    {
        /* code */
        int r = rand();
        printf("@r=%d\n", r);

        printf("-------------input `enter` to try again:");
        char c = getchar();
  
    }
}
```

- 如果不通过srand()函数设置种子,那么rand()使用的种子默认是1
- 连续调用rand()可以获得一定长度的随机数序列(这几次调用是在同一个进程生存周期内执行的)
- 如果在不同的进程(比如同一个程序(源代码)的若干次独立运行中,发生的rand()调用产生的序列将是一致的.
  - 只要是设置的seed一样(如果不设置,则默认为1),就可以确保通过rand()给出的序列是相同的

![](https://img-blog.csdnimg.cn/img_convert/d976f745b5b9ab1c76df61e9361ada28.png)



## 种子与伪随机数生成&种子的用途(pseudorandom number generator)

> 现在,我们回过头看看种子

- A **random seed** (or **seed state**, or just **seed**) is a [number](https://en.wikipedia.org/wiki/Number) (or [vector](https://en.wikipedia.org/wiki/Array_data_structure)) used to [initialize](https://en.wikipedia.org/wiki/Initial_condition) a [pseudorandom number generator](https://en.wikipedia.org/wiki/Pseudorandom_number_generator).

- For a seed to be used in a pseudorandom number generator, it does not need to be random. Because of the nature of number generating algorithms, so long as the original seed is ignored, the rest of the values that the algorithm generates will follow [probability distribution](https://en.wikipedia.org/wiki/Probability_distribution) in a pseudorandom manner.

- A pseudorandom number generator's number sequence is completely determined by the seed: thus, if a pseudorandom number generator is reinitialized with the same seed, it will produce the same sequence of numbers.

- The choice of a good random seed is crucial in the field of [computer security](https://en.wikipedia.org/wiki/Computer_security). When a secret [encryption](https://en.wikipedia.org/wiki/Encryption) [key](https://en.wikipedia.org/wiki/Key_(cryptography)) is [pseudorandomly](https://en.wikipedia.org/wiki/Pseudorandom) [generated](https://en.wikipedia.org/wiki/Key_generation), having the seed will allow one to obtain the key. High [entropy](https://en.wikipedia.org/wiki/Entropy_(computing)) is important for selecting good random seed data.[[1\]](https://en.wikipedia.org/wiki/Random_seed#cite_note-1)

- If the same *random* seed is deliberately shared, it becomes a [secret key](https://en.wikipedia.org/wiki/Secret_key), so two or more systems using matching pseudorandom number algorithms and matching seeds can generate matching sequences of non-repeating numbers which can be used to synchronize remote systems, such as [GPS](https://en.wikipedia.org/wiki/GPS) satellites and receivers.

- Random seeds are often generated from the state of the computer system (such as the [time](https://en.wikipedia.org/wiki/Time)), a [cryptographically secure pseudorandom number generator](https://en.wikipedia.org/wiki/Cryptographically_secure_pseudorandom_number_generator) or from a [hardware random number generator](https://en.wikipedia.org/wiki/Hardware_random_number_generator).

## 获取不同的种子

###  time(秒级别变化)

SYNOPSIS
       #include <time.h>

       time_t time(time_t *tloc);

DESCRIPTION
       time()  returns  the  time  as  the number of seconds since the Epoch, 1970-01-01
       00:00:00 +0000 (UTC).

       If tloc is non-NULL, the return value is also stored in the memory pointed to  by
       tloc.

RETURN VALUE
       On  success, the value of time in seconds since the Epoch is returned.  On error,
       ((time_t) -1) is returned, and errno is set appropriately.z

### 微秒级变化

```c
// #include"prints.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <sys/time.h>
// #include "common_fun.c"
int main(int argc, char const *argv[])
{
    printf("@time(s):%ld\n", time(NULL));
    while (1)
    {
        /* code */
        int r = rand();
        time_t ts; // time_t:long int
        // time()返回的是秒级的变换速度,可以使用毫秒级的变换速度
        ts = time(NULL);
        /* int gettimeofday(struct timeval *__restrict__ __tv, struct timezone *__restrict__ __tz) */
        printf("@@ts:%ld\n", ts);
        struct timeval tv;

        gettimeofday(&tv, NULL);
        // timeval 对象(结构)拆包
        long tms = tv.tv_sec + tv.tv_usec;
        // printf("@tv.tv_sec+tv.tv_usec:%ld\n", tms);
        // printf("@tv.tv_sec:%ld\n", tv.tv_sec);
        // printf("@tv.tv_usec:%ld\n", tv.tv_usec);
        printf("@@tms:%ld\n", tms);

        // printf("@r=%d\n", r);
        srand(tv.tv_sec + tv.tv_usec); //微秒级变化的种子

       
        for (int i = 0; i < 5; i++)
        {
            /* code */
            int r = rand();
            printf("@r%d:%d\n", i,r);
        }
        printf("-------------input `enter` to try again:");
        char c = getchar();

  
    }
}

```

#### 效果

![image-20220601124623741](https://img-blog.csdnimg.cn/img_convert/b3dbf0b66c697232ecb33b6185b8c36b.png)





