[toc]

在C语言中，`EOF` 是一个常量，用于表示**文件结束标志（End of File）**。它通常用于文件和输入流操作，表示文件已读取完毕或出现读取错误。`EOF` 定义在标准库 `<stdio.h>` 中，通常被定义为 `-1`。

### 使用场景

`EOF` 常用于文件或标准输入的读取操作，例如在循环中检测文件是否已经读取到结尾或输入流是否已经结束。以下是一些常见的使用场景：

1. **文件读取**：用 `fgetc`、`fgets` 或 `fread` 等函数读取文件内容时，可以使用 `EOF` 检查是否已到达文件末尾。
2. **标准输入读取**：在使用 `getchar()` 等函数读取输入时，用户可以通过 `Ctrl+D`（Linux/Mac）或 `Ctrl+Z`（Windows）发送EOF信号，表示输入结束。

### 示例

####  文件读取示例

以下代码示例读取一个文件的内容，直到遇到 `EOF` 为止：

```c
#include <stdio.h>

int main() {
    FILE *file = fopen("example.txt", "r");
    if (file == NULL) {
        printf("Failed to open file.\n");
        return 1;
    }

    int ch;
    while ((ch = fgetc(file)) != EOF) {
        putchar(ch);  // 输出读取的字符
    }

    fclose(file);
    return 0;
}
```

在这个例子中，`fgetc(file)` 每次从文件中读取一个字符。当文件读取完毕时，`fgetc` 返回 `EOF`，循环退出。

####  标准输入读取示例

以下代码示例使用 `getchar` 从标准输入读取字符，直到用户输入 `EOF`（例如按下 `Ctrl+D` 或 `Ctrl+Z`）为止：

```c
#include <stdio.h>

int main() {
    int ch;
    printf("Enter text (press Ctrl+D or Ctrl+Z to end):\n");

    while ((ch = getchar()) != EOF) {
        putchar(ch);  // 输出读取的字符
    }

    printf("End of input.\n");
    return 0;
}
```

在这个例子中，`getchar` 每次从标准输入读取一个字符。当用户输入 `EOF` 后，`getchar` 返回 `EOF`，循环退出。

```text
Enter text (press Ctrl+D or Ctrl+Z to end):
1
1
f
f
`
`
^Z
End of input.
```



### EOF 的定义与值

`EOF` 在大多数系统中被定义为 `-1`，这是因为 `EOF` 通常是一个负数，表示与正常字符的范围（通常为非负整数）区分开。实际的定义可能类似于：

```c
#define EOF (-1)
```

不过，`EOF` 的值可能因系统和编译器而异，因此在判断文件是否结束时，应该始终使用 `EOF` 常量，而不要直接使用 `-1`。

### EOF 的注意事项

1. **只用于检测文件结束或错误**：`EOF` 只用于检测是否达到文件末尾或发生错误，不表示文件中的实际数据值。
   
2. **数据范围冲突问题**：`EOF` 是一个整数常量，与正常字符编码范围（通常是非负整数）区分开来。例如，在 `fgetc` 返回值的范围内，所有字符的编码值是非负的，因此 `EOF` 使用负数来表示不会冲突。

3. **避免直接赋值**：不要将 `EOF` 直接赋给变量来表示某个值；它仅用于流函数返回值的检测。