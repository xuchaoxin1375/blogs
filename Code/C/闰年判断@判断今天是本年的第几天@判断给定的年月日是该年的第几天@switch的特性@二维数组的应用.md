[toc]





## abstract

闰年判断@判断今天是本年的第几天@判断给定的年月日是该年的第几天@switch的特性@二维数组的应用.md

闰年是为了调整日历年与天文年（即地球绕太阳一圈的时间）之间的差异。一般来说，平年为365天，闰年为366天。在许多日期问题上,都会用到闰年判断

### 闰年的规则

1. 年份能被4整除但不能被100整除的年份是闰年。
2. 如果该年份能被400整除，则仍然是闰年。



### 分析

从集合的角度分析:设能够被4,100,400整除的数构成的集合分别为$A,B,C$;

- $A=\set{x|x\mod{4}=0}$
- $B=\set{x|x \mod{100}=0}$
- $C=\set{x|x \mod{400}=0}$

而数学上如果$x$是$y$的整数倍,$z$是$x$的整数倍,那么$z$也是$x$的整数倍;对应于本例,$100=4\times{25}$,$400=100\times{}$

集合$A,B,C$之间的关系为$C\sub{B}\sub{A}$

闰年用集合表示:$S=\set{A-B}\cup{C}$或$S=A-\set{B-C}$



### 判断

给定一个年份year,先判断它是否属于S,可以先判断year是否属于C,如果不是,再判断是否属于$A-B$(这一步又可以分为先判断是否能属于$B$,如果是则year不是闰年,如果否则进一步判断其是否属于A,如果是则year是闰年)

### C语言 判断闰年

```c
#include <stdio.h>
#高效版本
int isLeapYear(int year)
{
    // 判断是否为闰年
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

/**
 * day_of_year: 根据年份、月份和日期计算一年中的第几天
 *
 * @param year 年份
 * @param month 月份
 * @param day 日期
 * @return 返回一年中的第几天
 *
 * 注意：这个函数考虑了闰年的情况，通过判断年份是否能被4整除但不能被100整除，或者能被400整除来确定是否是闰年
 */
int is_leap_year(int year)
{

    // 方案1:
    // return year % 400 == 0 || year % 4 == 0 && year % 100 != 0 ;
    // 方案2:(效率更高,但是代码更冗长)
    if (year % 400 == 0)
    {
        return 1;
    }
    if (year % 100 == 0)
    {
        return 0;
    }
    return year % 4 == 0;
}
int main()
{
    int year;
    printf("请输入年份: ");
    while (scanf("%d", &year) != EOF)
    {

        // printf("请输入年份: ");
        // scanf("%d", &year);

        if (isLeapYear(year))
        {
            printf("%d 是闰年。\n", year);
        }
        else
        {
            printf("%d 不是闰年。\n", year);
        }
        // 准备下一轮处理
        printf("请输入年份: ");
    }

    return 0;
}
```

这个程序首先定义了一个`isLeapYear`函数，该函数接收一个整数参数`year`，并根据上述规则判断是否为闰年。`main`函数中，我们让用户输入年份，然后调用`isLeapYear`函数并输出结果。

### Matlab判断闰年

matlab 判断闰年

```matlab
function judgeLeapYear(year)
%输入待判断的年份year
%调用格式为judgeLeapYear(year)
%如果是闰年,打印yes!
%否则打印no
if( (mod(year,4) == 0 &  mod(year,100)~=0) |  mod(year,400)==0)
    'yes!' %也可以disp(yes)
else
    disp('no')
end
```

## C语言中的switch

### break

```c
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

### case fall through

下面是另一个例子，演示了从一个 `case` 跳转到另一个 `case`（fall through）的特性：

```c
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

## 问题举例

据年、月、日计算天数文（分支）

题目描述

输入某年、月、日，判断其在一年中是第几天？

输入

以空格为分界，依次输入年月日。

输出

若输入合法，则输出其在当年是第几天；若输入不合法输出提示信息：dataerror!并退出

样例

样例输入

2004 1 1

样例输出

1

### 提示

注意闰年和非闰年的差别，注意数据范围！

## 朴素解决方案

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

## 其他思路

这里不局限于shagn

### switch版

- 利用了c语言中switch的特点

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

### 二维数组版

```c
#include <stdio.h>
// daytab是一个二维数组，用于存储平年和闰年每个月的天数
static char daytab[2][13] = {
    {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}, // 平年
    {0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}  // 闰年
};

/**
 * day_of_year: 根据年份、月份和日期计算一年中的第几天
 *
 * @param year 年份
 * @param month 月份
 * @param day 日期
 * @return 返回一年中的第几天
 *
 * 注意：这个函数考虑了闰年的情况，通过判断年份是否能被4整除但不能被100整除，或者能被400整除来确定是否是闰年
 */
int is_leap_year(int year)
{

    // 方案1:
    // return year % 400 == 0 || year % 4 == 0 && year % 100 != 0 ;
    // 方案2:(效率更高,但是代码更冗长)
    if (year % 400 == 0)
    {
        return 1;
    }
    if (year % 100 == 0)
    {
        return 0;
    }
    return year % 4 == 0;
}
int day_of_year(int year, int month, int day)
{
    int i, leap;
    // 判断是否是闰年
    leap = is_leap_year(year);
    // 累加每个月的天数，直到指定的月份，从而计算出一年中的第几天
    for (i = 1; i < month; i++)
        day += daytab[leap][i];
    return day;
}

/**
 * month_day: 根据年份和一年中的第几天计算月份和日期
 *
 * @param year 年份
 * @param yearday 一年中的第几天
 * @param pmonth 指向月份的指针
 * @param pday 指向日期的指针
 *
 * 注意：这个函数也考虑了闰年的情况，通过相同的方式判断是否是闰年
 * 函数通过指针参数pmonth和pday来返回月份和日期,来实现一次返回多个计算结果
 */
void month_day(int year, int yearday, int *pmonth, int *pday)
{
    int i, leap;

    // 判断是否是闰年
    leap = is_leap_year(year);
    // 通过减去每个月的天数来确定月份和日期
    for (i = 1; yearday > daytab[leap][i]; i++)
        yearday -= daytab[leap][i];

    *pmonth = i;
    *pday = yearday;
}

/* 分别举几个例子测试上述函数 */
int main()
{
    int year, month, day, yearday;

    scanf("%d%d%d", &year, &month, &day); // 本例的两个函数共有的参数是year,其中month,day作为函数day_of_year的参数,yearday作为函数day_of_year和month_day的共同参数

    yearday = day_of_year(year, month, day); // 2024 11 5
    printf("day_of_year(%d, %d, %d)=%d\n", year, month, day, yearday);

    month_day(year, yearday, &month, &day);
    printf("month_day(%d, %d)=%d %d\n", year, yearday, month, day);

    return 0;
}
```

