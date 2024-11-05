[toc]

## abstract

在C语言中，指针变量的存储空间大小是固定的，与其指向的数据类型（如`int`、`float`、`double`等）无关。指针变量的大小取决于系统的**地址长度（address length）**，即系统的**位宽**。以下是分析指针变量存储空间大小的主要因素：

### 1. 系统位宽决定了指针大小
在不同的位宽系统中，指针变量的大小不同。通常：
- **32位系统**：指针大小为4字节（32位地址）。
- **64位系统**：指针大小为8字节（64位地址）。

这是因为在32位系统中，内存地址是32位长的，最多支持 `2^32` 个地址；在64位系统中，地址长度为64位，支持的地址范围更大。因此，在64位系统上需要8字节的指针来存储完整的地址信息。

### 2. 指针类型不影响其存储空间
无论指针指向的数据类型是什么（如`int*`、`char*`、`double*`等），指针变量本身的存储空间大小是相同的。指针类型仅决定了**解引用**操作时如何解释指向的内存数据。

例如：
```c
int* p1;
char* p2;
double* p3;
```
在64位系统中，这三个指针变量的大小都是8字节。

### 3. 实际验证指针大小
可以使用 `sizeof` 运算符来验证指针变量的大小。例如：

```c
#include <stdio.h>

int main() {
   struct demo
    {
        int len;
        char *str;
    } x = {3, "hello"};
    struct demo *ps = &x;
    int *p_int;
    char *p_char;
    double *p_double;

    printf("Size of int*\t\t: %zu bytes\n", sizeof(p_int));
    printf("Size of char*\t\t: %zu bytes\n", sizeof(p_char));
    printf("Size of double*\t\t: %zu bytes\n", sizeof(p_double));
    printf("Size of struct demo*\t: %zu bytes\n", sizeof(ps));

    return 0;
}
```

在不同的系统上运行时可能输出不同的结果：

- 在32位系统上，结果通常是：
  ```c
  Size of int*            : 4 bytes
  Size of char*           : 4 bytes
  Size of double*         : 4 bytes
  Size of struct demo*    : 4 bytes
  ```
  
- 在64位系统上，结果通常是：
  ```c
  Size of int*            : 8 bytes
  Size of char*           : 8 bytes
  Size of double*         : 8 bytes
  Size of struct demo*    : 8 bytes
  ```

### 4. 指针大小与数据对齐

在不同系统和编译器中，可能会使用不同的**数据对齐（data alignment）**策略。但对齐方式一般不会改变指针的大小，因为指针的大小主要取决于地址长度，而非对齐策略。数据对齐通常只影响结构体中指针的排列顺序和间距，而不影响单个指针的大小。

### 5. 指针的空间需求在嵌入式系统中的差异

在嵌入式系统中，有些可能是16位或8位的系统，指针大小会更小，例如：
- 在16位系统上，指针大小可能是2字节（16位）。
- 在8位系统上，指针大小甚至可能是1字节（8位）。

这类嵌入式系统通常有更小的内存空间，因此它们的指针变量也会更小，但这类系统较少见于现代计算环境。

### 总结表

| 系统位宽 | 指针大小 |
| -------- | -------- |
| 8位系统  | 1字节    |
| 16位系统 | 2字节    |
| 32位系统 | 4字节    |
| 64位系统 | 8字节    |

