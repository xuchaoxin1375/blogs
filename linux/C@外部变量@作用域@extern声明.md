[toc]





## abstract

- C@引用外部对象@include@extern的使用@多文件编译和多文件源代码组织@头文件组织

## include文件包含

- #include包含是C预处理器最常用的预处理指令之一(还有 条件包含和宏替换)
  - C语言通过预处理器提供了一些语言功能。从概念上讲，预处理器是编译过程中单独执行的第一个步骤。两个最常用的预处理器指令是：#include指令（用于在编译期间把指定文件的内容包含进当前文件中）和#define指令（用任意字符序列替代一个标记）。

- `#include`将被include的文件导入到使用`#include`的文件中
  - 尽管如此,如果使用了预编译处理(preprocessor),引入的全部内容可能只有一部分会被编译(如果在本次编译中的多个c源文件中有超过一个源文件include过相同的头文件)

## extern 和 static

`extern` 用于声明**外部变量或函数**，即声明变量或函数在**其他源文件**中定义。它的主要用途是让当前文件可以引用其他文件中的变量或函数。

`static` 用于控制**变量或函数的作用域和生命周期**。它的具体作用取决于它应用的上下文：

- 在函数或代码块内声明变量：

  - 如果在函数内用 `static` 声明一个变量，那么这个变量的**生命周期**会是整个程序运行期间，即它的值在函数调用结束后也会保持不变。

  - 这种变量的**作用域**仅限于声明它的函数或代码块，其他地方无法访问它。

- 在函数外声明变量或函数：
  - 如果在函数外用 `static` 声明一个变量或函数，那么这个变量或函数的**作用域仅限于当前源文件**。
  - 其他源文件中无法访问这个变量或函数，这样可以防止命名冲突，便于模块化管理。

## extern

- 外部变量**必须定义在所有函数之外**，且**只能定义一次**，定义后编译程序将为它分配存储单元。
- 在**每个需要访问外部变量的函数中，必须声明相应的外部变量**，此时说明其类型。
  - 声明时可以用`extern`语句**显式声明**，也可以通过上下文**隐式声明**。
- 从语法角度看，外部变量的定义与局部变量的定义是相同的，但由于它们位于各函数的外部，因此这些变量是外部变量。
- 函数在使用外部变量之前，必须要知道**外部变量的名字**。要达到该目的，一种方式是在函数中使用extern类型的声明。这种类型的声明除了在前面加了一个关键字extern外，其它方面与普通变量的声明相同。
- 某些情况下可以**省略extern声明**。在**源文件**中，如果外部变量的**定义出现在使用它的函数之前**，那么在那个函数中就没有必要使用extern声明。
- 在通常的做法中，**所有外部变量的定义都放在源文件的开始处**，这样就可以省略extern声明。
- 如果程序包含在多个源文件中，而某个变量在file1文件中定义、在file2和file3文件中使用，那么在文件file2与file3中就需要使用extern声明来建立该变量与其定义之间的联系。

### extern的使用

- 一般将`extern `所声明的内容写在某个`头文件中`,可以保持`main.c`的整洁,以及提高方便复用

- 使用`extern`,可以只把定义对象的文件中的**指定对象**(通过声明&名称)引入到本程序的编译,而不会访问过多的内容,导致异常(例如对象冲突),在大程序中尤为如此

- 如果既没有用`#include`将提供被引用对象的定义的源文件导入,又没有使用`extern` 在主程序中显示声明,那么即使在编译文件中提到所有文件,还是无法通过编译(找不到被引用的对象)

### 必须显式声明外部变量的情况

如果要**在外部变量的定义之前**使用该变量，或者外部变量的定义与变量的使用**不在同一个源文件**中，则必须在相应的变量声明中强制性地使用关键字extern。

### 变量的定义和声明对比

 将外部变量的声明与定义严格区分开来很重要。

变量声明用于**说明变量的属**性（主要是变量的**类型**），而变量定义除此以外还将**引起存储器的分配**。

如果将下列语句放在所有函数的外部： 

```c
   int sp; 
   double val[MAXVAL]; 
```

那么这两条语句将[**定义**]**外部变量**`sp`与`val`，并为之分配**存储单元**，同时这两条语句还可以作为该源文件中其余部分的**声明**。而下面的两行语句： 

```c
   extern int sp; 
   extern double val[]; 
```

为源文件的其余部分**声明**了一个int 类型的外部变量sp 以及一个double 数组类型的外部变量val（该数组的长度在其它地方确定），但这两个声明并没有建立变量或为它们分配存储单元。


在一个源程序的所有源文件中，一个外部变量只能在某个文件中定义一次，而其它文件 可以通过 extern 声明来访问它（定义外部变量的源文件中也可以包含对该外部变量的extern 声明）。

外部变量的**定义**中必须指定数组的长度，但**extern 声明**则不一定要指定数组的长度。


外部变量的初始化只能出现在其定义中。

## 源代码头文件的组织

- 人们通常把**变量和函数的`extern`声明放在一个单独的文件中（习惯上称之为头文件）**，并在每个源文件的开头使用`#include`语句把**所要用的头文件包含进来**。后缀名`.h`约定为**头文件名的扩展名**。
- 例如，标准库中的函数就是在类似于`<stdio.h>`的头文件中声明的。

### 程序放在单个源文件中的作用域示例

```c
#include <stdio.h>
int out = 1;

int main() /* count digits, white space, others */
{
    int value;
    extern int out;//该语句前面有定义out变量，因此不需要用extern显式声明外部变量(这个语句省略掉,而不是省略extern这个关键字
    // 否则意思就是声明一个内部变量(自动变量),这不是我们要引用外部变量out的做法

    extern int out2;//该语句所在函数之前没有定义out2变量,因此需要用extern显式声明外部变量
    printf("%d\n", out);
    printf("%d\n", out2);
}
/* 通常将外部变量集中放到头部,可以省略extern关键字,如此一来,此规范下,使用extern的情况就变成是引用其他源文件中定义的变量了 */
int out2 = 2;
```

## 组织多源代码文件

考虑把一个计算器程序分割到若干个源文件中的情况。如果该程序的各组成部分很长，这么做还是有必要的。

分割：

1. 将主函数main单独放在文件main.c中；
2. 将push与pop函数以及它们使用的外部变量放在第二个文件stack.c中；
3. 将getop函数放在第三个文件getop.c中；
4. 将getch与ungetch函数放在第四个文件getch.c中.

之所以分割成多个文件，主要是考虑在实际的程序中，它们分别来自于单独编译的库.

此外，还必须考虑定义和声明在这些文件之间的**共享**问题.我们**尽可能把共享(分享)的部分集中在一起**，这样就只需要一个副本，改进程序时也容易保证程序的正确性.我们把这些**公共部分放在头文件`calc.h`**中，在需要使用该头文件时通过`#include`指令将它包含进来

### `calc.h`
```c
#define NUMBER '0'
void push(double);
double pop(void);
int getop(char []);
int getch(void);
void ungetch(int);
```
这个头文件定义了常量 `NUMBER`，并声明了一些函数接口，这些函数在不同的实现文件中定义。`push` 和 `pop` 是栈操作函数，`getop` 用于获取操作符或操作数，`getch` 和 `ungetch` 用于字符缓冲操作。

### `main.c`
```c
#include <stdio.h>
#include <stdlib.h>
#include "calc.h" #包含自定义的头文件calc.h
#define MAXOP 100

int main() {
    ...
}
```
`main.c` 是主程序文件，包含程序的入口函数 `main`。它包括标准输入输出库 `stdio.h` 和标准库 `stdlib.h`，以及 `calc.h` 头文件。`MAXOP` 用于定义操作符或操作数的最大长度。

### `getop.c`
```c
#include <stdio.h>
#include <ctype.h>
#include "calc.h"

int getop(char s[]) {
    ...
}
```
`getop.c` 实现了 `getop` 函数，用于从输入中提取下一个操作符或操作数。

为了快捷和完整实现相关函数(`gettop`),`gettop.c`包括标准输入输出库 `stdio.h` 和字符类型库 `ctype.h`，以及头文件 `calc.h`。

### `stack.c`
```c
#include <stdio.h>
#include "calc.h"
#define MAXVAL 100

int sp = 0;
double val[MAXVAL];

void push(double f) {
    ...
}

double pop(void) {
    ...
}
```
`stack.c` 实现了栈操作函数 `push` 和 `pop`。它包括标准输入输出库 `stdio.h` 和 `calc.h` 头文件，定义了 `MAXVAL` 作为栈的最大大小。变量 `sp` 是栈指针，`val` 数组存储栈中的值。

### `getch.c`
```c
#include <stdio.h>
#define BUFSIZE 100

char buf[BUFSIZE];
int bufp = 0;

int getch(void) {
    ...
}

void ungetch(int c) {
    ...
}
```
`getch.c` 实现了字符缓冲操作的 `getch` 和 `ungetch` 函数。`BUFSIZE` 定义了缓冲区大小，`buf` 是缓冲区数组，`bufp` 是缓冲区指针。

### 小结

通过这种文件分割方式，程序的不同功能模块被清晰地分离到不同的文件中，便于维护和扩展。

我们对下面两个因素进行了折衷：

1. 一方面是我们期望每个文件只能访问它完成任务所需的信息(代表着多拆分代码到不同文件)；
2. 另一方面是现实中维护较多的头文件比较困难(代表着将更多代码放到同一个文件中)

对于某些中等规模的程序，最好只用一个头文件存放程序中各部分共享/分享出来的对象。较大的程序需要使用更多的头文件，我们需要精心地组织它们。

## 简单案例和可运行的试验代码

使用extern,允许你在不使用`#include`的情况下使用其他文件中定义的对象

注意,在编译的时候,需要连同<u>main文件</u>(即,定义main())的源文件)以及<u>定义了被引用对象的源文件</u>一起告诉`gcc`

- `gcc m.c b.c multiply.c -o mbm`

  - 本试验指定了主程序源文件`m.c`
    - 主程序中,通过`#include`将头文件`cxxu.h`导入
    
  - 两个提供函数和外部变量的源文件`b.c`&`multiply.c`

    
  

### cxxu.h

该头文件中包含了一些调试宏



 ```c
// 数值调试宏
#ifndef CXXU
#define CXXU 1

#define dprint(expr) printf(#expr " = %d\n", expr)
#define gprint(expr) printf(#expr " = %g\n", expr)
#define fprint(expr) printf(#expr " = %f\n", expr)
#define sprint(expr) printf(#expr " = %s\n", expr)

#endif
 ```

### multiply.c

实现了一个简单函数:对两个整数做乘法的`multiply`函数

 ```c
#ifndef MULTIPLY
#define MULTIPLY
#include <stdio.h>
int multiply(int a, int b)
{
 return a * b;
}
#endif
 ```

### b.c

定义了一些用于试验的变量以及一个打印功能的函数`func`

```c
#include <stdio.h>
const int num = 5;
const char *str_multiplier="multiplier";
void func()
{
	printf("fun in a.c\n");
}
```



### m.c

定义程序入口(main()函数)

 ```c
#include <stdio.h>
#include "cxxu.h"
int main()
 {
 //这里将extern声明写在了m.c文件中,当然,也可以将他们放到导入的头文件中(编译语句命令行不变)
     extern void func();
     extern int multiply(int a, int b);
     extern char *str_multiplier;
     // 调用func()打印出实际定义函数体的源文件(b.c 文件中)
     func();
     // multiply()定义在multiply.c文件中.
     int product = multiply(1, 5);
       // 打印调用结果(乘积)
     dprint(product);
     // 打印外部字符串
    sprint(str_multiplier);
     return 0;
}
 ```

### 运行程序结果

- 编译命令行

  ```bash
  gcc m.c b.c multiply.c -o mbm
  ```

  注意到编译命令行使用`gcc`作为编译器,并且源文件列表为`m.c b.c multiply.c`(没有包含头文件`cxxu.h`,本例中头文件和其他源文件放在同一个目录中,而`main.c`中通过`#include "calc.c"`来将头文件包含进来,因此不用将头文件添加到此列表中),最后`-o mbm`表示编译结果为`mbm`文件,是个可执行二进制程序文件

- ```bash
  ┌─[cxxu@cxxuAli] - [~/cppCodes] - [2022-04-23 09:12:22]
  └─[0] <git:(master dc0fc40✗✱✈) > gcc m.c b.c multiply.c -o mbm
  ┌─[cxxu@cxxuAli] - [~/cppCodes] - [2022-04-23 09:17:37]
  └─[0] <git:(master dc0fc40✗✱✈) > ./mbm                        
  fun in a.c
  product = 5
  str_multiplier = multiplier
  ```




##  组织C语言的源文件结构/头文件内容组织
以下简单提一下基本的组织原则,具体的可以参考tlpi(The Linux Programming Interface)源代码中的组织方式

- 下载地址:[Source code for "The Linux Programming Interface" (man7.org)](https://www.man7.org/tlpi/code/)
	- 或者到github/gitee搜索源代码 	

- `头文件.h`只在其中编写最公用的内容(`#include`,`#define`,`extern 函数原型的声明`)(而不要在头文件中编写函数的实现,函数(函数系列)的实现应当创建相应的`.c`文件作为库(lib文件),(使用这些库文件(中的函数)的方式不一)
- 编写头文件的时候,建议用预编译处理来包裹全部的头文件内容,防止重复`#include`

### 示例
#### get_num.h
```c
/*************************************************************************\
*                  Copyright (C) Michael Kerrisk, 2022.                   *
*                                                                         *
* This program is free software. You may use, modify, and redistribute it *
* under the terms of the GNU Lesser General Public License as published   *
* by the Free Software Foundation, either version 3 or (at your option)   *
* any later version. This program is distributed without any warranty.    *
* See the files COPYING.lgpl-v3 and COPYING.gpl-v3 for details.           *
\*************************************************************************/

/* Listing 3-5 */

/* get_num.h

   Header file for get_num.c.
*/
#ifndef GET_NUM_H
#define GET_NUM_H

#define GN_NONNEG       01      /* Value must be >= 0 */
#define GN_GT_0         02      /* Value must be > 0 */

                                /* By default, integers are decimal */
#define GN_ANY_BASE   0100      /* Can use any base - like strtol(3) */
#define GN_BASE_8     0200      /* Value is expressed in octal */
#define GN_BASE_16    0400      /* Value is expressed in hexadecimal */

long getLong(const char *arg, int flags, const char *name);

int getInt(const char *arg, int flags, const char *name);

#endif

```
####  get_num.c
```c
/*************************************************************************\
*                  Copyright (C) Michael Kerrisk, 2022.                   *
*                                                                         *
* This program is free software. You may use, modify, and redistribute it *
* under the terms of the GNU Lesser General Public License as published   *
* by the Free Software Foundation, either version 3 or (at your option)   *
* any later version. This program is distributed without any warranty.    *
* See the files COPYING.lgpl-v3 and COPYING.gpl-v3 for details.           *
\*************************************************************************/

/* Listing 3-6 */

/* get_num.c

   Functions to process numeric command-line arguments.
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <errno.h>
#include "get_num.h"

/* Print a diagnostic message that contains a function name ('fname'),
   the value of a command-line argument ('arg'), the name of that
   command-line argument ('name'), and a diagnostic error message ('msg'). */
static void
gnFail(const char *fname, const char *msg, const char *arg, const char *name)
{
    fprintf(stderr, "%s error", fname);
    if (name != NULL)
        fprintf(stderr, " (in %s)", name);
    fprintf(stderr, ": %s\n", msg);
    if (arg != NULL && *arg != '\0')a
        fprintf(stderr, "        offending text: %s\n", arg);

    exit(EXIT_FAILURE);
}

/* Convert a numeric command-line argument ('arg') into a long integer,
   returned as the function result. 'flags' is a bit mask of flags controlling
   how the conversion is done and what diagnostic checks are performed on the
   numeric result; see get_num.h for details.

   'fname' is the name of our caller, and 'name' is the name associated with
   the command-line argument 'arg'. 'fname' and 'name' are used to print a
   diagnostic message in case an error is detected when processing 'arg'. */

static long
getNum(const char *fname, const char *arg, int flags, const char *name)
{
    long res;
    char *endptr;
    int base;

    if (arg == NULL || *arg == '\0')
        gnFail(fname, "null or empty string", arg, name);

    base = (flags & GN_ANY_BASE) ? 0 : (flags & GN_BASE_8) ? 8
                                   : (flags & GN_BASE_16)  ? 16
                                                           : 10;

    errno = 0;
    res = strtol(arg, &endptr, base);
    if (errno != 0)
        gnFail(fname, "strtol() failed", arg, name);

    if (*endptr != '\0')
        gnFail(fname, "nonnumeric characters", arg, name);

    if ((flags & GN_NONNEG) && res < 0)
        gnFail(fname, "negative value not allowed", arg, name);

    if ((flags & GN_GT_0) && res <= 0)
        gnFail(fname, "value must be > 0", arg, name);

    return res;
}

/* Convert a numeric command-line argument string to a long integer. See the
   comments for getNum() for a description of the arguments to this function. */

long getLong(const char *arg, int flags, const char *name)
{
    return getNum("getLong", arg, flags, name);
}

/* Convert a numeric command-line argument string to an integer. See the
   comments for getNum() for a description of the arguments to this function. */

int getInt(const char *arg, int flags, const char *name)
{
    long res;

    res = getNum("getInt", arg, flags, name);

    if (res > INT_MAX || res < INT_MIN)
        gnFail("getInt", "integer out of range", arg, name);

    return res;
}

```

