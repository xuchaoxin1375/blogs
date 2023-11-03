[toc]

# mergeSort

- 归并排序的过程可以理解为两个人打扑克
  - 在摸牌阶段(整理手中的牌,一般我们会用插入排序来整理)
  - 在出牌阶段,就是涉及到两个(或者更多的玩家),轮流出牌
    - 假设采取最为朴素的出牌方式
    - 玩家都尽可能先出可以出的最小的牌
    - 这样,当其中的一个玩家将牌出完,那么全部牌的大小顺序就确定下来

对于归并排序而言

## 相关概念

### 有序表

- 有序表:如果含有m个元素的序列$L[1,2,3\cdots,m]$中所有元素构成有序序列,那么L就是一个有序表
  - 该有序表长度为m
- 假定待排序列有n个元素
- 那么初始时,可以将n个元素看做n个表,每个表都是只有一个元素
- 这些单元素表也视为**有序表**

### 归并操作Merge

- 归并操作体现的就是扑克玩家出牌的过程
- 归并操作的效果设计为:
  - 将两个有序表Lp和Lq(设它们长度分别为p,q)进行归并,可以得到新有序表长度为两个表的长度之和p+q

#### 归并排序算法

```py

def merge_orderd_ranges(l, start=0, mid=0, end=0):
    """合并两个相邻区间内的元素:归并排序适配版
    <相邻有序区间的有序化合并操作>
    由于归并排序是自底向上的,而且合并的两个有序序列区间在同一个序列中且是相邻的
    因此我们用下标参数来描述描述两个待合并序列
    分别表示为l[start:mid];l[mid+1,end]
    Parameters
    ----------
    l : list
        待执行指定区间[start,end]的合并的序列
        为了保证合并后
    start : int, optional
        待合并的第一个区间起点, by default 0
    mid : int, optional
        待合并区间的第一个有序区间的终点下标,用以区分来个有序区间的边界, by default 0
    end : int, optional
        第二个有序区间的终点元素下标索引, by default 0
    Returns
    -------
    list
        两个有序区间有序化合并完的结果(不是必须的)
    """
    # end = end if mid and end > 0 else len(l) - 1
    #复制一份待归并序列
    print("elements to be merged:🎎", l[start:end + 1])
    bak_l = l[:]
    print("\t✨indexes:start,mid, end", start, mid, end)
    # res_l = []
    i = start  #~mid
    j = mid + 1  #~end
    k = i  #指示尚未排序的部分中的最小的元素应该插入到l序列中的那个位置
    # len_a = mid - start + 1
    # len_b = end - mid
    while (i <= mid and j <= end):
        if (bak_l[i] <= bak_l[j]):
            l[k] = bak_l[i]
            i += 1
        else:
            l[k] = bak_l[j]
            j += 1
        #更新下一个要插入的位置
        k += 1
    #将剩余部分直接拷贝到l中
    #c语言中的实现可以是:
    # while(i<=mid) l[k++]=bak_l[i++]
    # while(j<=mid) l[k++]=bak_l[j++]
    if (i <= mid):
        l[k:end + 1] = bak_l[i:mid + 1]
    else:
        l[k:end + 1] = bak_l[j:end + 1]
    print("merge res🎈:", l[start:end + 1])
    return l[start:end + 1]
```



### 归并排序MergeSort

- 归并排序MergeSort是按照分治的思想(和QuickSort一样),递归的调用MergeSort

  - 对于二路归并排序(k=2)
    - 初始时,可以将n个元素看做n个表,每个表都是只有一个元素
    - 经过一趟归并,得到$floor( \frac{n}{2})$个长度为2的有序表
      - 待排序列包含n个元素,如果n是个奇数,
      - 那么第一趟二路归并后,会有一个组(有序表)仍然只有一个元素
    - 反复的将这较小小的有序表Merge成大一些(k=2倍长度)的有序表:
      - 每个有序表的长度翻倍,有序表的总数量则相应减少一般
    - 知道合并至仅剩一个有序表,算结束

- MergeSort和Merge调用的关系

  - ```python
    
    def merge_sort_binary(l, start=0, end=0):
        """归并排序:基于分支算法的二路归并排序算法
        借助一个合并操作Merge来充当分治递归的主要操作逻辑
        Merge_sort和Merge调用的关系:
            Merge_sort负责划分问题(分治)
            Merge操作负责实际的元素调整,有序化移动序列中的元素
        Parameters
        ----------
        l :list
            待排序列;另外加上闭区间[start,end]
        start : int
             本次归并排序需要处理的区间(开头)
        end : int
            区间的结尾
        Returns
        -------
        list
            返回已经排好序的区间
            当递归调用栈回到最深层的时候,整个序列l已经有序
        """
        # end= end if end else len(l)-1
        #递归调用执行深入下去的条件:(递归入口及出口)
        if (start < end):
            #继续划分的条件是,当前序列区间[start,end]至少包含2个元素
            #(否则(只有0/1个元素,不需要在划分了,Merge操作可以对处理区间长度为2的序列进行有序化(合并))
            sum = (start + end)
            mid = sum // 2
            print("start,mid,end", (start, mid, end))
            merge_sort_binary(l, start, mid)
            merge_sort_binary(l, mid + 1, end)
            #merge调用被安排在划分(递归调用MergeSortBinary)之后,只有当所有任务被划分完毕
            #merge调用才有机会开始执行,递归调用栈开始逐步弹出
            merge_orderd_ranges(l, start, mid, end)
            # print(l[start:end+1])
        #如果只有一个元素,则直接返回
        return l[start:end+1]
    
    ```

    

### 调用&测试函数功能

```py
import random 
def generate_by_shuffle(n=30):
    l=list(range(n))
    random.shuffle(l)
    return l
def test_merge_orderd_ranges():
    a = [1, 3, 5, 7]
    b = [2, 4, 6, 8, 12, 14]
    l = a + b
    print(merge_orderd_ranges(l, mid=3))


def test_merge_sort_binary(l):
    merge_sort_binary(l, 0, len(l) - 1)
    print(l)


if __name__ == "__main__":
    a = [1, 3, 5, 7]
    b = [2, 4, 6, 8, 12, 14]
    l = generate_by_shuffle(20)
    print("random list:", l)
    # test_merge2()
    # test_merge_orderd_ranges()
    test_merge_sort_binary(l)
```



## 性能分析

- 空间:需要辅助单元n,空间复杂度为O(n)
- 时间:
  - 二路归并排序的过程很像逆向一个二叉树
    - 第一行结点:叶子结点(每个结点一个元素)摆在第一行
    - 第二行数量减半,么个结点包含2个元素,(但是可能有一个结点是仅有一个元素)
    - ...
    - 最后一行只有一个结点(包含了序列的所有结点)并且全局有序
  - 共需要$ceil(\log_2 n)$趟排序
    - 每趟排序调用一次merge操作
  - 每趟merge时间复杂度为O(n)
    - 从算的实现中可以看到,需要遍历所有元素一遍
  - $总的时间复杂度为O(n\log_2n)$

### k路归并

- 如果k>2,序列长度为n,那么需要排序的趟数为$h=\log_k n$
  - 借助k叉树(比如k=2,二叉树)模型,分析树的高度,可以得到排序的趟数
  - 大致满足$k^h=n$

### 稳定性

- 归并排序是稳定的
  - 在Merge的过程中遇到相邻有序区间内有相等元素的时候,可以总是让前一个区间中的元素先并入结果序列中



## C语言实现

### 头文件

- 有些多余的东西

```c
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>


#define ISHEAP 0/*是否从数组位置1开始记录元素(堆排序)*/
#define EASY 0/*是否先测试简单例子*/
#define Read_From_Keyboard 0/*是否要从键盘输入数据(若是,改为1)*/
#define MAX 100

/*"排序.c"里的源文件里的函数*/
void mergeSort(int r[], int n);
/*main.c 可以先跳过这部分:*/
int read(int* r)/*EOF结束*/
{
#if ISHEAP
	int i = 1;
#else
	int i = 0;
#endif
	while (scanf("%d", &r[i]) != EOF && i < MAX)
	{
		i++;
	}
	return i;
}
int main()
{
	/*根据要测试的函数/测试例子的简易程度,选择性编译不同的数组数据*/
	/*是否从键盘读取数据:*/
	#if Read_From_Keyboard
	//int* r = (int*)malloc(sizeof(int) * MAX);
		int r[MAX];
		int n = read(r);	
	#else
		#if ISHEAP
			int heapr[] = {-99, 19,15,13,1,6,7,0,3,2,4 };
		#else 
			#if EASY
				int	r[] = { 10,9,8,7,7,5,4,4,2,1 };
				int n = 10;
			#else
				int	r[] = { 19,15,13,1,6,7,0,3,15,7 /*2,4*/};
				int n = 10;
			#endif
	
		#endif
	#endif

	printf("testing:\n");
	/*归并排序*/
	mergeSort(r,n);
#if (ISHEAP)
	for (int i = 1; i <= n; i++) printf("%d ", heapr[i]);
#else
	for (int i = 0; i < n; i++) printf("%d ", r[i]);
#endif

}

```
### 正文:

先根遍历的序号规律:
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200831104231906.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70#pic_center)

### 代码解释

```c
/*归并排序
* 对n个元素的表，将这n个元素看作叶结点，若将叶子两两归并生成的 子表 看作它们的父结点，则归并过程对应由叶向根生成一棵二叉树的过程。所以归并趟数约等于二叉树的高度-1
* 即log2n，每趟归并需移动记录n次，故时间复杂度为O(nlog2n）
排序思想：如果N = 1，那么只有一个元素需要排序，答案显然；
否则，将数据分成前后两半，分别对前后两部分进行归并排序，再把排序好的前后两部分合并在一起。
该排序算法采用了经典的分治策略，可通过递归求解。

*/


	//合并前后两部分的排序数据的函数。函数原型如下：
		/**********************************************************
		 给定两个有序数组A和B。其中，数组A存放在r[leftPos ~ rightPos-1]，     
		 数组B存放在r[rightPos ~ rightEnd]。合并这两个有序数形成一个新的有     
		 序数组, 并存放在位置: r[leftPos ~ rightEnd]。提示：在合并形成新的有     
		 序数组时，可先存放于临时位置tmpArray，再复制到r[leftPos ~ rightEnd]。
	*********************************************************/
void merge(int r[], int tmpArray[], 
	int leftPos, /*第一部分序列的开头;(结尾rightPos-1)*/
	int rightPos, /*第二部分序列的开头*/
	int rightEnd)/*第二部分序列的结尾*/
{
	/*数组A存放在r[leftPos ~ rightPos-1]，     
		 数组B存放在r[rightPos ~ rightEnd]。*/
	int i = leftPos,
		j = rightPos,
		k;/*指示写在tmpArray[]索引k处*/
		
	k = leftPos;
	for (; i <= rightPos-1 && j <= rightEnd;)/*j-1 和 辅助变量混淆就糟糕了*//*j只是被初始化为rightPos,但难以保持不变,要写实参*/
	{
		if (r[i] < r[j])
		{
			tmpArray[k] = r[i++];
		}
		else
		{
			tmpArray[k] = r[j++];
		}
		k++;
	}
	/*若第一部分有剩余(if可以不写,直接些while())*/
	if (i <= rightPos - 1)
	{
		while (i <= rightPos - 1)/*rightPos不能写成j(j已经被改变了,不再是初始化时的第二部分左边界)*/
		{
			tmpArray[k++] = r[i++];
		}

	}
	/*若第二部分有剩余(if可以不写,直接些while())*/
	if (j <= rightEnd)
	{
		while (j <= rightEnd)
		{
			tmpArray[k++] = r[j++];
		}
	}
	/*将排序结果从辅助数组拷贝(遍历拷贝)回原序列所在数组,以便将结果带回.*/
	for (i = leftPos; i <= rightEnd; i++)
	{
		r[i] = tmpArray[i];
	}
}//merge()
/*归并排序核心算法(递归版本):
将排序结果存至tmpArray[]*/
void mergeSortImplemnt(
	int r[],
	int tmpArray[],/*临时存放数据空间*/
	int left,
	int right)
{
	/**********************************************************
	对数组r[]中下标在[left, right]之间的数据进行归并排序
*********************************************************/
	if (left < right)/*else:(left==right)递归出口_1(简单出口)此出口不做元素调整*/
	{ // N > 1
		int center = (left + right) / 2; // 中间位置，把待排序数据分成两半
		/*父级调用要等待子级调用回归后再触发它的兄弟级调用(如果还有后面的兄弟级调用的话);当它的最后一个兄弟级调用完成后就回到了父级调用,执行父级调用还未完成的操作;(叶子级别的调用一般时使用简单递归出口,父级调用一般使用复杂的递归出口(会有更多的处理)*/
		mergeSortImplemnt(r, tmpArray, left, center);  // 前半部分归并排序(递归进入)
		mergeSortImplemnt(r, tmpArray, center + 1, right); // 后半部分归并排序(对末次调用:递归出来(返程);而对于初次调用,他是后半部分的处理开端)

		merge(r, tmpArray, left, center + 1, right); /*递归出口_2(回程复杂出口(一般执行元素调整操作) ，合并前后两部分有序子序列为更大范围的大有序子序列)这一调用使得原序列数组r变得局部有序,调整完有序的部分是从父级调用的左右边界范围内*/
	}

}//mergeSortImplemnt()
void mergeSort(int r[], int n)
{
	/**********************************************************
	对数组r[]中的n个元素进行归并排序
*********************************************************/
	int* tmpArray = (int*)malloc(sizeof(int) * n); // 临时存放数据空间
	/*调用核心算法:*/
	mergeSortImplemnt(r, tmpArray, 0, n - 1); // 归并排序的具体实现

	free(tmpArray);
}
```









