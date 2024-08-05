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

## 问题 
据年、月、日计算天数文（分支）
### 题目描述
输入某年、月、日，判断其在一年中是第几天？
### 输入
以空格为分界，依次输入年月日。
### 输出
若输入合法，则输出其在当年是第几天；若输入不合法输出提示信息：dataerror!并退出
## 样例
### 样例输入
2004 1 1
### 样例输出
1
### 提示
注意闰年和非闰年的差别，注意数据范围！

## 朴素版
```c
#include <stdio.h>
int main(){
    int year ,month,day;
    int theday = 0;
    int legality = 1;
    scanf("%d%d%d",&year,&month,&day);
    if ((year%4==0&&year%100!=0)||year%400==0)
       switch (month)
       {
       case 1:
        if(day >= 0 && day <=31) theday += 0 ;
        else legality = 0;
           break;
        case 2:
            if(day >= 0 && day <=29) theday += 31 ;
        else legality = 0;
           break;

        case 3:
           if(day >= 0 && day <=31) theday += 60 ;
        else legality = 0;
           break;
        case 4:
            if(day >= 0 && day <=30) theday += 91 ;
        else legality = 0;
           break;
        case 5:
           if(day >= 0 && day <=31) theday +=121 ;
        else legality = 0;
           break;
        case 6:
           if(day >= 0 && day <=30) theday +=152 ;
        else legality = 0;
           break;
        case 7:
           if(day >= 0 && day <=31) theday += 182;
        else legality = 0;
           break;
        case 8:
            if(day >= 0 && day <=31) theday += 213 ;
        else legality = 0;
           break;
        case 9:
           if(day >= 0 && day <=30) theday += 244 ;
        else legality = 0;
           break;
        case 10:
           if(day >= 0 && day <=31) theday += 274 ;
        else legality = 0;
           break;
        case 11:
           if(day >= 0 && day <=30) theday += 305;
        else legality = 0;
           break;
        case 12:
           if(day >= 0 && day <=31) theday +=335 ;
        else legality = 0;
           break;
       default:
       legality = 0;
           break;
       }
       
   else if(!((year%4==0&&year%100!=0)||year%400==0))
         switch (month)
       {
       case 1:
           if(day >= 0 && day <=31) theday += 0 ;
        else legality = 0;
           break;
        case 2:
           if(day >= 0 && day <=28) theday +=31;
        else legality = 0;
           break;

        case 3:
           if(day >= 0 && day <=31) theday += 59;
        else legality = 0;
           break;
        case 4:
            if(day >= 0 && day <=30) theday +=90 ;
        else legality = 0;
           break;
        case 5:
           if(day >= 0 && day <=31) theday +=120 ;
        else legality = 0;
           break;
        case 6:
            if(day >= 0 && day <=30) theday += 151 ;
        else legality = 0;
           break;
        case 7:
           if(day >= 0 && day <=31) theday +=181 ;
        else legality = 0;
           break;
        case 8:
           if(day >= 0 && day <=31) theday += 212 ;
        else legality = 0;
           break;
        case 9:
            if(day >= 0 && day <=30) theday +=243 ;
        else legality = 0;
           break;
        case 10:
           if(day >= 0 && day <=31) theday +=273 ;
        else legality = 0;
           break;
        case 11:
           if(day >= 0 && day <=30) theday +=304 ;
        else legality = 0;
           break;
        case 12:
           if(day >= 0 && day <=31) theday +=334 ;
        else legality = 0;
           break;
       default:
       legality = 0;
           break;
       }
    
   if (legality == 0) printf("date error!");
   else
   {
     theday += day;
   printf("%d",theday);
   }
   

  
    return 0;
}
```
## 利用switch
```c
#include <stdio.h>

// 检查是否是闰年
int isLeapYear(int year)
{
    if (year % 4 == 0)
    {
        if (year % 100 == 0)
        {
            if (year % 400 == 0)
            {
                return 1; // 是闰年
            }
            else
            {
                return 0; // 不是闰年
            }
        }
        else
        {
            return 1; // 是闰年
        }
    }
    else
    {
        return 0; // 不是闰年
    }
}

// 计算给定年月日是当年的第几天
int dayOfYear(int year, int month, int day)
{
    int days = 0;
    int leap = isLeapYear(year);

    // 根据月份累加天数
    switch (month - 1)
    {
    case 11:
        days += 30; // November
    case 10:
        days += 31; // October
    case 9:
        days += 30; // September
    case 8:
        days += 31; // August
    case 7:
        days += 31; // July
    case 6:
        days += 30; // June
    case 5:
        days += 31; // May
    case 4:
        days += 30; // April
    case 3:
        days += 31; // March
    case 2:
        days += (leap ? 29 : 28); // February
    case 1:
        days += 31; // January
    case 0:
        days += 0; // No need to add anything for the first month
    }

    // 加上当前月份的天数
    days += day;

    return days;
}

int main()
{
    int year, month, day;

    // 输入年月日
    printf("Enter year: ");
    scanf("%d", &year);
    printf("Enter month: ");
    scanf("%d", &month);
    printf("Enter day: ");
    scanf("%d", &day);

    int result = dayOfYear(year, month, day);
    printf("The given date is the %dth day of the year %d\n", result, year);

    return 0;
}
```