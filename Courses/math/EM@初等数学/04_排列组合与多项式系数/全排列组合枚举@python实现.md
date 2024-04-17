[toc]

## ref

- [全排列_百度百科 (baidu.com)](https://baike.baidu.com/item/全排列/4022220#4_2)
- 参考https://blog.csdn.net/weixin_30412167/article/details/97482411

## python

- ```python
  
  ##普通函数版
  cnt=0
  def p(li,prefix=""):
      """ 全排列给定的li中的元素,共给出n!中排列,n=len(li) """
      if(not li):
          # put(prefix)
          global cnt
          cnt+=1
          print("%d:%s"%(cnt,prefix))
      for i in li:
          # prefix+=str(i)#错误!,会导致前缀累积
          v=li[:]
          v.remove(i)
          p(v,prefix+str(i))   
          
  ##高阶函数闭包版
  def permutations():
      counter=0
      def p(li,prefix=""):
          """ 全排列给定的li中的元素,共给出n!中排列,n=len(li) """
          # print(li)
          # nonlocal li
          if(not li):
              # put(prefix)
              nonlocal counter
              counter+=1
              print("%d:%s"%(counter,prefix))
          for i in li:
              # prefix+=str(i)#错误!,会导致前缀错误累积
              v =li[:]
              v.remove(i)
              p(v,prefix+str(i))
      return p
          
  if __name__=="__main__":
      test=list(range(1,5))
      test_abc=["a","b","c"]
      # 采用闭包(高阶函数)的方式组织代码
      pp=permutations()
      print("test p")
      p(test_abc)
      print("test pp")
      pp(test)
  ```

### 输出

- 

  ```bash
  (base) PS D:\repos\PythonLearn>  py tmp.py
  test p
  1:abc
  2:acb
  3:bac
  4:bca
  5:cab
  6:cba
  test pp
  1:1234
  2:1243
  3:1324
  4:1342
  5:1423
  6:1432
  7:2134
  8:2143
  9:2314
  10:2341
  11:2413
  12:2431
  13:3124
  14:3142
  15:3214
  16:3241
  17:3412
  18:3421
  19:4123
  20:4132
  21:4213
  22:4231
  23:4312
  24:4321
  ```

  

## C语言

```c
#include <stdio.h>
#define TEST_NO_Duplicate 1
void Swap(int *a, int *b){
    int tmp = *a;
    *a = *b;
    *b = tmp;
}

void Output(int A[], int size){
    int i;
    
    for(i = 0; i < size; i++){
        printf("%d ", A[i]);
    }
    putchar('\n');
}

int cnt=0;//全局变量;

#if TEST_NO_Duplicate

/* 可以解决待排列元素中没有重复元素的情况 */
void Full_Permutation(//相对外层调用/*随着递归的深入, p_size和end始终没有改变,方便递归 */
    int A[], /* 待排列数所在的数组(始终是这个数组) */
int begin/* 起始元素数组索引(随着递归的深入和浅出的变化而变化) */, 
int end/* 末尾元素数组索引(为不变量) */, 
int p_size/* 初始待排列元素的数目(为不变量) */
){
    printf("cnt=%d\n",++cnt);
    int i;
    /* 排列到最后一个元素时输出数组A
    (打印该序列) */
    if(begin >= p_size){//小心这不是递归出口,它只是一个在合适时机打印内容的打印语句;
        printf("\n");
        Output(A, p_size);
    }
    else{
        /* 遍历各个位置 ;
        i初始化为begin索引;*/
        for(i = begin; i <= end; i++){//递归出口:i>end的时候开始"归的过程"
                //for(int k = 0;k<i;k++) {printf("\t");};printf("before Swap(A + begin=&A[%d], A + i=&A[%d]) :",begin,i);Output(A, p_size);
            /* 对于当前层次的for而言,begin的值是不会改变的,而i在当前层次的for是要逐渐的增长的. */

            Swap(A + begin, A + i);/* 交换当前规模下的待排序列的首元素和第i个元素 */
                //for(int k = 0;k<i;k++) {printf("\t");};printf("after Swap(A + begin=&A[%d], A + i=&A[%d]) :",begin,i);Output(A, p_size);printf("\n");
            
                for(int k = 0;k<i;k++) {printf("\t");} printf("before %dth invoke, Full_Permutation(A, begin + 1= %d, end=%d, p_size=%d);",i+1,begin+1,end,p_size);Output(A, p_size);
            /* 暂时先忽略细节:把它当成一个可以完成特定功能的黑箱,不要急着进入,否则越来越深,看不出连贯的逻辑; */  //invoke deeper:
            Full_Permutation(A, begin + 1, end, p_size);/*相对内层调用(数组A相对的外层的那个数组A,排列起始位置改变);p_size和end也始终没有改变*/
                for(int k = 0;k<i;k++) {printf("\t");} printf("after %dth invoke, Full_Permutation(A, begin + 1= %d, end=%d, p_size=%d);",i+1,begin+1,end,p_size);Output(A, p_size);
            
                
            
            /* 打印完子级规模调用所计算出来的排列结果后,将本调用之初所交换的那两个元素换回去,以便下一个还未充当队头的元素能够顺利当上的对头同时不会让已经当过队头的元素再次当队头,避免了混乱;即事实上充当队头的元素是可以事先有序地安排好的.(即A[0]元素先当队头,计算并打印出所有A[0]打头的排列结果后,借助循环变量i,将A[1]元素A[0]元素交换(也就是和begin所指的元素进行交换,begin,begin在同一级别的调用中所指的位置(索引)不发生改变(当然位置里的值一般会变),在更深层的调用中则会随着深度的增加依次的增加1(往后面的位置指);),再次(递归)调用排列函数,以此来计算并打印以A[1]元素打头的所有排列结果,) */
                //for(int k = 0;k<i;k++) {printf("\t");};printf("before Swap(A + begin=&A[%d], A + i=&A[%d]) process:",begin,i);Output(A, p_size); 
            Swap(A + begin, A + i);
                for(int k = 0;k<i;k++) {printf("\t");};printf("after Swap(A + begin=&A[%d], A + i=&A[%d]) process:",begin,i);Output(A, p_size);printf("\n");

 
        }
    }
}
#endif


/* 解决含有重复元素的带排列数: */
void Full_Permutation_Duplicate(int A[], int begin, int end, int p_size)
{
    int i, j;

    if (begin >= p_size)
    {
        Output(A, p_size);
    }

    else
    {
        for (i = begin; i <= end; i++)//这个循环目的是让(不同/不重复的)元素都有机会当排列结果的打头元素.(反正都要拿来排列,可以从集合的角度排看待重复问题)
        {
            /* 类似选择排序,每一轮定下一个固定的参照元素A[i], */
            for (j = begin; j < i; j++)
            {
                if (A[j] == A[i])
                {
                    break;//此时必有 (i!=j,将导致A[i]不打头(因为它之间某个元素重复了,就不让这个元素(值)再打头),保证了(每一规模级别都不会出现重复打头的值))
                }
            }//如果不是由于break而离开for的话,那么有i==j

            if (i == j)
            {
                Swap(A + begin, A + i);
                Full_Permutation_Duplicate(A, begin + 1, end, p_size);
                Swap(A + begin, A + i);
            }
        }
    }
}


int main() {
    
    int B[5] = {1, 1, 2, 2, 3};
    Full_Permutation_Duplicate(B, 0, 4, 5);//duplicate重复/复制

#if TEST_NO_Duplicate
    int  A[3] = {1, 2, 3};
    int C[4] = {1,2,3,4};
    int D[5] = {1,2,3,4,5};
    Full_Permutation(A, 0, 2, 3);
   //Full_Permutation(C,0,3,4);
   //Full_Permutation(D,0,4,5);
#endif
   
}
```
### 输出

- 

  ```bash
  PS D:\repos\cpp\ConsoleApps> cd "d:\repos\cpp\ConsoleApps\" ; if ($?) { g++ -std=c++11 "tmp.c" -o "tmp.exe" } ; if ($?) {  .\"tmp.exe" }
  1 1 2 2 3 
  1 1 2 3 2 
  1 1 3 2 2 
  1 2 1 2 3 
  1 2 1 3 2 
  1 2 2 1 3 
  1 2 2 3 1 
  1 2 3 2 1 
  1 2 3 1 2
  1 3 2 2 1
  1 3 2 1 2
  1 3 1 2 2
  2 1 1 2 3
  2 1 1 3 2
  2 1 2 1 3
  2 1 2 3 1
  2 1 3 2 1
  2 1 3 1 2
  2 2 1 1 3
  2 2 1 3 1
  2 2 3 1 1
  2 3 1 2 1
  2 3 1 1 2
  2 3 2 1 1
  3 1 2 2 1
  3 1 2 1 2
  3 1 1 2 2
  3 2 1 2 1
  3 2 1 1 2
  3 2 2 1 1
  cnt=1
  before 1th invoke, Full_Permutation(A, begin + 1= 1, end=2, p_size=3);1 2 3
  cnt=2
          before 2th invoke, Full_Permutation(A, begin + 1= 2, end=2, p_size=3);1 2 3
  cnt=3
                  before 3th invoke, Full_Permutation(A, begin + 1= 3, end=2, p_size=3);1 2 3 
  cnt=4
  
  1 2 3
                  after 3th invoke, Full_Permutation(A, begin + 1= 3, end=2, p_size=3);1 2 3
                  after Swap(A + begin=&A[2], A + i=&A[2]) process:1 2 3
  
          after 2th invoke, Full_Permutation(A, begin + 1= 2, end=2, p_size=3);1 2 3
          after Swap(A + begin=&A[1], A + i=&A[1]) process:1 2 3
  
                  before 3th invoke, Full_Permutation(A, begin + 1= 2, end=2, p_size=3);1 3 2
  cnt=5
                  before 3th invoke, Full_Permutation(A, begin + 1= 3, end=2, p_size=3);1 3 2
  cnt=6
  
  1 3 2
                  after 3th invoke, Full_Permutation(A, begin + 1= 3, end=2, p_size=3);1 3 2
                  after Swap(A + begin=&A[2], A + i=&A[2]) process:1 3 2
  
                  after 3th invoke, Full_Permutation(A, begin + 1= 2, end=2, p_size=3);1 3 2
                  after Swap(A + begin=&A[1], A + i=&A[2]) process:1 2 3
  
  after 1th invoke, Full_Permutation(A, begin + 1= 1, end=2, p_size=3);1 2 3 
  after Swap(A + begin=&A[0], A + i=&A[0]) process:1 2 3
  
          before 2th invoke, Full_Permutation(A, begin + 1= 1, end=2, p_size=3);2 1 3
  cnt=7
          before 2th invoke, Full_Permutation(A, begin + 1= 2, end=2, p_size=3);2 1 3
  cnt=8
                  before 3th invoke, Full_Permutation(A, begin + 1= 3, end=2, p_size=3);2 1 3
  cnt=9
  
  2 1 3
                  after 3th invoke, Full_Permutation(A, begin + 1= 3, end=2, p_size=3);2 1 3
                  after Swap(A + begin=&A[2], A + i=&A[2]) process:2 1 3
  
          after 2th invoke, Full_Permutation(A, begin + 1= 2, end=2, p_size=3);2 1 3
          after Swap(A + begin=&A[1], A + i=&A[1]) process:2 1 3
  
                  before 3th invoke, Full_Permutation(A, begin + 1= 2, end=2, p_size=3);2 3 1
  cnt=10
                  before 3th invoke, Full_Permutation(A, begin + 1= 3, end=2, p_size=3);2 3 1
  cnt=11
  
  2 3 1
                  after 3th invoke, Full_Permutation(A, begin + 1= 3, end=2, p_size=3);2 3 1
                  after Swap(A + begin=&A[2], A + i=&A[2]) process:2 3 1
  
                  after 3th invoke, Full_Permutation(A, begin + 1= 2, end=2, p_size=3);2 3 1
                  after Swap(A + begin=&A[1], A + i=&A[2]) process:2 1 3
  
          after 2th invoke, Full_Permutation(A, begin + 1= 1, end=2, p_size=3);2 1 3
          after Swap(A + begin=&A[0], A + i=&A[1]) process:1 2 3
  
                  before 3th invoke, Full_Permutation(A, begin + 1= 1, end=2, p_size=3);3 2 1
  cnt=12
          before 2th invoke, Full_Permutation(A, begin + 1= 2, end=2, p_size=3);3 2 1
  cnt=13
                  before 3th invoke, Full_Permutation(A, begin + 1= 3, end=2, p_size=3);3 2 1
  cnt=14
  
  3 2 1
                  after 3th invoke, Full_Permutation(A, begin + 1= 3, end=2, p_size=3);3 2 1 
                  after Swap(A + begin=&A[2], A + i=&A[2]) process:3 2 1
  
          after 2th invoke, Full_Permutation(A, begin + 1= 2, end=2, p_size=3);3 2 1
          after Swap(A + begin=&A[1], A + i=&A[1]) process:3 2 1
  
                  before 3th invoke, Full_Permutation(A, begin + 1= 2, end=2, p_size=3);3 1 2
  cnt=15
                  before 3th invoke, Full_Permutation(A, begin + 1= 3, end=2, p_size=3);3 1 2
  cnt=16
  
  3 1 2
                  after 3th invoke, Full_Permutation(A, begin + 1= 3, end=2, p_size=3);3 1 2
                  after Swap(A + begin=&A[2], A + i=&A[2]) process:3 1 2
  
                  after 3th invoke, Full_Permutation(A, begin + 1= 2, end=2, p_size=3);3 1 2
                  after Swap(A + begin=&A[1], A + i=&A[2]) process:3 2 1
  
                  after 3th invoke, Full_Permutation(A, begin + 1= 1, end=2, p_size=3);3 2 1
                  after Swap(A + begin=&A[0], A + i=&A[2]) process:1 2 3 
  
  ```

  

### 示意图

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20201018210651671.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70#pic_center)