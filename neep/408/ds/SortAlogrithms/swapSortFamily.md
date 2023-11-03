[toc]

# 交换排序(冒泡排序bubbleSort/快速排序QuickSort)

## refs

- [python_分治算法举例(在互不相同的数列中找到第i小的数)(随机化性能为线性性能)的算法_Randomized divide-and- conquer algorithm_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/115287221)
- [python/C_快速排序(randomize_quick_sort())_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/108312732?ops_request_misc=%7B%22request%5Fid%22%3A%22166546406716782427451898%22%2C%22scm%22%3A%2220140713.130102334.pc%5Fblog.%22%7D&request_id=166546406716782427451898&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~first_rank_ecpm_v1~rank_v31_ecpm-6-108312732-null-null.nonecase&utm_term=快速&spm=1018.2226.3001.4450)

## 冒泡排序

### 基本概念

#### 最终有序位置FA

- **最终有序位置FA**:元素(记录Record)x的最终有序位置A(x)是指:元素在待排序列完全排完序后所处的位置是A(x)
  - FA(x):FinalAddress(of x in the sequence)
  - 在序列的某一趟排序后,确定下来x的位置是A(x)
  - 在整个序列全部排完序之后的元素x的位置仍然在A(x)
  - 则称A[x]是x的最终有序位置

### 算法描述

- 冒泡排序的没一趟排序,都会全局地确认出一个一个元素的最终位置
- 这些已经被确认位置的元素不再参与后续比较
- 可以理解为:
  - 每趟排序,就会使得待排序序列(称为B区)的长度-1
    - 初始时,全部元素都处在B区
      - 为了确定第一个元素的
  - 相应的,已经确定全局最终位置的元素(称处于A区)的数量+1
    - 这一点和插入排序很不一样
      - 强调**全局**是为了和插入排序做区分
    - 插入排序在排序过程中维护的一个有序序列是局部的,这些相对有序的元素所在的位置只有在最优一趟排序(最后一个元素插入到有序区才能够确定所有元素的最终位置)
  - 因此,冒泡排序可以认为是反复确定:最小值/最大值的排序过程
- 最坏情况下,算需要做完n-1趟排序才能够使得整个序列有序
  - 比如,对于升序冒泡,且被排序序列是一个逆序序列


### 例子

- 为了抽象出算法的一般流程,对一个具体的例子进行算法处理
- 对L=3,2,1进行升序冒泡排序
  - 假设我们没一趟排序都从后面往前比较
  - 第一趟排序:
    - swap(2,1):312
    - swap(3,1):<u>1</u>32
    - 其中有序区A中加入了一个元素1,待排序区B中减少了一个元素
    - 下一趟排序只会操作B区中剩余的元素(2个)
  - 第二趟排序:
    - swap(3,2):2,3
    - 现在确定了2要加入A区,B区中的待排序列长度剩下1
    - 当待排序列剩下1的时候,算法可以结束,因为,前n-1个已经是都处于**最终有序位置FA**,剩下一个元素必然也是位于最终有序位置
      - 因此,可以将B区中的唯一元素直接加入到A区
  - 现在总结过程,A区中的元素序列为1,2,3
  - 排序总共进行了两趟(n-1)趟
  - 第一趟所做的比较的次数是做多
  - 第二趟比第一趟少比较一次
  - 后面一次类推,第n-1趟比价只需要比较一次,就可以将剩余的两个元素都加入到有序区A,结束算法

### 待排序区的比较规律

- 假设算法:从后往前比较,将待排序列排成升序

- 假设B区中的元素为$\set{a[i],a[i+1],\cdots,a[n-1]}$

  - 假设数组下标从0开始计算

  - 再设一个比较指针j来指示现在比较到哪里了

    - 不妨将指针的含义约定为比较表达式的右侧

    - 指针j的每个取值对应的比较表达式形如$a[j-1]>a[j]$

      - 如果比较结果为True,那么执行swap(j-1,j)来交换数组中的两个元素
      - 那么,对于从后往前比较的方式,指针取值范围(顺序依次为):$n-1,n-2,\cdots,i+1$
      - 总之要保持/使得指针所指的元素是B区中的尽可能小/大元素(根据是逆序排序还是顺序排序确定)
      - 当本趟排序结束后,位置j-1(也就是i)上的元素的元素是B区中的最值,也就是B区的第一个元素被算法置为B区的最小值

    - 注意到,我们的指针j不会直接B取的第一个元素位置等于i

    - 因为j=i+1的时候,j-1可以取到i

      

#### 基本冒泡(c指针版)

```c

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>

//在此下方插入自定义函数对的声明:
void bubble_int_sort(int *p,int n)
{
    void swap(int*a,int*b);
    /* 冒泡https://img02.sogoucdn.com/app/a/100520146/2ebb85e6d696706cd231a745c593b1dd */
    /*冒泡法不需要设立最值flag. */
    for(int i = 0;i < n-1;i++)
    {
        for(int j = 0;j<=n-2-i;j++)
        {
            if(*(p+j) < *(p+j+1))/* 通过监视*(p+j)和*(p+j+1)可以知道当前(第j组)相邻量的值的情况 */
            {
                swap(p+j,p+j+1);
            }
        }
    }
}
void swap(int*a,int*b)
{
    int temp;
    temp = *a;
    *a = *b;
    *b = temp;
}
//主函数main
int main()
{
    int *p;
    p = (int*)malloc(10*sizeof(int));
    for(int i = 0;i<10;i++)
    {
        scanf("%d",p+i);
    }
    bubble_int_sort(p,10);
    for(int i = 0;i < 10;i++)
    {
        printf("%d\n",*(p+i));
    }
    return 0;
} 

```



### 性能与改进

- 冒泡排序在**<u>最坏</u>**的情况下,需要排序n-1趟

  - 下面我们基于最坏的情况(待排序列为<u>逆序</u>)
  - $i=1,2,...\cdots, n-1$
  - 第i趟排序需要进行n-i次关键字比较
  - 比较次数$C=\sum\limits_{i=1}^{n-1}(n-i)=(n-1)+(n-2)+\cdots+1=\frac{n(n-1)}{2}$

- 交换元素位置:

  - 相当于移动三次元素(三次赋值操作)
  - 那么对于逆序的待排序列(最坏情况):
    - 每次比较都需要伴随一次交换,即移动次数是交换次数的3倍情况下
    - $M=\sum\limits_{i=1}^{n-1}3(n-i)=3C$

- 在非最坏情况下,可以借助标记位,可以提前判断出某趟排序是否已经得到全局有序的序列
  - 具体表现为:
    - 如果在某一趟排序中,发现没有做任何的交换,说明任意两个相邻的元素被判断出来是有序的
      - 降序或者升序
    - 可以在每趟排序前设定一个标记值
      - 在该趟排序执行完毕后比较是否发生交换,如果没有交换,则说明有序
      - 注意这个标记值每趟排序前都要重置一次,以免受到上一次排序的影响

- 对于标记位改进的冒泡法,最好的情况下也是待排序列有序

  - 需要n-1次比较,且无序任意交换操作
  - 时间复杂度为O(n)

  

#### 参考代码python

```python
import random as rand

l = list(range(10))
rand.shuffle(l)
rl = l  #random number list
print(rl)


def swap(l,i,j):
    #python支持成组赋值
    l[i],l[j] = l[j],l[i]
    #传统写法如下:
    # tmp = rl[j]
    # rl[j] = rl[j - 1]
    # rl[j - 1] = tmp
def bubble_sort(rl):
    n = len(rl)
    for i in range(n - 1):
        #在本趟排序前,设立一个标记
        flag = True #标记:假设本轮排序前是有序的
        for j in range(n - 1, i, -1):
            if (rl[j] < rl[j - 1]):
                flag = False#若发现逆序,修改标记
                #交换序列中的两个元素
                swap(rl,j,j-1)
                
        #本趟排序结束后,检查标记是否被更改,来判定是否已经得到一个有序序列
        if flag:#如果本趟排序没有发现逆序(交换),则已经可以认定序列是有序的了,可以结束排序
            break
    return rl


if __name__ == "__main__":
    bubble_sort(rl)
    print(rl)
```



## 快速排序QuickSort

- 快速排序属于交换排序的范畴
- 和基本的交换排序(冒泡排序)的基本特征一样,也会提到`最终有序位置`
- qsort还应用了`分治`( divide-and- conquer algorithm)的思想
  
  

### 枢轴(Pivot)



- ​	枢轴一般取待排序序列(区间)中的某个元素
  - 通常是首元素
  - 但是也不总是这样,有时为了更好的对抗最坏的情况,会采取一些取枢轴的策略
- qsort通过枢轴pivot来对待排序列进行划分(partition)(体现分治)



### 划分操作partition

- 划分是根据前面提到的**枢轴**为依据,进行一定次数的比较,将待排序列划分为<u>两个独立的部分</u>
  - $不妨记根据枢轴p(i)划分出来的两个区间分别为A(p(i)),B(p(i))$
    - 如果不特地指明具体的划分,我们将分别简称为:枢轴p,区间A,区间B
  - case1:将小于枢轴p的元素调到A
    - $记A=L[1,2,\cdots,k-1]$
  - case2:将大于枢轴p的元素调到B
    - $记B=L[k+1,k+2,\cdots,n]$
  - case3:而等于枢轴p的元素选定一个区间,比如B,那么所有和p相等的元素之后就都调整到B
    - 下面假设把这种情况和case2合并
    - cases称为:将大于或等于枢轴p的元素调到B
      - `if(L[x]>=q){L[j] in parttion_B}`
  - 关于`调整`操作的实现的好坏可以进一步调率
    - 一般调整也指的是<u>交换操作</u>(q_swap)
  - 当所有元素都被调整到对应的区间A和B,并将枢轴p赋值给L[k],那么这一趟的排序就算结束
  - 其中<u>L[k]</u>上的元素今后的后续排序中不在发生改变(p已经处于它的最终有序位置,FA(p)=k)
  - partion调用返回枢轴最终插入的位置,以便于qsort中递归调用

#### 代码参考py

```python
def partion(l, low=0, high=0, pivot=0):
    #简单的指定枢轴为待划分区间的第一个元素 (将这个元素备份到pivot变量中保存)
    pivot = l[low]
    high=len(l)-1
    while (low < high):
        #操作连个区间的指针
        while (low < high and l[high] >= pivot):
            high -= 1
            #离开循环的时候说明high指针所指的元素比pivot小,
            # 需要把它移到low所指的地方(此时l[low]可以被安全覆盖而不会丢失必要数据)
        l[low] = l[high]
        #轮到另一个指针运动,做类似的比较和覆盖操作
        while (low < high and l[low] < pivot):
            low += 1
        l[high] = l[low]
        #覆盖掉可以被覆盖的元素(第一个是区间内的第一个元素原来的位置)
        #直到区间内的元素被划分完毕
    # 最后将枢轴pivot中保存的元素插入到序列中的正确位置,k=low=high
    pivot_postion = low  #low==high
    l[pivot_postion] = pivot
    return pivot_postion
```



#### 调整操作qswap

- 调整操作qswap根据具体的实现,有时也可理解为交替填充

- 前面提到partition操作需要调用调整操作qswap
- qswap的一种比较好的实现是:
- 设置两个辅助指针i,j,它们分别代表区间A,B
  - 初始A,B区间内的元素为空
    - i指针将元素加入到A
    - j指针将元素加入到B
  - 初始状态
    - 指针i作为指向区间首元的指针
    - 指针j指向最后一个元素
  - 运动规则:
    - 对于指针i,在遇到大于p的元素前,不断+1右移步进
      - 否则暂停变化(`if(L[i]>=p)`)
      - `while(i<j&&L[i]<p){++i}`
    - 对于指针j,在遇到小于p的元素前,不断-1向左步进
      - 否则暂停变化(`if(L[j]<p)`)
      - `while(i<j&&L[j]>=p){--j}`
    - 当两个指针都遇到暂停的时候,说明指针i,j遇到来来自本该属于对方区间的元素
    - 将这对元素交换,达到一举两得的效果
    - 交换完元素后,i,j继续按照原来的规则变化1次
    - 🎈i是单调递增的,j是单调递减的

- 由于引入了枢轴变量p,我们可以将被选为枢轴的元素(比如第一个元素L[0]备份到p)
- 这样待排序列中就有一个空位L[0]可以被覆盖而不比担心数据丢失
  - 这时候,调整可以认为是交替填充

- 现在，可以根据两个指针的位置关系来判断某轮划分是否已经结束:
  - 当`i==j`的时候划分结束

### 快速排序qsort

- 对上述划分得到的每个独立区间重新执行qsort
  - 也就是递归操作重复
- 直到所有元素都被确定下来FA,结束算法
  - 每部分都只有0/1个元素的时候,停止算法
- 可以看到,整个序列最终会被划分成二叉查找树的形式
- 划分形式上看类似于二分查找,这是这里的枢轴不一定是中间位置的元素

#### 参考代码

```py
def quick_sort(l,low=0,high=0):
    #快速排序是递归实现的
    #首先编写递归出口逻辑:
    #或者说递归继续深入的条件(包含了出口的意思)
    if(low<high):
        #首先对传入的区间片段做一个partition
        pivot_position=partion(l,low,high)
        quick_sort(l,low,pivot_position-1)
        quick_sort(l,pivot_position+1,high)
```



#### 调用者函数

```py
def generate_by_shuffle(n=30):
    #随机序列生成函数
    l=list(range(n))
    random.shuffle(l)
    return l
if __name__ == "__main__":
    # l = [2,3,5,7,1,4,6,15,5,2,7,9,10,15,9,17,12]
    l = generate()
    print(l)
    len_l = len(l)
    high = len_l - 1
    #测试函数功能
    ## 测试partition()
    # print(quick_sort_poor(l))
    # p = partion(l)
    ##测试quicksort()
    quick_sort(l,low=0,high=len_l-1)
    ##  打印结果
    # print("p=%d;l[p]=%d" %(p,l[p]))
    print("🎈排序结果:")
    print(l)
```



### 性能分析

- 快速排序由于其平均性能优秀,而且是原地排序,应用广泛
- $它的最坏情况下的性能是O(n^2)$
- 平均性能和最优性能都是$O(n\log_2n)$
  - 最理想的情况是,每次取的枢轴都是能够将序列分为元素数量大致相当的两部分A/B
  - 新能分析可以转换为类似于BST的高度的高度分析
- 由于partition操作对元素的位置调整,可能导致算法不稳定
  - 例如对3,2,2进行partition,去pivot=3,那么partition会将第二个2覆盖掉3的位置,最终将pivot插入到序列中,得到2,2,3

## 其他版本的冒泡排序实现

###  冒泡排序

####  结构梳理版

![在这里插入图片描述](https://img-blog.csdnimg.cn/f9d3bc3da39443abb234e2e9d8ce7a11.png)

```c
#include <stdio.h>
void swap_pointer(int *a, int *b);
void test_and_correct(int *p, int j)
{
    /* 测试并且比较序列的第j个元素和第j+1个元素的大小,必要时给做交换位置操作 */
    if (*(p + j) < *(p + j + 1)) /*或者写作if(p[j] < p[j+1])也可以*/
    {
        /*通过改变'<'为'>',可以从降序转为升序; 通过监视*(p+j)和*(p+j+1)可以知道当前(第j组)相邻量的值的情况 */
        swap_pointer(p + j, p + j + 1);
    }
    else
    {
        // 摆烂(pass)
    }
}
void order_next(int *p, int n, int i)
{
    /* 使得待排序序列中的一个元素全局有序(确定其最终结果);或者说,将下一个最小/大元素放到最理想有序的位置 */
    /* 假设我们要进行逆序(降序排列descend)
    那么,每一次排序(比较)就要把小的元素交换到右侧,以此来将本轮排序中的最小元素移动到最后
    函数每执行一次,有序区的序列就会增长一个元素(相应的,未排区的元素就减少一个)
    后面的调用需要执行的比较词书也会越来越少
    每次调用需要执行的交换次数最坏的情况下是n-i
    为了更方便的描述比较相邻两个元素以及在需要的时候做一次交换,我们不妨称呼这样额一组操作为`纠正(correction)`
    比如说,有n=3个待排序元素{a,b,c},那么第一趟排序需要n-1次纠正操作,这足以为有序区添加一个元素(全局意义上的排好了第一个元素)
    散列数值分别表示:
    有序区的长度:还待排序长度:该轮排序(再排一个元素)还需要测试纠正的次数
    0:n-0:n-1
    1:n-1:n-2
    ...
    i:n-i:n-i-1
    ...
    (n-1:1:0)

    */

    /* RHS = LHS+1 ∈ [1,n-1]
            单趟比较中:*/
    // for (int j = 0; j <= n - 2 - i; j++)
    for (int j = 0; j < n - 1 - i; j++)
    {
        /*内重循环控制各趟排序的一系列比较中:控制LHS从[0,n-2-i]从0取遍n-2-i(i由外重循环弹出的表示现在是第i趟排序) ;比较表达式的右边RHS = LHS+1 */ /* RHS∈[1,n-1] */
        test_and_correct(p, j);
    }
}
void bubble_sort_reverse(int *p, int n)
{
    /*冒泡法不需要设立最值flag.
    冒泡需要进行n-1趟排序*/
    for (int i = 0; i < n - 1; i++)
    {
        /*
        这里的i可以表示:
        1.有序区的元素长度(每执行一轮,长度+1)
        2.也可以表示排序的次数:当前执行第i趟排序
        */
        /*
        并且,只要排好n-1个数,那么整个数列就是有序的了(意味着只需要排n-1趟,即调用order_next()来个n-1次即可)*/
        /* RHS = LHS+1 ∈ [1,n-1]单趟比较中:*/
        order_next(p, n, i);
    }
}
/* 数字版swap() */
void swap_pointer(int *a, int *b)
{
    int temp;
    temp = *a;
    *a = *b;
    *b = temp;
}

int main(int argc, char const *argv[])
{
    int l[7] = {5, 2, 8, 0, 4, 3, 2};
    int n = 7;
    bubble_sort_reverse(l, n);
    for (int i = 0; i < n; i++)
    {
        printf("%d,", l[i]);
    }
    return 0;
}

```

####  紧凑版

```c
void bubble_int_sort(int *p, int n)
{
    void swap_int_pointer(int *a, int *b);
    /*冒泡法不需要设立最值flag. */
    for (int i = 0; i < n - 1; i++)
    {
        /* RHS = LHS+1 ∈ [1,n-1]
        单趟比较中:*/
        for (int j = 0; j <= n - 2 - i; j++)/*内重循环控制各趟排序的一系列比较中:控制LHS从[0,n-2-i]从0取遍n-2-i(i由外重循环弹出的表示现在是第i趟排序) ;比较表达式的右边RHS = LHS+1 */  /* RHS∈[1,n-1] */
        {
            /*通过改变'<'为'>',可以从降序转为升序; 通过监视*(p+j)和*(p+j+1)可以知道当前(第j组)相邻量的值的情况 */
            if (*(p + j) < *(p + j + 1)) /*或者写作if(p[j] < p[j+1])也可以*/
            {
                swap_int_pointer(p + j, p + j + 1);
            }
        }
    }
}
/* 数字版swap() */
void swap_int_pointer(int *a, int *b)
{
    int temp;
    temp = *a;
    *a = *b;
    *b = temp;
}

```

####  降序版

c++降序版代码示例

```cpp
#include <iostream>

void bubble_int_sort(int *elem_array_p, int size)
{
    void swap_int_pointer(int *a, int *b);
    /*冒泡法不需要设立最值flag. */
    /* 外层循环控制比较的趟数rounds(或者称为回合数) */
    for (int round_i = 0; round_i < size - 1; round_i++)
    {
        /* RHS = LHS+1 ∈ [1,size-1]
        单趟比较中:
        该趟剩余待排序元素个数为remains=size-round_i*/
        int remains = size - round_i;
        int times_to_compare = remains - 1;
        /* 这样，内层便利将会为该round(回合)的排序过程中做times_to_compare次比较. 可以举三个元素构成的待排序列来感受一下
        内层循环的条件表达式的编写可以基于本回合需要比较的次数来编写.
        循环变量left_j也可以理解为本回合的比较次数计数器/或每次被比较的两个元素的左侧元素.*/
        for (int left_j = 0; left_j < times_to_compare; left_j++) /*内重循环控制各趟排序的一系列比较中:控制LHS从[0,size-2-round_i]从0取遍size-2-round_i(round_i由外重循环弹出的表示现在是第round_i趟排序) ;比较表达式的右边RHS = LHS+1 */ /* RHS∈[1,size-1] */
        {
            int *left = elem_array_p + left_j;
            int *right = left + 1;
            /*通过改变'<'为'>',可以从降序转为升序; 通过监视*(elem_array_p+left_j)和*(elem_array_p+left_j+1)可以知道当前(第left_j组)相邻量的值的情况 */
            if (*left > *right)
            {
                swap_int_pointer(left, right);
            }
        }
    }
}
/* 数字版swap() */
void swap_int_pointer(int *a, int *b)
{
    int temp;
    temp = *a;
    *a = *b;
    *b = temp;
}
using namespace std;
int main()
{
    /* 在这个数组里填充您要排序的整数序列 */
    int test_arr[] = {6, 8, 2, 0, 1, 70};
    int size = sizeof(test_arr) / sizeof(test_arr[0]);
    bubble_int_sort(test_arr, size);
    for (int round_i = 0; round_i < size; round_i++)
    {
        cout << test_arr[round_i] << endl;
    }
}
```





