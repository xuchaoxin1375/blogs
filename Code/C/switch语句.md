[toc]



## C语言中的switch实例

```
#include <stdio.h>

int main() {
    char grade;
    printf("Enter your grade (A, B, C, D, F): ");
    scanf("%c", &grade);

    switch (grade) {
        case 'A':
            printf("Excellent! You passed.\n");
            break;
        case 'B':
            printf("Very good! You passed.\n");
            break;
        case 'C':
            printf("Good! You passed.\n");
            break;
        case 'D':
            printf("You passed, but try to do better.\n");
            break;
        case 'F':
            printf("Unfortunately, you did not pass.\n");
            break;
        default:
            printf("Invalid grade.\n");
    }

    return 0;
}
```

这个例子展示了 `switch` 语句的基本用法，包括多个 `case` 标签、`break` 语句来阻止后续 `case` 的执行，以及 `default` 标签来处理未匹配的所有情况。

下面是另一个例子，演示了从一个 `case` 跳转到另一个 `case`（fall through）的特性：

```
#include <stdio.h>

int main() {
    int month;
    printf("Enter the month number (1 to 12): ");
    scanf("%d", &month);

    switch (month) {
        case 12:
        case 1:
        case 2:
            printf("Winter\n");
            break;
        case 3:
        case 4:
        case 5:
            printf("Spring\n");
            break;
        case 6:
        case 7:
        case 8:
            printf("Summer\n");
            break;
        case 9:
        case 10:
        case 11:
            printf("Autumn\n");
            break;
        default:
            printf("Invalid month number.\n");
    }

    return 0;
}
```

在这个例子中，如果 `month` 等于 12、1 或者 2，都会执行相同的代码块，因为在每个 `case` 之后没有 `break`，所以会发生 fall through，直到遇到 `break` 关键字或者 `switch` 语句的结束。

这两个例子都可以直接编译并运行，它们演示了 `switch` 语句的两个主要特性：多路选择和 fall through。