[toc]



## C 预处理器

C 语言提供了一些预处理器指令来扩展语言功能。预处理器在编译前单独执行，是编译过程的第一个步骤。常见的预处理器指令包括 `#include`（用于在编译时包含文件内容）和 `#define`（用于定义宏）。此外，预处理器还支持条件编译和带参数的宏，增强了代码的可扩展性。

## 文件包含指令

`#include` 指令用于引入文件内容，通常在程序开头用于包含常见的声明和宏定义，或包含库函数的头文件。

```c
#include "filename"   // 从当前路径查找文件
#include <filename>   // 从系统路径查找文件
```

1. 引号`""`和尖括号`<>`的区别：
   - 引号模式：在源文件目录查找文件，找不到时再根据编译器规则查找。
   - 尖括号模式：直接按系统路径规则查找。

2. 大型程序中的应用：
   - 使用 `#include` 统一包含声明，确保各源文件中定义和变量的一致性。
   - 一旦头文件发生更改，所有依赖该头文件的源文件都需重新编译。

### 宏替换

宏的定义格式如下：

```c
#define NAME replacement_text
```

1. **基本宏**：宏定义的标识符将被替换为宏内容。例如：

   ```c
   #define PI 3.14159
   ```

2. **多行宏**：长的宏可以使用 `\` 延续至下一行。

3. **带参数的宏**：
   - 带参数的宏类似于函数调用，实参替换宏内容中的形式参数。例如：

     ```c
     #define max(A, B) ((A) > (B) ? (A) : (B))
     ```

   - 调用 `max(x, y)` 将被替换为 `((x) > (y) ? (x) : (y))`。


### 注意事项：

- 宏展开可能会导致重复计算。如果表达式中有副作用（如自增），可能产生意外效果。例如，`max(i++, j++)` 会导致两次自增。

  - ```c
    #define max(A, B) ((A) > (B) ? (A) : (B))
    ```

    计算`max(i++,j++)`时,被展开为`((i++)>(j++)?(i++):(j++))`,发生了重复自增

    ```c
    #include <stdio.h>
    #define max(a, b) ((a) > (b) ? (a) : (b))
    
    extern int max_int(int a, int b);
    int main()
    {
        int a = 5;
        int b = 10;
        // max(a, b); //
        // max(a++, b++); // a = 6, b = 12
        max(++a, ++b); // a = 6, b = 12
        // max_int(a, b); // a = 5, b = 10
        printf("a = %d, b = %d\n", a, b);
    }
    int max_int(int a, int b)
    {
        // printf("a = %d, b = %d\n", a, b);
        return (a > b) ? a : b;
    }
    
    ```

    就不会有重复计算，
- 使用括号保证表达式顺序。

- 错误例子如下：

  ```c
  #define square(x) x * x  
  ```

  - 使用 `square(z + 1)` 会错误展开成 `z + 1 * z + 1`。正确形式为：


  ```c
  #define square(x) ((x) * (x))
  ```

  - 而不是` #define square(x) (x * x)`,这个形式只比第一种情况好点,但是squar(z+1)会被展开为`(z+1*z+1)`=`2z+1`,这显然不是我们要的


### 带参数宏和函数调用的区别

使用宏max 看起来很像是函数调用，但宏调用直接将替换文本插入到代码中。形式参数（在此为A或B）的每次出现都将被替换成对应的实际参数。因此，语句： 

```c
x = max(p+q, r+s); 
```

将被替换为下列形式： 

```c
x = ((p+q) > (r+s) ? (p+q) : (r+s)); 
```

如果对各种类型的参数的处理是一致的，则可以将**同一个宏定义应用于任何数据类型**，而无需针对不同的数据类型需要定义不同的max函数。

### 宏高级用法

`<stdio.h>` 头文件中有一个很实用的例子：`getchar` 与 `putchar` 函数在实际中常常被定义为宏，这样可以避免处理字符时调用函数所需的运行时开销。`<ctype.h>` 头文件中定义的函数也常常是通过宏实现的。

可以通过 `#undef` 指令取消名字的宏定义，这样做可以保证后续的调用是函数调用，而不是宏调用：

```c
#undef getchar
int getchar(void) { ... }
```

### `#`前缀的高级替换@调试打印宏

形式参数不能用带引号的字符串替换。但是，如果在**替换文本中**，**参数名**以 `#` 作为**前缀**则结果将被扩展为**由实际参数替换该参数的带引号的字符串**。

例如，可以将它与字符串连接运算结合起来编写一个**调试打印宏**：

```c
#define dprint(expr) printf(#expr " = %g\n", expr)
```

使用语句：

```c
dprint(x/y)
```

调用该宏时，该宏将被扩展为：(`#expr`被扩展为`"x/y"`,注意它带上了引号)

```c
printf("x/y" " = %g\n", x/y);
```

其中的字符串被连接起来了，这样，该宏调用的效果等价于：

```c
printf("x/y = %g\n", x/y);
```

在实际参数中，每个双引号 `"` 将被替换为 `\"`，反斜杠 `\` 将被替换为 `\\`，因此替换后的字符串是合法的字符串常量。

可以运行的例子

```c
#include <stdio.h>
#define dprint(expr) printf(#expr " = %g\n", expr)
int main()
{
    float x = 5.1, y = 1.2;
    dprint(x + y); // 打印结果为: x + y = 6.3
}
```

### `##`连接实际参数

预处理器运算符 `##` 为宏扩展提供了一种连接实际参数的手段。

通过 `##` 运算符，C 预处理器可以将两个标记拼接成一个新的标记，这种用法在需要动态生成变量名、函数名或结构体成员名等。

如果**替换文本中的参数**与 `##` 相邻，则该参数将**被实际参数替换**，`##` 与**前后的空白符**都将被删除，并对替换后的结果重新扫描。

例如，下面定义的宏 `paste` 用于连接两个参数：

```c
#define paste(front, back) front ## back
```

因此，宏调用 `paste(name, 1)` 的结果将建立记号 `name1`。

预处理器中的 `##` 运算符称为“标记连接”运算符，用于在宏定义中将两个标记（token）连接成一个新的标记。我们可以通过几个具体例子来了解它的实际用法。

### 例 1：拼接变量名

假设我们想创建多个变量名，像 `int_var1`、`int_var2`，每个变量名的后缀数字表示不同的实例。可以使用 `##` 运算符来生成这些变量名：

```c
#include <stdio.h>

#define CREATE_VAR(type, name, num) type name##num

int main() {
    CREATE_VAR(int, int_var, 1) = 10;  // 生成 int int_var1 = 10;
    CREATE_VAR(int, int_var, 2) = 20;  // 生成 int int_var2 = 20;

    printf("int_var1 = %d\n", int_var1);  // 输出 int_var1 的值
    printf("int_var2 = %d\n", int_var2);  // 输出 int_var2 的值

    return 0;
}
```

**解释**：
- `CREATE_VAR(int, int_var, 1)` 宏调用会展开成 `int int_var1`。
- `CREATE_VAR(int, int_var, 2)` 宏调用会展开成 `int int_var2`。

这样，通过 `##` 把 `int_var` 和 `1` 拼接成了新的变量名 `int_var1`，方便生成一系列类似的变量名。

### 例 2：拼接函数名

如果需要根据数据类型调用不同的函数，可以使用 `##` 运算符来生成函数名。例如，定义两个函数 `print_int` 和 `print_float`，分别打印整数和浮点数：

```c
#include <stdio.h>

void print_int(int value) {
    printf("Integer: %d\n", value);
}

void print_float(float value) {
    printf("Float: %f\n", value);
}

#define PRINT(type, value) print_##type(value)

int main() {
    PRINT(int, 42);     // 生成 print_int(42);
    PRINT(float, 3.14); // 生成 print_float(3.14);

    return 0;
}
```

**解释**：
- `PRINT(int, 42)` 会展开成 `print_int(42)`，调用 `print_int` 函数。
- `PRINT(float, 3.14)` 会展开成 `print_float(3.14)`，调用 `print_float` 函数。

通过 `##`，我们把 `print_` 和 `type` 拼接成不同类型对应的函数名，方便调用不同数据类型的处理函数。

### 例 3：生成结构体成员名

在某些情况下，我们可能想通过宏自动生成结构体的成员名：

```c
#include <stdio.h>

struct Data
{
    int d_int;
    float d_float;
};

#define GET_MEMBER(structure, member) structure.d_##member

int main()
{
    struct Data data1 = {42, 3.14};

    printf("Integer member: %d\n", GET_MEMBER(data1, int)); // 生成 data.data_int
    printf("Float member: %f\n", GET_MEMBER(data1, float)); // 生成 data.data_float

    return 0;
}
```

**解释**：
- `GET_MEMBER(data, int)` 会展开成 `data.data_int`，访问 `data` 结构体中的 `data_int` 成员。
- `GET_MEMBER(data, float)` 会展开成 `data.data_float`，访问 `data` 结构体中的 `data_float` 成员。

通过 `##`，我们把 `data_` 和 `member` 拼接成结构体成员名，简化了访问成员的过程。



## 条件包含

条件包含指令提供了选择性包含代码的手段，可以根据条件编译不同的代码。

1. **基本格式**：

   ```c
   #if expression
   // code
   #elif expression
   // code
   #else
   // code
   #endif
   ```

2. **防止重复包含**：使用条件包含可以防止头文件被重复包含。

   ```c
   #ifndef HDR
   #define HDR
   // 文件内容
   #endif
   ```

3. **选择性包含文件**：根据系统变量选择包含不同版本的头文件。

   ```c
   #if SYSTEM == SYSV
       #define HDR "sysv.h"
   #elif SYSTEM == BSD
       #define HDR "bsd.h"
   #else
       #define HDR "default.h"
   #endif
   #include HDR
   ```

## 