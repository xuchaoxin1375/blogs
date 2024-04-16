@[toc]
# 银行家算法

- [银行家算法 ](https://zh.m.wikipedia.org/zh-hans/银行家算法)
  - [背景](https://zh.m.wikipedia.org/zh-hans/银行家算法#背景)
  - [处理程序](https://zh.m.wikipedia.org/zh-hans/银行家算法#處理程序)
  - [安全和不安全的状态](https://zh.m.wikipedia.org/zh-hans/银行家算法#安全和不安全的状态)
  - 参考文献
    - [引用](https://zh.m.wikipedia.org/zh-hans/银行家算法#引用)
    - [书籍](https://zh.m.wikipedia.org/zh-hans/银行家算法#书籍)

- 在银行中，客户申请贷款的数量是有限的，每个客户在
- 第一次申请贷款时要**声明完成该项目所需的最大资金量**，
- 在满足所有贷款要求时，**客户应及时归还**。
- 银行家在客户申请的**贷款数量不超过自己拥有的最大值时，都应尽量满足客户的需要**。
- 在这样的描述中，银行家就好比操作系统，**资金就是资源，客户就相当于要申请资源的进程**。

## 银行家算法涉及的概念

For the Banker's algorithm to work, it needs to know three things:

### MAX-Request-Matrix

- How much of each resource **each process** could possibly request ("MAX")

### ALLOCATED-Resource-Array

- How much of each resource each process is currently holding ("ALLOCATED")

### AVAILABLE-Resource-Array

- How much of each resource the system currently has available ("AVAILABLE")

### NEED-Resource-Matrix

> 执行矩阵减法

- Need=Max-Allocation
  - 更具体的描述Need[i]:表示Request_i的上限(如果进程i的某次资源请求向量Request_i 的任何一个分量超出这个上限,必然是不合理的),系统会拒绝
  - Need: RequestUppers
- 求得Need矩阵后,Max矩阵就不再用到!



### 安全性试探(试探性分配资源)

> 两减一增

- Request_i表示进程i的某一次资源请求向量
- 试探的过程中,需要临时修改几个对象的值
  - Available-Request_i(向量减法)
  - Need[i]-Request_i
  - Allocation[i]+Request_i

### 安全性检测算法

> - 这是一个试图找出一个安全序列的过程
> - 在进行完试探性分配后,都应该执行这么一个检测流程,来确定试探性分配的结果到底会不会引起危险
> - 如果这个安全序列最终可以覆盖虽有进程(不关心进程间顺序),那么认为上述的试探性分配是安全的.



- 在安全性检测算法中,需要用到的矩阵/向量:
  - Need矩阵
  - Allocation矩阵(更具地,是Allocation矩阵中的某一行,譬如第i个进程对应的第i行向量Allocation[i])
  - AvailableUpdating(Work)向量
    - Work向量很能代表银行的角色,进行收本收息(**债权人**)
    - Work向量的更新方式:`Work=Work+Allocation[i]`
    - Work向量在更新的过程中,**只可能增大,而不会减小**(向量中的任何一个元素的都是如此)
    - Allocation[i]表示第i个进程已经获得的资源分配向量(Allocation本身是一个矩阵(二维))
    - Work向量的各个分量随着安全检测算法的推进,每确认一个可以进入SafeProcessSeq的`安全`进程,Work就有机会更新(通常会变化至少一个分量,而且是变大的)
- SafeProcessSeq安全序列
  - 这个序列收集被认为是可以安全地分配资源地进程
  - 系统不会因为将资源分配给这些进程后而陷入危险区
  - 换句话说,这个序列中地进程地所占用的资源系统都可以安全的回收回来(连本带利)
  - 因此,当Need[i]<Work

### data structure

![image-20220530084036077](https://img-blog.csdnimg.cn/img_convert/365398f2d56eb47f79c212424ba2a465.png)

## 案例



```
      Allocation　　　Max　　　Available
 　　 ＡＢＣＤ　　  ＡＢＣＤ　　ＡＢＣＤ
 P1   ００１４　　  ０６５６　　１５２０　
 P2　 １４３２　　  １９４２　
 P3　 １３５４　  　１３５６
 P4 　１０００　　  １７５０
```



　　  

- 我们会看到一个资源分配表，要判断是否为安全状态，**首先先找出它的Need**，
  - Need即Max（最多需要多少资源）减去Allocation（原本已经分配出去的资源），
  - 计算结果如下：

```
   NEED
 ＡＢＣＤ
 ０６４２　
 ０５１０
 ０００２
 ０７５０
```

- 接下来找出need比available小的（千万不能把它当成4位数 他是4个不同的数）
- 如果有多个满足条件,那么随意选取一个都可以,不会影响对安全性的判断(但是序列会有所不同.)

```
   NEED　　  Available
 ＡＢＣＤ　　ＡＢＣＤ
 
 ０６４２　　１５２０
 ０５１０<-
 ０００２
 ０７５０
```

- P2的各种资源的最大需求小于(或等于)当前可用(可以提供的各种资源量)，所以配置给他再**回收**

  - 注意这里回收的向量是来自于Allocation中进程的对应行

  - 不要误把Need中的对应行回收了

  - ```
      	Allocation　　　
       　　ＡＢＣＤ　
         
     P1   ００１４　　 　　
     P2　 １４３２　
     P3　 １３５４　  　
     P4 　１０００
    ```

    

- 回收完毕后,将需求矩阵Need中对应的行修改为全0(或者全部划掉)

```
      NEED　　   Available_updating(Work ing)
     ＡＢＣＤ　　ＡＢＣＤ

     ０６４２　　１５２０
   ->００００　＋１４３２
     ０００２－－－－－－－
     ０７５０　　２９５２
```

此时P2 FINISH的false要改成true（己完成,进入安全序列）

```
 FINISH
 false
 true
 false
 false
```

接下来继续往下找，发现P3的需求为0002，小于能用的2952，所以资源配置给他再回收

```
 　NEED　　    Available
 ＡＢＣＤ　　Ａ　Ｂ　Ｃ　Ｄ
 
 ０６４２　　２　９　５　２
 ００００　＋１　３　５　４
 ００００－－－－－－－－－－
 ０７５０　　３　12　10　6
```


依此类推，做完P4→P1，当**全部的FINISH都变成true时，就是安全状态。**



