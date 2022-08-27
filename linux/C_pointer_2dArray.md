[toc]



# C_指针/指针数组/二维指针/函数指针

## references

- The C(K&R)

###  二维数组

> 在C 语言中，二维数组实际上是一种特殊的一维数组，它的每个元素也是一个一维数组。

- 如果将二维数组作为参数传递给函数，那么在函数的参数声明中必须指明数组的`列数`。


- 数组的行数没有太大关系，因为前面已经讲过，函数调用时传递的是一个`指针`，

- 它指向由行向量构成的一维数组，其中每个行向量是具有13个整型元素的一维数组。

If a two-dimensional array is to be passed to a function, the parameter declaration in the function must include the number of columns; 

the number of rows is irrelevant, since what is passed is, as before, a `pointer` to an array of rows, <u>where each row is an array of 13 ints.</u> 

In this particular case, it is a pointer to <u>objects that are arrays of 13 ints.</u>

其中`每个对象是由13个整型元素`构成的`一维数组`。

 Thus if the array daytab is to be passed to a function f, the declaration of f would be:  

因此，如果将数组daytab作为`参数`传递给函数f，那么`f的声明`应该写成下列形式：
`f(int daytab[2][13]) { ... }`
也可以写成
`f(int daytab[][13]) { ... }`
因为数组的`行数无关紧要`，所以，该声明还可以写成
`f(int (*daytab)[13]) { ... }`
这种声明形式表明参数是一个指针，它指向数组(这些数组是具有13 个整型元素的一维数组)。

> - 因为方括号[]的优先级高于*的优先级，所以上述声明中必须使用圆括号。
> - 如果去掉括号，则声明变成int *daytab[13]
> - 这相当于声明了一个数组，该数组有13个元素，其中每个元素都是一个指向整型对象的指针。
> - 一般来说，除数组的第一维（下标）可以不指定大小外，其余各维都必须明确指定大小。

## code0:调试宏(prints.h)

```c
// 数值调试宏
#ifndef CXXU
#define CXXU 1

#define dprint(expr) printf(#expr " = %d @%%d\n", expr)
#define ldprint(expr) printf(#expr " = %ld @%%ld\n", expr)
#define gprint(expr) printf(#expr " = %g\n", expr)
#define fprint(expr) printf(#expr " = %f\n", expr)
#define cprint(expr) printf(#expr " = %c @%%c\n", expr)
#define sprint(expr) printf(#expr " = %s @%%s\n", expr)
// #define sprint(expr) printf("\t@sprint"#expr " = %s\n", expr)

// #define sprint(expr) printf(expr)
#define sprintln(expr) printf(expr "\n")
// 直接传递变量给pprint(取地址操作包含在了宏中)
#define pprint(expr) printf("&" #expr " \t= %p &%%p\n", &expr)
#define pprinta(expr) printf(#expr " \t= %p %%p (pointer var:" #expr ")\n", expr)
// extern void func();
// extern int multiply(int a, int b);
// extern char *str_multiplier;

#endif
```



## code1:二维数组(common_fun.c)

```c
#include "prints.h"
/* 返回值为0/1,可以作为数组下标 */
int is_leap(int year)
{
    int leap;
    return leap = year % 4 == 0 && year % 100 != 0 || year % 400 == 0;
}
/* 年月日和天的转化 */
static char daytab[2][13] = {
    {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31},
    {0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}};

/*
指针数组的一个重要优点在于，数组的每一行长度可以不同，也就是说，b的每个元素不
必都指向一个具有20 个元素的向量，某些元素可以指向具有2 个元素的向量，某些元素可以
指向具有50 个元素的向量，而某些元素可以不指向任何向量。
  */
int day_of_year(int year, int month, int day)
{
    // 直接以day为底子(天数)开始累加
    int i, leap;
    leap = is_leap(year);
    int dday = 0, pdday = 0;
    dday += day;
    pdday += day;
    // pdaytab是一个数组,数组中存放的元素的类型指针(指向char型对象的指针)
    char(*pdaytab)[13] = daytab;
    pprinta(daytab);
    pprinta(pdaytab);

    pprinta(pdaytab + 1);
    pprinta(daytab + 1);
    pprinta(*(pdaytab + 1));
    /* 混用[]和*的时候要小心优先级的问题,即[]的优先级要高于*;这意味着,某些清空下如果不加括号,会导致出乎意料的结果! */
    dprint(*(pdaytab + 1)[2]);
    // 下面才是我们想要的
    dprint((*(pdaytab + 1))[2]); //第二个数组的第2个元素(char)
    dprint((*(pdaytab) + 1)[2]);
    // 只使用*寻址
    dprint(*(*(pdaytab + 1) + 2));
    // 结果一致
    for (i = 1; i < month; i++)
    {
        day += daytab[leap][i];
        /* 从指针的角度来理解二维数组:

         char daytab[leap][day],即daytab通过两次间接寻址,可以得到一个char型值
         daytab[leap]
         对比char a[i]中的a,即(a是char *,则daytab[leap]也是char *类型)
         但是daytab的类型(char **)
          */
        // 调试
        // day+=*(daytab[leap] + i);
        // day += *(*(daytab + leap) + i);
        dday += *(*(daytab + leap) + i);
        pdday += *(*(pdaytab + leap) + i);
        // pdday += *(*pdaytab);

        // dprint(day);
        // dprint(dday);
        // dprint(pdday);
    }
    dprint(dday);
    dprint(pdday);
    dprint(day);
    return day;
    // return dday;
}
/* month_day:  set month, day from day of year */
void month_day(int year, int yearday, int *pmonth, int *pday)
{
    int i, leap;

    // leap = year % 4 == 0 && year % 100 != 0 || year % 400 == 0;
    leap = is_leap(year);
    for (i = 1; yearday > daytab[leap][i]; i++)
        yearday -= daytab[leap][i];
    *pmonth = i;
    *pday = yearday;
}

void traversepp(char **v, int size)
{

    // int size = sizeof(v) / sizeof(v[0]);
    for (int i = 0; i < size; i++)
    {
        sprint(*(v + i));
    }
}
void traversepa(char *v[], int size)
{

    // int size = sizeof(v) / sizeof(v[0]);
    for (int i = 0; i < size; i++)
    {
        sprint(*(v + i));
    }
}
void pswap(char **v, int i, int j)
{
    char *temp;
    temp = v[i];
    v[i] = v[j];
    v[j] = temp;
}
void swap(char *v[], int i, int j)
{
    char *temp;
    temp = v[i];
    v[i] = v[j];
    v[j] = temp;
}


```



###  指针的类型以及类型的影响 
- 总之,指针是有类型的,而且大多情况下,严格区分类型(通过指针指向的对象的类型区分指针的类型.)
- 譬如,我们对指针执行加法(加上一个整数),其效果就依赖于指针所指元素的类型(或者说,定义指针时所声明的指针指向的类型

  - 在计算`p+n` 时，n 将根据p 指向的对象的长度`按比例缩放`，而p 指向的`对象的长度`则取决于`p的声明`。
- 例如，如果int类型占4 个字节的存储空间，那么在`int`类型的计算中，对应的n将按4 的倍数来计算。)

### 二维数组的行地址和列地址的比较

![img](https://img-blog.csdnimg.cn/20200408210621578.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

#### code1.1 验证代码

```c
#include <stdio.h>
#include "prints.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include "common_fun.c"
void main()
{
    static char a[2][13] = {
        {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31},
        {0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}};
    int i = 0, j = 0;
    pprinta(a + i);
    pprinta(&a[i]);
    pprinta(a[i]);
    pprinta(*(a + i));
    pprinta(&a[i][0]);
}

/*
运行结果.(全部相等)
不同于指针数组,二维数组的不同行(一维数组)是连续的内存上分部,所以行内首元素的地址会和改行的入口地址一致(二级地址和一级地址一致)
# cxxu @ cxxuAli in ~/cppCodes on git:master x [17:53:51]
$ ./m
a + i   = 0x560cf489a030 %p (pointer var:a + i)
&a[i]   = 0x560cf489a030 %p (pointer var:&a[i])
a[i]    = 0x560cf489a030 %p (pointer var:a[i])
*(a + i)        = 0x560cf489a030 %p (pointer var:*(a + i))
&a[i][0]        = 0x560cf489a030 %p (pointer var:&a[i][0])
 */
```



###  二维数组与指针数组之间的区别

- 假如有下面两个定义：
`int a[10][20];`
`int *b[10];`
那么，从语法角度讲，`a[3][4]`和`b[3][4]`都是对一个int 对象的合法引用。
- 但a 是一个真正的二维数组，它分配了200 个int 类型长度的存储空间，并且通过常规的矩阵下标计算
公式`20×row+col`（其中，row 表示行，col 表示列）计算得到元素`a[row][col]`的位置。
但是，对b来说，该定义仅仅分配了10 个指针，并且没有对它们初始化，它们的初始化必须以显式
的方式进行，比如静态初始化或通过代码初始化。
假定b的每个元素都指向一个具有20 个元素的数组，
那么编译器就要为它分配200 个int类型长度的存储空间以及10 个指针的存储空间。

###   指针数组的优点

> 指针数组的一个重要优点在于，数组的每一行长度可以不同，也就是说，b的每个元素不
> 必都指向一个具有20 个元素的向量，某些元素可以指向具有2 个元素的向量，某些元素可以
> 指向具有50 个元素的向量，而某些元素可以不指向任何向量。

##  code2:指针/指针数组的代码(test_pointer.c)

```c
#include <stdio.h>
#include "prints.h"
#include <math.h>
#include <time.h>
#include "common_fun.c"

int strlen_p(char *s)
{
    int n;

    for (n = 0; *s != '\0'; s++)
    {
        n++;
    }
    return n;
}
/* 利用指针运算实现字符串拷贝函数(仅需一行)
strcpy:  copy t to s; pointer version 3 */
void strcpy_p(char *s, char *t)
{
    while (*s++ = *t++)
        ;
}
int main(int argc, char const *argv[])
{
    /* code */
    int a = 10;
    dprint(a);
    dprint(*(&a));
    dprint(*&a);
    // 一维数组和一维指针
    int arr[] = {1, 2, 3, 4};
    int *p2 = arr + 2; //*offset=3      //此时p2前面还有两个本数组的元素

    char *lineptr[] = {"abcde", "fghi", "jklm", "nopq"};
    char **pl = lineptr;
    pprinta(pl);
    pprinta(lineptr);
    int i = 0, j = 0;
    i = 2, j = 2;
    dprint(i);
    dprint(j);
    cprint(*(*(lineptr + i) + j));
    cprint(*(lineptr[i] + j));
    /* 比较两个一级地址(字符数组文本行首字符地址)和代表该文本行的文本行地址 */
    pprinta(lineptr[i]);
    pprinta(&lineptr[i][0]);
    /*
    lineptr + i     = 0x7ffcfc0d55f0 %p (pointer var:lineptr + i)
    lineptr[i]      = 0x561c584deb00 %p (pointer var:lineptr[i])
    */
    /* 比较行地址和行首字符地址 */
    sprintln("比较行地址和行首字符地址");
    sprintln("查看第i行地址(入口地址)");
    pprinta(lineptr + i);
    sprintln("查看列地址:(第i行的首元素字符的地址)");
    pprinta(lineptr[i]);
    sprintln("我们也可以通过&运算符来求行首(字符)地址的入口地址值),同时也许数组元素(指针变量)的地址.");
    pprinta(&(lineptr[i]));
    sprintln("尝试从一个strange viewport to check it:");
    // [ˌdezɪg'neɪtə]
    /* expression must be an lvalue or a function designator */
    // pprinta(&(lineptr[i] + j)); // lvalue required as unary(一元的/单目运算符) ‘&’ operand
    /* 检测地址 */
    pprinta(p2);
    pprinta(arr);
    /* 下面两个操作效果一样(一级寻址,访问地址p2处的元素) */
    dprint(p2[-1]); //我们可以通过-1来访问前面一个元素(这会成功,因为还未越界(而p2[-3]则会越界))
    dprint(*(p2 - 1));
    // pprint(p2 - arr);//指针值之间做差(地址值做差),为long int
    ldprint(p2 - arr); //或者在指针间隔不太大时 dprint((int)(p2 - arr));
    pprint(arr[0]);
    pprinta(arr);
    // dprint(NULL);//NULL = 0 @%d
    dprint((a = arr[2]));
    dprint((a = 5));
    sprintln("check the char type pointer array:");
    /*     for (int i = 0; i < 4; i++)
        {
            sprint(*(lineptr + i));
        } */
    int size = 4;
    traversepp(lineptr, size);
    traversepa(lineptr, size);
    return 0;
}



```

###  函数指针 
- 函数本身不是变量，但可以定义指向函数的指针。这种类型的指针可以被赋值、存放在数组中、传递给函数以及作为函数的返回值等等

  - `int (*comp)(void *, void *)`
  - 它表明comp是一个指向函数的指针，该函数具有两个void *类型的参数，其返回值类型为int。

根据优先级来看声明,标识符`comp`被定义为一个指针,其指向一个函数(接受参数void*,void*),而且这个函数的返回值类型是`int`型值

`comp`的使用和其声明是一致的，`comp`是一个指向函数的指针，`*comp`代表一个函数。
下列语句是对该函数进行调用：
`(*comp)(v[i], v[left])`
其中的圆括号是必须的，这样才能够保证其中的各个部分正确结合。
如果没有括号，例如写
成下面的形式：
则表明comp 是一个函数，该函数`返回一个指向int 类型的指针`，这同我们的本意显然有很大的差别。(圆括号和方括号的优先级相当>*的优先级)
`// int *comp(void *, void *) // WRONG`


看下面所示的两个声明：
```c
// int *f();       //  f: function returning pointer to int 
// int (*pf)(); /  pf: pointer to function returning int 

```
复杂声明的分析,可能需要一些编译原理文法分析/语法分析等知识

它们之间的含义差别说明： *是一个前缀运算符，其优先级低于() ，所以，声明中必须使用圆括号以保正确的结合顺序

对数组元素`a[i]`的引用也可以写成`*(a+i)`这种形式。

> 下标和指针运算之间具有密切的对应关系。
>

- 根据定义，数组类型的变量或表达式的值是该数组第0个元素的地址。
- 在计算数组元素`a[i]`的值时，C 语言实际上先将其转换为`*(a+i)`的形式，然后再进行求值，因此在程序中这两种形式是等价的
- `&a[i]`和`a+i` 的含义也是相同的
- 相应地，如果pa是个指针，那么，在表达式中也可以在它的后面加下标。
- `pa[i]`与`*(pa+i)`是等价的。

> 简而言之，一个通过数组和下标实现的表达式可等价地通过指针和偏移量实现。 

### 数组名和指针的区别

我们必须记住，数组名和指针之间有一个不同之处:

- `指针是一个变量`，因此，在C语言中，语句`pa=a`和`pa++`都是合法的。

- 但`数组名`不是变量，因此，类似于`a=pa`和`a++`形式的语句是非法的。

当把数组名传递给一个函数时，实际上传递的是该数组第一个元索的地址。
在被调用函数中，该参数是一个局部变量，因此，数组名参数必须是一个指针，也就是一个存储地址值的变量。

我们可以利用该特性编写strlen 函数的另一个版本，该函数用于计算一个字符串的长度。  

在函数定义中，形式参数
`char s[];`
和
`char *s;`
是等价的。我们通常更习惯于使用后一种形式，因为它比前者更直观地表明了该参数是一个
指针。如果将数组名传递给函数，函数可以根据情况判定是按照数组处理还是按照指针处理，
随后根据相应的方式操作该参数。为了直观且恰当地描述函数，在函数中甚至可以同时使用
数组和指针这两种表示方法。
也可以将指向子数组起始位置的指针传递给函数，这样，就将数组的一部分传递给了函
数。例如，如果a是一个数组，那么下面两个函数调用
`f(&a[2])`
与
`f(a+2)`
都将把起始于`a[2]`的子数组的地址传递给函数f。在函数f中，参数的声明形式可以为
如果确信相应的元素存在，也可以通过下标访问数组第一个元素之前的元素。

类似于`p[-1]`、`p[-2]`这样的表达式在语法上都是合法的，它们分别引用位于`p[0]`之前的两个元素。
当然，引用数组边界之外的对象是非法的。

`C 语言`中的地址算术运算方法是一致且有规律的，将指针、数组和地址的算术运算集成在
一起是该语言的一大优点
减少类型维护工作量(k&R alloc 示例)

* 指针的算术运算具有一致性：如果处理的数据类型是比字符型占据更多存储空间的浮点
类型，并且p 是一个指向浮点类型的指针，那么在执行p++后，p 将指向下一个浮点数的地
址。因此，只需要将alloc和afree函数中所有的char类型替换为float类型，就可以
得到一个适用于浮点类型而非字符型的内存分配函数。所有的指针运算都会自动考虑它所指
向的对象的长度。 

###  有效的指针运算包括

- 相同类型指针之间的赋值运算；(直白)

- 指针同整数之间的加法或减法运算；(偏移)
- 指向相同数组中元素的两个指针间的减法或比较运算；(计算指针间隙,结果一般是`long int`)
- 将指针赋值为0 或指针与0 之间的比较运算。

> 其它所有形式的指针运算都是非法的，例如两个指针间的加法、乘法、除法、移位
> 或屏蔽运算；指针同`float`或`double`类型之间的加法运算；不经强制类型转换而直接将指
> 向一种类型对象的指针赋值给指向另一种类型对象的指针的运算（两个指针之一是`void *`
> 类型的情况除外）。 

###  指针与整数之间不能相互转换

- 指针与整数之间不能相互转换,但0 是惟一的例外：

常量0 可以赋值给指针，指针也可以和常量0 进行比较。
不过,程序中经常用符号常量NULL代替常量0，这样便于更清晰地说明常量0 是指针的一个特殊值。(而不是直接使用0)
`NULL`经常被定义为`(void*)0`
符号常量`NULL`定义在标准头文件`<stddef.h>`中。


###  指针算数运算 
> 指针算术运算有以下几个重要特点。首先，在某些情况下对指针可以进行比较运算。
例如，如果指针p 和q 指向同一个数组的成员，那么它们之间就可以进行类似
于==、!=、<、>=的关系比较运算
任何指针与0 进行相等或不等的比较运算都有意义。
但是，指向不同数组的元素的指针之间的算术或比较运算没有定义。
（这里有一个特例：指针的算术运算中 可使用 数组最后一个元素 的 下一个元素的地址。）

其次。我们从前面可以看到，指针可以和整数进行相加或相减运算。
例如，结构
`p + n`
表示指针`p` 当前指向的对象之后第n 个对象的地址。
无论指针`p` 指向的对象是何种类型，上述结论都成立。
在计算`p+n `时，n 将根据`p` 指向的对象的长度`按比例缩放`，而p 指向的`对象的长度`则取决于`p的声明`。

> 例如，如果int类型占4 个字节的存储空间，那么在int类型的计算中，对应的n将按4 的倍数来计算。
>

###   字符串和指针

字符串常量最常见的用法也许是作为函数参数，例如：

`princf("hello, world\n"};`
当类似于这样的一个字符串出现在程序中时，实际上是通过字符指针访问该字符串的。在上
述语句中，`printf`接受的是一个指向字符数组第一个字符的指针。
也就是说，字符串常量可通过一个指向其第一个元素(字符)的指针访问。
除了作为函数参数外，字符串常量还有其它用法。

假定指针`pmessage`的声明如下：
`char *pmessage;`
那么，语句
`pmessage ="now is the time";`
将把一个指向该字符数组的指针赋值给`pmessage`。
该过程并没有进行字符串的复制，而只是涉及到指针的操作。
C 语言没有提供将整个字符串作为一个整体进行处理的运算符。
下面两个定义之间有很大的差别：

```c
// char amessage[] = "nw is the time"; ###  定义一个数组 
//  char *pmessage = "now is the time"; ###  定义一个指针 

```
上述声明中，amessage 是一个仅仅足以存放初始化字符串以及空字符 '\0'的一维数组。
数组中的单个字符可以进行修改，但amessage始终指向同一个存储位置(可以理解为只读)。

另一方面，pmessage是一个指针，其初值指向一个字符串常量，之后它可以被修改以指向其它地址，
但如果试图修改字符串的内容，结果是没有定义的

###  指针数组分析 
`char *lineptr[MAXLINES];`
从表示符`lineptr`的含义(从结合[],(),*和标识符结合优先级,顺序来解释)

它表示:`lineptr` 是一个具有`MAXLINES` 个元素的一维数组，(关键是数组类型(数组中的元素类型是什么))
其中数组的每个元素是一个指向字符类型对象的`指针`。
即,形如`*lineptr[i]`(或者带上若干偏移的)的表达式的类型是一个char型值
改写为只含有*表达式:**(lineptr+i),该表达式的值也是一个char型值(第i个字符串的首字符)

此外,`*(lineptr[i]+j)`等同于`*(*(line+i)+j)`,从而可以精确的访问到多行字符数组中的某一个字符
也就是说，`lineptr[i]`的值是一个字符指针，而*lineptr[i]类型是一个字符类型(char),并且该指针指向的第i个文本行的首字符。
`*(*(lineptr+i)+j)`//同样的效果,也是进行了两次寻址(而且都是用*寻址),
不过,这里进行了行间偏移(i)以及列间偏移(j)
最终,会指向第i个文本行(字符串)的第j个字符(从0开始计数)
其中,`(lineptr+i)`做的是行地址(入口)定位(偏移),
`*(lineptr+i)`则是一个一级地址(定位到了第i字符串的第一个字符(的地址))

#### 使用定位(行/列指针)和寻址到变量保存的值的角度

下方的声明中表示,需要两次寻址(*或者[]都可以累计一次寻址),才可以得到字符类型(char类型)的值
`char *lineptr[] = {"abcde", "fghi", "jklm", "nopq"};`

事实上,就算是函数指针,也可以这样理解:`int (*pf)()`;该声明的右部(int后面的部分,`(*pf)()`的计算结果会是一个int类型)
当然,仅仅知道整体的表达式值的类型是不够的,我们还需要知道被声明标识符本身到底是什么(或者说,指向什么)

回到指针数组:
注意到,`*`和`[]`,两个操作符都可以作用在地址(或者指针变量)上;(而它们的反向操作&(取地址)只可以作用在左值上`lvalue`(譬如变量))
且使用`[]`寻址的时候,会做绑定在一起的两件事情(譬如表达式为`p[i]`),从p所指的地址偏移i个单位(譬如`int`,`char`,..),然后寻址:拿到偏移后的地址对应的变量值.(`[]`优先级高于`*`)
反观间接寻址运算符`*`,它仅仅只做寻址,而不要求你指定偏移量,
最初学习数组的时候,就可以理解为数组名(数组名是首地址,用`[i]`偏移并寻址,从而取得数组中第i个元素的值

#### 寻址

仍然以指针数组`char *lineptr[] = {"abcde", "fghi", "jklm", "nopq"};`为例.
如果只寻址一次可以进入到某一行,进入行内地址(列地址)的后续操作(一次寻址后的地址就已经可以指向文本行中某个字符(是列地址),
一次寻址后,再可以配合偏移量,也只能够得到文本行内某个字符的地址(文本行可以是只有一个单词的文本行)的行地址
不带偏移的时候的行内地址是该行行首字符的地址)
二次寻址:定位好行内字符后,再次寻址(第二次寻址)可以拿到地址所指变量中的值(字符值)
(注意,C语言没有文本行(字符串)数据类型).

summary:
行内字符值的取得(精确定位)需要二次寻址(循着变量地址拿到它保存的值)
由上述可知,行地址(行入口,大门)和文本行首字符地址(行内第一个座位,一维数组名)还是不同

###  寻址运算符*和[]      
寻址运算符`*`和`[]`,他们有寻址的功能
在声明变量的时候遇到它们,其中的任意一方出现每出现一次,都表示被定义的变量标识符的指针(地址)级数加1

(譬如一维数组`int array[]`,`array`(数组名字)就是地址,在使用该数组的时候,以`array[n]`的形式出现,那么他这个表达式的类型就是int
如果以`array`的形式出现,那么他就是表示的就是地址(可以赋值给一个指针变量))

###  分析声明中的变量标识符自身的含义 
不从声明的式子的整体理解,而分析**标识符本身的含义**

- 靠谱的方式是,根据构成声明的符号的优先级(以及解析顺序)来判断声明的标识符到底是什么(指针/数组/..其他)
- C语言也有其对应的语法分析树`(PrinciplesOfCompiler)`相关知识

###  复杂声明标识符是如何使用的 
我们可以从整体的角度来理解复杂声明标识符是如何使用的

> (这里的讨论没有考虑优先级)

譬如,`char *lineptr[];`
可以对比的简单声明:`char a[];char *b;`

如果我们将`*lineptr`理解为整体并映射到上述简单声明a(简单将,就是把 `(*lineptr)`代入到`a`),那么就容易理解,对于`a`的表达式(指针运算/寻址等)得到的数据类型和`*lineptr`是一样的
(就本例而言,`a[i]`的数据类型是`char`,那么可以知道,`*lineptr[i]`运算得到的数据类型也是`char`.
而且,`(a+i)`表示第i个`char`型元素(对象)的地址,那么`(*lineptr + i)`同样也是char类型对象的地址

`*(a+i)`或`a[i]`的效果一样,值都是char类型的,
同样`*lineptr[i]`的值也是char型的

再对比简化到`char *b;`
`b`对应的是`lineptr[],(b+j)`对应`(lineptr[i]+j)`视为整体,
他们的类型都是指向char型变量的指针变量;
那么`*(b+j)`和`*(lineptr[i]+j)`就都对应的是char型变量
当然,因为后者是实际上是二维数组,所以做更多的偏移(定位)运算,譬如行偏移后再寻址:`lineptr[i]`或者等效的`*(lineptr+i)`
)



###  c语言函数返回多个参数?
可以通过参数来将多个值传递出去
这些参数必须是指针变量
当然也可以通过数组等形式组织起来多个变量

这种操作要求调用者在调用相关函数前就准备好对应的返回值容器变量. 