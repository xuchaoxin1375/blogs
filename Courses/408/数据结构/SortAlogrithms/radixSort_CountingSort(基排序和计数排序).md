@[toc]
# 非比较排序:基数排序(基排序/桶排序)radixSort/bucketSort/DigitalSort)&计数排序(coutingSort)

## ref

- [java_基数排序(可变基数的)radixSort(int *numbers,int radix)_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/115262078)
  - [Radix sort - Wikipedia](https://en.wikipedia.org/wiki/Radix_sort)


## 概述

- 基排序(radixSort),也叫桶排序BucketSort

- 是一种用**多关键字**排序思想对**单逻辑关键字**进行排序的方法

  - 多关键字:例如数据库中的记录之间的排序
    - 例如处理一个关系模式中包含两个可比较大小的字段:k1,k2
    - 当我们选定关键字属性集k=(k1,k2)作为关键字,并且对所有记录进行排序,
    - 遵循规则为:
      - 当排序遇到具有相同的k1的两条记录时,进一步比较k2
      - 对于十进制数而言,100 vs 120
        - 那么先比较百位权上的码,都是1
        - 在比较十位权上的码,后者2>1,因此里可以立即断言,后者比前者大

- In [computer science](https://en.wikipedia.org/wiki/Computer_science), **radix sort** is a non-[comparative](https://en.wikipedia.org/wiki/Comparison_sort) [sorting algorithm](https://en.wikipedia.org/wiki/Sorting_algorithm). 

- It avoids comparison by **creating** and [distributing](https://en.wikipedia.org/wiki/Distribution_sort) elements into **buckets** according to their [radix](https://en.wikipedia.org/wiki/Radix). 

- For elements with more than one [significant digit](https://en.wikipedia.org/wiki/Significant_digit), this bucketing process is **repeated** for each digit, while preserving the ordering of the prior step, until all digits have been considered. 

- <u>For this reason, **radix sort** has also been called **[bucket sort](https://en.wikipedia.org/wiki/Bucket_sort)** and **digital sort**.</u>

- Radix sort can be applied to data that can be sorted [lexicographically](https://en.wikipedia.org/wiki/Lexicographical_order), be they integers, words, punch cards, playing cards, or the [mail](https://en.wikipedia.org/wiki/Bucket_sort#Postman's_sort).

  - Lexicographical_order:词汇表顺序

- **基数排序**（英语：Radix sort）是一种非比较型[整数](https://zh.wikipedia.org/wiki/整数)[排序算法](https://zh.wikipedia.org/wiki/排序算法)，其原理是将整数按位数切割成不同的数字，然后按每个位数分别比较。

- 由于整数也可以表达字符串（比如名字或日期）和特定格式的浮点数，所以基数排序也不是只能使用于整数。

  - 基数排序的发明可以追溯到1887年[赫尔曼·何乐礼](https://zh.wikipedia.org/wiki/赫爾曼·何樂禮)在[列表机](https://zh.wikipedia.org/wiki/列表機)（Tabulation Machine）上的贡献[[1\]](https://zh.wikipedia.org/zh-cn/基数排序#cite_note-1)。

- 它是这样实现的：将所有待比较数值（正整数）**统一为同样的数位长度**，

  - 数位较短的数**前面补零**。
  - 然后，从最低位开始，依次进行一次排序。
  - 这样从最低位排序一直到最高位排序完成以后，**数列就变成一个有序序列**

  - 基数排序的方式可以采用<u>LSD（Least significant digital）</u>或<u>MSD（Most significant digital）</u>，
    - LSD的排序方式由键值的最右边开始，而MSD则相反，由键值的最左边开始。

## 概念

### LSD（Least significant digital）

- LSD最低位优先法:
  - 按关键字权重**递增**,依次进行排序

### MSD（Most significant digital）

- 和LSD相反
- 实际生活中,我们用MSD来排序是更多的,因为往往不需要比较低位,只要看最高的记为就可以判断出大小
- 而如果从低位开始观察,低位的大小分量太轻,还得比较到最高位
- 因此我们习惯从高位比较到低位

### 关键字和子关键字

- 以十进制整数的排序问题为例:

  - 比较排序算法中,我们将一个元素视为最小比较单位

  - 而radixSort中,我们将一个k位数(比100就是一个k=3位数),的各个数码看做最小比较单位

    - 不妨将100这个元素称为一个关键字key

      - 而将三个数码1,0,0称为三个自关键字k1,k2,k3;它们分别代表的权重为100,10,1

        

## 操作

### 分配

- 入队(桶)
  - 对于十进制数,其基radix=10;后面我们简单用r表示radix
    - 那么就创建10个队列来存储数码
    - 队列数量等于被排序对象的类型(r进制数就创建r个队列)

### 收集

- 首尾相接

### LSD:的案例

Input list:

- p0=[170, 45, 75, 90, 2, 802, 2, 66]

Starting from the rightmost (last) digit, sort the numbers based on that digit:

- p1=[{170, 90}, {2, 802, 2}, {45, 75}, {66}]

  - 分配:

    - 由于是10进制数,基r=10,创建0~9号队列待命

    - 按照`个位`数对输入序列进行**分配**(分类)(如果设立10个队列(桶),那么现在用到了其中的4个)

      - 大致流程:

        - 第1个元素170,个位数是0,因此将170分到0号队列

        - 第2个元素45,个位是5,因此将45分配到5号队列

        - ...扫描并处理所有元素

        - 后面将用表格表示

        - | 待命的队列号$r_i$                                            | 移入的元素情况 |
          | ------------------------------------------------------------ | -------------- |
          | 0                                                            | 170,90         |
          | 1                                                            |                |
          | 2                                                            | 2,802,2        |
          | 3                                                            |                |
          | 4                                                            |                |
          | 5                                                            | 45,75          |
          | 6                                                            | 66             |
          | 7-9为空行,<br />不画出来了,但是实际统计的时候,<br />画出来可以更加方便统计 |                |

    - 对于进入同一个队列的元素,是有先后之分的

      - 先扫描到的元素(初始序列中排在前面的)先进入桶

      - 但是如果不区分**桶内顺序也要区分**

        - 只有桶内也区分先后顺序radixSort才是稳定的

        - 如果不区分,可以完成排序吗?

          - 关键在于最后一趟(第d趟)必须区分,否则显然是不能够保证有序
          - 而且最后一趟之前的某些趟如果桶内无序,可能导致基排序不稳定!

        - 此外必须坚持桶之间是有序的

          - 也就是小号桶内的元素在前,大号桶在后

            

          

  - 收集:

    - 再将这些队列首尾相连(**收集**),构成了一个包含所有元素的序列p1
    - 每个花括号代表一个队列,它们首尾相接

Sorting by the next left digit:

- p2=[{02, 802, 02}, {45}, {66}, {170, 75}, {90}]

  - 第二趟.

    - 注意是基于p1=[{170, 90}, {2, 802, 2}, {45, 75}, {66}]序列的基础上进行再**<u>分配-收集操作</u>**

    - 分配:在按照`十位数`(权为10的码)的大小,对这些元素进行分配入队(到对应的基数列中)

      - 如果我们用你表格来统计/展示扫描p1序列后的分配结果,如下

        - 空白地方表示本轮没有(合适的)可插入元素

      - | 待命的队列号$r_i$ | 移入的元素情况 |
        | ----------------- | -------------- |
        | 0                 | 2,802,2        |
        | 1                 |                |
        | 2                 |                |
        | 3                 |                |
        | 4                 | 45             |
        | 5                 |                |
        | 6                 | 66             |
        | 7                 | 170,75         |
        | 8                 |                |
        | 9                 | 90             |

And finally by the leftmost digit:

- p3=[{002, 002, 045, 066, 075, 090}, {170}, {802}]

  - 第3趟:

    - 基于p2=[{02, 802, 02}, {45}, {66}, {170, 75}, {90}]进行分类-收集操作
    - 这次我们依照百位上的数码来分类
      - 对于百位缺失的小于100的数,只需要在百位上补0即可

  - | 待命的队列号$r_i$                                 | 移入的元素情况          |
    | ------------------------------------------------- | ----------------------- |
    | 0                                                 | 002,002,045,066,075,090 |
    | 1                                                 | 170                     |
    | ....(2~7,9行是空的,为了节约篇幅,不画出这些空行了) |                         |
    | 8                                                 | 802                     |

- 收集这些队列(首尾相连),就得到了升序排列的结果p3=[{002, 002, 045, 066, 075, 090}, {170}, {802}]

### 小结

- 从上面的例子中,我们可以感受到:
  - **比较的趟数**:取决于被排序序列中位数最多的那个元素(可以看绝对值最大的元素的位数)
    - 假设这个最大值为d
    - 相当于表格的数量
  - 表格的长度(行数):取决于待排序元素的基数radix的大小
    - 记为r
    - 不过,经过优化(改进)后的实现,设立的队列(桶)的数量可以减少
  - 待排序元素数量n会影响将元素分类(入队)的操作次数

## 性能分析

- Each step requires **just a single pass over the data**, since <u>each item can be placed in its bucket without comparison with any other element.</u>

- 空间效率:
  - 一趟排序需要用到辅助空间为r个队列
    - 每个队列中可包含:一个头指针和一个尾指针
    - 总的空间复杂度为O(r)
- 时间效率:
  - 计数排序的问题规模使用3个参数来衡量比较合适
    - 待排序元素n
    - 待排序元素的基r
    - 待排序元素的位数d
  - 那么时间复杂度可以表示为O(d(n+r))
  - 或者说:基数排序的时间复杂度是$ O(k\cdot n)$，其中$ n$是排序元素个数，$ k$是数字位数。
    - 注意这不是说这个时间复杂度一定优于$ O\left(n\cdot \log_2 \left(n\right)\right)$，
      - k的大小取决于数字位的选择（比如比特位数），和待排序数据所属数据类型的全集的大小；
      - $ k$决定了进行多少轮处理，而$ n$是每轮处理的操作数目。

### 改进

- Some radix sort implementations **allocate** space for buckets by first **counting** the number of keys that belong in each bucket before moving keys into those buckets.

  -  The number of times that each digit occurs is stored in an [array](https://en.wikipedia.org/wiki/Array_data_type).

  - Although it is always possible to pre-determine the bucket boundaries using **counts**, some implementations opt to use **dynamic memory allocation** instead.



##  参考代码

- 本代码尽量不使用java独有的特性(独特的内置的方法,以便用其他语言改写)

###  overview of the algorithm:

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210327113311327.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

### java code

 (use the core thinking of counting_sort() to complete every pass of digit sort to iterate the number array)

```java
import java.util.ArrayList;
import java.util.Random;
import java.util.Scanner;

/*
 * @Description: 
 * @Version: 2.0
 * @Author: xuchaoxin
 * @Date: 2021-03-27 08:12:30
 * @LastEditors: xuchaoxin
 * @LastEditTime: 2021-03-27 11:24:26
 */
public class RadixSort {
    public static void sort(int[] number, int d, int radix) // d表示最大的数有多少位
    {

        /* k: to traverse the number[] */
        int k = 0;
        /* n: as divisor to get digits to sort in that weight */
        int n = 1;
        /*
         * m: count the times of sort has been executed (the numbers is sorted in which
         * weight )
         */
        int m = 1;
        /*
         * handle the numbers input:the array stores complete numbers rather than signal
         * radix (or use a pointer array non_matrix structure to auxiliary the sort)
         */
        int[][] buckets = new int[radix][number.length];
        /*
         * the count array convey the sort method:counting sort（it's a stable sort
         * algorithm,and it is linear time sort method in many occasions ); (counting
         * the element of each bucket) the number of the buckets depends on the radix
         */
        int[] count = new int[radix];
        /* we need to sort d times */
        while (m <= d) {/* traverse the elements:to build the buckets */
            for (int i = 0; i < number.length; i++) {
                /* get the radix(lsd in the range(0,radix)) */
                int lsd = ((number[i] / n) % radix);
                /*
                 * according to the lsd ,to insert the elements to the buckets array separately
                 */
                buckets[lsd][count[lsd]] = number[i];
                /*
                 * counting radix (in count to calculate the index of the next element to place
                 * in the buckets
                 */
                count[lsd]++;
            }
            /* traverse all the buckets */
            for (int i = 0; i < radix; i++) {
                if (count[i] != 0)
                    /*
                     * traverse the elements in the same buckets; use the core part idea of the of
                     * counting sort: in the later,we iterate the number d times( digit d is the
                     * highest-order digit. ) (not by merge the sorted buckets)
                     */
                    for (int j = 0; j < count[i]; j++) {
                        /*
                         * update the elements in the input array(number[]):it can be think of as a sort
                         * pass
                         */
                        number[k] = buckets[i][j];
                        k++;
                    }
                /*
                 * reset all the counting array's elements in time(as soon as the bucket is
                 * used)
                 */
                count[i] = 0;
            }
            /*
             * update the weight to get new signal digits(number.lenth digits totally every
             * time) to make a new round sort
             */
            n *= radix;
            /* reset k */
            k = 0;
            /* counting the rounds that have been executed */
            m++;
        }
    }

    /**
     * the max in the input numbers
     */
    public static int max(int[] number) {
        // Arrays.sort(number);
        // return number[number.length-1];
        int maxElement = number[0];
        for (int i = 0; i < number.length; i++) {
            if (maxElement < number[i]) {
                maxElement = number[i];
            }
        }
        return maxElement;
    }

    /* get d(the highest-order digit) */
    public static int getD(int maxElement, int radix) {
        int d = 0;
        while (maxElement > 0) {
            maxElement /= radix;
            d++;
        }
        return d;
    }

    public static void main(String[] args) {
        // Scanner sc=new Scanner(System.in);
        // ArrayList<Integer> list=new ArrayList<>();
        // System.out.println("testing...");
        // /* attention! use Ctrl+z to end your input(if you use windows OS ) */
        // while(sc.hasNextInt()){//not use hasNext()
        //     int num= sc.nextInt();
        //     list.add(num);
        // }
        // sc.close();
        
        // /*list to int[] */
        // // int[] numbers=new int[list.size()];
        // // for(int i=0;i<list.size();i++){
        // //     numbers[i]=list.get(i);
        // // }
        // // Integer[] numbers=(Integer[])list.toArray();
        // /* another method to transition: */
        // int[] numbers=list.stream().mapToInt(Integer::intValue).toArray();

        
        /* use the built input to test the function: */
        // int[] numbers = { 73, 22, 93, 43, 55, 14, 28, 656844, 35649, 8441, 353, 10 };

        
        /* use random sequence to test: */
        Random random=new Random();
        int[] numbers=new int[100];
        for(int i=0;i<100;i++){
            numbers[i]=random.nextInt(900);
        }
        System.out.println("the input sequence is:");
        for(int element:numbers){
            System.out.print(element+" ");
        }
        System.out.println("");

        int d = getD(max(numbers), 100);
        RadixSort.sort(numbers, d,100);
        System.out.println("the sorted sequence:");
        for (int i = 0; i < numbers.length; i++) {
            System.out.print(numbers[i] + " ");
        }
        // System.out.println(getD(max(numbers), radix));
    }
}
```


#  计数排序是非比较排序,牺牲空间换取时间(Linear Time)
##  ref
- [计数排序 - 维基百科，自由的百科全书 (wikipedia.org)](https://zh.wikipedia.org/zh-cn/计数排序)

## 基本思想

- 特点:可以用来直接排列正整数

- 设待排序列存放在数组A中

  - 记A中的元素数量为`len(A)`

- 确定待排序元素的最大值M

  - 意味着,所有元素的取值必定是$\in [0,M]$

- 创建一个大小为M+1的数组C

  - 将这个数组视为频数统计容器,用来统计待排序列中的每个元素出现的次数

  - 其中,数组的每个元素C[i]视为独立的计数器

    - 它需要统计的元素是值为满足A[x]=i的所有A中的元素

    - 也就是

      ```py
      for element in A:
          C[element]+=1
      ```

  - 最后根据统计数组C,将元素依次输出

    - 不难发现:
    - $\sum\limits_{i=0}^{M}(C[i])=len(A)$

- 将每个元素

##  code python

- (adapted from Introduction to Alogrithm)

```python
'''
Description: 
Version: 2.0
Author: xuchaoxin
Date: 2021-03-26 20:58:42
LastEditors: xuchaoxin
LastEditTime: 2021-03-26 23:07:59
'''
""" 
for i ← 1 to k
do C[i] ← 0
for j ← 1 to n
do C[A[ j]] ← C[A[ j]] + 1 ⊳C[i] = |{key = i}|
for i ← 2 to k
do C[i] ← C[i] + C[i–1] ⊳C[i] = |{key ≤ i}|
for j ← n down_to 1
do B[C[A[ j]]] ← A[ j]
C[A[ j]] ← C[A[ j]] – 1
"""


def counting_sort(A):
    """counting_sort(),stable sort algorithm;
    the function apply to natural numbers,but:
    if you want to sort float,then times all the elements a positive integer big enough to make them natural numbers 
    if you want to sort negative numbers,you can plus all of the element a positive big enough to make them natural numbers

    Args:
        A (List): list/array to be sort
    """
    sizeOfA = len(A)  # n
    max_element = max(A)  # k
    count_list = []
    result_list = []
    """ initial the counting list """
    for i in range(0, max_element+1):
        # A[i]=0
        count_list.append(0)
        # result_list.append(0)
    for i in range(0, sizeOfA):
        result_list.append(0)
    """ counting values:(it's ok) """
    for i in range(0, sizeOfA):
        count_list[A[i]] += 1
    """ update the values(element) after the second element in the count_list;
    however,the indice start from 0,so substract 1 at first """
    count_list[0] -= 1
    for i in range(1, max_element+1):
        count_list[i] += (count_list[i-1])
    """ insert the element of A(A[i]) to correct place in the sorting sequence """
    for i in range(sizeOfA-1, -1, -1):
        """ in order to find the cause :IndexError: list assignment index out of range
        I print some value to locate it(comment out the program statement),the cause is that I didn't initial the list:result_list"""
        # print("i=",i)
        # print("A[i]=",A[i])
        # print("len(count_list)=",len(count_list))
        # print("")
        result_list[count_list[A[i]]] = A[i]
        """ update the indice of count_list:namely,the value which indice=A[i]:count_list[A[i]] """
        count_list[A[i]] -= 1
    return result_list


def main():
    """ test the counting_sort() """
    print(counting_sort([4, 2, 2, 6, 9, 0, 1]))


# main()

```
