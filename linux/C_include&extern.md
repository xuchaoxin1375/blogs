@[toc]
# C_引用外部其他源文件中的对象的方法include & extern/extern的主要作用

## 概要

- #include将被include的文件导入到使用#include的文件中
  - 尽管如此,如果使用了预编译处理(preprocessor),引入的全部内容可能只有一部分会被编译(如果在本次编译中的多个c源文件中有超过一个源文件include过相同的头文件)
- extern:extern对于源文件中定义的对象的做作用域和static恰好相反

## 试验代码

> 使用extern,允许你在不通过include的情况下使用其他文件中定义的对象

- 注意,在编译的时候,需要连同<u>main文件</u>(即,定义main())的源文件)以及<u>定义了被引用对象的源文件</u>一起告诉`gcc`

  - `gcc m.c b.c multiply.c -o mbm`

    - 本试验指定了主程序源文件`m.c`
      - 主程序中,通过`#include`将头文件`cxxu.h`导入
      
    - 两个提供函数和外部变量的源文件`b.c`&`multiply.c`

      
    
    > - cxxu.h(该头文件中包含了一些调试宏)
    >
    >   - 
    >
    >   ```c
    >   // 数值调试宏
    >   #ifndef CXXU
    >   #define CXXU 1
    >   
    >   #define dprint(expr) printf(#expr " = %d\n", expr)
    >   #define gprint(expr) printf(#expr " = %g\n", expr)
    >   #define fprint(expr) printf(#expr " = %f\n", expr)
    >   #define sprint(expr) printf(#expr " = %s\n", expr)
    >   
    >   #endif
    >   ```
    >
    > - multiply.c
    >
    >   - ```c
    >     #ifndef MULTIPLY
    >     #define MULTIPLY
    >     #include <stdio.h>
    >     int multiply(int a, int b)
    >     {
    >         return a * b;
    >     }
    >     #endif
    >     ```
    >
    > - b.c
    >
    >   - ```c
    >     #include <stdio.h>
    >     const int num = 5;
    >     const char *str_multiplier="multiplier";
    >     void func()
    >     {
    >         printf("fun in a.c\n");
    >     }
    >
    > 
    >
    > - m.c(定义程序入口(main()函数))
    >
    >   - ```c
    >     #include <stdio.h>
    >     #include "cxxu.h"
    >     int main()
    >     {
    >     //这里将extern声明写在了m.c文件中,当然,也可以将他们放到导入的头文件中(编译语句命令行不变)
    >         extern void func();
    >         extern int multiply(int a, int b);
    >         extern char *str_multiplier;
    >         // 调用func()打印出实际定义函数体的源文件(b.c 文件中)
    >         func();
    >         // multiply()定义在multiply.c文件中.
    >         int product = multiply(1, 5);
    >         // 打印调用结果(乘积)
    >         dprint(product);
    >         // 打印外部字符串
    >         sprint(str_multiplier);
    >         return 0;
    >     }
    >     ```

    - 运行程序

      - `./mbm`

    - 结果
    
      - ```bash
        ┌─[cxxu@cxxuAli] - [~/cppCodes] - [2022-04-23 09:12:22]
        └─[0] <git:(master dc0fc40✗✱✈) > gcc m.c b.c multiply.c -o mbm
        ┌─[cxxu@cxxuAli] - [~/cppCodes] - [2022-04-23 09:17:37]
        └─[0] <git:(master dc0fc40✗✱✈) > ./mbm                        
        fun in a.c
        product = 5
        str_multiplier = multiplier
        ```

    - 当然,一般将`extern `所声明的内容写在某个`头文件中`,可以保持main.c的整洁,以及提高方便复用
    
    - 使用extern,可以只把定义对象的文件中的**指定对象**(通过声明&名称)引入到本程序的编译,而不会访问过多的内容,导致异常(例如对象冲突),在大程序中尤为如此

- 如果既没有用`#include`将提供被引用对象的定义的源文件导入,又没有使用extern 在主程序中显示声明,那么即使在编译文件中提到所有文件,还是无法通过编译(找不到被引用的对象)