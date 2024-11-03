### 5.1 指针与地址

指针是C语言中一种特殊的变量，用于存储内存地址。通过指针，我们可以直接访问和修改内存中的数据。指针的使用非常广泛，因为它们能够提供对数据的直接访问，有助于提高程序的效率和灵活性。

在C语言中，指针的声明格式如下：
```c
type *pointer_name;
```
其中 `type` 是指针所指向的数据类型，`pointer_name` 是指针变量的名称。例如：
```c
int *ip; // ip 是一个指向 int 类型的指针
```

获取变量的地址可以使用地址运算符 `&`，例如：
```c
int x = 10;
int *ip = &x; // ip 现在指向 x
```

通过指针访问其所指向的变量可以使用解引用运算符 `*`，例如：
```c
int y = *ip; // y 现在等于 10
*ip = 20;    // x 现在等于 20
```

### 5.2 指针与函数参数

C语言中的函数参数传递采用传值方式，这意味着函数内部对参数的修改不会影响调用者中的原始变量。为了在函数内部修改调用者中的变量，可以传递指向这些变量的指针。

例如，交换两个整数的函数 `swap` 可以这样实现：
```c
void swap(int *px, int *py) {
    int temp = *px;
    *px = *py;
    *py = temp;
}

int a = 1, b = 2;
swap(&a, &b); // 交换 a 和 b 的值
```

### 5.3 指针与数组

指针和数组之间有着密切的关系。在C语言中，数组名可以被视为指向数组第一个元素的指针。例如：
```c
int arr[10];
int *p = arr; // p 指向 arr 的第一个元素
```

数组的元素可以通过指针访问，例如：
```c
int x = *p; // x 等于 arr[0]
p++;        // p 现在指向 arr[1]
int y = *p; // y 等于 arr[1]
```

### 5.4 地址算术运算

指针支持算术运算，例如加法和减法。指针的算术运算会根据指针所指向的数据类型自动调整。例如，对于 `int *p`，`p + 1` 实际上是 `p + sizeof(int)`。

例如：
```c
int arr[10];
int *p = arr;
p += 2; // p 现在指向 arr[2]
int x = *p; // x 等于 arr[2]
```

指针的减法运算也是有意义的，可以用于计算两个指针之间的距离。例如：
```c
int arr[10];
int *p1 = &arr[0];
int *p2 = &arr[5];
int distance = p2 - p1; // distance 等于 5
```

#### 有效的指针运算

有效运算

1. 相同类型指针之间的赋值运算；
2. 指针同整数之间的加法或减法运算；
3. 指向相同数组中元素的两个指针间的减法或比较运算；
4. 将指针赋值为0或指针与0之间的比较运算。

其它所有形式的指针运算都是非法的，例如

- 两个指针间的加法、乘法、除法、移位或屏蔽运算；
- 指针同float或double类型之间的加法运算；
- 不经强制类型转换而直接将指向一种类型对象的指针赋值给指向另一种类型对象的指针的运算（两个指针之一是void*类型的情况除外）

### 5.5 字符指针与函数

字符指针在处理字符串时非常有用。字符串在C语言中是以字符数组的形式存储的，以空字符 `\0` 结尾。字符指针可以用于遍历和操作字符串。

例如，计算字符串长度的函数 `strlen` 可以这样实现：
```c
size_t strlen(const char *s) {
    const char *p = s;
    while (*p != '\0') {
        p++;
    }
    return p - s;
}
```

### 5.6 指针数组以及指向指针的指针

指针数组是数组的元素为指针的数组。这种数据结构在处理多个字符串或动态分配的内存时非常有用。

例如，可以使用指针数组来存储多个字符串：
```c
char *lines[] = {"Hello", "World", "C Programming"};
```

指向指针的指针（即双重指针）可以用于更复杂的数据结构。例如，可以用于动态分配的二维数组：
```c
int **matrix;
int rows = 3, cols = 3;

matrix = (int **)malloc(rows * sizeof(int *));
for (int i = 0; i < rows; i++) {
    matrix[i] = (int *)malloc(cols * sizeof(int));
}
```

### 5.7 多维数组

多维数组在C语言中可以视为数组的数组。例如，二维数组可以声明为：
```c
int matrix[3][3];
```

访问多维数组的元素可以使用多重下标：
```c
int x = matrix[1][2]; // 访问第二行第三列的元素
```

### 5.8 指针数组的初始化

指针数组可以在声明时进行初始化，例如：
```c
char *lines[] = {"Hello", "World", "C Programming"};
```

静态指针数组也可以在声明时初始化为指向其他变量的指针：
```c
int x = 10, y = 20, z = 30;
int *ptrs[] = {&x, &y, &z};
```

通过这种方式，可以方便地管理多个变量的地址，从而在需要时直接访问这些变量。

### 5.9 指针与多维数组

对于C语言的初学者来说，很容易混淆二维数组与指针数组之间的区别。虽然两者在语法上都可以通过双下标访问元素，但它们的内存布局和使用方式有所不同。

#### 二维数组
二维数组在内存中是连续存储的，每个元素的地址可以通过公式计算得出。例如：
```c
int a[10][20];
```
这个数组分配了200个`int`类型长度的存储空间，可以通过公式 `20 * row + col` 计算元素 `a[row][col]` 的位置。

#### 指针数组
指针数组则是数组的元素为指针的数组。每个指针可以指向一个独立的数组或变量。例如：
```c
int *b[10];
```
这个定义仅分配了10个指针的存储空间，每个指针需要显式初始化。如果假设 `b` 的每个元素都指向一个具有20个元素的数组，那么编译器需要额外分配200个 `int` 类型长度的存储空间。

指针数组的一个重要优点在于，数组的每一行长度可以不同。例如：
```c
int arr1[2] = {1, 2};
int arr2[50] = {3, 4, 5, 6, 7, ...};
int *b[2] = {arr1, arr2};
```

### 5.10 命令行参数

在支持C语言的环境中，可以在程序开始执行时将命令行参数传递给程序。调用主函数 `main` 时，它带有两个参数：
- `argc`：表示命令行中参数的数量。
- `argv`：是一个指向字符串数组的指针，每个字符串对应一个参数。

例如，程序 `echo` 将命令行参数回显在屏幕上：
```c
#include <stdio.h>

int main(int argc, char *argv[]) {
    for (int i = 1; i < argc; i++) {
        printf("%s%s", argv[i], (i < argc - 1) ? " " : "");
    }
    printf("\n");
    return 0;
}
```

### 5.11 指向函数的指针

在C语言中，函数本身不是变量，但可以定义指向函数的指针。这种类型的指针可以被赋值、存放在数组中、传递给函数以及作为函数的返回值等。

例如，假设我们有一个排序函数，可以通过可选参数 `-n` 按数值大小排序：
```c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAXLINES 5000

char *lineptr[MAXLINES];

int readlines(char *lineptr[], int nlines);
void writelines(char *lineptr[], int nlines);
void qsort(void *v[], int left, int right, int (*comp)(void *, void *));
int numcmp(char *, char *);

int main(int argc, char *argv[]) {
    int nlines;
    int numeric = 0;

    if (argc > 1 && strcmp(argv[1], "-n") == 0) {
        numeric = 1;
    }

    if ((nlines = readlines(lineptr, MAXLINES)) >= 0) {
        qsort((void **)lineptr, 0, nlines - 1, (int (*)(void *, void *))(numeric ? numcmp : strcmp));
        writelines(lineptr, nlines);
        return 0;
    } else {
        printf("input too big to sort\n");
        return 1;
    }
}

int numcmp(char *s1, char *s2) {
    double v1, v2;
    v1 = atof(s1);
    v2 = atof(s2);
    if (v1 < v2) return -1;
    else if (v1 > v2) return 1;
    else return 0;
}
```

### 5.12 复杂声明

C语言的声明语法有时会显得复杂，特别是涉及函数指针时。C语言的声明语法力图使声明和使用相一致，但对于复杂的情况，容易让人混淆。

例如，以下两个声明有不同的含义：
```c
int *f(); // f: 返回指向 int 类型的指针的函数
int (*pf)(); // pf: 指向返回 int 类型的函数的指针
```

为了更好地理解和创建复杂的声明，可以使用 `typedef` 通过简单的步骤合成。例如：
```c
typedef int (*PF)(int, int); // PF 是一个指向返回 int 类型的函数的指针
```

另一种方法是使用解析工具将复杂的声明转换为文字描述。例如：
```c
char **argv; // argv: 指向 char 的指针
int (*daytab)[13]; // daytab: 指向 int 类型数组 [13] 的指针
int *daytab[13]; // daytab: int 类型指针的数组 [13]
void (*comp)(); // comp: 返回 void 类型的函数指针
```

通过这些方法，可以更清晰地理解和使用复杂的声明。